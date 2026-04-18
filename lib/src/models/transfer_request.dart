import 'dart:convert';

TransferRequest transferRequestFromJson(String str) =>
    TransferRequest.fromJson(json.decode(str) as Map<String, dynamic>);

String transferRequestToJson(TransferRequest data) =>
    json.encode(data.toJson());

class TransferRequest {
  const TransferRequest({
    required this.inputTransactionReference,
    required this.inputAmount,
    required this.inputThirdPartyReference,
    required this.inputPrimaryPartyCode,
    required this.inputReceiverPartyCode,
  });

  final String inputTransactionReference;
  final String inputAmount;
  final String inputThirdPartyReference;
  final String inputPrimaryPartyCode;
  final String inputReceiverPartyCode;

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      TransferRequest(
        inputTransactionReference:
            json['input_TransactionReference'] as String,
        inputAmount: json['input_Amount'] as String,
        inputThirdPartyReference: json['input_ThirdPartyReference'] as String,
        inputPrimaryPartyCode: json['input_PrimaryPartyCode'] as String,
        inputReceiverPartyCode: json['input_ReceiverPartyCode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'input_TransactionReference': inputTransactionReference,
        'input_Amount': inputAmount,
        'input_ThirdPartyReference': inputThirdPartyReference,
        'input_PrimaryPartyCode': inputPrimaryPartyCode,
        'input_ReceiverPartyCode': inputReceiverPartyCode,
      };
}
