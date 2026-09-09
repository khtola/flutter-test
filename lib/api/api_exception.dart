class ApiException implements Exception {
  final int? statusCode;
  final String message;

  const ApiException({this.statusCode, required this.message});

  factory ApiException.fromStatusCode(int statusCode, [String? body]) {
    return ApiException(
      statusCode: statusCode,
      message: body?.isNotEmpty == true
          ? body!
          : 'Request failed with status $statusCode',
    );
  }

  @override
  String toString() => message;
}
