import 'dart:convert';

CustomerNameResponse customerNameResponseFromJson(String str) =>
    CustomerNameResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String customerNameResponseToJson(CustomerNameResponse data) =>
    json.encode(data.toJson());

class CustomerNameResponse {
  const CustomerNameResponse({
    this.outputResultCode,
    this.outputResultDesc,
    this.outputConversationID,
    this.outputThirdPartyReference,
    this.outputCustomerName,
  });

  final String? outputResultCode;
  final String? outputResultDesc;
  final String? outputConversationID;
  final String? outputThirdPartyReference;
  final String? outputCustomerName;

  factory CustomerNameResponse.fromJson(Map<String, dynamic> json) =>
      CustomerNameResponse(
        outputResultCode: json['output_ResultCode'] as String?,
        outputResultDesc: json['output_ResultDesc'] as String?,
        outputConversationID: json['output_ConversationID'] as String?,
        outputThirdPartyReference:
            json['output_ThirdPartyReference'] as String?,
        outputCustomerName: json['output_CustomerName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (outputResultCode != null) 'output_ResultCode': outputResultCode,
        if (outputResultDesc != null) 'output_ResultDesc': outputResultDesc,
        if (outputConversationID != null)
          'output_ConversationID': outputConversationID,
        if (outputThirdPartyReference != null)
          'output_ThirdPartyReference': outputThirdPartyReference,
        if (outputCustomerName != null) 'output_CustomerName': outputCustomerName,
      };
}
