import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:core/src/config/env/env.dart';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/wallet/dto/create_order_params.dart';
import 'package:learnwayv2/features/wallet/dto/onramp_order_params.dart';
import 'package:learnwayv2/features/wallet/models/confirm_order_response.dart';
import 'package:learnwayv2/features/wallet/models/exchange_rates_response.dart';
import 'package:learnwayv2/features/wallet/models/create_order_response.dart';
import 'package:learnwayv2/features/wallet/models/onramp_order_limit.dart';
import 'package:learnwayv2/features/wallet/models/onramp_confirm_response.dart';
import 'package:learnwayv2/features/wallet/models/onramp_intermediate_action_response.dart';
import 'package:learnwayv2/features/wallet/models/onramp_order_response.dart';
import 'package:learnwayv2/features/wallet/models/onramp_quote_response.dart';
import 'package:learnwayv2/features/wallet/models/transaction_status_response.dart';
import 'package:learnwayv2/features/wallet/models/deposit_object.dart';
import 'package:learnwayv2/features/wallet/models/order_limit.dart';
import 'package:learnwayv2/features/wallet/models/quote_response.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:learnwayv2/features/wallet/wallet_exception.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';
import 'package:learnwayv2/services/eip_4337/account_abstraction.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

///
class WalletDataSource {
  final service = locator<AAServices>();
  final client = locator<BaseApiClients>();

  Future<TransactionResponse> getTransactions({
    required String walletAddress,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      log('Get transactions: $walletAddress');
      final response = await http.get(
        Uri.parse('${getPath()}$walletAddress?limit=$limit'),
      );
      log('Get transactions: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return TransactionResponse.fromJson(decoded as Map<String, dynamic>);
      } else {
        throw Exception(
          'Error fetching wallet transaction ${response.statusCode}',
        );
      }
    } on Exception catch (e) {
      throw Exception('Error getting transaction: $e');
    }
  }

  String getPath() {
    if (Env.isDev) {
      return '${Env.learnWayIndexerUrl}/api/transfers/address/';
    }
    if (Env.isStaging) {
      return '${Env.learnWayIndexerUrl}/api/mainnet/transfers/address/';
    }
    if (Env.isProd) {
      return '${Env.learnWayIndexerUrl}/api/mainnet/transfers/address/';
    }
    return '${Env.learnWayIndexerUrl}/api/mainnet/transfers/address/';
  }

  Future<bool> verifyTransaction() async {
    final userEmail = LocalStorageService.getUserSync()?.email;
    final response = await locator.get<BaseApiClients>().post(
      Endpoints.verifyEmail,
      body: {'email': userEmail},
    );
    final Map<String, dynamic> decoded = json.decode(response.body);
    final message = decoded['message'];
    if (message is List && message.isNotEmpty) {
      throw Exception(message.join(', '));
    }
    return message is String && message.toLowerCase().contains('success');
  }

