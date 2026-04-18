import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/mpesa_client_config.dart';
import '../config/mpesa_config.dart';
import '../errors/mpesa_exception.dart';
import '../models/customer_name_request.dart';
import '../models/customer_name_response.dart';
import '../models/output_response.dart';
import '../models/payment_request.dart';
import '../models/payment_response.dart';
import '../models/reversal_request.dart';
import '../models/transaction_status_request.dart';
import '../models/transaction_status_response.dart';
import '../models/transfer_request.dart';

enum _MpesaOperation {
  c2b,
  b2c,
  reversal,
  transactionStatus,
  b2b,
  customerName,
}

class MpesaTransaction {
  MpesaTransaction(this.config, {http.Client? client})
      : _client = client ?? http.Client() {
    config.validate();
  }

  final MpesaClientConfig config;
  final http.Client _client;

  String get bearerToken => MpesaConfig.getBearerToken(
        config.credentials.apiKey,
        config.credentials.publicKey,
      );

  Future<http.Response> c2b(PaymentRequest paymentRequest) {
    return _sendJson(
      operation: _MpesaOperation.c2b,
      method: _HttpMethod.post,
      payload: paymentRequest.toJson(),
    );
  }

  Future<http.Response> b2c(PaymentRequest paymentRequest) {
    return _sendJson(
      operation: _MpesaOperation.b2c,
      method: _HttpMethod.post,
      payload: paymentRequest.toJson(),
    );
  }

  Future<http.Response> reversal(ReversalRequest reversalRequest) {
    return _sendJson(
      operation: _MpesaOperation.reversal,
      method: _HttpMethod.put,
      payload: reversalRequest.toJson(),
    );
  }

  Future<http.Response> getTransactionStatus(
    TransactionStatusRequest request,
  ) {
    return _sendQuery(
      operation: _MpesaOperation.transactionStatus,
      queryParameters: request.toQueryParameters(),
    );
  }

  Future<http.Response> b2b(TransferRequest transferRequest) {
    return _sendJson(
      operation: _MpesaOperation.b2b,
      method: _HttpMethod.post,
      payload: transferRequest.toJson(),
    );
  }

  Future<http.Response> getCustomerMaskedName(CustomerNameRequest request) {
    return _sendQuery(
      operation: _MpesaOperation.customerName,
      queryParameters: request.toQueryParameters(),
    );
  }

  PaymentResponse parsePaymentResponse(http.Response response) {
    return _parseResponse(
      response,
      parserName: 'parsePaymentResponse',
      fromJson: paymentResponseFromJson,
    );
  }

  TransactionStatusResponse parseTransactionStatusResponse(
    http.Response response,
  ) {
    return _parseResponse(
      response,
      parserName: 'parseTransactionStatusResponse',
      fromJson: transactionStatusResponseFromJson,
    );
  }

  CustomerNameResponse parseCustomerNameResponse(http.Response response) {
    return _parseResponse(
      response,
      parserName: 'parseCustomerNameResponse',
      fromJson: customerNameResponseFromJson,
    );
  }

  OutputResponse parseOutputResponse(http.Response response) {
    return _parseResponse(
      response,
      parserName: 'parseOutputResponse',
      fromJson: outputResponseFromJson,
    );
  }

  Future<http.Response> _sendJson({
    required _MpesaOperation operation,
    required _HttpMethod method,
    required Map<String, dynamic> payload,
  }) {
    final uri = _buildUri(operation);
    final body = json.encode(payload);
    switch (method) {
      case _HttpMethod.post:
        return _executeRequest(
          operation: operation,
          method: method,
          uri: uri,
          send: () => _client.post(
            uri,
            headers: _headers(),
            body: body,
            encoding: utf8,
          ),
        );
      case _HttpMethod.put:
        return _executeRequest(
          operation: operation,
          method: method,
          uri: uri,
          send: () => _client.put(
            uri,
            headers: _headers(),
            body: body,
            encoding: utf8,
          ),
        );
      case _HttpMethod.get:
        throw ArgumentError.value(method, 'method', 'GET is not valid for JSON');
    }
  }

