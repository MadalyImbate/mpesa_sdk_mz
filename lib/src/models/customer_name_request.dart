class CustomerNameRequest {
  const CustomerNameRequest({
    required this.inputCustomerMsisdn,
    required this.inputThirdPartyReference,
    required this.inputServiceProviderCode,
  });

  final String inputCustomerMsisdn;
  final String inputThirdPartyReference;
  final String inputServiceProviderCode;

  Map<String, String> toQueryParameters() => {
        'input_CustomerMSISDN': inputCustomerMsisdn,
        'input_ThirdPartyReference': inputThirdPartyReference,
        'input_ServiceProviderCode': inputServiceProviderCode,
      };
}
