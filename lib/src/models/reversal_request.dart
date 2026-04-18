import 'dart:convert';

ReversalRequest reversalRequestFromJson(String str) =>
    ReversalRequest.fromJson(json.decode(str) as Map<String, dynamic>);

String reversalRequestToJson(ReversalRequest data) =>
    json.encode(data.toJson());

class ReversalRequest {
  const ReversalRequest({
    required this.inputTransactionID,
    required this.inputSecurityCredential,
    required this.inputInitiatorIdentifier,
    required this.inputThirdPartyReference,
    required this.inputServiceProviderCode,
    this.inputReversalAmount,
  });

  final String inputTransactionID;
  final String inputSecurityCredential;
  final String inputInitiatorIdentifier;
  final String inputThirdPartyReference;
  final String inputServiceProviderCode;
  final String? inputReversalAmount;

  factory ReversalRequest.fromJson(Map<String, dynamic> json) =>
      ReversalRequest(
        inputTransactionID: json['input_TransactionID'] as String,
        inputSecurityCredential: json['input_SecurityCredential'] as String,
        inputInitiatorIdentifier: json['input_InitiatorIdentifier'] as String,
        inputThirdPartyReference: json['input_ThirdPartyReference'] as String,
        inputServiceProviderCode:
            json['input_ServiceProviderCode'] as String,
        inputReversalAmount: json['input_ReversalAmount'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'input_TransactionID': inputTransactionID,
        'input_SecurityCredential': inputSecurityCredential,
        'input_InitiatorIdentifier': inputInitiatorIdentifier,
        'input_ThirdPartyReference': inputThirdPartyReference,
        'input_ServiceProviderCode': inputServiceProviderCode,
        if (inputReversalAmount != null)
          'input_ReversalAmount': inputReversalAmount,
      };
}