  Future<bool> sendTransactionOtp() async {
    try {
      final userEmail = LocalStorageService.getUserSync()?.email;
      if (userEmail == null || userEmail.isEmpty) {
        throw Exception('User email not found');
      }

      final userToken = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.post(
        Endpoints.verifyEmail,
        body: {'email': userEmail},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      log('Send transaction OTP response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        final message = decoded['message'];

        if (message is String && message.toLowerCase().contains('success')) {
          return true;
        }

        if (message is List && message.isNotEmpty) {
          throw Exception(message.join(', '));
        }

        return true;
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Error sending transaction OTP: $e');
    }
  }

  Future<bool> verifyTransactionOtp(String otp) async {
    try {
      log('Verify transaction OTP: $otp');
      final userEmail = LocalStorageService.getUserSync()?.email;
      if (userEmail == null || userEmail.isEmpty) {
        throw Exception('User email not found');
      }

      final response = await client.post(
        Endpoints.verifyOtp,
        body: {'email': userEmail, 'otpCode': otp},
      );

      log('Verify transaction OTP response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        final message = decoded['message'];

        if (message is String && message.toLowerCase().contains('success')) {
          return true;
        }

        if (message is List && message.isNotEmpty) {
          throw Exception(message.join(', '));
        }

        return true;
      } else if (response.statusCode == 400) {
        final decoded = json.decode(response.body);
        final message = decoded['message'];
        if (message is String) {
          throw Exception(message);
        } else if (message is List && message.isNotEmpty) {
          throw Exception(message.join(', '));
        }
        throw Exception('Invalid OTP');
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Error verifying transaction OTP: $e');
    }
  }

  Future<QuoteResponse> getOffRampQuote(DepositObject deposit) async {
    log('Getting OffRamp quote for deposit: ${deposit.toJson()}');

    try {
      final response = await client
          .post(
            Endpoints.getOffRampQuote,
            body: {
              "cryptoCurrency": deposit.asset,
              "cryptoNetwork": deposit.network,
              "cryptoAmount": deposit.amount,
              "fiatCurrency": deposit.currency,
              "payoutChannel": deposit.paymentChannel,
              "countryCode": deposit.countryIsoCode,
            },
          )
          .timeout(const Duration(seconds: 15));

      log('OffRamp quote response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return QuoteResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        _reportRampError(
          'getOffRampQuote',
          message: errorMessage,
          code: errorCode,
          statusCode: response.statusCode,
          responseBody: response.body,
        );
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException catch (e, st) {
      log(
        'getOffRampQuote: no internet: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException catch (e, st) {
      log(
        'getOffRampQuote: timed out: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: ' The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      if (e is RampException) rethrow;
      _reportRampError('getOffRampQuote', error: e, stackTrace: st);
      log('Unexpected error in getOffRampQuote: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<List<SupportedCurrency>> getSupportedCurrencies() async {
    try {
      final response = await client.get(Endpoints.getSupportedCurrencies);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as List<dynamic>;
        log('Supported currencies retrieved: ${response.body}');

        final supportedCurrencies = decoded
            .map((e) => SupportedCurrency.fromJson(e as Map<String, dynamic>))
            .toList();

        return supportedCurrencies;
      }

      final decoded = json.decode(response.body);
      final errorMessage =
          decoded['message'] ?? 'Unable to get supported currencies';

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error fetching supported currencies: $e');
    }
  }

  Future<OrderLimit> getOrderLimits({
    required String cryptoCurrency,
    required String fiatCurrency,
    required String payoutChannel,
    required String countryCode,
  }) async {
    try {
      final queryParams =
          '?cryptoCurrency=$cryptoCurrency&fiatCurrency=$fiatCurrency&payoutChannel=$payoutChannel&countryCode=$countryCode';
      final response = await client
          .get('${Endpoints.getOrderLimits}$queryParams')
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        log('Order limits retrieved: ${response.body}');

        return OrderLimit.fromJson(decoded as Map<String, dynamic>);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        _reportRampError(
          'getOrderLimits',
          message: errorMessage,
          code: errorCode,
          statusCode: response.statusCode,
          responseBody: response.body,
        );
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException catch (e, st) {
      log(
        'getOrderLimits: no internet: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException catch (e, st) {
      log(
        'getOrderLimits: timed out: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: ' The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      if (e is RampException) rethrow;
      _reportRampError('getOrderLimits', error: e, stackTrace: st);
      log('Unexpected error in getOrderLimits: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<CreateOrderResponse> createOrder({
    required CreateOrderParams request,
  }) async {
    try {
      log('Creating order with params: ${request.toJson()}');
      final response = await client
          .post(Endpoints.createOrder, body: request.toJson())
          .timeout(const Duration(seconds: 15));

      log('Create order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return CreateOrderResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        log('Error creating order: $errorMessage (code: $errorCode)');
        _reportRampError(
          'createOrder',
          message: errorMessage,
          code: errorCode,
          statusCode: response.statusCode,
          responseBody: response.body,
        );
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException catch (e, st) {
      log('createOrder: no internet: $e', name: 'OfframpError', stackTrace: st);
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException catch (e, st) {
      log('createOrder: timed out: $e', name: 'OfframpError', stackTrace: st);
      throw RampException(
        message: ' The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      if (e is RampException) rethrow;
      _reportRampError('createOrder', error: e, stackTrace: st);
      log('Unexpected error in createOrder: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<TransactionStatusResponse> getTransactionStatus({
    required String transactionId,
  }) async {
    try {
      log('Getting transaction status for: $transactionId');
      final response = await client
          .get('${Endpoints.getTransactionStatus}/$transactionId')
          .timeout(const Duration(seconds: 15));

      log(
        'Transaction status response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return TransactionStatusResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        _reportRampError(
          'getTransactionStatus',
          message: errorMessage,
          code: errorCode,
          statusCode: response.statusCode,
          responseBody: response.body,
        );
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException catch (e, st) {
      log(
        'getTransactionStatus: no internet: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException catch (e, st) {
      log(
        'getTransactionStatus: timed out: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      if (e is RampException) rethrow;
      _reportRampError('getTransactionStatus', error: e, stackTrace: st);
      log('Unexpected error in getTransactionStatus: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<Map<String, double>> getExchangeRates() async {
    try {
      final response = await client.get(Endpoints.getExchangeRates);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final exchangeRatesResponse = ExchangeRatesResponse.fromJson(decoded);
        log('Exchange rates retrieved: ${exchangeRatesResponse.toJson()}');
        return exchangeRatesResponse.data.toFlatRatesMap();
      } else {
        throw Exception(
          'Failed to fetch exchange rates: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  Future<OnRampQuoteResponse> getOnRampQuote({
    required String fiatCurrency,
    required String depositChannel,
    required String countryCode,
    required String cryptoCurrency,
    required double fiatAmount,
  }) async {
    try {
      final response = await client
          .post(
            Endpoints.getOnRampQuote,
            body: {
              'fiatCurrency': fiatCurrency,
              'depositChannel': depositChannel,
              'countryCode': countryCode,
              'cryptoCurrency': cryptoCurrency,
              'fiatAmount': fiatAmount,
            },
          )
          .timeout(const Duration(seconds: 15));

      log('OnRamp quote response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return OnRampQuoteResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';
        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException {
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e) {
      if (e is RampException) rethrow;
      log('Unexpected error in getOnRampQuote: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<OnRampOrderResponse> initializeOnRampOrder({
    required OnRampOrderParams params,
  }) async {
    try {
      log('Initializing on-ramp order: ${params.toJson()}');
      final response = await client
          .post(Endpoints.initializeOnRamp, body: params.toJson())
          .timeout(const Duration(seconds: 15));

      log('OnRamp order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return OnRampOrderResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';
        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException {
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e) {
      if (e is RampException) rethrow;
      log('Unexpected error in initializeOnRampOrder: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<OnRampConfirmResponse> confirmOnRampOrder({
    required String transactionId,
    required String fonbnkOrderId,
  }) async {
    try {
      log('Confirming on-ramp order: $transactionId / $fonbnkOrderId');
      final response = await client
          .post(
            Endpoints.confirmOnRamperOder,
            body: {
              'transactionId': transactionId,
              'fonbnkOrderId': fonbnkOrderId,
            },
          )
          .timeout(const Duration(seconds: 15));

      log('OnRamp confirm response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return OnRampConfirmResponse.fromJson(decoded);
      } else {
        if (response.statusCode == 400) {
          try {
            final errorDecode = json.decode(response.body);
            final message = (errorDecode['message']?.toString() ?? '')
                .toUpperCase();
            if (message.contains('COMPLETED') || message.contains('SUCCESS')) {
              return OnRampConfirmResponse(
                transactionId: transactionId,
                fonbnkOrderId: fonbnkOrderId,
                status: 'COMPLETED',
              );
            }
            if (message.contains('PROCESSING')) {
              return OnRampConfirmResponse(
                transactionId: transactionId,
                fonbnkOrderId: fonbnkOrderId,
                status: 'PROCESSING',
              );
            }
          } catch (_) {}
        }

        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';
        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException {
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e) {
      if (e is RampException) rethrow;
      log('Unexpected error in confirmOnRampOrder: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<OnRampIntermediateActionResponse> submitOnRampIntermediateAction({
    required String transactionId,
    required Map<String, dynamic> fieldsForIntermediateAction,
  }) async {
    try {
      log('Submitting on-ramp intermediate action for: $transactionId');
      final response = await client
          .post(
            Endpoints.intermediateAction,
            body: {
              'transactionId': transactionId,
              'fieldsForIntermediateAction': fieldsForIntermediateAction,
            },
          )
          .timeout(const Duration(seconds: 15));

      log(
        'OnRamp intermediate action response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return OnRampIntermediateActionResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';
        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException {
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException {
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e) {
      if (e is RampException) rethrow;
      log('Unexpected error in submitOnRampIntermediateAction: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<ConfirmOrderResponse> confirmOfframpOrder({
    required String transactionId,
    required String blockchainTxHash,
  }) async {
    try {
      log(
        'Confirming offramp order: $transactionId with hash: $blockchainTxHash',
      );
      final response = await client
          .post(
            Endpoints.confirmOrder,
            body: {
              "transactionId": transactionId,
              "blockchainTransactionHash": blockchainTxHash,
            },
          )
          .timeout(const Duration(seconds: 15));

      log('Confirm order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return ConfirmOrderResponse.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        _reportRampError(
          'confirmOfframpOrder',
          message: errorMessage,
          code: errorCode,
          statusCode: response.statusCode,
          responseBody: response.body,
        );
        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException catch (e, st) {
      log(
        'confirmOfframpOrder: no internet: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'Please check your internet connection.',
        code: 'NO_INTERNET',
      );
    } on TimeoutException catch (e, st) {
      log(
        'confirmOfframpOrder: timed out: $e',
        name: 'OfframpError',
        stackTrace: st,
      );
      throw RampException(
        message: 'The connection timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      if (e is RampException) rethrow;
      _reportRampError('confirmOfframpOrder', error: e, stackTrace: st);
      log('Unexpected error in confirmOfframpOrder: $e');
      throw RampException(
        message: 'Something went wrong. Please try again.',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  Future<OnRampOrderLimit> getOnRampOrderLimit({
    String? fiatCurrency,
    String? despositChannel,
    String? countryCode,
    String? cryptoCurrency,
  }) async {
    try {
      final queryParams = <String, String>{
        'fiatCurrency': ?fiatCurrency,
        'depositChannel': ?despositChannel,
        'countryCode': ?countryCode,
        'cryptoCurrency': ?cryptoCurrency,
      };
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final endpoint = queryString.isNotEmpty
          ? '${Endpoints.getOnRampOrderLimit}?$queryString'
          : Endpoints.getOnRampOrderLimit;

      final response = await client
          .get(endpoint)
          .timeout(const Duration(seconds: 15));

      log('Confirm order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return OnRampOrderLimit.fromJson(decoded);
      } else {
        String errorMessage = 'Unknown error occurred';
        String errorCode = 'unknown';

        try {
          final errorDecode = json.decode(response.body);
          if (errorDecode is Map<String, dynamic>) {
            errorMessage = errorDecode['message']?.toString() ?? errorMessage;
            errorCode = errorDecode['statusCode']?.toString() ?? errorCode;
          }
        } catch (_) {
          errorMessage = 'Server Error: ${response.statusCode}';
          errorCode = '${response.statusCode}';
        }

        throw RampException(message: errorMessage, code: errorCode);
      }
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  // Future<OnRampQouteResponse> getOnRampQuote() async {}
}

/// Logs an off-ramp API failure locally and sends it to Sentry (all flavors).
void _reportRampError(
  String operation, {
  String? message,
  String? code,
  int? statusCode,
  String? responseBody,
  Object? error,
  StackTrace? stackTrace,
}) {
  log(
    'Ramp error in $operation: status=$statusCode code=$code '
    'message=$message body=$responseBody error=$error',
    name: 'OfframpError',
  );
  Sentry.captureException(
    error ?? RampException(message: message ?? 'Unknown', code: code),
    stackTrace: stackTrace ?? StackTrace.current,
    withScope: (scope) {
      scope.setTag('feature', 'offramp');
      scope.setTag('operation', operation);
      if (statusCode != null) scope.setTag('http_status', '$statusCode');
      scope.setContexts('ramp_response', {
        'statusCode': statusCode,
        'code': code,
        'message': message,
        'body': responseBody,
      });
    },
  );
}
