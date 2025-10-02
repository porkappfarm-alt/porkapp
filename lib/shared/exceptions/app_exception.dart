enum AppExceptionType {
  network,
  unauthorized,
  notFound,
  database,
  validation,
  unexpected,
}

class AppException implements Exception {
  final String message;
  final AppExceptionType type;
  final dynamic error;

  AppException({required this.message, required this.type, this.error});

  @override
  String toString() => message;
}
