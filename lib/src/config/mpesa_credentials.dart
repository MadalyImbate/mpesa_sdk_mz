class MpesaCredentials {
  const MpesaCredentials({
    required this.apiKey,
    required this.publicKey,
  });

  final String apiKey;
  final String publicKey;

  void validate() {
    if (apiKey.trim().isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'apiKey cannot be empty.');
    }
    if (publicKey.trim().isEmpty) {
      throw ArgumentError.value(
        publicKey,
        'publicKey',
        'publicKey cannot be empty.',
      );
    }
  }
}
