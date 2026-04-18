class TransactionStatusRequest {
  const TransactionStatusRequest({
    required this.inputThirdPartyReference,
    required this.inputQueryReference,
    required this.inputServiceProviderCode,
  });

  final String inputThirdPartyReference;
  final String inputQueryReference;
  final String inputServiceProviderCode;

  Map<String, String> toQueryParameters() => {
        'input_ThirdPartyReference': inputThirdPartyReference,
        'input_QueryReference': inputQueryReference,
        'input_ServiceProviderCode': inputServiceProviderCode,
      };
}
