import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account/model/supported_language_response.dart';
import 'package:learnwayv2/features/account/repository/profile_repository.dart';
import 'package:learnwayv2/features/auth/repository/auth_repository.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/badges/bloc/badge_bloc.dart';
import 'package:learnwayv2/features/badges/bloc/badge_event.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/features/wallet/balance_caching.dart';
import 'package:learnwayv2/features/invite_friends/cubit/invite_friends_cubit.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/kyc_cubit.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/kyc_service/kyc_sync_queue.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/revenue_cat_service.dart';
import 'package:learnwayv2/services/screen_load_state_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/services/notification_service/fcm_service.dart';

part 'profile_state.dart';

enum PreferredImageSource { camera, gallery }

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({HomeBloc? homeBloc})
    : _homeBloc = homeBloc ?? locator<HomeBloc>(),
      _kycCubit = locator<KycCubit>(),
      super(const ProfileState());

  final ProfileRepository _profileRepository = ProfileRepository();
  final HomeBloc _homeBloc;
  final KycCubit _kycCubit;

  Future<void> fetchUserData() async {
    emit(
      state.copyWith(
        profileStatus: ProfileStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final homeState = _homeBloc.state;
      if (homeState.userProfile != null) {
        final userAccount = homeState.userProfile!.toUserAccountModel();
        emit(
          state.copyWith(
            profileStatus: ProfileStatus.loaded,
            user: userAccount,
            clearErrorMessage: true,
          ),
        );
      } else {
        final result = await _profileRepository.fetchUserData();
        result.fold(
          (error) => emit(
            state.copyWith(
              profileStatus: ProfileStatus.error,
              errorMessage: error.message,
            ),
          ),
          (user) => emit(
            state.copyWith(
              profileStatus: ProfileStatus.loaded,
              user: user,
              clearErrorMessage: true,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.error,
          errorMessage: 'Failed to fetch user data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> selectProfileImage({
    required PreferredImageSource imageSource,
  }) async {
    final options = ImagePicker();
    XFile? image;

    try {
      if (imageSource == PreferredImageSource.camera) {
        image = await _takePhoto(options);
      } else if (imageSource == PreferredImageSource.gallery) {
        image = await _pickFromGallery(options);
      }

      if (image != null && image.path.isNotEmpty) {
        emit(state.copyWith(selectedImagePath: image.path));
      }
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.error,
          errorMessage: 'Failed to select image: ${e.toString()}',
        ),
      );
    }
  }

  void setAvatar(String avatarPath) {
    log('Setting avatar: $avatarPath');
    emit(state.copyWith(selectedImagePath: avatarPath));
  }

  Future<void> updateProfile({
    String? username,
    String? email,
    String? phoneNumber,
    String? country,
    String? profileImagePath,
  }) async {
    emit(
      state.copyWith(
        updateStatus: UpdateStatus.updating,
        clearUpdateErrorMessage: true,
      ),
    );

    try {
      final result = await _profileRepository.updateUserProfile(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        profileImagePath: profileImagePath,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            updateStatus: UpdateStatus.error,
            updateErrorMessage: error.message,
          ),
        ),
        (updatedUser) {
          final shouldClearSelectedImage =
              profileImagePath != null &&
              !profileImagePath.startsWith('assets/');

          emit(
            state.copyWith(
              updateStatus: UpdateStatus.updated,
              user: updatedUser,
              profileStatus: ProfileStatus.loaded,
              clearUpdateErrorMessage: true,
              selectedImagePath: shouldClearSelectedImage
                  ? null
                  : state.selectedImagePath,
            ),
          );

          _notifyHomeBloc(updatedUser);
          _updateLocalStorage(updatedUser);
          if (updatedUser.profileImageUrl != null) {
            appRouter.push(
              ChangeAvatarSuccessRoute(
                imagePath: updatedUser.profileImageUrl ?? '',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          updateStatus: UpdateStatus.error,
          updateErrorMessage: 'Failed to update profile: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> deleteAccount() async {
    log('Deleting account...');
    emit(
      state.copyWith(
        deleteStatus: DeleteStatus.deleting,
        clearDeleteErrorMessage: true,
      ),
    );

    try {
      if (locator.isRegistered<BalanceNotifier>()) {
        final balanceNotifier = locator.get<BalanceNotifier>();
        balanceNotifier.stopAutoRefresh();
        balanceNotifier.clearState();
      }
    } catch (e) {
      log('Error clearing balance notifier: $e');
    }

    await BalanceCache.clearCache();
    await LocalStorageService.clearWalletAddress();

    try {
      final result = await _profileRepository.deleteMyAccount();
      result.fold(
        (error) => emit(
          state.copyWith(
            deleteStatus: DeleteStatus.error,
            deleteErrorMessage: error.message,
          ),
        ),
        (isDeleted) async {
          emit(
            state.copyWith(
              deleteStatus: DeleteStatus.deleted,
              clearDeleteErrorMessage: true,
            ),
          );

          resetState();
          _homeBloc.resetState();
          locator.get<InviteFriendsCubit>().resetState();

          locator.get<CoursesBloc>().add(const ResetCoursesBloc());
          locator.get<RegisteredCoursesBloc>().add(
            const ResetRegisteredCoursesBloc(),
          );
          locator.get<LearnAndEarnBloc>().add(const ResetLearnAndEarnBloc());

          await SharedPreferencesStore.clearKycData();
          await _kycCubit.resetKyc();
          await LocalStorageService.clear();
          await BalanceCache.clearCache();

          locator.get<WalletCubit>()
            ..resetAllStates()
            ..resetAllErrors();
          await SharedPreferencesStore.clearKycData();
          await KycSyncQueue.clearQueue();
          await FCMService().dispose();
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          deleteStatus: DeleteStatus.error,
          deleteErrorMessage: 'Failed to delete account: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> checkUserName(String name) async {
    emit(
      state.copyWith(
        usernameCheckStatus: UsernameCheckStatus.checking,
        clearUsernameCheckMessage: true,
      ),
    );

    try {
      final result = await _profileRepository.checkUserNames(name);
      result.fold(
        (error) => emit(
          state.copyWith(
            usernameCheckStatus: UsernameCheckStatus.error,
            usernameCheckMessage: error.message,
          ),
        ),
        (isAvailable) => emit(
          state.copyWith(
            usernameCheckStatus: isAvailable
                ? UsernameCheckStatus.available
                : UsernameCheckStatus.unavailable,
            usernameCheckMessage: isAvailable
                ? 'Username is available'
                : 'Username is not available',
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          usernameCheckStatus: UsernameCheckStatus.error,
          usernameCheckMessage: 'Username check error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> getSupportedLanguage() async {
    emit(
      state.copyWith(
        supportedLanguageStatus: FetchsupportedLanguageStatus.fetching,
      ),
    );
    try {
      final result = await _profileRepository.getSupportedLanguages();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              supportedLanguage: null,
              supportedLanguageStatus: FetchsupportedLanguageStatus.error,
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              supportedLanguage: success,
              supportedLanguageStatus: FetchsupportedLanguageStatus.fetched,
            ),
          );
        },
      );
    } catch (e) {}
  }

  void clearUsernameCheck() {
    emit(
      state.copyWith(
        usernameCheckStatus: UsernameCheckStatus.none,
        clearUsernameCheckMessage: true,
      ),
    );
  }

  void clearError() {
    emit(
      state.copyWith(
        profileStatus: state.hasUser
            ? ProfileStatus.loaded
            : ProfileStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void clearUpdateError() {
    emit(
      state.copyWith(
        updateStatus: UpdateStatus.none,
        clearUpdateErrorMessage: true,
      ),
    );
  }

  void clearDeleteError() {
    emit(
      state.copyWith(
        deleteStatus: DeleteStatus.none,
        clearDeleteErrorMessage: true,
      ),
    );
  }

  Future<XFile?> _takePhoto(ImagePicker options) async {
    try {
      final image = await options.pickImage(source: ImageSource.camera);
      if (image == null) {
        log('No image selected from camera');
        return null;
      }
      return image;
    } catch (e) {
      log('Error taking photo: $e');
      return null;
    }
  }

  Future<XFile?> _pickFromGallery(ImagePicker options) async {
    try {
      final image = await options.pickImage(source: ImageSource.gallery);
      if (image == null) {
        log('No image selected from gallery');
        return null;
      }
      return image;
    } catch (e) {
      log('Error picking from gallery: $e');
      return null;
    }
  }

  Future<void> updateLanguage(String prefLanguageString) async {
    emit(state.copyWith(updateLanguageStatus: UpdateLanguageStatus.updating));
    log('My new language ${prefLanguageString}');
    try {
      final result = await _profileRepository.updateLanguagePref(
        prefLanguageString,
      );

      result.fold(
        (fail) {
          emit(
            state.copyWith(updateLanguageStatus: UpdateLanguageStatus.error),
          );
        },
        (right) {
          emit(
            state.copyWith(
              preferredLanguage: right,
              updateLanguageStatus: UpdateLanguageStatus.updated,
            ),
          );
        },
      );
    } catch (e) {
      log('Error updating language ${e.toString()}');
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutAccountStatus: LogoutAccountStatus.loggingOut));
    final currentUserId = await SharedPreferencesStore.getUserId(userIdKey);

    try {
      if (locator.isRegistered<BalanceNotifier>()) {
        final balanceNotifier = locator.get<BalanceNotifier>();
        balanceNotifier.stopAutoRefresh();
        balanceNotifier.clearState();
      }
    } catch (e) {
      log('Error clearing balance notifier: $e');
    }

    await BalanceCache.clearCache();
    await LocalStorageService.clearWalletAddress();
    await RevenueCatService.instance.logOut();

    final result = await _profileRepository.logOut();
    result.fold(
      (error) => emit(
        state.copyWith(
          logoutAccountStatus: LogoutAccountStatus.error,
          logoutErrorMessage: error.message,
        ),
      ),
      (isLoggedOut) async {
        emit(
          state.copyWith(logoutAccountStatus: LogoutAccountStatus.loggedOut),
        );
        if (currentUserId != null && currentUserId.isNotEmpty) {
          locator.get<BadgeBloc>().add(ClearCache(userId: currentUserId));
        }
        BadgeBloc.clearCache();
        ScreenLoadStateService().clearAll();
        resetState();
        locator.get<MainActivityCubit>().resetState();
        locator.get<InviteFriendsCubit>().resetState();

        if (locator.isRegistered<AppleAuthCubit>()) {
          locator.get<AppleAuthCubit>().resetState();
        }
        if (locator.isRegistered<GoogleAuthCubit>()) {
          locator.get<GoogleAuthCubit>().resetState();
        }

        await SharedPreferencesStore.hasRegistered(hasRegisteredKey, false);
        await SharedPreferencesStore.saveUserEmail(userEmailKey, '');

        try {
          final authRepo = AuthRepository();
          await authRepo.signOut();
        } catch (e) {
          log('Error signing out from Firebase: $e');
        }

        await SharedPreferencesStore.clearKycData();
        await _kycCubit.resetKyc();

        _homeBloc.resetState();
        await _homeBloc.clearUserData();

        locator.get<WalletCubit>()
          ..resetAllStates()
          ..resetAllErrors();

        await LocalStorageService.clear();
        await BalanceCache.clearCache();

        await FCMService().dispose();
        locator.get<CoursesBloc>().add(const ResetCoursesBloc());
        locator.get<RegisteredCoursesBloc>().add(
          const ResetRegisteredCoursesBloc(),
        );
        locator.get<LearnAndEarnBloc>().add(const ResetLearnAndEarnBloc());
        appRouter.pushAndPopUntil(
          const RegisterRoute(),
          predicate: (_) => false,
        );
      },
    );
  }

  void resetState() {
    emit(const ProfileState());
  }

  void _notifyHomeBloc(UserAccountModel userAccount) {
    try {
      final userProfile = UserProfileModel(
        id: userAccount.id,
        username: userAccount.username,
        email: userAccount.email,
        isEmailVerified: userAccount.isEmailVerified,
        role: userAccount.role,
        country: userAccount.country,
        halfPrivateKey: userAccount.halfPrivateKey,
        referralCode: userAccount.referralCode,
        walletAddress: userAccount.walletAddress,
        lastLoginAt: userAccount.lastLoginAt,
        createdAt: userAccount.createdAt,
        updatedAt: userAccount.updatedAt,
        profileImageUrl: userAccount.profileImageUrl,
        profileImageFileId: userAccount.profileImageFileId,
        profileThumbnailUrl: userAccount.profileThumbnailUrl,
        badgeList: userAccount.badgeList,
        totalBadges: userAccount.totalBadges,
        totalGems: userAccount.totalGems,
        totalXp: userAccount.totalXp,
      );

      _homeBloc.updateUserProfile(userProfile);
      log('Notified HomeBloc about profile update');
    } catch (e) {
      log('Error notifying HomeBloc: $e');
    }
  }

  void _updateLocalStorage(UserAccountModel userAccount) {
    try {
      final userProfile = UserProfileModel(
        id: userAccount.id,
        username: userAccount.username,
        email: userAccount.email,
        isEmailVerified: userAccount.isEmailVerified,
        role: userAccount.role,
        country: userAccount.country,
        halfPrivateKey: userAccount.halfPrivateKey,
        referralCode: userAccount.referralCode,
        walletAddress: userAccount.walletAddress,
        lastLoginAt: userAccount.lastLoginAt,
        createdAt: userAccount.createdAt,
        updatedAt: userAccount.updatedAt,
        profileImageUrl: userAccount.profileImageUrl,
        profileImageFileId: userAccount.profileImageFileId,
        profileThumbnailUrl: userAccount.profileThumbnailUrl,
        badgeList: userAccount.badgeList,
        totalBadges: userAccount.totalBadges,
        totalGems: userAccount.totalGems,
        totalXp: userAccount.totalXp,
      );

      LocalStorageService.saveUser(userProfile);
      log('Updated LocalStorage with new user profile');
    } catch (e) {
      log('Error updating LocalStorage: $e');
    }
  }
}
