class PurchaseResult {
  final bool success;
  final bool userCancelled;
  final String? errorMessage;

  const PurchaseResult({
    required this.success,
    this.userCancelled = false,
    this.errorMessage,
  });

  const PurchaseResult.success()
    : success = true,
      userCancelled = false,
      errorMessage = null;

  const PurchaseResult.cancelled()
    : success = false,
      userCancelled = true,
      errorMessage = null;

  const PurchaseResult.failed(String message)
    : success = false,
      userCancelled = false,
      errorMessage = message;
}
