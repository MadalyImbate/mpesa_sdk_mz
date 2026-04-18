import 'package:mpesa_sdk_mz/mpesa_sdk_mz.dart';

import 'mpesa_keys.dart';

Future<void> main() async {
  final exampleConfig = ExampleMpesaConfig.fromEnv();
  final transaction = MpesaTransaction(
    MpesaClientConfig(
      environment: exampleConfig.environment,
      credentials: exampleConfig.credentials,
      origin: exampleConfig.origin,
    ),
  );

  const payload = PaymentRequest(
    inputTransactionReference: 'T12344C',
    inputCustomerMsisdn: '25884xxxxxxx',
    inputAmount: '10',
    inputThirdPartyReference: '11114',
    inputServiceProviderCode: '171717',
  );

  final response = await transaction.c2b(payload);
  final parsed = transaction.parsePaymentResponse(response);

  print(response.statusCode);
  print(parsed.outputResponseDesc);
}
