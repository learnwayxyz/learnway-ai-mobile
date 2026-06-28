part of 'verify_email_cubit.dart';

abstract class EmailState extends Equatable {
  const EmailState({this.email = ''});
  final String email;
}

class EmailInitial extends EmailState {
  const EmailInitial() : super();
  @override
  List<Object?> get props => [];
}

class SendingOtpState extends EmailState {
  const SendingOtpState({required super.email});
  @override
  List<Object?> get props => [email];
}

class SendingOtpSuccessState extends EmailState {
  const SendingOtpSuccessState(this.isEmailSent, {required super.email});
  final bool isEmailSent;
  @override
  List<Object?> get props => [isEmailSent, email];
}

class SendingOtpFailureState extends EmailState {
  const SendingOtpFailureState(this.message, {required super.email});
  final String message;
  @override
  List<Object?> get props => [message, email];
}

class VerifyingOtpState extends EmailState {
  const VerifyingOtpState({required super.email});
  @override
  List<Object?> get props => [email];
}

class GeneratingWallet extends EmailState {
  const GeneratingWallet({required super.email});
  @override
  List<Object?> get props => [email];
}

class VerifyingOtpStateSuccessState extends EmailState {
  const VerifyingOtpStateSuccessState(
    this.authResponse, {
    required super.email,
  });
  final AuthResponse authResponse;
  @override
  List<Object?> get props => [authResponse, email];
}

class VerifyingOtpStateFailureState extends EmailState {
  const VerifyingOtpStateFailureState(this.message, {required super.email});
  final String message;
  @override
  List<Object?> get props => [message, email];
}

class VerifyingNewUser extends EmailState {
  const VerifyingNewUser({required super.email});
  @override
  List<Object?> get props => [email];
}

class VerifyingNewUserSuccessState extends EmailState {
  const VerifyingNewUserSuccessState(
    this.isUserVerified, {
    required super.email,
  });
  final bool isUserVerified;
  @override
  List<Object?> get props => [isUserVerified, email];
}

class VerifyingNewUserFailureState extends EmailState {
  const VerifyingNewUserFailureState(this.message, {required super.email});
  final String message;
  @override
  List<Object?> get props => [message, email];
}
