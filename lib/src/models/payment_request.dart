import 'dart:convert';

PaymentRequest paymentRequestFromJson(String str) =>
    PaymentRequest.fromJson(json.decode(str) as Map<String, dynamic>);

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  const PaymentRequest({
    required this.inputTransactionReference,
    required this.inputCustomerMsisdn,
    required this.inputAmount,
    required this.inputThirdPartyReference,
    required this.inputServiceProviderCode,
  });

  final String inputTransactionReference;
  final String inputCustomerMsisdn;
  final String inputAmount;
  final String inputThirdPartyReference;
  final String inputServiceProviderCode;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        inputTransactionReference:
            json['input_TransactionReference'] as String,
        inputCustomerMsisdn: json['input_CustomerMSISDN'] as String,
        inputAmount: json['input_Amount'] as String,
        inputThirdPartyReference: json['input_ThirdPartyReference'] as String,
        inputServiceProviderCode:
            json['input_ServiceProviderCode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'input_TransactionReference': inputTransactionReference,
        'input_CustomerMSISDN': inputCustomerMsisdn,
        'input_Amount': inputAmount,
        'input_ThirdPartyReference': inputThirdPartyReference,
        'input_ServiceProviderCode': inputServiceProviderCode,
      };
}
