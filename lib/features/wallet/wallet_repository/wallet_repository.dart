import 'dart:developer';

import 'package:learnwayv2/features/wallet/dto/create_order_params.dart';
import 'package:learnwayv2/features/wallet/dto/onramp_order_params.dart';
import 'package:learnwayv2/features/wallet/models/confirm_order_response.dart';
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
import 'package:learnwayv2/features/wallet/models/user_ops_result.dart';
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:learnwayv2/features/wallet/wallet_data_source/wallet_data_source.dart';
import 'package:learnwayv2/features/wallet/wallet_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';

///
class WalletRepository {
  factory WalletRepository() {
    _singleton._walletDataSource = WalletDataSource();
    return _singleton;
  }
  WalletRepository._internal();
  static final WalletRepository _singleton = WalletRepository._internal();
  late final WalletDataSource _walletDataSource;

  Future<List<LearnWayTransaction>> geTransactionWalletAddress({
    required String walletAddress,
    required int page,
    required int limit,
  }) async {
    try {
      final transactionInfo = await _walletDataSource.getTransactions(
        walletAddress: walletAddress,
        page: page,
        limit: limit,
      );
      return transactionInfo.data;
    } catch (e) {
      throw WalletNetworkException(
        message: e.toString(),
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<bool> sendTransactionOtp() async {
    try {
      return await _walletDataSource.sendTransactionOtp();
    } catch (e) {
      throw WalletNetworkException(
        message: e.toString(),
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<bool> verifyTransactionOtp(String otp) async {
    try {
      return await _walletDataSource.verifyTransactionOtp(otp);
    } catch (e) {
      throw WalletNetworkException(
        message: e.toString(),
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<Either<WalletException, List<SupportedCurrency>>>
  getSupportedCurrencies() async {
    try {
      final response = await _walletDataSource.getSupportedCurrencies();
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, QuoteResponse>> getQuote(
    DepositObject depositObject,
  ) async {
    log('WalletRepository.getQuote called with: ${depositObject.toJson()}');
    try {
      final response = await _walletDataSource.getOffRampQuote(depositObject);
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OrderLimit>> getOrderLimits({
    required String cryptoCurrency,
    required String fiatCurrency,
    required String payoutChannel,
    required String countryCode,
  }) async {
    try {
      final response = await _walletDataSource.getOrderLimits(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fiatCurrency,
        payoutChannel: payoutChannel,
        countryCode: countryCode,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, CreateOrderResponse>> createOrder({
    required CreateOrderParams request,
  }) async {
    try {
      final response = await _walletDataSource.createOrder(request: request);
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, TransactionStatusResponse>>
  getTransactionStatus({required String transactionId}) async {
    try {
      final response = await _walletDataSource.getTransactionStatus(
        transactionId: transactionId,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, ConfirmOrderResponse>> confirmOfframpOrder({
    required String transactionId,
    required String blockchainTxHash,
  }) async {
    try {
      final response = await _walletDataSource.confirmOfframpOrder(
        transactionId: transactionId,
        blockchainTxHash: blockchainTxHash,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, Map<String, double>>>
  getExchangeRates() async {
    try {
      final rates = await _walletDataSource.getExchangeRates();
      return Right(rates);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OnRampOrderLimit>> getOnRampOrderLimits({
    required String cryptoCurrency,
    required String fiatCurrency,
    required String despositChannel,
    required String countryCode,
  }) async {
    try {
      final response = await _walletDataSource.getOnRampOrderLimit(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fiatCurrency,
        despositChannel: despositChannel,
        countryCode: countryCode,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OnRampQuoteResponse>> getOnRampQuote({
    required String fiatCurrency,
    required String depositChannel,
    required String countryCode,
    required String cryptoCurrency,
    required double fiatAmount,
  }) async {
    try {
      final response = await _walletDataSource.getOnRampQuote(
        fiatCurrency: fiatCurrency,
        depositChannel: depositChannel,
        countryCode: countryCode,
        cryptoCurrency: cryptoCurrency,
        fiatAmount: fiatAmount,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OnRampOrderResponse>> initializeOnRampOrder({
    required OnRampOrderParams params,
  }) async {
    try {
      final response = await _walletDataSource.initializeOnRampOrder(
        params: params,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OnRampConfirmResponse>> confirmOnRampOrder({
    required String transactionId,
    required String fonbnkOrderId,
  }) async {
    try {
      final response = await _walletDataSource.confirmOnRampOrder(
        transactionId: transactionId,
        fonbnkOrderId: fonbnkOrderId,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }

  Future<Either<WalletException, OnRampIntermediateActionResponse>>
  submitOnRampIntermediateAction({
    required String transactionId,
    required Map<String, dynamic> fieldsForIntermediateAction,
  }) async {
    try {
      final response = await _walletDataSource.submitOnRampIntermediateAction(
        transactionId: transactionId,
        fieldsForIntermediateAction: fieldsForIntermediateAction,
      );
      return Right(response);
    } catch (e) {
      return Left(WalletNetworkException(message: e.toString()));
    }
  }
}
