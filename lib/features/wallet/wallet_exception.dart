/// Base exception class for all wallet-related errors.
sealed class WalletException implements Exception {
  const WalletException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;

  @override
  String toString() => 'WalletException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Exception thrown when a network request fails.
class WalletNetworkException extends WalletException {
  const WalletNetworkException({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });

  final int? statusCode;

  factory WalletNetworkException.noConnection() => const WalletNetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_CONNECTION',
      );

  factory WalletNetworkException.timeout() => const WalletNetworkException(
        message: 'Request timed out. Please try again.',
        code: 'TIMEOUT',
      );

  factory WalletNetworkException.serverError([int? statusCode]) =>
      WalletNetworkException(
        message: 'Server error occurred. Please try again later.',
        code: 'SERVER_ERROR',
        statusCode: statusCode,
      );

  @override
  String toString() =>
      'WalletNetworkException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}

/// Exception thrown when a transaction operation fails.
class TransactionException extends WalletException {
  const TransactionException({
    required super.message,
    super.code,
    super.stackTrace,
    this.transactionHash,
  });

  final String? transactionHash;

  factory TransactionException.failed([String? hash]) => TransactionException(
        message: 'Transaction failed. Please try again.',
        code: 'TRANSACTION_FAILED',
        transactionHash: hash,
      );

  factory TransactionException.pending(String hash) => TransactionException(
        message: 'Transaction is still pending.',
        code: 'TRANSACTION_PENDING',
        transactionHash: hash,
      );

  factory TransactionException.notFound([String? hash]) => TransactionException(
        message: 'Transaction not found.',
        code: 'TRANSACTION_NOT_FOUND',
        transactionHash: hash,
      );

  factory TransactionException.insufficientFunds() => const TransactionException(
        message: 'Insufficient funds for this transaction.',
        code: 'INSUFFICIENT_FUNDS',
      );

  factory TransactionException.invalidAmount() => const TransactionException(
        message: 'Invalid transaction amount.',
        code: 'INVALID_AMOUNT',
      );

  @override
  String toString() =>
      'TransactionException: $message${transactionHash != null ? ' (hash: $transactionHash)' : ''}';
}

/// Exception thrown when OTP verification fails.
class OtpException extends WalletException {
  const OtpException({
    required super.message,
    super.code,
    super.stackTrace,
    this.attemptsRemaining,
  });

  final int? attemptsRemaining;

  factory OtpException.invalid() => const OtpException(
        message: 'Invalid OTP. Please check and try again.',
        code: 'INVALID_OTP',
      );

  factory OtpException.expired() => const OtpException(
        message: 'OTP has expired. Please request a new one.',
        code: 'OTP_EXPIRED',
      );

  factory OtpException.sendFailed() => const OtpException(
        message: 'Failed to send OTP. Please try again.',
        code: 'OTP_SEND_FAILED',
      );

  factory OtpException.maxAttemptsReached() => const OtpException(
        message: 'Maximum OTP attempts reached. Please request a new code.',
        code: 'MAX_ATTEMPTS',
        attemptsRemaining: 0,
      );

  @override
  String toString() =>
      'OtpException: $message${attemptsRemaining != null ? ' (attempts remaining: $attemptsRemaining)' : ''}';
}

/// Exception thrown when on-ramp/off-ramp operations fail.
class RampException extends WalletException {
  const RampException({
    required super.message,
    super.code,
    super.stackTrace,
    this.rampType,
  });

  final RampType? rampType;

  factory RampException.quoteUnavailable([RampType? type]) => RampException(
        message: 'Unable to get quote. Please try again.',
        code: 'QUOTE_UNAVAILABLE',
        rampType: type,
      );

  factory RampException.unsupportedCountry(String countryCode) => RampException(
        message: 'This service is not available in your country ($countryCode).',
        code: 'UNSUPPORTED_COUNTRY',
      );

  factory RampException.unsupportedPaymentChannel(String channel) => RampException(
        message: 'Payment channel "$channel" is not supported.',
        code: 'UNSUPPORTED_PAYMENT_CHANNEL',
      );

  factory RampException.minimumNotMet(String minimum, String currency) =>
      RampException(
        message: 'Minimum amount is $minimum $currency.',
        code: 'MINIMUM_NOT_MET',
      );

  factory RampException.maximumExceeded(String maximum, String currency) =>
      RampException(
        message: 'Maximum amount is $maximum $currency.',
        code: 'MAXIMUM_EXCEEDED',
      );

  factory RampException.providerUnavailable() => const RampException(
        message: 'Payment provider is currently unavailable.',
        code: 'PROVIDER_UNAVAILABLE',
      );

  @override
  String toString() =>
      'RampException: $message${rampType != null ? ' (type: ${rampType?.name})' : ''}';
}

/// Exception thrown when wallet balance operations fail.
class BalanceException extends WalletException {
  const BalanceException({
    required super.message,
    super.code,
    super.stackTrace,
    this.tokenAddress,
  });

  final String? tokenAddress;

  factory BalanceException.fetchFailed() => const BalanceException(
        message: 'Failed to fetch wallet balance.',
        code: 'FETCH_FAILED',
      );

  factory BalanceException.tokenNotFound(String address) => BalanceException(
        message: 'Token not found.',
        code: 'TOKEN_NOT_FOUND',
        tokenAddress: address,
      );

  @override
  String toString() =>
      'BalanceException: $message${tokenAddress != null ? ' (token: $tokenAddress)' : ''}';
}

/// Exception thrown when authentication/authorization fails in wallet context.
class WalletAuthException extends WalletException {
  const WalletAuthException({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory WalletAuthException.sessionExpired() => const WalletAuthException(
        message: 'Session expired. Please log in again.',
        code: 'SESSION_EXPIRED',
      );

  factory WalletAuthException.unauthorized() => const WalletAuthException(
        message: 'You are not authorized to perform this action.',
        code: 'UNAUTHORIZED',
      );

  factory WalletAuthException.userNotFound() => const WalletAuthException(
        message: 'User not found. Please log in again.',
        code: 'USER_NOT_FOUND',
      );

  @override
  String toString() => 'WalletAuthException: $message';
}

/// Exception thrown for validation errors.
class WalletValidationException extends WalletException {
  const WalletValidationException({
    required super.message,
    super.code,
    super.stackTrace,
    this.field,
  });

  final String? field;

  factory WalletValidationException.invalidAddress(String address) =>
      WalletValidationException(
        message: 'Invalid wallet address: $address',
        code: 'INVALID_ADDRESS',
        field: 'address',
      );

  factory WalletValidationException.invalidPhoneNumber() =>
      const WalletValidationException(
        message: 'Invalid phone number format.',
        code: 'INVALID_PHONE',
        field: 'phoneNumber',
      );

  factory WalletValidationException.requiredField(String fieldName) =>
      WalletValidationException(
        message: '$fieldName is required.',
        code: 'REQUIRED_FIELD',
        field: fieldName,
      );

  @override
  String toString() =>
      'WalletValidationException: $message${field != null ? ' (field: $field)' : ''}';
}

/// Enum for ramp operation types.
enum RampType { onRamp, offRamp }
