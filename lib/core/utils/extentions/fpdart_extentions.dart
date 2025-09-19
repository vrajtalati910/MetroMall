import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:tailor_mate/core/utils/network/http_failure.dart';

extension ResponseParser<T> on Either<HttpFailure, T> {
  Either<HttpFailure, R> parseResponse<R>(
    R Function(Map<String, dynamic> json) fromJson,
  ) {
    return fold(
      left,
      (json) {
        return Either.tryCatch(() => fromJson(json as Map<String, dynamic>), (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return HttpFailure.parsing(
            error.toString(),
            500,
            stackTrace,
          );
        });
      },
    );
  }
}

extension EitherExtension<L, R> on Either<L, R> {
  R? getRightFolded() => fold((l) => null, (r) => r);
  L? getLeftFolded() => fold((l) => l, (r) => null);
}
