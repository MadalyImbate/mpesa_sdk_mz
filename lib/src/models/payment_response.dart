import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) =>
    PaymentResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String paymentResponseToJson(PaymentResponse data) => json.encode(data.toJson());

class PaymentResponse {
  const PaymentResponse({
    this.outputResponseCode,
    this.outputResponseDesc,
    this.outputTransactionID,
    this.outputConversationID,
    this.outputThirdPartyReference,
  });

  final String? outputResponseCode;
  final String? outputResponseDesc;
  final String? outputTransactionID;
  final String? outputConversationID;
  final String? outputThirdPartyReference;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        outputResponseCode: json['output_ResponseCode'] as String?,
        outputResponseDesc: json['output_ResponseDesc'] as String?,
        outputTransactionID: json['output_TransactionID'] as String?,
        outputConversationID: json['output_ConversationID'] as String?,
        outputThirdPartyReference:
            json['output_ThirdPartyReference'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (outputResponseCode != null)
          'output_ResponseCode': outputResponseCode,
        if (outputResponseDesc != null)
          'output_ResponseDesc': outputResponseDesc,
        if (outputTransactionID != null)
          'output_TransactionID': outputTransactionID,
        if (outputConversationID != null)
          'output_ConversationID': outputConversationID,
        if (outputThirdPartyReference != null)
          'output_ThirdPartyReference': outputThirdPartyReference,
      };
}
