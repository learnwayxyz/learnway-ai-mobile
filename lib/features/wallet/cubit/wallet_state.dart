part of 'wallet_cubit.dart';

enum WalletStatus { initial, loading, loaded, empty, error }

enum TransactionStatus { initial, sending, success, pending, failed }

enum BalanceStatus { initial, loading, loaded, error }

enum SwapStatus { initial, swapping, success, failed }

enum DepositStatus { initial, processing, success, failed }

enum WithdrawStatus { initial, processing, success, failed }

enum OffRampStatus { initial, processing, success, failed }

enum SupportedCurrencyStatus { initial, loading, loaded, error }

enum QuoteStatus { initial, loading, loaded, error }

enum OrderLimitStatus { initial, loading, loaded, error }

enum OnRampOrderLimitStatus { initial, loading, loaded, error }

enum CreateOrderStatus { initial, creating, success, failed }

enum PoolStatus { initial, loading, loaded, error }

enum ConfirmOrderStatus { initial, confirming, success, failed }

enum OnRampQuoteStatus { initial, loading, loaded, error }

enum OnRampOrderStatus { initial, creating, success, failed }

enum OnRampConfirmStatus { initial, confirming, success, failed }

enum OnRampIntermediateActionStatus { initial, processing, success, failed }

enum OtpVerificationStatus {
  initial,
  sending,
  sent,
  verifying,
  verified,
  failed,
}

// Add to wallet_state.dart

class WalletState extends Equatable {
  const WalletState({
    this.walletStatus = WalletStatus.initial,
    this.transactionStatus = TransactionStatus.initial,
    this.balanceStatus = BalanceStatus.initial,
    this.swapStatus = SwapStatus.initial,
    this.depositStatus = DepositStatus.initial,
    this.transactions,
    this.balance,
    this.walletError,
    this.transactionError,
    this.transactionHash,
    this.balanceError,
    this.swapError,
    this.swapTransaction,
    this.depositError,
    this.depositResponse,
    this.onRampStatus,
    this.depositStatusLoading = false,
    this.exchangeRates = const {},
    this.onRampRate,
    this.ratesLoading = false,
    this.ratesError,
    this.withdrawStatus = WithdrawStatus.initial,
    this.offRampRate,
    this.offRampStatus,
    this.offRampStatusState = OffRampStatus.initial,
    this.otpVerificationStatus = OtpVerificationStatus.initial,
    this.otpError,
    this.pendingTransactionAmount,
    this.pendingTransactionRecipient,
    this.supportedCurrencies,
    this.supportedCurrencyStatus = SupportedCurrencyStatus.initial,
    this.supportedCurrencyMessage,
    this.quoteResponse,
    this.quoteStatus = QuoteStatus.initial,
    this.quoteError,
    this.orderLimit,
    this.orderLimitStatus = OrderLimitStatus.initial,
    this.orderLimitError,
    this.offRampScreenData,
    this.createOrderStatus = CreateOrderStatus.initial,
    this.createOrderResponse,
    this.createOrderError,
    this.transactionStatusResponse,
    this.pollingStatus = PoolStatus.initial,
    this.confirmOrderStatus = ConfirmOrderStatus.initial,
    this.onRampOrderLimitStatus = OnRampOrderLimitStatus.initial,
    this.confirmOrderResponse,
    this.confirmOrderError,
    this.onRampOrderLimit,
    this.onRampQuoteStatus = OnRampQuoteStatus.initial,
    this.onRampQuoteResponse,
    this.onRampQuoteError,
    this.onRampOrderStatus = OnRampOrderStatus.initial,
    this.onRampOrderResponse,
    this.onRampOrderError,
    this.onRampConfirmStatus = OnRampConfirmStatus.initial,
    this.onRampConfirmResponse,
    this.onRampConfirmError,
    this.onRampIntermediateStatus = OnRampIntermediateActionStatus.initial,
    this.onRampIntermediateResponse,
    this.onRampIntermediateError,
  });

