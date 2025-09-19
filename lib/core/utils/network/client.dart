import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:tailor_mate/core/local_storage/i_local_storage_repository.dart';
import 'package:tailor_mate/core/utils/network/http_failure.dart';

typedef ApiResult<T> = Future<Either<HttpFailure, T>>;

abstract class Client {
  const Client(this.localStorageRepository);
  final ILocalStorageRepository localStorageRepository;

  ApiResult<Map<String, dynamic>> post({
    required String url,
    Map<String, String> headers,
    Map<String, dynamic> requests,
    Map<String, dynamic> params,
  });

  ApiResult<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic> params,
    Map<String, String> headers,
  });

  ApiResult<Map<String, dynamic>> getPublic({
    required String url,
    Map<String, dynamic> params,
    Map<String, String> headers,
  });

  ApiResult<Map<String, dynamic>> delete({
    required String url,
    Map<String, dynamic> params,
    Map<String, String> headers,
  });

  ApiResult<Map<String, dynamic>> multipart({
    required String url,
    String method = 'POST',
    Map<String, String> headers,
    Map<String, String> requests,
    Map<String, dynamic> params,
    List<MapEntry<String, File>> files,
    List<http.MultipartFile> webFiles,
  });
}
