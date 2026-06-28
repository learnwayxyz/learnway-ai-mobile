import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:learnwayv2/app/app.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/auth/auth_data_source/auth_models/auth_response.dart';
import 'package:learnwayv2/features/auth/repository/auth_repository.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';

part 'apple_auth_state.dart';

class AppleAuthCubit extends Cubit<AppleAuthState> {
  AppleAuthCubit() : super(AppleAuthInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> signInWithApple() async {
    emit(AppleAuthLoading());
    final appleResult = await _authRepository.registerwithApple();

    appleResult.fold(
      (l) {
        log('Apple Sign-In error: ${l.message}');
        emit(AppleAuthError(l.message));
      },
      (userCredential) async {
        await SharedPreferencesStore.saveUserEmail(
          userEmailKey,
          userCredential.user!.email ?? '',
        );
        final loginResult = await _authRepository.loginUser(
          userCredential.user?.email ?? '',
          AuthProvider.apple,
        );

        loginResult.fold(
          (l) {
            if (l.message.contains('User not found')) {
              emit(AppleAuthSuccess(userCredential, null, AuthProvider.apple));
              appRouter.push(const WelcomeToSetupRoute());
            } else {
              emit(AppleAuthError(l.message));
            }
          },
          (authResponse) async {
            if (authResponse.user == null) {
              emit(
                AppleAuthError(
                  'Unable to retrieve user information. Please try again.',
                ),
              );
              return;
            }
            final hasPrivateKey =
                authResponse.user!.halfPrivateKey?.isNotEmpty ?? false;

            if (hasPrivateKey) {
              log('Apple login successful');
              emit(
                AppleAuthSuccess(
                  userCredential,
                  authResponse,
                  AuthProvider.apple,
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
              log(
                'Recovering wallet Apple (remote shares) for: ${config.pepAddress}',
              );
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
                log('Navigation error: $e');
              }
            } else {
              log('No private key found, navigating to setup');
              emit(AppleAuthSuccess(userCredential, null, AuthProvider.apple));
              appRouter.replaceAll([const WelcomeToSetupRoute()]);
            }
          },
        );
      },
    );
  }

  void resetState() {
    log('Resetting state...');
    emit(AppleAuthInitial());
  }
}