  final WalletStatus walletStatus;
  final TransactionStatus transactionStatus;
  final BalanceStatus balanceStatus;
  final SwapStatus swapStatus;
  final DepositStatus depositStatus;
  final WithdrawStatus withdrawStatus;
  final TransactionResponse? transactions;
  final String? balance;
  final String? walletError;
  final String? transactionError;
  final String? transactionHash;
  final String? balanceError;
  final String? swapError;
  final LearnWayTransaction? swapTransaction;
  final String? depositError;
  final MobileMoneyDepositResponse? depositResponse;
  final OnRampStatusResponse? onRampStatus;
  final bool depositStatusLoading;
  final Map<String, dynamic> exchangeRates;
  final OnRampRateResponse? onRampRate;
  final OffRampRatesResponse? offRampRate;
  final OfframpStatusResponse? offRampStatus;
  final OffRampStatus offRampStatusState;
  final bool ratesLoading;
  final String? ratesError;
  final OtpVerificationStatus otpVerificationStatus;
  final String? otpError;
  final String? pendingTransactionAmount;
  final String? pendingTransactionRecipient;
  final List<SupportedCurrency>? supportedCurrencies;
  final SupportedCurrencyStatus supportedCurrencyStatus;
  final String? supportedCurrencyMessage;
  final QuoteResponse? quoteResponse;
  final QuoteStatus quoteStatus;
  final String? quoteError;
  final OrderLimit? orderLimit;
  final OrderLimitStatus orderLimitStatus;
  final String? orderLimitError;
  final StoreOffRampScreenTranscientData? offRampScreenData;
  final CreateOrderStatus createOrderStatus;
  final CreateOrderResponse? createOrderResponse;
  final String? createOrderError;
  final TransactionStatusResponse? transactionStatusResponse;
  final PoolStatus pollingStatus;
  final ConfirmOrderStatus confirmOrderStatus;
  final ConfirmOrderResponse? confirmOrderResponse;
  final OnRampOrderLimitStatus? onRampOrderLimitStatus;
  final String? confirmOrderError;
  final OnRampOrderLimit? onRampOrderLimit;
  final OnRampQuoteStatus onRampQuoteStatus;
  final OnRampQuoteResponse? onRampQuoteResponse;
  final String? onRampQuoteError;
  final OnRampOrderStatus onRampOrderStatus;
  final OnRampOrderResponse? onRampOrderResponse;
  final String? onRampOrderError;
  final OnRampConfirmStatus onRampConfirmStatus;
  final OnRampConfirmResponse? onRampConfirmResponse;
  final String? onRampConfirmError;
  final OnRampIntermediateActionStatus onRampIntermediateStatus;
  final OnRampIntermediateActionResponse? onRampIntermediateResponse;
  final String? onRampIntermediateError;

  // Computed properties for easier state checking
  bool get isWalletLoading => walletStatus == WalletStatus.loading;
  bool get isWalletLoaded => walletStatus == WalletStatus.loaded;
  bool get hasWalletError => walletStatus == WalletStatus.error;

  bool get isSendingTransaction =>
      transactionStatus == TransactionStatus.sending;
  bool get isTransactionSuccessful =>
      transactionStatus == TransactionStatus.success;
  bool get hasTransactionError => transactionStatus == TransactionStatus.failed;

  bool get isLoadingBalance => balanceStatus == BalanceStatus.loading;
  bool get isBalanceLoaded => balanceStatus == BalanceStatus.loaded;
  bool get hasBalanceError => balanceStatus == BalanceStatus.error;

  bool get isSwapping => swapStatus == SwapStatus.swapping;
  bool get isSwapSuccessful => swapStatus == SwapStatus.success;
  bool get hasSwapError => swapStatus == SwapStatus.failed;

  bool get isProcessingDeposit => depositStatus == DepositStatus.processing;
  bool get isDepositSuccessful => depositStatus == DepositStatus.success;
  bool get hasDepositError => depositStatus == DepositStatus.failed;

  bool get isProcessingWithdraw => withdrawStatus == WithdrawStatus.processing;
  bool get isWithdrawSuccessful => withdrawStatus == WithdrawStatus.success;
  bool get hasWithdrawError => withdrawStatus == WithdrawStatus.failed;

  bool get hasRatesError => ratesError != null;

  bool get isSendingOtp =>
      otpVerificationStatus == OtpVerificationStatus.sending;
  bool get isOtpSent => otpVerificationStatus == OtpVerificationStatus.sent;
  bool get isVerifyingOtp =>
      otpVerificationStatus == OtpVerificationStatus.verifying;
  bool get isOtpVerified =>
      otpVerificationStatus == OtpVerificationStatus.verified;
  bool get hasOtpError => otpVerificationStatus == OtpVerificationStatus.failed;

  bool get confirmingDeposit =>
      onRampConfirmStatus == OnRampConfirmStatus.confirming;

