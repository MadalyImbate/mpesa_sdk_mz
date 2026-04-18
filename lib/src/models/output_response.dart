import 'dart:convert';

OutputResponse outputResponseFromJson(String str) =>
    OutputResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String outputResponseToJson(OutputResponse data) => json.encode(data.toJson());

class OutputResponse {
  const OutputResponse({
    this.outputResponseCode,
    this.outputResponseDesc,
    this.outputResultCode,
    this.outputResultDesc,
    this.outputTransactionID,
    this.outputConversationID,
    this.outputThirdPartyReference,
    this.outputResponseTransactionStatus,
    this.outputCustomerName,
  });

  final String? outputResponseCode;
  final String? outputResponseDesc;
  final String? outputResultCode;
  final String? outputResultDesc;
  final String? outputTransactionID;
  final String? outputConversationID;
  final String? outputThirdPartyReference;
  final String? outputResponseTransactionStatus;
  final String? outputCustomerName;

  factory OutputResponse.fromJson(Map<String, dynamic> json) => OutputResponse(
        outputResponseCode: json['output_ResponseCode'] as String?,
        outputResponseDesc: json['output_ResponseDesc'] as String?,
        outputResultCode: json['output_ResultCode'] as String?,
        outputResultDesc: json['output_ResultDesc'] as String?,
        outputTransactionID: json['output_TransactionID'] as String?,
        outputConversationID: json['output_ConversationID'] as String?,
        outputThirdPartyReference:
            json['output_ThirdPartyReference'] as String?,
        outputResponseTransactionStatus:
            json['output_ResponseTransactionStatus'] as String?,
        outputCustomerName: json['output_CustomerName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (outputResponseCode != null)
          'output_ResponseCode': outputResponseCode,
        if (outputResponseDesc != null)
          'output_ResponseDesc': outputResponseDesc,
        if (outputResultCode != null) 'output_ResultCode': outputResultCode,
        if (outputResultDesc != null) 'output_ResultDesc': outputResultDesc,
        if (outputTransactionID != null)
          'output_TransactionID': outputTransactionID,
        if (outputConversationID != null)
          'output_ConversationID': outputConversationID,
        if (outputThirdPartyReference != null)
          'output_ThirdPartyReference': outputThirdPartyReference,
        if (outputResponseTransactionStatus != null)
          'output_ResponseTransactionStatus': outputResponseTransactionStatus,
        if (outputCustomerName != null) 'output_CustomerName': outputCustomerName,
      };
}
