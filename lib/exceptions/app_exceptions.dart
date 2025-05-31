import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = "Something went wrong", this.prefix]);

  @override
  String toString() => "${prefix ?? ''}$message";

  /// ✅ Proper place for fromDioError
  static AppException fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        switch (statusCode) {
          case 400:
            return BadRequestException();
          case 401:
          case 403:
            return UnauthorizedException();
          case 404:
            return NotFoundException();
          default:
            return FetchDataException(
              "Received invalid status code: $statusCode",
            );
        }
      case DioExceptionType.cancel:
        return FetchDataException("Request to API server was cancelled");
      case DioExceptionType.unknown:
        return FetchDataException("No internet or unknown error occurred");
      default:
        return AppException();
    }
  }
}

//───────────────────────────────────────────────

class FetchDataException extends AppException {
  FetchDataException([String message = "Error during communication"])
      : super(message, "Fetch Data Error: ");
}

class BadRequestException extends AppException {
  BadRequestException([String message = "Invalid request"])
      : super(message, "Bad Request: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = "Unauthorized"])
      : super(message, "Unauthorized: ");
}

class NotFoundException extends AppException {
  NotFoundException([String message = "Resource not found"])
      : super(message, "Not Found: ");
}

class TimeoutException extends AppException {
  TimeoutException([String message = "Request timed out"])
      : super(message, "Timeout: ");
}
