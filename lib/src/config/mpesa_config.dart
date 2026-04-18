import 'dart:convert';

import '../errors/mpesa_exception.dart';
import '../utils/rsa_key_helper.dart';

class MpesaConfig {
  /// Encrypts the [Api Key] with [Public Key] and
  /// returns a usable Bearer Token
  ///
  static String getBearerToken(String apiKey, String publicKey) {
    try {
      final rsaKeyHelper = RsaKeyHelper();
      final pk = rsaKeyHelper.parsePublicKeyFromPem(publicKey);
      final token = rsaKeyHelper.encrypt(apiKey, pk);

      return 'Bearer ${base64.encode(token)}';
    } catch (error) {
      throw MpesaConfigurationException(
        'Failed to generate bearer token: $error',
      );
    }
  }
}
