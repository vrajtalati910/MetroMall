import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:tailor_mate/core/utils/network/client.dart';
import 'package:tailor_mate/core/utils/network/http_failure.dart';

@Injectable(as: Client)
class HttpClient extends Client {
  HttpClient(super.localStorageRepository);

  @override
  ApiResult<Map<String, dynamic>> delete({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final fullUrl = Uri.parse(url).replace(
      queryParameters: <String, dynamic>{
        ...params ?? <String, dynamic>{},
      },
    );
    log(
      'url: $fullUrl',
    );
    try {
      return _returnResponse(
        await http.delete(
          fullUrl,
          headers: _httpHeaders(headers),
        ),
      );
    } on SocketException catch (e) {
      return left(HttpFailure.noInternet(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  ApiResult<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final fullUrl = Uri.parse(url).replace(
      queryParameters: <String, dynamic>{...params ?? <String, dynamic>{}},
    );

    if (isNoInternet) return left(HttpFailure.noInternet());

    log('url: $fullUrl');
    log('headers: ${_httpHeaders(headers) ?? <String, dynamic>{}}}');

    try {
      return _returnResponse(
        await http.get(
          fullUrl,
          headers: _httpHeaders(headers),
        ),
      );
    } on SocketException catch (e) {
      return left(HttpFailure.noInternet(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  ApiResult<Map<String, dynamic>> getPublic({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
  }) async {
    final fullUrl = Uri.parse(url).replace(queryParameters: params);

    log('url: $fullUrl');
    try {
      return _returnResponse(
        await http.get(
          fullUrl,
          headers: _httpHeaders(headers),
        ),
      );
    } on SocketException catch (e) {
      return left(HttpFailure.noInternet(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  ApiResult<Map<String, dynamic>> multipart({
    required String url,
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    Map<String, String>? requests,
    List<MapEntry<String, File>> files = const [],
    List<http.MultipartFile> webFiles = const [],
  }) async {
    final fullUrl = Uri.parse(url).replace(queryParameters: params);

    log('url: $fullUrl');
    log('requests: ${requests ?? <String, dynamic>{}}}');
    log('files: $files');

    try {
      final multipartRequest = http.MultipartRequest(
        method,
        fullUrl,
      );

      multipartRequest.headers.addAll(_httpHeaders());
      if (kIsWeb || (webFiles.isNotEmpty && files.isEmpty)) {
        if (webFiles.isNotEmpty) {
          for (final fileData in webFiles) {
            multipartRequest.files.add(
              fileData,
            );
          }
        }
      } else {
        if (files.isNotEmpty) {
          for (final fileData in files) {
            multipartRequest.files.add(
              await http.MultipartFile.fromPath(
                fileData.key,
                fileData.value.path,
              ),
            );
          }
        }
      }

      multipartRequest.fields.addAll(requests ?? <String, String>{});

      final multiPartResponse = await multipartRequest.send();

      return _returnResponse(await http.Response.fromStream(multiPartResponse));
    } on SocketException catch (e) {
      return left(HttpFailure.noInternet(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  ApiResult<Map<String, dynamic>> post({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? requests,
    Map<String, dynamic>? params,
  }) async {
    final fullUrl = Uri.parse(url).replace(queryParameters: params);

    log('url: $fullUrl');
    log('requests: ${requests ?? <String, dynamic>{}}}');
    if (isNoInternet) return left(HttpFailure.noInternet());
    try {
      return _returnResponse(
        await http.post(
          fullUrl,
          headers: _httpHeaders(headers),
          body: jsonEncode({...requests ?? <String, dynamic>{}}),
        ),
      );
    } on SocketException catch (e) {
      return left(HttpFailure.noInternet(e.message));
    } catch (e) {
      rethrow;
    }
  }

  Map<String, String> _httpHeaders([Map<String, String>? extraHeaders]) {
    final userToken = localStorageRepository.token;
    return {
      if (userToken != null) 'Authorization': 'Bearer $userToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...extraHeaders ?? {},
    };
  }

  Either<HttpFailure, Map<String, dynamic>> _returnResponse(
    http.Response response,
  ) {
    log('body: ${response.body}, statusCode: ${response.statusCode}');

    switch (response.statusCode) {
      case 200:
        return Either.tryCatch(
          () {
            final data = json.decode(response.body) as Map<String, dynamic>;

            final tempStatus = data['status'];
            final tempMessage = data['message'];

            final status = tempStatus is int ? tempStatus : 0;
            final message = tempMessage is String ? tempMessage : 'Something Went Wrong';

            if (status == 1 || status == 2 || status == 3) {
              return data;
            } else {
              throw HttpFailure.fetchData(message, status);
            }
          },
          (o, s) => o is HttpFailure ? o : HttpFailure.parsing(o.toString(), 500, s),
        );
      case 400:
        return Either.tryCatch(
          () {
            final data = json.decode(response.body) as Map<String, dynamic>;

            throw HttpFailure.badRequest(
              (data['message'] ?? 'Bad Request') as String,
            );
          },
          (o, s) => o is HttpFailure ? o : HttpFailure.badRequest(),
        );

      case 401:
        return Either.tryCatch(
          () {
            final data = json.decode(response.body) as Map<String, dynamic>;

            // localStorageRepository.clearAuth();
            // goRouter.go(AppRoutes.landing.route);

            throw HttpFailure.unauthorized(
              (data['message'] ?? 'Unauthorized') as String,
            );
          },
          (o, s) => o is HttpFailure ? o : HttpFailure.unauthorized(),
        );

      case 403:
        return Either.tryCatch(
          () {
            final data = json.decode(response.body) as Map<String, dynamic>;

            throw HttpFailure.forbidden(
              (data['message'] ?? 'Forbidden') as String,
            );
          },
          (o, s) => o is HttpFailure ? o : HttpFailure.forbidden(),
        );

      default:
        return Either.tryCatch(
          () {
            final data = json.decode(response.body) as Map<String, dynamic>;
            final tempStatus = data['status'];
            final tempMessage = data['message'];

            final status = tempStatus is String ? tempStatus : '0';
            final message = tempMessage is String ? tempMessage : 'Something Went Wrong';

            if (status == '1' || status == '2' || status == '3') {
              return data;
            } else {
              throw HttpFailure.fetchData(message, response.statusCode);
            }
          },
          (o, s) => o is HttpFailure
              ? o
              : HttpFailure.fetchData(
                  'Error occured while communication with server'
                  ' with StatusCode : ${response.statusCode}',
                  response.statusCode,
                ),
        );
    }
  }

  // bool get isNoInternet => getIt<InternetConnectivityCubit>().state.isNoInternet;
  bool get isNoInternet => false;
}