  WalletState copyWith({
    WalletStatus? walletStatus,
    TransactionStatus? transactionStatus,
    BalanceStatus? balanceStatus,
    SwapStatus? swapStatus,
    DepositStatus? depositStatus,
    WithdrawStatus? withdrawStatus,
    TransactionResponse? transactions,
    String? balance,
    String? walletError,
    String? transactionError,
    String? transactionHash,
    String? balanceError,
    String? swapError,
    LearnWayTransaction? swapTransaction,
    String? depositError,
    MobileMoneyDepositResponse? depositResponse,
    OnRampStatusResponse? onRampStatus,
    OfframpStatusResponse? offRampStatus,
    bool? depositStatusLoading,
    bool clearWalletError = false,
    bool clearTransactionError = false,
    bool clearTransactionHash = false,
    bool clearBalanceError = false,
    bool clearSwapError = false,
    bool clearSwapTransaction = false,
    bool clearBalance = false,
    bool clearTransactions = false,
    bool clearDepositError = false,
    bool clearDepositResponse = false,
    bool clearOnRampStatus = false,
    Map<String, dynamic>? exchangeRates,
    OnRampRateResponse? onRampRate,
    OffRampRatesResponse? offRampRate,
    OffRampStatus? offRampStatusState,
    bool? ratesLoading,
    String? ratesError,
    bool clearRatesError = false,
    OtpVerificationStatus? otpVerificationStatus,
    String? otpError,
    bool clearOtpError = false,
    String? pendingTransactionAmount,
    String? pendingTransactionRecipient,
    bool clearPendingTransaction = false,
    SupportedCurrencyStatus? supportedCurrencyStatus,
    List<SupportedCurrency>? supportedCurrencies,
    String? supportedCurrencyMessage,
    bool clearSupportedCurrencyError = false,
    QuoteResponse? quoteResponse,
    QuoteStatus? quoteStatus,
    String? quoteError,
    bool clearQuoteError = false,
    OrderLimit? orderLimit,
    OrderLimitStatus? orderLimitStatus,
    String? orderLimitError,
    bool clearOrderLimitError = false,
    StoreOffRampScreenTranscientData? offRampScreenData,
    CreateOrderStatus? createOrderStatus,
    CreateOrderResponse? createOrderResponse,
    String? createOrderError,
    bool clearCreateOrderError = false,
    TransactionStatusResponse? transactionStatusResponse,
    PoolStatus? pollingStatus,
    ConfirmOrderStatus? confirmOrderStatus,
    ConfirmOrderResponse? confirmOrderResponse,
    OnRampOrderLimitStatus? onRampOrderLimitStatus,
    String? confirmOrderError,
    bool clearConfirmOrderError = false,
    OnRampOrderLimit? onRampOrderLimit,
    OnRampQuoteStatus? onRampQuoteStatus,
    OnRampQuoteResponse? onRampQuoteResponse,
    String? onRampQuoteError,
    bool clearOnRampQuoteError = false,
    OnRampOrderStatus? onRampOrderStatus,
    OnRampOrderResponse? onRampOrderResponse,
    String? onRampOrderError,
    bool clearOnRampOrderError = false,
    OnRampConfirmStatus? onRampConfirmStatus,
    OnRampConfirmResponse? onRampConfirmResponse,
    String? onRampConfirmError,
    bool clearOnRampConfirmError = false,
    OnRampIntermediateActionStatus? onRampIntermediateStatus,
    OnRampIntermediateActionResponse? onRampIntermediateResponse,
    String? onRampIntermediateError,
    bool clearOnRampIntermediateError = false,
  }) {
    return WalletState(
      walletStatus: walletStatus ?? this.walletStatus,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      balanceStatus: balanceStatus ?? this.balanceStatus,
      swapStatus: swapStatus ?? this.swapStatus,
      depositStatus: depositStatus ?? this.depositStatus,
      transactions: clearTransactions
          ? null
          : (transactions ?? this.transactions),
      balance: clearBalance ? null : (balance ?? this.balance),
      walletError: clearWalletError ? null : (walletError ?? this.walletError),
      transactionError: clearTransactionError
          ? null
          : (transactionError ?? this.transactionError),
      transactionHash: clearTransactionHash
          ? null
          : (transactionHash ?? this.transactionHash),
      balanceError: clearBalanceError
          ? null
          : (balanceError ?? this.balanceError),
      swapError: clearSwapError ? null : (swapError ?? this.swapError),
      swapTransaction: clearSwapTransaction
          ? null
          : (swapTransaction ?? this.swapTransaction),
      depositError: clearDepositError
          ? null
          : (depositError ?? this.depositError),
      depositResponse: clearDepositResponse
          ? null
          : (depositResponse ?? this.depositResponse),
      onRampStatus: clearOnRampStatus
          ? null
          : (onRampStatus ?? this.onRampStatus),
      depositStatusLoading: depositStatusLoading ?? this.depositStatusLoading,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      onRampRate: onRampRate ?? this.onRampRate,
      ratesLoading: ratesLoading ?? this.ratesLoading,
      ratesError: clearRatesError ? null : (ratesError ?? this.ratesError),
      offRampRate: offRampRate ?? this.offRampRate,
      withdrawStatus: withdrawStatus ?? this.withdrawStatus,
      offRampStatus: offRampStatus ?? this.offRampStatus,
      offRampStatusState: offRampStatusState ?? this.offRampStatusState,
      otpVerificationStatus:
          otpVerificationStatus ?? this.otpVerificationStatus,
      otpError: clearOtpError ? null : (otpError ?? this.otpError),
      pendingTransactionAmount: clearPendingTransaction
          ? null
          : (pendingTransactionAmount ?? this.pendingTransactionAmount),
      pendingTransactionRecipient: clearPendingTransaction
          ? null
          : (pendingTransactionRecipient ?? this.pendingTransactionRecipient),

      supportedCurrencies: supportedCurrencies ?? this.supportedCurrencies,
      supportedCurrencyStatus:
          supportedCurrencyStatus ?? this.supportedCurrencyStatus,
      supportedCurrencyMessage: clearSupportedCurrencyError
          ? null
          : (supportedCurrencyMessage ?? this.supportedCurrencyMessage),
      quoteResponse: quoteResponse ?? this.quoteResponse,
      quoteStatus: quoteStatus ?? this.quoteStatus,
      quoteError: clearQuoteError ? null : (quoteError ?? this.quoteError),
      orderLimit: orderLimit ?? this.orderLimit,
      orderLimitStatus: orderLimitStatus ?? this.orderLimitStatus,
      orderLimitError: clearOrderLimitError
          ? null
          : (orderLimitError ?? this.orderLimitError),
      offRampScreenData: offRampScreenData ?? this.offRampScreenData,
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      createOrderResponse: createOrderResponse ?? this.createOrderResponse,
      createOrderError: clearCreateOrderError
          ? null
          : (createOrderError ?? this.createOrderError),
      transactionStatusResponse:
          transactionStatusResponse ?? this.transactionStatusResponse,
      pollingStatus: pollingStatus ?? this.pollingStatus,
      confirmOrderStatus: confirmOrderStatus ?? this.confirmOrderStatus,
      confirmOrderResponse: confirmOrderResponse ?? this.confirmOrderResponse,
      confirmOrderError: clearConfirmOrderError
          ? null
          : (confirmOrderError ?? this.confirmOrderError),
      onRampOrderLimitStatus:
          onRampOrderLimitStatus ?? this.onRampOrderLimitStatus,
      onRampOrderLimit: onRampOrderLimit ?? this.onRampOrderLimit,
      onRampQuoteStatus: onRampQuoteStatus ?? this.onRampQuoteStatus,
      onRampQuoteResponse: onRampQuoteResponse ?? this.onRampQuoteResponse,
      onRampQuoteError: clearOnRampQuoteError
          ? null
          : (onRampQuoteError ?? this.onRampQuoteError),
      onRampOrderStatus: onRampOrderStatus ?? this.onRampOrderStatus,
      onRampOrderResponse: onRampOrderResponse ?? this.onRampOrderResponse,
      onRampOrderError: clearOnRampOrderError
          ? null
          : (onRampOrderError ?? this.onRampOrderError),
      onRampConfirmStatus: onRampConfirmStatus ?? this.onRampConfirmStatus,
      onRampConfirmResponse:
          onRampConfirmResponse ?? this.onRampConfirmResponse,
      onRampConfirmError: clearOnRampConfirmError
          ? null
          : (onRampConfirmError ?? this.onRampConfirmError),
      onRampIntermediateStatus:
          onRampIntermediateStatus ?? this.onRampIntermediateStatus,
      onRampIntermediateResponse:
          onRampIntermediateResponse ?? this.onRampIntermediateResponse,
      onRampIntermediateError: clearOnRampIntermediateError
          ? null
          : (onRampIntermediateError ?? this.onRampIntermediateError),
    );
  }

