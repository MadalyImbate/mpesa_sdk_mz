import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mpesa_sdk_mz/mpesa_sdk_mz.dart';
import 'package:test/test.dart';

const _testPublicKey = '''
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAszE+xAKVB9HRarr6/uHYYAX/
RdD6KGVIGlHv98QKDIH26ldYJQ7zOuo9qEscO0M1psSPe/67AWYLEXh13fbtcSKGP6WF
jT9OY6uV5ykw9508x1sW8UQ4ZhTRNrlNsKizE/glkBfcF2lwDXJGQennwgickWz7VN+A
P/1c4DnMDfcl8iVIDlsbudFoXQh5aLCYl+XOMt/vls5a479PLMkPcZPOgMTCYTCE6ReX
3KD2aGQ62uiu2T4mK+7Z6yvKvhPRF2fTKI+zOFWly//IYlyB+sde42cIU/588msUmgr3
G9FYyN2vKPVy/MhIZpiFyVc3vuAAJ/mzue5p/G329wzgcz0ztyluMNAGUL9A4ZiFcKOe
bT6y6IgIMBeEkTwyhsxRHMFXlQRgTAufaO5hiR/usBMkoazJ6XrGJB8UadjH2m2+kdJI
ieI4FbjzCiDWKmuM58rllNWdBZK0XVHNsxmBy7yhYw3aAIhFS0fNEuSmKTfFpJFMBzIQ
YbdTgI28rZPAxVEDdRaypUqBMCq4OstCxgGvR3Dy1eJDjlkuiWK9Y9RGKF8HOI5a4ruH
yLheddZxsUihziPF9jKTknsTZtF99eKTIjhV7qfTzxXq+8GGoCEABIyu26LZuL8X12bF
qtwLAcjfjoB7HlRHtPszv6PJ0482ofWmeH0BE8om7VrSGxsCAwEAAQ==
-----END PUBLIC KEY-----
''';

