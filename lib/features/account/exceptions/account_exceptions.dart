import 'package:core/core.dart';

class AccountExceptions extends Failure {
  AccountExceptions(super.message);
  factory AccountExceptions.network() => AccountExceptions(
    "No internet connection. Please check your network and try again.",
  );

  factory AccountExceptions.server() =>
      AccountExceptions("Server error. Please try again later.");

  factory AccountExceptions.unauthorized() =>
      AccountExceptions("Your session has expired. Please log in again.");

  factory AccountExceptions.unknown() =>
      AccountExceptions("Something went wrong. Please try again.");

  factory AccountExceptions.timeout() => AccountExceptions(
    "Request timed out. Please check your connection and try again.",
  );

  factory AccountExceptions.invalidData() =>
      AccountExceptions("Invalid data received from server. Please try again.");

  @override
  String toString() => message;
}
