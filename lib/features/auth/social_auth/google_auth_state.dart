import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnwayv2/features/auth/auth_data_source/auth_models/auth_response.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';

abstract class GoogleAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {
  GoogleAuthLoading(this.provider);
  final AuthProvider provider;
  @override
  List<Object> get props => [provider];
}

class WalletGenerating extends GoogleAuthState {
  WalletGenerating(this.provider);
  final AuthProvider provider;
  @override
  List<Object> get props => [provider];
}

class GoogleAuthSuccess extends GoogleAuthState {
  GoogleAuthSuccess(
    this.userCredential,
    this.provider,
    this.googleSignIn,
    this.authResponse,
  );
  final fb.UserCredential userCredential;
  final GoogleSignIn googleSignIn;
  final AuthProvider provider;
  final AuthResponse? authResponse;
  @override
  List<Object> get props => [userCredential, provider];
}

class GoogleAuthError extends GoogleAuthState {
  GoogleAuthError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