  @override
  List<Object?> get props => [
    walletStatus,
    transactionStatus,
    balanceStatus,
    swapStatus,
    depositStatus,
    transactions,
    balance,
    walletError,
    transactionError,
    transactionHash,
    balanceError,
    swapError,
    swapTransaction,
    depositError,
    depositResponse,
    onRampStatus,
    depositStatusLoading,
    exchangeRates,
    onRampRate,
    ratesLoading,
    ratesError,
    offRampRate,
    withdrawStatus,
    offRampStatus,
    offRampStatusState,
    otpVerificationStatus,
    otpError,
    pendingTransactionAmount,
    pendingTransactionRecipient,
    supportedCurrencies,
    supportedCurrencyStatus,
    supportedCurrencyMessage,
    quoteResponse,
    quoteStatus,
    quoteError,
    orderLimit,
    orderLimitStatus,
    orderLimitError,
    offRampScreenData,
    createOrderStatus,
    createOrderResponse,
    createOrderError,
    transactionStatusResponse,
    pollingStatus,
    confirmOrderStatus,
    confirmOrderResponse,
    confirmOrderError,
    onRampOrderLimitStatus,
    onRampOrderLimit,
    onRampQuoteStatus,
    onRampQuoteResponse,
    onRampQuoteError,
    onRampOrderStatus,
    onRampOrderResponse,
    onRampOrderError,
    onRampConfirmStatus,
    onRampConfirmResponse,
    onRampConfirmError,
    onRampIntermediateStatus,
    onRampIntermediateResponse,
    onRampIntermediateError,
  ];
}