void main() {
  group('MpesaTransaction', () {
    late MpesaClientConfig config;

    setUp(() {
      config = const MpesaClientConfig(
        environment: MpesaEnvironment.sandbox,
        credentials: MpesaCredentials(
          apiKey: 'sandbox-api-key',
          publicKey: _testPublicKey,
        ),
        origin: 'developer.mpesa.vm.co.mz',
      );
    });

    test('validates required config fields', () {
      expect(
        () => const MpesaClientConfig(
          environment: MpesaEnvironment.sandbox,
          credentials: MpesaCredentials(apiKey: '', publicKey: 'pk'),
          origin: 'developer.mpesa.vm.co.mz',
        ).validate(),
        throwsArgumentError,
      );

      expect(
        () => const MpesaClientConfig(
          environment: MpesaEnvironment.sandbox,
          credentials: MpesaCredentials(apiKey: 'key', publicKey: 'pk'),
          origin: '',
        ).validate(),
        throwsArgumentError,
      );
    });

    test('resolves environment host', () {
      expect(config.host, 'api.sandbox.vm.co.mz');
      expect(config.requestTimeout, const Duration(seconds: 30));
      expect(
        const MpesaClientConfig(
          environment: MpesaEnvironment.production,
          credentials: MpesaCredentials(apiKey: 'key', publicKey: 'pk'),
          origin: 'api.vm.co.mz',
        ).host,
        'api.vm.co.mz',
      );
    });

    test('validates request timeout is greater than zero', () {
      expect(
        () => const MpesaClientConfig(
          environment: MpesaEnvironment.sandbox,
          credentials: MpesaCredentials(apiKey: 'key', publicKey: 'pk'),
          origin: 'developer.mpesa.vm.co.mz',
          requestTimeout: Duration.zero,
        ).validate(),
        throwsArgumentError,
      );
    });

    test('serializes payment request using string amount', () {
      const request = PaymentRequest(
        inputTransactionReference: 'T12344C',
        inputCustomerMsisdn: '25884xxxxxxx',
        inputAmount: '10',
        inputThirdPartyReference: '11114',
        inputServiceProviderCode: '171717',
      );

      expect(
        request.toJson(),
        {
          'input_TransactionReference': 'T12344C',
          'input_CustomerMSISDN': '25884xxxxxxx',
          'input_Amount': '10',
          'input_ThirdPartyReference': '11114',
          'input_ServiceProviderCode': '171717',
        },
      );
    });

    test('serializes reversal request without optional amount', () {
      const request = ReversalRequest(
        inputTransactionID: '49XCDF6',
        inputSecurityCredential: 'Mpesa2019',
        inputInitiatorIdentifier: 'MPesa2018',
        inputThirdPartyReference: '11114',
        inputServiceProviderCode: '171717',
      );

      expect(request.toJson().containsKey('input_ReversalAmount'), isFalse);
    });

    test('sends c2b request to sandbox endpoint with configured origin', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response(
          json.encode({
            'output_ResponseCode': 'INS-0',
            'output_ResponseDesc': 'Request processed successfully',
          }),
          201,
        );
      });
      final transaction = MpesaTransaction(config, client: client);

      await transaction.c2b(
        const PaymentRequest(
          inputTransactionReference: 'T12344C',
          inputCustomerMsisdn: '25884xxxxxxx',
          inputAmount: '10',
          inputThirdPartyReference: '11114',
          inputServiceProviderCode: '171717',
        ),
      );

      expect(captured.method, 'POST');
      expect(
        captured.url.toString(),
        'https://api.sandbox.vm.co.mz:18352/ipg/v1x/c2bPayment/singleStage/',
      );
      expect(captured.headers['origin'], 'developer.mpesa.vm.co.mz');
      expect(captured.headers['authorization'], startsWith('Bearer '));
      expect(captured.body, contains('"input_Amount":"10"'));
    });

    test('builds query parameters for transaction status', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response(
          json.encode({
            'output_ResponseCode': 'INS-0',
            'output_ResponseDesc': 'Success',
            'output_ResponseTransactionStatus': 'Completed',
          }),
          200,
        );
      });
      final transaction = MpesaTransaction(config, client: client);

      await transaction.getTransactionStatus(
        const TransactionStatusRequest(
          inputThirdPartyReference: '11114',
          inputQueryReference: '5C1400CVRO',
          inputServiceProviderCode: '171717',
        ),
      );

      expect(captured.method, 'GET');
      expect(
        captured.url.toString(),
        'https://api.sandbox.vm.co.mz:18353/ipg/v1x/queryTransactionStatus/?input_ThirdPartyReference=11114&input_QueryReference=5C1400CVRO&input_ServiceProviderCode=171717',
      );
    });

    test('supports query customer masked name endpoint', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return http.Response(
          json.encode({
            'output_ResultCode': 'INS-0',
            'output_ResultDesc': 'Request processed successfully',
            'output_CustomerName': 'Jo*n Sm**h',
          }),
          200,
        );
      });
      final transaction = MpesaTransaction(config, client: client);

      final response = await transaction.getCustomerMaskedName(
        const CustomerNameRequest(
          inputCustomerMsisdn: '25884xxxxxxx',
          inputThirdPartyReference: '11114',
          inputServiceProviderCode: '171717',
        ),
      );

      final parsed = transaction.parseCustomerNameResponse(response);

      expect(captured.method, 'GET');
      expect(
        captured.url.toString(),
        'https://api.sandbox.vm.co.mz:19323/ipg/v1x/queryCustomerName/?input_CustomerMSISDN=25884xxxxxxx&input_ThirdPartyReference=11114&input_ServiceProviderCode=171717',
      );
      expect(parsed.outputCustomerName, 'Jo*n Sm**h');
    });

    test('maps request timeout to MpesaTimeoutException', () async {
      final client = MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return http.Response('{}', 200);
      });
      final transaction = MpesaTransaction(
        const MpesaClientConfig(
          environment: MpesaEnvironment.sandbox,
          credentials: MpesaCredentials(apiKey: 'key', publicKey: _testPublicKey),
          origin: 'developer.mpesa.vm.co.mz',
          requestTimeout: Duration(milliseconds: 10),
        ),
        client: client,
      );

      await expectLater(
        transaction.getTransactionStatus(
          const TransactionStatusRequest(
            inputThirdPartyReference: '11114',
            inputQueryReference: '5C1400CVRO',
            inputServiceProviderCode: '171717',
          ),
        ),
        throwsA(isA<MpesaTimeoutException>()),
      );
    });

    test('maps socket errors to MpesaNetworkException', () async {
      final client = MockClient((request) async {
        throw const SocketException('No route to host');
      });
      final transaction = MpesaTransaction(config, client: client);

      await expectLater(
        transaction.c2b(
          const PaymentRequest(
            inputTransactionReference: 'T12344C',
            inputCustomerMsisdn: '25884xxxxxxx',
            inputAmount: '10',
            inputThirdPartyReference: '11114',
            inputServiceProviderCode: '171717',
          ),
        ),
        throwsA(isA<MpesaNetworkException>()),
      );
    });

    test('maps client errors to MpesaNetworkException', () async {
      final client = MockClient((request) async {
        throw http.ClientException('Connection closed');
      });
      final transaction = MpesaTransaction(config, client: client);

      await expectLater(
        transaction.c2b(
          const PaymentRequest(
            inputTransactionReference: 'T12344C',
            inputCustomerMsisdn: '25884xxxxxxx',
            inputAmount: '10',
            inputThirdPartyReference: '11114',
            inputServiceProviderCode: '171717',
          ),
        ),
        throwsA(isA<MpesaNetworkException>()),
      );
    });

    test('preserves non-success http responses', () async {
      final client = MockClient((request) async {
        return http.Response('{"error":"bad request"}', 400);
      });
      final transaction = MpesaTransaction(config, client: client);

      final response = await transaction.c2b(
        const PaymentRequest(
          inputTransactionReference: 'T12344C',
          inputCustomerMsisdn: '25884xxxxxxx',
          inputAmount: '10',
          inputThirdPartyReference: '11114',
          inputServiceProviderCode: '171717',
        ),
      );

      expect(response.statusCode, 400);
      expect(response.body, contains('bad request'));
    });

    test('throws parse exception for invalid response body', () {
      final transaction = MpesaTransaction(config);

      expect(
        () => transaction.parsePaymentResponse(http.Response('not-json', 200)),
        throwsA(isA<MpesaResponseParseException>()),
      );
    });
  });
}
