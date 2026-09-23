import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/auth/auth_data_source/auth_models/auth_response.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart'
    as auth_enum;
import 'package:learnwayv2/features/auth/auth_exception.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const List<String> _googleScopes = <String>[
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile',
];

class RemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  RemoteDataSource() {
    unawaited(
      _googleSignIn
          .initialize(
            clientId: Platform.isIOS
                ? Env.googleClientIdIos
                : Env.googleClientIdAndroid,
          )
          .then((_) {
            _googleSignIn.authenticationEvents
                .listen(_handleAuthenticationEvent)
                .onError(_handleAuthenticationError);
          }),
    );
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      if (!locator.isRegistered<GoogleSignIn>()) {
        locator.registerLazySingleton<GoogleSignIn>(() => _googleSignIn);
      }
      if (locator.isRegistered<GoogleSignInAccount>()) {
        locator.unregister<GoogleSignInAccount>();
      }
      locator.registerSingleton<GoogleSignInAccount>(event.user);
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      if (locator.isRegistered<GoogleSignInAccount>()) {
        locator.unregister<GoogleSignInAccount>();
      }
    }
  }

  void _handleAuthenticationError(Object e) {
    debugPrint('GoogleSignIn silent auth error: $e');
  }

  Future<UserCredential> signInWithGoogle({String accountType = ''}) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      GoogleSignInClientAuthorization? authorization = await googleUser
          .authorizationClient
          .authorizationForScopes(_googleScopes);
      authorization ??= await googleUser.authorizationClient.authorizeScopes(
        _googleScopes,
      );

      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return userCredential;
    } on GoogleSignInException catch (e) {
      log('Google Sign-In Exception: ${e.code} - ${e.description}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthFailure('Sign-in was cancelled.');
      }
      throw AuthFailure('Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } on SocketException {
      throw AuthFailure.network();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Google Sign-In Error: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<UserCredential> signInWithApple() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        log('Clearing existing Firebase session before Apple sign-in');
        await _firebaseAuth.signOut();
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        authCredential,
      );

      if (userCredential.additionalUserInfo!.isNewUser ||
          userCredential.additionalUserInfo!.username == null) {
        final user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(
            '${credential.givenName} ${credential.familyName}',
          );
          await user.reload();
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } on SignInWithAppleAuthorizationException catch (e) {
      log('Apple Sign-In Error: ${e.code} - ${e.message}');
      if (e.code == AuthorizationErrorCode.canceled) {
        throw AuthFailure('Sign-in was cancelled.');
      }
      throw AuthFailure('Apple sign-in failed. Please try again.');
    } on SocketException {
      throw AuthFailure.network();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Apple Sign-In Error: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<bool> verifyEmail(String email) async {
    try {
      final baseApi = locator<BaseApiClients>();

      final response = await baseApi.post(
        Endpoints.verifyEmail,
        body: {'email': email},
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      final message = decoded['message'];

      if (message is List && message.isNotEmpty) {
        throw AuthFailure(message.join(', '));
      }

      if (decoded['error'] != null) {
        throw AuthFailure(
          message ?? 'Failed to verify email. Please try again.',
        );
      }

      return message is String && message.toLowerCase().contains('success');
    } on SocketException {
      throw AuthFailure.network();
    } on FormatException {
      throw AuthFailure.server();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Unexpected error in verifyEmail: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final baseApi = locator<BaseApiClients>();

      final response = await baseApi.post(
        Endpoints.verifyOtp,
        body: {'email': email, 'otpCode': otp},
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      log('OTP verification response: $decoded');

      final message = decoded['message'];
      if (message is List && message.isNotEmpty) {
        throw AuthFailure(message.join(', '));
      }

      if (decoded['error'] != null) {
        throw AuthFailure(message ?? 'Invalid OTP. Please try again.');
      }

      final verificationToken = decoded['verificationToken'];
      if (verificationToken is String && verificationToken.isNotEmpty) {
        await SharedPreferencesStore.setUserToken(
          emailVerificationTokenKey,
          verificationToken,
        );
      }

      return decoded['isVerified'] == true;
    } on SocketException {
      throw AuthFailure.network();
    } on FormatException {
      throw AuthFailure.server();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Unexpected error in verifyOtp: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<AuthResponse> loginWithOtp(String email, String otp) async {
    return await _loginWithOtp(email, otp);
  }

  Future<AuthResponse> loginUser(
    String email,
    auth_enum.AuthProvider authProvider,
  ) async {
    return await _loginUser(email, authProvider);
  }

  Future<AuthResponse> _loginUser(
    String email,
    auth_enum.AuthProvider authProvider,
  ) async {
    try {
      final baseApi = locator<BaseApiClients>();
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final providerName = authProvider.name.toLowerCase();
      final idToken = await _firebaseAuth.currentUser?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw AuthFailure('Sign-in session expired. Please sign in again.');
      }

      final response = await baseApi.post(
        Endpoints.loginUser,
        body: {'email': email, 'provider': providerName, 'idToken': idToken},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      if (decoded['error'] != null) {
        final message = decoded['message'];
        final errorMessage = message is List
            ? message.join(', ')
            : (message ?? 'Login failed. Please try again.');
        throw AuthFailure(errorMessage);
      }
      if (decoded['accessToken'] == null) {
        throw AuthFailure('Authentication failed. Please try again.');
      }

      await SharedPreferencesStore.setUserToken(
        userTokenKey,
        decoded['accessToken'],
      );
      log('User token (_loginUser): ${decoded['accessToken']}');

      return AuthResponse.fromJson(decoded);
    } on SocketException {
      throw AuthFailure.network();
    } on FormatException {
      throw AuthFailure.server();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Unexpected error in _loginUser: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<AuthResponse> _loginWithOtp(String email, String otp) async {
    try {
      final baseApi = locator<BaseApiClients>();
      final response = await baseApi.post(
        Endpoints.loginWithOtp,
        body: {'email': email, 'otpCode': otp},
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['error'] != null) {
        throw AuthFailure(
          decoded['message'] ?? 'Login failed. Please try again.',
        );
      }

      if (decoded['accessToken'] == null) {
        throw AuthFailure('Authentication failed. Please try again.');
      }

      await SharedPreferencesStore.setUserToken(
        userTokenKey,
        decoded['accessToken'],
      );
      log('User token (_loginWithOtp): ${decoded['accessToken']}');

      return AuthResponse.fromJson(decoded);
    } on SocketException {
      throw AuthFailure.network();
    } on FormatException {
      throw AuthFailure.server();
    } on AuthFailure {
      rethrow;
    } catch (e) {
      log('Unexpected error in _loginWithOtp: $e');
      throw AuthFailure.unknown();
    }
  }

  Future<bool> isUserSignedIn() async {
    try {
      final user = _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      log('Error checking sign-in status: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      log('Starting sign-out process...');

      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.signOut();
      }
      await _googleSignIn.disconnect();
      log('Sign-out completed successfully');
    } catch (e) {
      log('Error during sign-out: $e');
      try {
        await _firebaseAuth.signOut();
      } catch (e2) {
        log('Force sign-out also failed: $e2');
      }
    }
  }

  AuthFailure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return AuthFailure(
          'An account already exists with this email using a different sign-in method.',
        );
      case 'invalid-credential':
        return AuthFailure('Invalid credentials. Please try again.');
      case 'operation-not-allowed':
        return AuthFailure('This sign-in method is not enabled.');
      case 'user-disabled':
        return AuthFailure('This account has been disabled.');
      case 'user-not-found':
        return AuthFailure('No account found with this email.');
      case 'wrong-password':
        return AuthFailure('Incorrect password. Please try again.');
      case 'invalid-verification-code':
        return AuthFailure('Invalid verification code.');
      case 'invalid-verification-id':
        return AuthFailure('Verification session expired. Please try again.');
      case 'network-request-failed':
        return AuthFailure.network();
      case 'too-many-requests':
        return AuthFailure('Too many attempts. Please try again later.');
      case 'email-already-in-use':
        return AuthFailure('This email is already registered.');
      default:
        return AuthFailure('Authentication failed. Please try again.');
    }
  }
}
