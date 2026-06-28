import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<EmailState> {
  VerifyEmailCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(EmailInitial());

  final AuthRepository _authRepository;

  Future<void> verifyEmail(String email) async {
    emit(SendingOtpState(email: email));

    try {
      final result = await _authRepository.verifyEmail(email);
      await SharedPreferencesStore.saveUserEmail(userEmailKey, email);
      result.fold(
        (failure) =>
            emit(SendingOtpFailureState(failure.message, email: email)),
        (isEmailSent) {
          emit(SendingOtpSuccessState(isEmailSent, email: email));
          appRouter.push(const VerifyEmailRoute());
        },
      );
    } catch (e) {
      emit(SendingOtpFailureState(e.toString(), email: email));
    }
  }

  Future<void> handleOtpLoginFlow({
    required String email,
    required String otp,
  }) async {
    emit(VerifyingOtpState(email: email));

    try {
      final loginResult = await _authRepository.loginWithOtp(email, otp);

      loginResult.fold(
        (failure) async {
          if (failure.message.contains('User not found')) {
            await _handleOtpVerificationForSignup(email, otp);
          } else {
            emit(VerifyingOtpStateFailureState(failure.message, email: email));
          }
        },
        (authResponse) async {
          await _cacheAndNavigate(authResponse, email: email, toMain: true);
        },
      );
    } catch (e) {
      emit(VerifyingOtpStateFailureState(e.toString(), email: email));
    }
  }

  Future<void> _handleOtpVerificationForSignup(String email, String otp) async {
    try {
      emit(VerifyingNewUser(email: email));
      final verifyResult = await _authRepository.verifyOtp(
        email: email,
        otp: otp,
      );

      verifyResult.fold(
        (failure) =>
            emit(VerifyingNewUserFailureState(failure.message, email: email)),
        (_) {
          emit(VerifyingNewUserSuccessState(true, email: email));
          SharedPreferencesStore.saveIsAuthenticatedKey(
            isAuthenticatedKey,
            true,
          );
          appRouter.replace(const WelcomeToSetupRoute());
        },
      );
    } catch (e) {
      emit(VerifyingNewUserFailureState(e.toString(), email: email));
    }
  }

  Future<void> resendOtp(String email) async {
    emit(SendingOtpState(email: email));

    try {
      final result = await _authRepository.verifyEmail(email);
      result.fold(
        (failure) =>
            emit(SendingOtpFailureState(failure.message, email: email)),
        (isEmailSent) =>
            emit(SendingOtpSuccessState(isEmailSent, email: email)),
      );
    } catch (e) {
      emit(SendingOtpFailureState(e.toString(), email: email));
    }
  }

  Future<void> _cacheAndNavigate(
    AuthResponse authResponse, {
    required String email,
    bool toMain = false,
  }) async {
    await SharedPreferencesStore.saveIsAuthenticatedKey(
      isAuthenticatedKey,
      true,
    );
    await SharedPreferencesStore.hasRegistered(hasRegisteredKey, true);
    if (authResponse.user?.id != null) {
      await SharedPreferencesStore.setUserId(userIdKey, authResponse.user!.id!);
      log(' Saved userId to SharedPreferences: ${authResponse.user!.id}');
    }

    emit(VerifyingOtpStateSuccessState(authResponse, email: email));

    if (authResponse.user?.id != null) {
      await AdService.instance.init(userId: authResponse.user!.id);
    }

    if (toMain) {
      if (authResponse.user?.halfPrivateKey == null) {
        appRouter.replace(const WelcomeToSetupRoute());
      } else {
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
        appRouter.replace(const MainActivityRoute());
      }
    }
  }
}
