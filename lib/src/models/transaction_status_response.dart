import 'dart:convert';

TransactionStatusResponse transactionStatusResponseFromJson(String str) =>
    TransactionStatusResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String transactionStatusResponseToJson(TransactionStatusResponse data) =>
    json.encode(data.toJson());

class TransactionStatusResponse {
  const TransactionStatusResponse({
    this.outputResponseCode,
    this.outputResponseDesc,
    this.outputTransactionID,
    this.outputConversationID,
    this.outputThirdPartyReference,
    this.outputResponseTransactionStatus,
  });

  final String? outputResponseCode;
  final String? outputResponseDesc;
  final String? outputTransactionID;
  final String? outputConversationID;
  final String? outputThirdPartyReference;
  final String? outputResponseTransactionStatus;

  factory TransactionStatusResponse.fromJson(Map<String, dynamic> json) =>
      TransactionStatusResponse(
        outputResponseCode: json['output_ResponseCode'] as String?,
        outputResponseDesc: json['output_ResponseDesc'] as String?,
        outputTransactionID: json['output_TransactionID'] as String?,
        outputConversationID: json['output_ConversationID'] as String?,
        outputThirdPartyReference:
            json['output_ThirdPartyReference'] as String?,
        outputResponseTransactionStatus:
            json['output_ResponseTransactionStatus'] as String?,
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
        if (outputResponseTransactionStatus != null)
          'output_ResponseTransactionStatus': outputResponseTransactionStatus,
      };
}
