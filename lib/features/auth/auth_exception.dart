import 'package:core/core.dart';

class AuthFailure extends Failure {
  AuthFailure(super.message);

  // Named constructors for common scenarios
  factory AuthFailure.network() => AuthFailure(
    "No internet connection. Please check your network and try again.",
  );

  factory AuthFailure.server() =>
      AuthFailure("Server error. Please try again later.");

  factory AuthFailure.invalidCredentials() =>
      AuthFailure("Invalid email or password. Please try again.");

  factory AuthFailure.userNotFound() =>
      AuthFailure("No account found with this email.");

  factory AuthFailure.emailAlreadyInUse() =>
      AuthFailure("This email is already registered.");

  factory AuthFailure.weakPassword() =>
      AuthFailure("Password is too weak. Please use a stronger password.");

  factory AuthFailure.invalidEmail() =>
      AuthFailure("Please enter a valid email address.");

  factory AuthFailure.userDisabled() =>
      AuthFailure("This account has been disabled. Please contact support.");

  factory AuthFailure.tooManyRequests() =>
      AuthFailure("Too many login attempts. Please try again later.");

  factory AuthFailure.operationNotAllowed() =>
      AuthFailure("This sign-in method is not enabled.");

  factory AuthFailure.unknown() =>
      AuthFailure("Something went wrong. Please try again.");

  factory AuthFailure.cancelled() => AuthFailure("Sign-in was cancelled.");

  @override
  String toString() => message;
}
