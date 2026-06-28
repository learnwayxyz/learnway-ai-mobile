class OnRampFailure implements Exception {
  final String message;
  final OnRampFailureType type;

  const OnRampFailure._(this.message, this.type);

  factory OnRampFailure.network([String? message]) => OnRampFailure._(
    message ?? 'No internet connection',
    OnRampFailureType.network,
  );

  factory OnRampFailure.server([String? message]) => OnRampFailure._(
    message ?? 'Server error occurred',
    OnRampFailureType.server,
  );

  factory OnRampFailure.unknown([String? message]) => OnRampFailure._(
    message ?? 'An unexpected error occurred',
    OnRampFailureType.unknown,
  );

  @override
  String toString() => 'OnRampFailure($type): $message';
}

enum OnRampFailureType { network, server, unknown }
