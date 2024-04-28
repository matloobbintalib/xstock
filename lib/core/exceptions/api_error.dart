import 'dart:io';

import 'package:dio/dio.dart';

import '../../utils/logger/logger.dart';

class ApiError implements Exception {
  final int? code;
  final String? message;

  ApiError({
    this.code,
    required this.message,
  });
  factory ApiError.fromDioException(DioException dioException) {
    final log = logger(ApiError);
    print("Dio Exception ::: ${dioException.error}");
    if (dioException.response != null) {
      log.e('ApiError.fromDioException: ${dioException.response?.data}');
      switch (dioException.response?.statusCode) {
        case 401:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 404:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 405:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 500:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 503:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        default:
          return ApiError(
            code: dioException.response?.statusCode ?? 0,
            message: dioException.response?.data['message'],
          );
      }
    }

    /// Exception on socket/no internet
    else if (dioException.type == DioExceptionType.unknown && dioException.error is SocketException) {
      return ApiError(
        code: dioException.response?.statusCode,
        message: dioException.response?.statusMessage,
      );
    }
    else if (dioException.type == DioExceptionType.connectionError ) {
      return ApiError(
        code: 500,
        message: 'No internet connection',
      );
    }

    else if (dioException.type == DioExceptionType.unknown ) {
      return ApiError(
        code: 500,
        message: 'Server is not available',
      );
    }

    else if (dioException.error is HandshakeException) {
      return ApiError(
        code: dioException.response?.statusCode,
        message: 'Handshake Error',
      );
    }
    else if (dioException.error is SocketException) {
      return ApiError(
        code: dioException.response?.statusCode,
        message: 'Socket Exception',
      );
    }

    /// Exceptions on timeout
    else if (dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.sendTimeout ||
        dioException.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        code: 0,
        message: 'Connection timeout, Please try again',
      );
    }

    return ApiError(
      code: dioException.response?.statusCode ?? 0,
      message: dioException.message,
    );
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message)';
  }
}