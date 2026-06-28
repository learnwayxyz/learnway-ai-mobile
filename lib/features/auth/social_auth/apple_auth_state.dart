part of 'apple_auth_cubit.dart';

sealed class AppleAuthState extends Equatable {
  const AppleAuthState();

  @override
  List<Object> get props => [];
}

final class AppleAuthInitial extends AppleAuthState {}

final class AppleAuthLoading extends AppleAuthState {}

final class AppleWalletGenerating extends AppleAuthState {}

final class AppleAuthSuccess extends AppleAuthState {
  final fb.UserCredential userCredential;
  final AuthProvider provider;
  final AuthResponse? authResponse;
  const AppleAuthSuccess(this.userCredential, this.authResponse, this.provider);
  @override
  List<Object> get props => [userCredential];
}

final class AppleAuthError extends AppleAuthState {
  final String message;
  const AppleAuthError(this.message);
  @override
  List<Object> get props => [message];
}
