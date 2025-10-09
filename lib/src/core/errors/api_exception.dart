abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class NetworkException extends ApiException {
  NetworkException({required super.message});
}

class ServerException extends ApiException {
  ServerException({required super.message, required super.statusCode});
}

class UnexpectedException extends ApiException {
  UnexpectedException({super.message = "terjadi kesalahan yang tidak terduga"});
}
