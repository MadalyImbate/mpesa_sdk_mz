import 'package:mpesa_sdk_mz/mpesa_sdk_dart.dart';

main() async {
  String token = MpesaConfig.getBearerToken(
    'API_KEY_HERE',
    'PUBLIC_KEY_HERE',
  );

  String apiHost = 'api.sandbox.vm.co.mz'; // use {api.vm.co.mz} for production

  PaymentRequest payload = PaymentRequest(
    inputTransactionReference: 'T12344C',
    inputCustomerMsisdn: '25884xxxxxxx',
    inputAmount: 10.0,
    inputThirdPartyReference: '11114',
    inputServiceProviderCode: '171717', // business short code
  );

  await MpesaTransaction.c2b(token, apiHost, payload);
}
