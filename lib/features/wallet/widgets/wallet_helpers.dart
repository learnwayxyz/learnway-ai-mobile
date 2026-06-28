import 'dart:developer';
import 'package:learnwayv2/services/defi_service/models/offramp_status_response.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';

class WithdrawalStatusHelper {
  WithdrawalStatusHelper._();

  static int getCurrentStep(
    OfframpStatusResponse? statusResponse,
    TransactionStatus transactionStatus,
  ) {
    if (transactionStatus == TransactionStatus.failed) {
      return TransactionStep.failed.index;
    }

    if (statusResponse == null || statusResponse.data == null) {
      return TransactionStep.ready.index;
    }

    final status = statusResponse.data!.status.toLowerCase();
    final onchainStatus = statusResponse.data!.onchainStatus.toLowerCase();

    log(
      'Current status: $status, onchainStatus: $onchainStatus, transactionStatus: $transactionStatus',
    );

    if (_isCompleted(onchainStatus)) {
      return TransactionStep.completed.index;
    }

    if (_isProcessing(onchainStatus)) {
      return TransactionStep.processing.index;
    }

    if (_isCompleted(status)) {
      return TransactionStep.completed.index;
    }

    if (_isProcessing(status)) {
      return TransactionStep.processing.index;
    }

    return TransactionStep.ready.index;
  }

  static String getStatusMessage(
    OfframpStatusResponse? statusResponse,
    TransactionStatus transactionStatus,
    String? transactionError,
  ) {
    if (transactionStatus == TransactionStatus.failed) {
      return transactionError ?? WithdrawalStatusMessage.transferFailed;
    }

    if (statusResponse == null || statusResponse.data == null) {
      return WithdrawalStatusMessage.initiating;
    }

    final status = statusResponse.data!.status.toLowerCase();
    final onchainStatus = statusResponse.data!.onchainStatus.toLowerCase();

    if (_isCompleted(onchainStatus)) {
      return WithdrawalStatusMessage.completed;
    }

    if (_isProcessing(onchainStatus)) {
      return WithdrawalStatusMessage.processingOnchain;
    }

    if (_isCompleted(status)) {
      return WithdrawalStatusMessage.fundsTransferred;
    }

    if (_isProcessing(status)) {
      return WithdrawalStatusMessage.processing;
    }

    if (_isFailed(status)) {
      return WithdrawalStatusMessage.failed;
    }

    if (_isCancelled(status)) {
      return WithdrawalStatusMessage.cancelled;
    }

    if (_isInitiated(status)) {
      return WithdrawalStatusMessage.initiated;
    }

    return WithdrawalStatusMessage.preparing;
  }

  static bool isCompleted(
    OfframpStatusResponse? statusResponse,
    TransactionStatus transactionStatus,
  ) {
    if (transactionStatus == TransactionStatus.failed) {
      return false;
    }

    if (statusResponse == null || statusResponse.data == null) {
      return false;
    }

    final status = statusResponse.data!.status.toLowerCase();
    final onchainStatus = statusResponse.data!.onchainStatus.toLowerCase();

    return _isCompleted(onchainStatus) || _isCompleted(status);
  }

  static bool isProcessing(
    OfframpStatusResponse? statusResponse,
    TransactionStatus transactionStatus,
  ) {
    if (transactionStatus == TransactionStatus.failed) {
      return false;
    }

    if (statusResponse == null || statusResponse.data == null) {
      return false;
    }

    final status = statusResponse.data!.status.toLowerCase();
    final onchainStatus = statusResponse.data!.onchainStatus.toLowerCase();

    return _isProcessing(onchainStatus) || _isProcessing(status);
  }

  static bool isFailed(
    OfframpStatusResponse? statusResponse,
    TransactionStatus transactionStatus,
  ) {
    if (transactionStatus == TransactionStatus.failed) {
      return true;
    }

    if (statusResponse == null || statusResponse.data == null) {
      return false;
    }

    final status = statusResponse.data!.status.toLowerCase();
    return _isFailed(status);
  }

  static bool _isCompleted(String status) {
    return status == 'successful' ||
        status == 'completed' ||
        status == 'success' ||
        status == 'confirmed';
  }

  static bool _isProcessing(String status) {
    return status == 'pending' || status == 'processing';
  }

  static bool _isFailed(String status) {
    return status == 'failed';
  }

  static bool _isCancelled(String status) {
    return status == 'cancelled';
  }

  static bool _isInitiated(String status) {
    return status == 'initiated';
  }
}

enum TransactionStep { ready, processing, completed, failed }

class WithdrawalStatusMessage {
  WithdrawalStatusMessage._();

  static const String initiating = 'Initiating withdrawal...';
  static const String completed = 'Withdrawal completed successfully!';
  static const String processingOnchain =
      'Processing your withdrawal on the blockchain...';
  static const String fundsTransferred =
      'Withdrawal completed! Funds sent to mobile money.';
  static const String processing = 'Your withdrawal is being processed...';
  static const String failed = 'Withdrawal failed. Please contact support.';
  static const String cancelled = 'Withdrawal was cancelled.';
  static const String initiated =
      'Withdrawal initiated. Processing transaction...';
  static const String preparing = 'Preparing your withdrawal...';

  static const String transferFailed =
      'Failed to transfer funds to escrow. Please try again.';
}