class StoreOffRampScreenTranscientData extends Equatable {
  const StoreOffRampScreenTranscientData({
    required this.cryptoCurrency,
    required this.cryptoNetwork,
    required this.cryptoAmount,
    required this.fiatCurrency,
    required this.countryCode,
    required this.quoteId,
    this.payOutDetails,
  });

  final String cryptoCurrency;
  final String cryptoNetwork;
  final double cryptoAmount;
  final String fiatCurrency;
  final String countryCode;
  final PayoutDetails? payOutDetails;
  final String quoteId;

  StoreOffRampScreenTranscientData copyWith({
    String? cryptoCurrency,
    String? cryptoNetwork,
    double? cryptoAmount,
    String? fiatCurrency,
    String? payoutChannel,
    String? countryCode,
    String? carrierCode,
    PayoutDetails? payOutDetails,
    String? quoteId,
  }) {
    return StoreOffRampScreenTranscientData(
      cryptoCurrency: cryptoCurrency ?? this.cryptoCurrency,
      cryptoNetwork: cryptoNetwork ?? this.cryptoNetwork,
      cryptoAmount: cryptoAmount ?? this.cryptoAmount,
      fiatCurrency: fiatCurrency ?? this.fiatCurrency,
      countryCode: countryCode ?? this.countryCode,
      payOutDetails: payOutDetails ?? this.payOutDetails,
      quoteId: quoteId ?? this.quoteId,
    );
  }

  @override
  String toString() {
    return 'StoreOffRampScreenTranscientData(cryptoCurrency: $cryptoCurrency, cryptoNetwork: $cryptoNetwork, cryptoAmount: $cryptoAmount, fiatCurrency: $fiatCurrency, countryCode: $countryCode, payOutDetails: $payOutDetails, quoteId: $quoteId)';
  }

  @override
  List<Object?> get props => [
    cryptoCurrency,
    cryptoNetwork,
    cryptoAmount,
    fiatCurrency,
    countryCode,
    payOutDetails,
    quoteId,
  ];
}

sealed class PayoutDetails extends Equatable {
  const PayoutDetails();

  String get channelType;
}

class MobileMoneyPayoutDetails extends PayoutDetails {
  const MobileMoneyPayoutDetails({
    required this.phoneNumber,
    required this.carrierCode,
    required this.fullName,
  });

  final String phoneNumber;
  final String carrierCode;
  final String fullName;

  @override
  String get channelType => 'mobile_money';

  @override
  List<Object?> get props => [phoneNumber, carrierCode, fullName];
}

class BankPayoutDetails extends PayoutDetails {
  const BankPayoutDetails({
    required this.bankCode,
    required this.accountNumber,
    required this.phoneNumber,
  });

  final String bankCode;
  final String accountNumber;
  final String phoneNumber;

  @override
  String get channelType => 'bank';

  @override
  List<Object?> get props => [bankCode, accountNumber, phoneNumber];
}

class AirtimePayoutDetails extends PayoutDetails {
  const AirtimePayoutDetails({
    required this.phoneNumber,
    required this.carrierCode,
  });

  final String phoneNumber;
  final String carrierCode;

  @override
  String get channelType => 'airtime';

  @override
  List<Object?> get props => [phoneNumber, carrierCode];
}
