import 'dart:io';

import 'package:mpesa_sdk_mz/mpesa_sdk_mz.dart';

class ExampleMpesaConfig {
  const ExampleMpesaConfig._({
    required this.environment,
    required this.origin,
    required this.credentials,
  });

  final MpesaEnvironment environment;
  final String origin;
  final MpesaCredentials credentials;

  factory ExampleMpesaConfig.fromEnv() {
    final environmentValue =
        Platform.environment['MPESA_ENV']?.trim().toLowerCase() ?? 'sandbox';
    final environment = environmentValue == 'production'
        ? MpesaEnvironment.production
        : MpesaEnvironment.sandbox;

    final apiKey = _readRequiredEnv('MPESA_API_KEY');
    final publicKey = _readRequiredEnv('MPESA_PUBLIC_KEY');
    final origin = _readRequiredEnv('MPESA_ORIGIN');

    return ExampleMpesaConfig._(
      environment: environment,
      origin: origin,
      credentials: MpesaCredentials(
        apiKey: apiKey,
        publicKey: publicKey,
      ),
    );
  }

  static String _readRequiredEnv(String key) {
    final value = Platform.environment[key]?.trim();
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required environment variable $key.\n'
        'Example:\n'
        'MPESA_ENV=sandbox\n'
        'MPESA_API_KEY=your_api_key\n'
        'MPESA_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----..."\n'
        'MPESA_ORIGIN=developer.mpesa.vm.co.mz',
      );
    }
    return value;
  }
}
