# mpesa_sdk_mz

[![Pub Version](https://img.shields.io/pub/v/mpesa_sdk_mz?color=blue)](https://pub.dev/packages/mpesa_sdk_mz)
![GitHub](https://img.shields.io/github/license/MadalyImbate/mpesa_sdk_mz)
![GitHub repo size](https://img.shields.io/github/repo-size/MadalyImbate/mpesa_sdk_mz?color=red)

A Dart SDK for integrating with the M-Pesa Mozambique API, with explicit
support for `sandbox` and `production`.

This package is designed to be easy to start with and safe to configure:

- explicit environments
- separate credentials per environment
- typed requests
- raw HTTP responses plus typed parsers
- support for `C2B`, `B2C`, `B2B`, `Reversal`, `Transaction Status`, and
  `Query Customer Masked Name`

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [Environment Configuration](#environment-configuration)
- [Basic Usage](#basic-usage)
- [Responses](#responses)
- [API Summary](#api-summary)
- [Best Practices](#best-practices)
- [License](#license)

## Overview

This SDK wraps the authentication and HTTP calls needed to work with the
M-Pesa Mozambique APIs in Dart or Flutter applications.

You still get access to the original `http.Response`, but the package also
provides typed requests and typed response parsers.

Before integrating, check the official documentation:
https://developer.mpesa.vm.co.mz/documentation/

## Quick Start

### 1. Install the package

```yaml
dependencies:
  mpesa_sdk_mz: <latest_version>
```

### 2. Import it

```dart
import 'package:mpesa_sdk_mz/mpesa_sdk_mz.dart';
```

### 3. Export environment variables

```dart
export MPESA_ENV=sandbox
export MPESA_API_KEY=YOUR_API_KEY
export MPESA_PUBLIC_KEY='YOUR_PUBLIC_KEY'
export MPESA_ORIGIN=developer.mpesa.vm.co.mz
```

### 4. Create a client

```dart
final config = MpesaClientConfig(
  environment: MpesaEnvironment.sandbox,
  credentials: MpesaCredentials(
    apiKey: Platform.environment['MPESA_API_KEY']!,
    publicKey: Platform.environment['MPESA_PUBLIC_KEY']!,
  ),
  origin: Platform.environment['MPESA_ORIGIN']!,
  requestTimeout: const Duration(seconds: 30),
);

final transaction = MpesaTransaction(config);
```

### 5. Make a C2B call

```dart
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
```

## How It Works

The main SDK flow is:

1. Choose the active environment with `MpesaEnvironment`.
2. Provide that environment's credentials with `MpesaCredentials`.
3. Create `MpesaTransaction` using `MpesaClientConfig`.
4. Build a typed request and send the operation.
5. Use the raw `http.Response` or a typed parser from the SDK.

If you need the bearer token separately:

```dart
final token = MpesaConfig.getBearerToken(
  'API_KEY_HERE',
  'PUBLIC_KEY_HERE',
);
```

## Environment Configuration

The SDK supports two environments:

- `MpesaEnvironment.sandbox`
- `MpesaEnvironment.production`

Hosts are resolved automatically by the SDK:

- `sandbox` → `api.sandbox.vm.co.mz`
- `production` → `api.vm.co.mz`

Each environment should have:

- its own `apiKey`
- its own `publicKey`
- its own `origin`

Do not reuse credentials across environments.

### Sandbox

```dart
final config = MpesaClientConfig(
  environment: MpesaEnvironment.sandbox,
  credentials: MpesaCredentials(
    apiKey: Platform.environment['MPESA_API_KEY']!,
    publicKey: Platform.environment['MPESA_PUBLIC_KEY']!,
  ),
  origin: Platform.environment['MPESA_ORIGIN']!,
  requestTimeout: const Duration(seconds: 30),
);
```

### Production

```dart
final config = MpesaClientConfig(
  environment: MpesaEnvironment.production,
  credentials: MpesaCredentials(
    apiKey: Platform.environment['MPESA_API_KEY']!,
    publicKey: Platform.environment['MPESA_PUBLIC_KEY']!,
  ),
  origin: Platform.environment['MPESA_ORIGIN']!,
  requestTimeout: const Duration(seconds: 30),
);
```

## Basic Usage

### C2B

```dart
const payload = PaymentRequest(
  inputTransactionReference: 'T12344C',
  inputCustomerMsisdn: '25884xxxxxxx',
  inputAmount: '10',
  inputThirdPartyReference: '11114',
  inputServiceProviderCode: '171717',
);

final response = await transaction.c2b(payload);
final parsed = transaction.parsePaymentResponse(response);
```

### B2C

```dart
const payload = PaymentRequest(
  inputTransactionReference: 'T12344C',
  inputCustomerMsisdn: '25884xxxxxxx',
  inputAmount: '10',
  inputThirdPartyReference: '11114',
  inputServiceProviderCode: '171717',
);

await transaction.b2c(payload);
```

### B2B

```dart
const payload = TransferRequest(
  inputTransactionReference: 'T12344C',
  inputAmount: '10',
  inputThirdPartyReference: '11114',
  inputPrimaryPartyCode: '171717',
  inputReceiverPartyCode: '979797',
);

await transaction.b2b(payload);
```

### Reversal

```dart
const payload = ReversalRequest(
  inputTransactionID: '49XCDF6',
  inputSecurityCredential: 'Mpesa2019',
  inputInitiatorIdentifier: 'MPesa2018',
  inputThirdPartyReference: '11114',
  inputServiceProviderCode: '171717',
  inputReversalAmount: '10',
);

await transaction.reversal(payload);
```

### Query Transaction Status

```dart
final response = await transaction.getTransactionStatus(
  const TransactionStatusRequest(
    inputThirdPartyReference: '11114',
    inputQueryReference: '5C1400CVRO',
    inputServiceProviderCode: '171717',
  ),
);

final parsed = transaction.parseTransactionStatusResponse(response);
```

### Query Customer Masked Name

```dart
final response = await transaction.getCustomerMaskedName(
  const CustomerNameRequest(
    inputCustomerMsisdn: '25884xxxxxxx',
    inputThirdPartyReference: '11114',
    inputServiceProviderCode: '171717',
  ),
);

final parsed = transaction.parseCustomerNameResponse(response);
```

## Responses

All operations return `http.Response`.

Requests use a default timeout of `30` seconds. If the request does not finish
in time, the SDK throws `MpesaTimeoutException`.

This allows you to:

- inspect `statusCode`
- inspect `headers`
- use the raw `body`
- convert the response with the SDK's typed parsers

Example:

```dart
final response = await transaction.c2b(payload);

if (response.statusCode == 200 || response.statusCode == 201) {
  final parsed = transaction.parsePaymentResponse(response);
  print(parsed.outputTransactionID);
} else {
  print(response.body);
}
```

## Network Error Handling

Network failures are surfaced as SDK exceptions so callers can distinguish
transport problems from API responses:

- `MpesaTimeoutException`: the request exceeded `requestTimeout`
- `MpesaNetworkException`: socket or HTTP client transport failure
- `MpesaResponseParseException`: response body could not be parsed
- `MpesaConfigurationException`: bearer token generation failed before sending

Example:

```dart
try {
  final response = await transaction.c2b(payload);
  final parsed = transaction.parsePaymentResponse(response);
  print(parsed.outputResponseDesc);
} on MpesaTimeoutException catch (error) {
  print(error.message);
} on MpesaNetworkException catch (error) {
  print(error.message);
} on MpesaResponseParseException catch (error) {
  print(error.body);
}
```

## API Summary

| Operation | HTTP Method | Request Type | Recommended parser |
| --- | --- | --- | --- |
| C2B | `POST` | `PaymentRequest` | `parsePaymentResponse` |
| B2C | `POST` | `PaymentRequest` | `parsePaymentResponse` |
| B2B | `POST` | `TransferRequest` | `parsePaymentResponse` |
| Reversal | `PUT` | `ReversalRequest` | `parseOutputResponse` |
| Transaction Status | `GET` | `TransactionStatusRequest` | `parseTransactionStatusResponse` |
| Query Customer Masked Name | `GET` | `CustomerNameRequest` | `parseCustomerNameResponse` |

## Best Practices

- Use `sandbox` before going live in production.
- Do not mix credentials between environments.
- Load `apiKey`, `publicKey`, and `origin` from environment variables or a
  secure secret manager instead of hardcoding them.
- Always set `origin` explicitly for the active environment.
- Tune `requestTimeout` for your deployment instead of relying on unbounded I/O.
- Check `response.statusCode` before assuming success.
- Use the typed parsers when you want to read official response fields with less
  manual JSON handling.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
