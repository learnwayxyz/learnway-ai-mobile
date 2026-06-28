import 'package:core/core.dart';

class KycException extends Failure {
  KycException(super.message);

  factory KycException.network() => KycException("Network error occurred");
  factory KycException.server() => KycException("Server error occurred");
  factory KycException.unknown() => KycException("An unknown error occurred");

  @override
  String toString() => 'KycException: $message';
}