  Future<http.Response> _sendQuery({
    required _MpesaOperation operation,
    required Map<String, String> queryParameters,
  }) {
    final uri = _buildUri(operation, queryParameters: queryParameters);
    return _executeRequest(
      operation: operation,
      method: _HttpMethod.get,
      uri: uri,
      send: () => _client.get(
        uri,
        headers: _headers(),
      ),
    );
  }

  Future<http.Response> _executeRequest({
    required _MpesaOperation operation,
    required _HttpMethod method,
    required Uri uri,
    required Future<http.Response> Function() send,
  }) async {
    try {
      return await send().timeout(config.requestTimeout);
    } on TimeoutException {
      throw MpesaTimeoutException(
        operation: _operationLabel(operation),
        method: _methodLabel(method),
        uri: uri,
        timeout: config.requestTimeout,
      );
    } on SocketException catch (error) {
      throw MpesaNetworkException(
        operation: _operationLabel(operation),
        method: _methodLabel(method),
        uri: uri,
        cause: error,
      );
    } on http.ClientException catch (error) {
      throw MpesaNetworkException(
        operation: _operationLabel(operation),
        method: _methodLabel(method),
        uri: uri,
        cause: error,
      );
    }
  }

  T _parseResponse<T>(
    http.Response response, {
    required String parserName,
    required T Function(String body) fromJson,
  }) {
    try {
      return fromJson(response.body);
    } catch (error) {
      throw MpesaResponseParseException(
        parser: parserName,
        body: response.body,
        cause: error,
      );
    }
  }

  Uri _buildUri(
    _MpesaOperation operation, {
    Map<String, String>? queryParameters,
  }) {
    return Uri.https(
      '${config.host}:${_portFor(operation)}',
      _pathFor(operation),
      queryParameters,
    );
  }

  Map<String, String> _headers() => {
        'content-type': 'application/json',
        'authorization': bearerToken,
        'origin': config.origin,
      };

  static String _operationLabel(_MpesaOperation operation) {
    switch (operation) {
      case _MpesaOperation.c2b:
        return 'c2b';
      case _MpesaOperation.b2c:
        return 'b2c';
      case _MpesaOperation.reversal:
        return 'reversal';
      case _MpesaOperation.transactionStatus:
        return 'transactionStatus';
      case _MpesaOperation.b2b:
        return 'b2b';
      case _MpesaOperation.customerName:
        return 'customerName';
    }
  }

  static String _methodLabel(_HttpMethod method) {
    switch (method) {
      case _HttpMethod.post:
        return 'POST';
      case _HttpMethod.put:
        return 'PUT';
      case _HttpMethod.get:
        return 'GET';
    }
  }

  static int _portFor(_MpesaOperation operation) {
    switch (operation) {
      case _MpesaOperation.c2b:
        return 18352;
      case _MpesaOperation.b2c:
        return 18345;
      case _MpesaOperation.reversal:
        return 18354;
      case _MpesaOperation.transactionStatus:
        return 18353;
      case _MpesaOperation.b2b:
        return 18349;
      case _MpesaOperation.customerName:
        return 19323;
    }
  }

  static String _pathFor(_MpesaOperation operation) {
    switch (operation) {
      case _MpesaOperation.c2b:
        return '/ipg/v1x/c2bPayment/singleStage/';
      case _MpesaOperation.b2c:
        return '/ipg/v1x/b2cPayment/';
      case _MpesaOperation.reversal:
        return '/ipg/v1x/reversal/';
      case _MpesaOperation.transactionStatus:
        return '/ipg/v1x/queryTransactionStatus/';
      case _MpesaOperation.b2b:
        return '/ipg/v1x/b2bPayment/';
      case _MpesaOperation.customerName:
        return '/ipg/v1x/queryCustomerName/';
    }
  }
}

enum _HttpMethod {
  post,
  put,
  get,
}
