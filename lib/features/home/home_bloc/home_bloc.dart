import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry/sentry.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/home/home_repository/home_repository.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:learnwayv2/features/wallet/balance_caching.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/services/eip_4337/account_abstraction.dart';
import 'package:learnwayv2/services/ioslate_recovery_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/cryptography_service.dart';
import 'package:learnwayv2/services/secret_sharing_service/crypto/share_processor.dart';
import 'package:variance_dart/variance_dart.dart';
import 'package:web3_signers/web3_signers.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeRepository? homeRepository})
    : _homeRepository = locator<HomeRepository>(),
      super(FetchHomeDataInitial()) {
    on<FetchHomeDataEvent>(_onFetchUserDetails);
    on<RefreshHomeDataEvent>(_onRefreshHome);
    on<AttemptWalletRecoveryEvent>(_onAttemptRecoveryEvent);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<ResetHomeBlocEvent>(_onResetHomeBloc);
  }

  final HomeRepository _homeRepository;

  UserProfileModel? _cachedUserProfile;

  Future<void> _onFetchUserDetails(
    FetchHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(FetchingHomeData(userProfile: _cachedUserProfile));
    try {
      final user = await _homeRepository.fetchHomeData();
      user.fold(
        (fail) {
          emit(
            FetchingHomeDataError(
              fail.message,
              userProfile: _cachedUserProfile,
            ),
          );
        },
        (success) {
          _cachedUserProfile = success;

          emit(FetchHomeDataSuccess(userProfile: success));
        },
      );
    } catch (e) {
      emit(
        FetchingHomeDataError(
          "Unexpected error: ${e.toString()}",
          userProfile: _cachedUserProfile,
        ),
      );
    }
  }

  Future<void> _onRefreshHome(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final user = await _homeRepository.fetchHomeData();
      user.fold(
        (fail) {
          emit(
            FetchingHomeDataError(
              fail.message,
              userProfile: _cachedUserProfile,
            ),
          );
        },
        (success) {
          _cachedUserProfile = success;
          emit(FetchHomeDataSuccess(userProfile: success));
        },
      );
    } catch (e) {
      emit(
        FetchingHomeDataError(
          "Unexpected error: ${e.toString()}",
          userProfile: _cachedUserProfile,
        ),
      );
    }
  }

  Future<void> _onAttemptRecoveryEvent(
    AttemptWalletRecoveryEvent event,
    Emitter<HomeState> emit,
  ) async {
    log('Starting wallet recovery process');
    try {
      emit(RecoveringInBackground(userProfile: _cachedUserProfile));
      await compute(_recoveryEntry, event.args).then((val) async {
        final result = ShareProcessor().recoverOriginalSecret(
          Uint8List.fromList(val),
        );
        final decoded = jsonDecode(result);
        final smartWallet = await locator.get<AAServices>().recoverAccount(
          decoded['mnemonic'],
        );
        final backendWallet = event.args['walletAddress'] as String?;
        final ownerEoa = EOAWallet.recoverAccount(
          decoded['mnemonic'],
          const SignatureOptions(prefix: [0]),
        ).getAddress();
        log(
          'Wallet recovery: userEmail=${event.args['userEmail']} '
          'userId=${event.args['userId']} backendWallet=$backendWallet '
          'recoveredWallet=${smartWallet.address.eip55With0x} '
          'ownerEoa=$ownerEoa '
          'sharesWallet=${decoded['walletAddress']} '
          'sharesCreatedAt=${decoded['createdAt']} '
          'sharesVersion=${decoded['version']}',
        );
        if (backendWallet != null &&
            backendWallet.toLowerCase() !=
                smartWallet.address.eip55With0x.toLowerCase()) {
          log(
            'Wallet recovery MISMATCH: backend has $backendWallet but shares '
            'recovered ${smartWallet.address.eip55With0x}',
          );
          Sentry.captureMessage(
            'Wallet recovery address mismatch',
            level: SentryLevel.error,
            withScope: (scope) {
              scope.setTag('feature', 'wallet_recovery');
              scope.setTag('flavor', Env.flavor.name);
              scope.setUser(SentryUser(id: event.args['userId'] as String?));
              scope.setContexts('wallet_recovery', {
                'backendWallet': backendWallet,
                'recoveredWallet': smartWallet.address.eip55With0x,
                'sharesWallet': decoded['walletAddress'],
                'ownerEoa': ownerEoa,
                'sharesCreatedAt': decoded['createdAt'],
                'sharesVersion': decoded['version'],
                'accountFactory': Env.accountFactory,
                'chainId': Env.chainId,
              });
            },
          );
        }
        try {
          await LocalStorageService.saveWalletAddress(
            smartWallet.address.eip55With0x,
          );

          final savedAddress = await LocalStorageService.getWalletAddress();
          if (savedAddress != smartWallet.address.eip55With0x) {
            throw Exception('Wallet address was not saved correctly');
          }
        } catch (saveError) {
          log('Failed to save wallet address: $saveError');
          emit(
            RecoveryError(
              'Failed to save wallet address: $saveError',
              userProfile: _cachedUserProfile,
            ),
          );
          return;
        }
        final value = locator.get<CryptographyService>();
        value.secureZeroize(
          Uint8List.fromList(utf8.encode(decoded['mnemonic'])),
        );
        emit(RecoverySuccess(smartWallet, userProfile: _cachedUserProfile));
        log('Registering SmartWallet instance in locator');
        if (locator.isRegistered<SmartWallet>()) {
          log('Unregistering existing SmartWallet instance');
          locator.unregister<SmartWallet>();
        }
        locator.registerLazySingleton<SmartWallet>(() => smartWallet);
        log('SmartWallet instance registered successfully');
      });
    } catch (e, st) {
      log('Wallet recovery failed: $e', stackTrace: st);
      Sentry.captureException(
        e,
        stackTrace: st,
        withScope: (scope) {
          scope.setTag('feature', 'wallet_recovery');
          scope.setUser(SentryUser(id: event.args['userId'] as String?));
        },
      );
      emit(
        RecoveryError('Unexpected error: $e', userProfile: _cachedUserProfile),
      );
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<HomeState> emit,
  ) {
    _cachedUserProfile = event.userProfile;
    emit(FetchHomeDataSuccess(userProfile: event.userProfile));
  }

  void updateUserProfile(UserProfileModel userProfile) {
    add(UpdateUserProfileEvent(userProfile));
  }

  void resetState() {
    add(const ResetHomeBlocEvent());
  }

  void _onResetHomeBloc(ResetHomeBlocEvent event, Emitter<HomeState> emit) {
    _cachedUserProfile = null;
    emit(const FetchHomeDataInitial());
  }

  Future<void> clearUserData() async {
    try {
      _cachedUserProfile = null;

      await LocalStorageService.clearWalletAddress();

      await LocalStorageService.clear();
      await LocalStorageService.clearExchangeRates();
      await BalanceCache.clearCache();
      if (locator.isRegistered<SmartWallet>()) {
        locator.unregister<SmartWallet>();
      }

      final walletCubit = locator<WalletCubit>();
      walletCubit.resetAllStates();

      log('User data cleared successfully');
    } catch (e) {
      log('Error clearing user data: $e');
    }
  }
}

Future<List<int>> _recoveryEntry(Map<String, dynamic> args) async {
  log('Starting recovery in isolate with args: $args');
  final service = IsolateRecoveryService();
  return await service.recovery(
    args['remoteShares'] as String,
    args['userName'] as String,
    args['userEmail'] as String,
    args['walletAddress'] as String,
    args['userId'] as String,
    args['pepAddress'] as String,
  );
}
