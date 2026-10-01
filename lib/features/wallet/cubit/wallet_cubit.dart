import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/balance_caching.dart';
import 'package:learnwayv2/features/wallet/dto/create_order_params.dart';
import 'package:learnwayv2/features/wallet/exchange_cache_manager.dart';
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
import 'package:learnwayv2/features/wallet/models/wallet_transactions.dart';
import 'package:learnwayv2/features/wallet/transaction_manager.dart';
import 'package:learnwayv2/features/wallet/utils.dart';
import 'package:learnwayv2/features/wallet/wallet_data_source/wallet_data_source.dart';
import 'package:learnwayv2/features/wallet/wallet_repository/wallet_repository.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/ethereum_utils.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:provider/provider.dart';
import 'package:variance_dart/variance_dart.dart';
// GasEstimation isn't exported from the SDK's public barrel.
// ignore: implementation_imports
import 'package:variance_dart/src/interfaces/interfaces.dart'
    show GasEstimation;
import 'package:wallet/wallet.dart';
import 'package:core/src/config/env/env.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({WalletRepository? walletRepository})
    : _walletRepository = walletRepository ?? locator<WalletRepository>(),
      super(const WalletState());

  final WalletRepository _walletRepository;

  Future<void> fetchWalletData() async {
    log('Called fetchWalletData()');
    emit(
      state.copyWith(
        walletStatus: WalletStatus.loading,
        clearWalletError: true,
      ),
    );

    final walletAddress = await LocalStorageService.getWalletAddress();

    if (walletAddress.isEmpty) {
      emit(
        state.copyWith(
          walletStatus: WalletStatus.error,
          walletError: 'Wallet address not found',
        ),
      );
      return;
    }

    try {
      final cachedTxs = await _getCachedTransactions(walletAddress);
      log('Loaded cached transactions: ${cachedTxs.data.length} items');
      emit(
        state.copyWith(
          walletStatus: WalletStatus.loaded,
          transactions: cachedTxs,
        ),
      );

      final freshTxs = await _walletRepository.geTransactionWalletAddress(
        walletAddress: walletAddress,
        page: 1,
        limit: 20,
      );

      emit(
        state.copyWith(
          walletStatus: WalletStatus.loaded,
          transactions: TransactionResponse(
            success: true,
            count: freshTxs.length,
            data: freshTxs,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          walletStatus: WalletStatus.error,
          walletError: e.toString(),
        ),
      );
    }
  }

  Future<void> reloadWalletData() async {
    await fetchWalletData();
  }

  Future<void> fetchBalance({bool forceRefresh = false}) async {
    final walletAddress = await LocalStorageService.getWalletAddress();
    if (walletAddress.isEmpty) return;

    if (!forceRefresh) {
      final cachedBalance = await BalanceCache.getCachedBalance(walletAddress);
      if (cachedBalance != null) {
        emit(
          state.copyWith(
            balanceStatus: BalanceStatus.loaded,
            balance: cachedBalance,
          ),
        );
        return;
      }
    } else {
      await BalanceCache.forceRefresh();
    }

    emit(
      state.copyWith(
        balanceStatus: BalanceStatus.loading,
        clearBalanceError: true,
      ),
    );

    try {
      final balance = await _erc20Balance();

      await BalanceCache.saveBalance(walletAddress, balance);

      emit(
        state.copyWith(balanceStatus: BalanceStatus.loaded, balance: balance),
      );
    } catch (e) {
      emit(
        state.copyWith(
          balanceStatus: BalanceStatus.error,
          balanceError: 'Error getting balance: $e',
        ),
      );
    }
  }

  Future<void> refreshBalance() async {
    await fetchBalance(forceRefresh: true);
  }

  Future<void> _applyGasBuffer(SmartWallet smartWallet) async {
    dynamic high;
    try {
      high = await smartWallet.getGasPrice(GasEstimation.high);
    } catch (e) {
      log('Could not fetch high-tier gas price: $e');
    }

    BigInt pad(BigInt v) => (v * BigInt.from(3)) ~/ BigInt.two;
    BigInt max(BigInt a, BigInt b) => a > b ? a : b;
    final minPriorityFee = BigInt.from(1500000);

    smartWallet.gasOverrides = GasOverrides(
      maxFeePerGas: (v) =>
          pad(max(v ?? BigInt.zero, high?.maxFeePerGas ?? BigInt.zero)),
      maxPriorityFeePerGas: (v) => max(
        pad(max(v ?? BigInt.zero, high?.maxPriorityFeePerGas ?? BigInt.zero)),
        minPriorityFee,
      ),
    );
  }

  Future<void> transferToken({
    required String amount,
    required String recipientAddress,
  }) async {
    log('Called transferToken()');
    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.sending,
        clearTransactionError: true,
        clearTransactionHash: true,
      ),
    );

    try {
      final smartWallet = locator<SmartWallet>();
      await _applyGasBuffer(smartWallet);
      final originalWei = convertToWei(amount, getTokenDecimals());

      UserOperationResponse? response;

      if (EthereumAddressUtils.isValidAddress(recipientAddress)) {
        final responsex = await smartWallet.sendTransaction(
          EthereumAddress.fromHex(Env.activeTokenAddress),
          encodeERC20TransferWithTag(
            EthereumAddress.fromHex(Env.activeTokenAddress),
            EthereumAddress.fromHex(recipientAddress),
            originalWei,
          ),
        );
        log('Transfer transaction sent, response: ${responsex.userOpHash}');
        response = responsex;
      }

      if (response == null) {
        throw Exception(
          'Failed to initiate transfer - no response from wallet',
        );
      }

      log('Transfer initiated with userOpHash: ${response.userOpHash}');
      final userOpResult = await response.wait();
      final txHash =
          userOpResult?.txReceipt.transactionHash ?? response.userOpHash;

      log('User operation result: $txHash');

      emit(
        state.copyWith(
          transactionStatus: TransactionStatus.success,
          transactionHash: txHash,
        ),
      );

      await refreshBalance();
    } catch (e, stackTrace) {
      if (e is TypeError) {
        log(
          'transferToken null cast — inputs:'
          ' amount=$amount'
          ' recipient=$recipientAddress'
          ' tokenContract=${Env.activeTokenAddress}',
        );
      }
      log('Error sending USDT: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          transactionStatus: TransactionStatus.failed,
          transactionError: 'Failed to transfer funds: ${e.toString()}',
        ),
      );
      emit(state.copyWith(withdrawStatus: WithdrawStatus.failed));
    }
  }

  Future<void> swapToUSDT({required String amount}) async {
    emit(
      state.copyWith(
        swapStatus: SwapStatus.swapping,
        clearSwapError: true,
        clearSwapTransaction: true,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(swapStatus: SwapStatus.success));

      await refreshBalance();
    } catch (e) {
      emit(
        state.copyWith(
          swapStatus: SwapStatus.failed,
          swapError: 'Error swapping tokens: $e',
        ),
      );
    }
  }

  Future<void> fetchExchangeRates({bool forceRefresh = false}) async {
    try {
      final rates = forceRefresh
          ? await ExchangeRateCacheManager.forceRefreshRates()
          : await ExchangeRateCacheManager.getRatesWithFallback();

      emit(state.copyWith(exchangeRates: rates));
    } catch (e) {
      emit(state.copyWith(walletError: 'Failed to fetch exchange rates: $e'));
    }
  }

  Future<void> refreshExchangeRates() async {
    await fetchExchangeRates(forceRefresh: true);
  }

  Future<void> loadCachedExchangeRates() async {
    try {
      if (await ExchangeRateCacheManager.hasFreshRates()) {
        final cachedRates = await LocalStorageService.getExchangeRates();
        if (cachedRates != null) {
          emit(state.copyWith(exchangeRates: cachedRates));
        }
      }
    } catch (e) {}
  }

  Future<List<String>> getRecentDepositReferences() async {
    try {
      final storage = locator<FlutterSecureStorage>();
      final allKeys = await storage.readAll();

      return allKeys.entries
          .where((entry) => entry.key.startsWith('last_deposit_ref_'))
          .map((entry) => entry.value)
          .toList();
    } catch (e) {
      log('Error retrieving deposit references: $e');
      return [];
    }
  }

  void resetTransactionState() {
    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.initial,
        clearTransactionError: true,
        clearTransactionHash: true,
      ),
    );
  }

  void resetSwapState() {
    emit(
      state.copyWith(
        swapStatus: SwapStatus.initial,
        clearSwapError: true,
        clearSwapTransaction: true,
      ),
    );
  }

  void resetDepositState() {
    emit(
      state.copyWith(
        depositStatus: DepositStatus.initial,
        clearDepositError: true,
      ),
    );
  }

  void resetAllErrors() {
    emit(
      state.copyWith(
        walletStatus: state.hasWalletError
            ? WalletStatus.initial
            : state.walletStatus,
        transactionStatus: state.hasTransactionError
            ? TransactionStatus.initial
            : state.transactionStatus,
        balanceStatus: state.hasBalanceError
            ? BalanceStatus.initial
            : state.balanceStatus,
        swapStatus: state.hasSwapError ? SwapStatus.initial : state.swapStatus,
        depositStatus: state.hasDepositError
            ? DepositStatus.initial
            : state.depositStatus,
        clearWalletError: true,
        clearTransactionError: true,
        clearBalanceError: true,
        clearSwapError: true,
        clearDepositError: true,
      ),
    );
  }

  Future<TransactionResponse> _getCachedTransactions(
    String walletAddress,
  ) async {
    final transactionCache = TransactionCache();
    return transactionCache.getTransactionsFromStorage(walletAddress, ({
      required String walletAddress,
      required int limit,
      required int offset,
    }) async {
      final page = (offset ~/ limit) + 1;
      final transactions = await _walletRepository.geTransactionWalletAddress(
        walletAddress: walletAddress,
        page: page,
        limit: limit,
      );
      return TransactionResponse(
        success: true,
        count: transactions.length,
        data: transactions,
      );
    });
  }

  Future<String> _erc20Balance() async {
    try {
      final smartWallet = locator<SmartWallet>();
      final result = await smartWallet.readContract(
        EthereumAddress.fromHex(Env.activeTokenAddress),
        ContractAbis.get('ERC20_BalanceOf'),
        'balanceOf',
        params: [smartWallet.address],
        sender: smartWallet.address,
      );

      final rawBalance = result.first as BigInt;
      final decimals = getTokenDecimals();
      final divisor = BigInt.from(10).pow(decimals);
      final humanBalance = rawBalance / divisor;
      final value = humanBalance
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'\.?0+$'), '');
      return value.isEmpty ? '0' : value;
    } catch (e) {
      throw Exception('Failed to fetch balance: $e');
    }
  }

  void resetAllStates() {
    emit(WalletState());
  }

  void clearRateError() {
    emit(state.copyWith(clearRatesError: true));
  }

  void resetWithdrawStatus() {
    emit(state.copyWith(withdrawStatus: WithdrawStatus.initial));
  }

  void resetTransactionStatus() {
    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.initial,
        transactionHash: null,
        clearTransactionHash: true,
      ),
    );
  }

  Future<void> sendTransactionOtp({
    required String amount,
    required String recipientAddress,
  }) async {
    emit(
      state.copyWith(
        otpVerificationStatus: OtpVerificationStatus.sending,
        clearOtpError: true,
        pendingTransactionAmount: amount,
        pendingTransactionRecipient: recipientAddress,
      ),
    );

    try {
      final success = await _walletRepository.sendTransactionOtp();

      if (success) {
        emit(state.copyWith(otpVerificationStatus: OtpVerificationStatus.sent));
      } else {
        emit(
          state.copyWith(
            otpVerificationStatus: OtpVerificationStatus.failed,
            otpError: 'Failed to send OTP',
          ),
        );
      }
    } catch (e) {
      log('Error sending transaction OTP: $e');
      emit(
        state.copyWith(
          otpVerificationStatus: OtpVerificationStatus.failed,
          otpError: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> verifyTransactionOtp({
    required String otp,
    Function()? onVerified,
  }) async {
    emit(
      state.copyWith(
        otpVerificationStatus: OtpVerificationStatus.verifying,
        clearOtpError: true,
      ),
    );

    try {
      final success = await _walletRepository.verifyTransactionOtp(otp);

      if (success) {
        emit(
          state.copyWith(otpVerificationStatus: OtpVerificationStatus.verified),
        );
        onVerified?.call();
      } else {
        emit(
          state.copyWith(
            otpVerificationStatus: OtpVerificationStatus.failed,
            otpError: 'Failed to verify OTP',
          ),
        );
      }
    } catch (e) {
      log('Error verifying transaction OTP: $e');
      emit(
        state.copyWith(
          otpVerificationStatus: OtpVerificationStatus.failed,
          otpError: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void resetOtpState() {
    emit(
      state.copyWith(
        otpVerificationStatus: OtpVerificationStatus.initial,
        clearOtpError: true,
        clearPendingTransaction: true,
      ),
    );
  }

  Future<void> getSupportedCurrencies() async {
    emit(
      state.copyWith(supportedCurrencyStatus: SupportedCurrencyStatus.loading),
    );
    try {
      final response = await _walletRepository.getSupportedCurrencies();
      response.fold(
        (error) {
          emit(
            state.copyWith(
              supportedCurrencyStatus: SupportedCurrencyStatus.error,
              supportedCurrencyMessage: error.message,
            ),
          );
        },
        (supportedCurrencies) {
          emit(
            state.copyWith(
              supportedCurrencyStatus: SupportedCurrencyStatus.loaded,
              supportedCurrencies: supportedCurrencies,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error fetching supported currencies: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          supportedCurrencyStatus: SupportedCurrencyStatus.error,
          supportedCurrencyMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getQuote({
    required String address,
    required String network,
    required String asset,
    required String amount,
    required String currency,
    required String countryIsoCode,
    required String paymentChannel,
  }) async {
    emit(state.copyWith(quoteStatus: QuoteStatus.loading));
    try {
      final response = await _walletRepository.getQuote(
        DepositObject(
          address: address,
          network: network,
          asset: asset,
          amount: amount,
          currency: currency,
          countryIsoCode: countryIsoCode,
          paymentChannel: paymentChannel,
        ),
      );
      response.fold(
        (error) {
          emit(
            state.copyWith(
              quoteStatus: QuoteStatus.error,
              quoteResponse: null,
              quoteError: error.message,
            ),
          );
        },
        (quote) {
          emit(
            state.copyWith(
              quoteStatus: QuoteStatus.loaded,
              quoteResponse: quote,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error fetching quote: $e', stackTrace: stackTrace);
      emit(state.copyWith(quoteStatus: QuoteStatus.error, quoteResponse: null));
    }
  }

  Future<void> getOrderLimits({
    required String cryptoCurrency,
    required String fiatCurrency,
    required String payoutChannel,
    required String countryCode,
  }) async {
    emit(
      state.copyWith(
        orderLimitStatus: OrderLimitStatus.loading,
        clearOrderLimitError: true,
      ),
    );
    try {
      final response = await _walletRepository.getOrderLimits(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fiatCurrency,
        payoutChannel: payoutChannel,
        countryCode: countryCode,
      );
      response.fold(
        (error) {
          emit(
            state.copyWith(
              orderLimitStatus: OrderLimitStatus.error,
              orderLimitError: error.message,
            ),
          );
        },
        (orderLimit) {
          emit(
            state.copyWith(
              orderLimitStatus: OrderLimitStatus.loaded,
              orderLimit: orderLimit,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error fetching order limits: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          orderLimitStatus: OrderLimitStatus.error,
          orderLimitError: e.toString(),
        ),
      );
    }
  }

  Future<void> getOnRampOrderLimits({
    required String cryptoCurrency,
    required String fiatCurrency,
    required String depositChannel,
    required String countryCode,
  }) async {
    emit(
      state.copyWith(
        onRampOrderLimitStatus: OnRampOrderLimitStatus.loading,
        clearOrderLimitError: true,
      ),
    );
    try {
      final response = await _walletRepository.getOnRampOrderLimits(
        cryptoCurrency: cryptoCurrency,
        fiatCurrency: fiatCurrency,
        despositChannel: depositChannel,
        countryCode: countryCode,
      );
      response.fold(
        (error) {
          emit(
            state.copyWith(
              onRampOrderLimitStatus: OnRampOrderLimitStatus.error,
              orderLimitError: error.message,
            ),
          );
        },
        (orderLimit) {
          emit(
            state.copyWith(
              onRampOrderLimitStatus: OnRampOrderLimitStatus.loaded,
              onRampOrderLimit: orderLimit,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error fetching onRamp() order limits: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          onRampOrderLimitStatus: OnRampOrderLimitStatus.error,
          orderLimitError: e.toString(),
        ),
      );
    }
  }

  Future<void> createOffRampOrder({
    required StoreOffRampScreenTranscientData request,
  }) async {
    emit(state.copyWith(createOrderStatus: CreateOrderStatus.creating));
    try {
      // Fonbnk quotes are short-lived and tied to the amount, so fetch a fresh
      // one for the exact order instead of reusing the one shown on screen.
      final quoteResult = await _walletRepository.getQuote(
        DepositObject(
          address: '',
          network: request.cryptoNetwork,
          asset: request.cryptoCurrency,
          amount: request.cryptoAmount.toString(),
          currency: request.fiatCurrency,
          countryIsoCode: request.countryCode,
          paymentChannel: request.payOutDetails!.channelType,
        ),
      );
      final quoteId = quoteResult.fold((error) {
        log('Failed to refresh off-ramp quote: ${error.message}');
        return null;
      }, (quote) => quote.quoteId);
      if (quoteId == null) {
        emit(
          state.copyWith(
            createOrderStatus: CreateOrderStatus.failed,
            createOrderError: 'Unable to get a quote. Please try again.',
          ),
        );
        return;
      }

      final response = await _walletRepository.createOrder(
        request: CreateOrderParams(
          cryptoCurrency: request.cryptoCurrency,
          fiatCurrency: request.fiatCurrency,
          cryptoAmount: request.cryptoAmount,
          payoutDetails: request.payOutDetails!,
          countryCode: request.countryCode,
          userEmail: LocalStorageService.getUserSync()!.email ?? '',
          quoteId: quoteId,
        ),
      );
      response.fold(
        (error) {
          emit(
            state.copyWith(
              createOrderStatus: CreateOrderStatus.failed,
              createOrderError: error.message,
            ),
          );
        },
        (orderResponse) async {
          emit(
            state.copyWith(
              createOrderResponse: orderResponse,
              createOrderStatus: CreateOrderStatus.success,
            ),
          );

          // Automatically transfer funds to the provided crypto wallet address
          await _executeOffRampTransfer(
            amount: orderResponse.cryptoAmount.toString(),
            recipientAddress: orderResponse.cryptoWalletAddress,
            transactionId: orderResponse.transactionId,
          );
        },
      );
    } catch (e, stackTrace) {
      log('Error creating off-ramp order: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          createOrderStatus: CreateOrderStatus.failed,
          createOrderError: e.toString(),
        ),
      );
    }
  }

  Future<void> pollTransactionStatus(String transactionId) async {
    const maxAttempts = 60;
    const pollInterval = Duration(seconds: 5);
    int consecutiveErrors = 0;
    const maxConsecutiveErrors = 3;

    log('Starting transaction status polling for: $transactionId');

    for (int i = 0; i < maxAttempts; i++) {
      try {
        await Future.delayed(pollInterval);

        log('Polling attempt ${i + 1}/$maxAttempts...');

        final response = await _walletRepository.getTransactionStatus(
          transactionId: transactionId,
        );

        response.fold(
          (error) {
            consecutiveErrors++;
            log('Error polling status: ${error.message}');
            if (consecutiveErrors >= maxConsecutiveErrors) {
              log('Max consecutive errors reached, stopping polling');
              emit(state.copyWith(offRampStatusState: OffRampStatus.failed));
            }
          },
          (statusResponse) {
            consecutiveErrors = 0;
            final status = statusResponse.status.toUpperCase();

            log('Transaction status: $status');
            emit(state.copyWith(transactionStatusResponse: statusResponse));

            if (status == 'COMPLETED' || status == 'SUCCESS') {
              log('Transaction completed successfully');
              emit(
                state.copyWith(
                  offRampStatusState: OffRampStatus.success,
                  transactionStatus: TransactionStatus.success,
                ),
              );
              refreshBalance();
              return;
            }

            if (status == 'FAILED' ||
                status == 'CANCELLED' ||
                status == 'EXPIRED') {
              log('Transaction failed with status: $status');
              emit(
                state.copyWith(
                  offRampStatusState: OffRampStatus.failed,
                  transactionStatus: TransactionStatus.failed,
                ),
              );
              return;
            }

            log('Transaction still processing, will poll again...');
          },
        );

        // Check if we should stop polling
        final currentStatus = state.transactionStatusResponse?.status
            .toUpperCase();
        if (currentStatus == 'COMPLETED' ||
            currentStatus == 'SUCCESS' ||
            currentStatus == 'FAILED' ||
            currentStatus == 'CANCELLED' ||
            currentStatus == 'EXPIRED') {
          break;
        }

        if (consecutiveErrors >= maxConsecutiveErrors) {
          break;
        }
      } catch (e, stackTrace) {
        consecutiveErrors++;
        log('Error during polling: $e', stackTrace: stackTrace);

        if (consecutiveErrors >= maxConsecutiveErrors) {
          log('Max consecutive errors reached, stopping polling');
          emit(state.copyWith(offRampStatusState: OffRampStatus.failed));
          break;
        }
      }
    }

    log('Transaction status polling completed');
  }

  void selectBankChannel(String bankCode, String account, String phoneNumber) {
    final newDetails = BankPayoutDetails(
      bankCode: bankCode,
      accountNumber: account,
      phoneNumber: phoneNumber,
    );

    emit(
      state.copyWith(
        offRampScreenData: state.offRampScreenData?.copyWith(
          payOutDetails: newDetails,
        ),
      ),
    );
  }

  void selectMobileMoneyChannel(
    String carrierCode,
    String phoneNumber,
    String fullName,
  ) {
    final newDetails = MobileMoneyPayoutDetails(
      carrierCode: carrierCode,
      phoneNumber: phoneNumber,
      fullName: fullName,
    );

    emit(
      state.copyWith(
        offRampScreenData: state.offRampScreenData?.copyWith(
          payOutDetails: newDetails,
        ),
      ),
    );
  }

  void selectAirtimeChannel(String carrierCode, String phoneNumber) {
    final newDetails = AirtimePayoutDetails(
      carrierCode: carrierCode,
      phoneNumber: phoneNumber,
    );

    emit(
      state.copyWith(
        offRampScreenData: state.offRampScreenData?.copyWith(
          payOutDetails: newDetails,
        ),
      ),
    );
  }

  Future<void> _executeOffRampTransfer({
    required String amount,
    required String recipientAddress,
    required String transactionId,
  }) async {
    log('Starting off-ramp transfer: $amount to $recipientAddress');

    emit(
      state.copyWith(
        transactionStatus: TransactionStatus.sending,
        clearTransactionError: true,
        clearTransactionHash: true,
      ),
    );

    try {
      final smartWallet = locator<SmartWallet>();
      await _applyGasBuffer(smartWallet);
      final originalWei = convertToWei(amount, getTokenDecimals());

      UserOperationResponse? response;

      if (EthereumAddressUtils.isValidAddress(recipientAddress)) {
        response = await smartWallet.sendTransaction(
          EthereumAddress.fromHex(Env.activeTokenAddress),
          encodeERC20TransferWithTag(
            EthereumAddress.fromHex(Env.activeTokenAddress),
            EthereumAddress.fromHex(recipientAddress),
            originalWei,
          ),
        );
      }

      if (response == null) {
        throw Exception(
          'Failed to initiate transfer - no response from wallet',
        );
      }

      log(
        'Off-ramp transfer initiated with userOpHash: ${response.userOpHash}',
      );

      emit(
        state.copyWith(
          transactionStatus: TransactionStatus.pending,
          transactionHash: response.userOpHash,
        ),
      );

      await refreshBalance();
      final result = await response.wait();

      if (result?.success == true) {
        await confirmOfframpOrder(
          transactionId: transactionId,
          blockchainTxHash: result?.txReceipt.transactionHash ?? '',
        );
        return;
      }
    } catch (e, stackTrace) {
      log('Error in off-ramp transfer: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          transactionStatus: TransactionStatus.failed,
          transactionError: 'Failed to transfer funds: ${e.toString()}',
          createOrderStatus: CreateOrderStatus.failed,
          createOrderError: 'Transfer failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> confirmOfframpOrder({
    required String transactionId,
    required String blockchainTxHash,
  }) async {
    log(
      'Confirming offramp order: $transactionId with hash: $blockchainTxHash',
    );

    emit(
      state.copyWith(
        confirmOrderStatus: ConfirmOrderStatus.confirming,
        clearConfirmOrderError: true,
      ),
    );

    try {
      final response = await _walletRepository.confirmOfframpOrder(
        transactionId: transactionId,
        blockchainTxHash: blockchainTxHash,
      );

      response.fold(
        (error) {
          log('Error confirming order: ${error.message}');
          emit(
            state.copyWith(
              confirmOrderStatus: ConfirmOrderStatus.failed,
              confirmOrderError: error.message,
            ),
          );
        },
        (confirmResponse) {
          log('Order confirmed successfully: ${confirmResponse.status}');
          emit(
            state.copyWith(
              confirmOrderStatus: ConfirmOrderStatus.success,
              confirmOrderResponse: confirmResponse,
            ),
          );

          unawaited(pollTransactionStatus(transactionId));
        },
      );
    } catch (e, stackTrace) {
      log('Error confirming offramp order: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          confirmOrderStatus: ConfirmOrderStatus.failed,
          confirmOrderError: e.toString(),
        ),
      );
    }
  }

  void resetConfirmOrderStatus() {
    emit(
      state.copyWith(
        confirmOrderStatus: ConfirmOrderStatus.initial,
        clearConfirmOrderError: true,
      ),
    );
  }

  // ============ On-Ramp Server-to-Server Methods ============

  Future<void> getOnRampQuote({
    required String fiatCurrency,
    required String depositChannel,
    required String countryCode,
    required String cryptoCurrency,
    required double fiatAmount,
  }) async {
    emit(
      state.copyWith(
        onRampQuoteStatus: OnRampQuoteStatus.loading,
        clearOnRampQuoteError: true,
      ),
    );
    try {
      final response = await _walletRepository.getOnRampQuote(
        fiatCurrency: fiatCurrency,
        depositChannel: depositChannel,
        countryCode: countryCode,
        cryptoCurrency: cryptoCurrency,
        fiatAmount: fiatAmount,
      );
      response.fold(
        (error) => emit(
          state.copyWith(
            onRampQuoteStatus: OnRampQuoteStatus.error,
            onRampQuoteError: error.message,
          ),
        ),
        (quote) => emit(
          state.copyWith(
            onRampQuoteStatus: OnRampQuoteStatus.loaded,
            onRampQuoteResponse: quote,
          ),
        ),
      );
    } catch (e, stackTrace) {
      log('Error fetching on-ramp quote: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          onRampQuoteStatus: OnRampQuoteStatus.error,
          onRampQuoteError: e.toString(),
        ),
      );
    }
  }

  Future<void> initializeOnRampOrder({
    required OnRampOrderParams params,
  }) async {
    emit(
      state.copyWith(
        onRampOrderStatus: OnRampOrderStatus.creating,
        clearOnRampOrderError: true,
      ),
    );
    try {
      final response = await _walletRepository.initializeOnRampOrder(
        params: params,
      );
      response.fold(
        (error) => emit(
          state.copyWith(
            onRampOrderStatus: OnRampOrderStatus.failed,
            onRampOrderError: error.message,
          ),
        ),
        (order) => emit(
          state.copyWith(
            onRampOrderStatus: OnRampOrderStatus.success,
            onRampOrderResponse: order,
          ),
        ),
      );
    } catch (e, stackTrace) {
      log('Error initializing on-ramp order: $e', stackTrace: stackTrace);
      emit(
        state.copyWith(
          onRampOrderStatus: OnRampOrderStatus.failed,
          onRampOrderError: e.toString(),
        ),
      );
    }
  }

  Future<void> confirmOnRampOrder({
    required String transactionId,
    required String fonbnkOrderId,
  }) async {
    const maxAttempts = 20;
    const pollDelay = Duration(seconds: 3);

    emit(
      state.copyWith(
        onRampConfirmStatus: OnRampConfirmStatus.confirming,
        clearOnRampConfirmError: true,
      ),
    );

    for (int i = 0; i < maxAttempts; i++) {
      try {
        if (i > 0) await Future.delayed(pollDelay);

        final response = await _walletRepository.confirmOnRampOrder(
          transactionId: transactionId,
          fonbnkOrderId: fonbnkOrderId,
        );

        bool done = false;
        response.fold(
          (error) {
            if (i == maxAttempts - 1) {
              emit(
                state.copyWith(
                  onRampConfirmStatus: OnRampConfirmStatus.failed,
                  onRampConfirmError: error.message,
                ),
              );
              done = true;
            }
          },
          (confirm) {
            final status = confirm.status.toUpperCase();
            if (status == 'COMPLETED' || status == 'SUCCESS') {
              emit(
                state.copyWith(
                  onRampConfirmStatus: OnRampConfirmStatus.success,
                  onRampConfirmResponse: confirm,
                ),
              );
              done = true;
            }
          },
        );

        if (done) break;
      } catch (e, stackTrace) {
        log('Error confirming on-ramp order: $e', stackTrace: stackTrace);
        if (i == maxAttempts - 1) {
          emit(
            state.copyWith(
              onRampConfirmStatus: OnRampConfirmStatus.failed,
              onRampConfirmError: e.toString(),
            ),
          );
        }
      }
    }
  }

  Future<void> submitOnRampIntermediateAction({
    required String transactionId,
    required Map<String, dynamic> fieldsForIntermediateAction,
  }) async {
    emit(
      state.copyWith(
        onRampIntermediateStatus: OnRampIntermediateActionStatus.processing,
        clearOnRampIntermediateError: true,
      ),
    );
    try {
      final response = await _walletRepository.submitOnRampIntermediateAction(
        transactionId: transactionId,
        fieldsForIntermediateAction: fieldsForIntermediateAction,
      );
      response.fold(
        (error) => emit(
          state.copyWith(
            onRampIntermediateStatus: OnRampIntermediateActionStatus.failed,
            onRampIntermediateError: error.message,
          ),
        ),
        (result) => emit(
          state.copyWith(
            onRampIntermediateStatus: OnRampIntermediateActionStatus.success,
            onRampIntermediateResponse: result,
          ),
        ),
      );
    } catch (e, stackTrace) {
      log(
        'Error submitting on-ramp intermediate action: $e',
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          onRampIntermediateStatus: OnRampIntermediateActionStatus.failed,
          onRampIntermediateError: e.toString(),
        ),
      );
    }
  }

  Future<void> onRampOrderComplete(String id) async {
    try {} catch (e) {}
  }

  void resetOnRampState() {
    emit(
      state.copyWith(
        onRampQuoteStatus: OnRampQuoteStatus.initial,
        clearOnRampQuoteError: true,
        onRampOrderStatus: OnRampOrderStatus.initial,
        clearOnRampOrderError: true,
        onRampConfirmStatus: OnRampConfirmStatus.initial,
        clearOnRampConfirmError: true,
        onRampIntermediateStatus: OnRampIntermediateActionStatus.initial,
        clearOnRampIntermediateError: true,
      ),
    );
  }

  void clearSupportedCurrencyError() {
    if (state.supportedCurrencyMessage != null) {
      emit(state.copyWith(clearSupportedCurrencyError: true));
    }
  }

  void clearQuoteError() {
    if (state.quoteError != null) {
      emit(state.copyWith(clearQuoteError: true));
    }
  }

  void clearOrderLimitError() {
    if (state.orderLimitError != null) {
      emit(state.copyWith(clearOrderLimitError: true));
    }
  }

  void clearCreateOrderError() {
    if (state.createOrderError != null) {
      emit(state.copyWith(clearCreateOrderError: true));
    }
  }

  void clearConfirmOrderError() {
    if (state.confirmOrderError != null) {
      emit(state.copyWith(clearConfirmOrderError: true));
    }
  }

  void clearAllErrors() {
    emit(
      state.copyWith(
        clearWalletError: true,
        clearTransactionError: true,
        clearBalanceError: true,
        clearSwapError: true,
        clearDepositError: true,
        clearRatesError: true,
        clearOtpError: true,
        clearOrderLimitError: true,
        clearConfirmOrderError: true,
        clearSupportedCurrencyError: true,
        clearQuoteError: true,
        clearCreateOrderError: true,
      ),
    );
  }
}
