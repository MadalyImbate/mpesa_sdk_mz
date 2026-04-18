import 'mpesa_credentials.dart';
import 'mpesa_environment.dart';

class MpesaClientConfig {
  const MpesaClientConfig({
    required this.environment,
    required this.credentials,
    required this.origin,
    this.requestTimeout = _defaultRequestTimeout,
  });

  static const Duration _defaultRequestTimeout = Duration(seconds: 30);

  final MpesaEnvironment environment;
  final MpesaCredentials credentials;
  final String origin;
  final Duration requestTimeout;

  String get host => _defaultHostFor(environment);

  void validate() {
    credentials.validate();
    if (origin.trim().isEmpty) {
      throw ArgumentError.value(origin, 'origin', 'origin cannot be empty.');
    }
    if (requestTimeout <= Duration.zero) {
      throw ArgumentError.value(
        requestTimeout,
        'requestTimeout',
        'requestTimeout must be greater than zero.',
      );
    }
  }

  static String _defaultHostFor(MpesaEnvironment environment) {
    switch (environment) {
      case MpesaEnvironment.sandbox:
        return 'api.sandbox.vm.co.mz';
      case MpesaEnvironment.production:
        return 'api.vm.co.mz';
    }
  }
}
