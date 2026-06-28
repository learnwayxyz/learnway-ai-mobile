import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_state.dart';
import 'package:learnwayv2/features/auth/repository/auth_repository.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:core/core.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  GoogleAuthCubit() : super(GoogleAuthInitial());

  final AuthRepository _authRepository = AuthRepository();

  void signInWithGoogle() async {
    emit(GoogleAuthLoading(AuthProvider.google));
    final googleResult = await _authRepository.signInWithGoogle();

    googleResult.fold(
      (l) {
        log('Google Sign-In error: ${l.message}');
        emit(GoogleAuthError(l.message));
      },
      (userCredential) async {
        if (userCredential.user?.email != null) {
          await SharedPreferencesStore.saveUserEmail(
            userEmailKey,
            userCredential.user!.email ?? '',
          );
        }

        final googleSignIn = locator<GoogleSignIn>();

        final loginResult = await _authRepository.loginUser(
          userCredential.user!.email ?? '',
          AuthProvider.google,
        );

        loginResult.fold(
          (l) {
            if (l.message.contains('User not found')) {
              emit(
                GoogleAuthSuccess(
                  userCredential,
                  AuthProvider.google,
                  googleSignIn,
                  null,
                ),
              );
              appRouter.push(const WelcomeToSetupRoute());
            } else {
              emit(GoogleAuthError(l.message));
            }
          },
          (authResponse) async {
            if (authResponse.user == null) {
              emit(
                GoogleAuthError(
                  'Unable to retrieve user information. Please try again.',
                ),
              );
              return;
            }

            final hasPrivateKey =
                authResponse.user!.halfPrivateKey?.isNotEmpty ?? false;

            if (hasPrivateKey) {
              // Existing user with wallet
              emit(
                GoogleAuthSuccess(
                  userCredential,
                  AuthProvider.google,
                  googleSignIn,
                  authResponse,
                ),
              );

              await SharedPreferencesStore.hasRegistered(
                hasRegisteredKey,
                true,
              );
              await SharedPreferencesStore.saveIsAuthenticatedKey(
                isAuthenticatedKey,
                true,
              );

              locator.get<MainActivityCubit>().resetState();
              final config = locator.get<ApiConfigResponse>();

              final payload = {
                'remoteShares': authResponse.user!.halfPrivateKey,
                'userName': authResponse.user!.username,
                'userEmail': authResponse.user!.email,
                'walletAddress': authResponse.user!.walletAddress,
                'userId': authResponse.user!.id,
                'pepAddress': config.pepAddress,
              };

              locator.get<HomeBloc>().add(AttemptWalletRecoveryEvent(payload));

              await AdService.instance.init(userId: authResponse.user!.id);

              try {
                appRouter.replaceAll([const MainActivityRoute()]);
              } catch (e) {
                emit(GoogleAuthError(e.toString()));
              }
            } else {
              emit(
                GoogleAuthSuccess(
                  userCredential,
                  AuthProvider.google,
                  googleSignIn,
                  authResponse,
                ),
              );
              log('User has not registered yet');
              appRouter.push(const WelcomeToSetupRoute());
            }
          },
        );
      },
    );
  }

  void resetState() {
    log('Resetting state...');
    emit(GoogleAuthInitial());
  }
}
