class MpesaException implements Exception {
  const MpesaException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class MpesaConfigurationException extends MpesaException {
  const MpesaConfigurationException(String message) : super(message);
}

class MpesaTimeoutException extends MpesaException {
  const MpesaTimeoutException({
    required this.operation,
    required this.method,
    required this.uri,
    required this.timeout,
  }) : super(
         'Request timed out for $operation ($method $uri) after $timeout.',
       );

  final String operation;
  final String method;
  final Uri uri;
  final Duration timeout;
}

class MpesaNetworkException extends MpesaException {
  const MpesaNetworkException({
    required this.operation,
    required this.method,
    required this.uri,
    required this.cause,
  }) : super('Network request failed for $operation ($method $uri): $cause');

  final String operation;
  final String method;
  final Uri uri;
  final Object cause;
}

class MpesaResponseParseException extends MpesaException {
  const MpesaResponseParseException({
    required this.parser,
    required this.body,
    required this.cause,
  }) : super('Failed to parse response with $parser: $cause');

  final String parser;
  final String body;
  final Object cause;
}
