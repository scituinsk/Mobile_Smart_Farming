/// Custom exceptions for API-related errors.
/// Provides structured error handling for networkm server, and unexpected issues.

library;

/// Abstract base class for API exceptions.
/// All API errors should extend this class for consistency.
abstract class ApiException implements Exception {
  /// This error message describing the issue.
  final String message;

  /// Optional HTTP status code associated with the error.
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    return message;
  }
}

/// Exception for network-related errors, such as connectivity issues.
class NetworkException extends ApiException {
  NetworkException({required super.message});
}

/// Exception for server-related errors, such as HTTP errors with status code.
class ServerException extends ApiException {
  ServerException({required super.message, required super.statusCode});
}

/// Exception for unexpected errors that do not fit other categories
class UnexpectedException extends ApiException {
  UnexpectedException({super.message = "terjadi kesalahan yang tidak terduga"});
}
