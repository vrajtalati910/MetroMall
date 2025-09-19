import 'package:flutter/material.dart';

@immutable
class HttpFailure implements Exception {
  const HttpFailure({
    this.message,
    this.status,
    this.stackTrace,
  });

  factory HttpFailure.fetchData(
    String message,
    int status,
  ) =>
      HttpFailure(message: message, status: status);

  factory HttpFailure.parsing([
    String message = 'Error Parsing Data',
    int status = 500,
    StackTrace? stackTrace,
  ]) =>
      HttpFailure(message: message, status: status, stackTrace: stackTrace);

  factory HttpFailure.badRequest([
    String message = 'Bad Request',
    int status = 400,
  ]) =>
      HttpFailure(message: message, status: status);

  factory HttpFailure.unauthorized([
    String message = 'Unauthorized',
    int status = 401,
  ]) =>
      HttpFailure(message: message, status: status);

  factory HttpFailure.noInternet([
    String message = 'No Internet',
    int status = 503,
  ]) =>
      HttpFailure(message: message, status: status);

  factory HttpFailure.forbidden([
    String message = 'Forbidden',
    int status = 403,
  ]) =>
      HttpFailure(message: message, status: status);

  factory HttpFailure.userCancelledSocialLogin([
    String message = 'Cancelled',
    int status = 444,
  ]) =>
      HttpFailure(message: message, status: status);

  final String? message;
  final int? status;
  final StackTrace? stackTrace;

  @override
  String toString() => 'HttpFailure(message: $message, status: $status, stackTrace: $stackTrace)';

  HttpFailure copyWith({
    String? message,
    int? status,
    StackTrace? stackTrace,
  }) {
    return HttpFailure(
      message: message ?? this.message,
      status: status ?? this.status,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  bool operator ==(covariant HttpFailure other) {
    if (identical(this, other)) return true;

    return other.message == message && other.status == status && other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => message.hashCode ^ status.hashCode ^ stackTrace.hashCode;
}
