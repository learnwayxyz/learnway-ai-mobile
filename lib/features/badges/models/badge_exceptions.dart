/// Custom exceptions for badge-related operations

/// Base exception for all badge-related errors
abstract class BadgeException implements Exception {
  final String message;
  final String? details;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const BadgeException(
    this.message, {
    this.details,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }
}

/// Thrown when there's no internet connection
class BadgeNetworkException extends BadgeException {
  const BadgeNetworkException({
    String? details,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          'No internet connection',
          details: details,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Thrown when the API returns an error response
class BadgeApiException extends BadgeException {
  final int? statusCode;

  const BadgeApiException(
    String message, {
    this.statusCode,
    String? details,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message,
          details: details,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  @override
  String toString() {
    final buffer = StringBuffer(message);
    if (statusCode != null) {
      buffer.write(' (Status: $statusCode)');
    }
    if (details != null) {
      buffer.write(': $details');
    }
    return buffer.toString();
  }
}

/// Thrown when a requested badge or user is not found
class BadgeNotFoundException extends BadgeException {
  const BadgeNotFoundException(String message, {String? details})
      : super(message, details: details);
}

/// Thrown when the API response cannot be parsed
class BadgeParsingException extends BadgeException {
  const BadgeParsingException({
    String? details,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          'Invalid response format',
          details: details,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}

/// Thrown when user is not authenticated or authorized
class BadgeAuthException extends BadgeException {
  const BadgeAuthException({String? details})
      : super('Authentication required', details: details);
}

/// Thrown when the server is unavailable or times out
class BadgeServerException extends BadgeException {
  const BadgeServerException({
    String? details,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          'Server unavailable',
          details: details,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}
