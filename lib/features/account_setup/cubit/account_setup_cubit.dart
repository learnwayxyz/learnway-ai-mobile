import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnwayv2/features/account_setup/set_up_repository/set_up_repository.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/invite_friends/repository/referral_repository.dart';
import 'package:core/core.dart';
import 'package:variance_dart/variance_dart.dart';

part 'account_setup_state.dart';

enum PreferredImage { camera, gallery, emoji }

enum SetupStep {
  collectingInfo,
  uploadingImage,
  creatingAccount,
  generatingWallet,
  generatingReferralCode,
  settingUpSecurity,
  finalizing,
  completed,
}

class SetupProgress {
  const SetupProgress({
    required this.currentStep,
    required this.message,
    required this.progress,
    this.isError = false,
    this.errorMessage,
  });

  final SetupStep currentStep;
  final String message;
  final double progress;
  final bool isError;
  final String? errorMessage;
  SetupProgress copyWith({
    SetupStep? currentStep,
    String? message,
    double? progress,
    bool? isError,
    String? errorMessage,
  }) {
    return SetupProgress(
      currentStep: currentStep ?? this.currentStep,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AccountSetupCubit extends Cubit<AccountSetupState> {
  AccountSetupCubit() : super(AccountSetupInitial());
  final SetUpRepository _setUpRepository = SetUpRepository();

  void setUserDetails({
    required String userName,
    required String country,
    String? referralCode,
    required AuthProvider? authProvider,
    String? passPhrase,
  }) {
    final currentState = state;
    String currentImage = '';
    String currentPassPhrase = passPhrase ?? '';
    bool? currentUsernameAvailable;

    if (currentState is SetAccountDetails) {
      currentImage = currentState.prefferedImage;
      currentPassPhrase = currentState.passPhrase.isNotEmpty
          ? currentState.passPhrase
          : (passPhrase ?? '');
    }

    log('Setting user details - Username: "$userName", Country: "$country"');

    emit(
      SetAccountDetails(
        userInfo: UserInfoObject(
          userName: userName,
          country: country,
          referralCode: referralCode,
          authProvider: authProvider,
          isComplete: true,
        ),
        selectAvatar: SelectAvatarObject(
          prefferedImage: currentImage,
          passPhrase: currentPassPhrase,
          isSelectAvatarComplete: currentImage.isNotEmpty,
        ),
        userName: userName,
        country: country,
        referralCode: referralCode,
        authProvider: authProvider,
        prefferedImage: currentImage,
        passPhrase: currentPassPhrase,
        isUsernameAvailable: currentUsernameAvailable,
        isCheckingUsername: false,
      ),
    );
  }

  void updateUserName(String userName) {
    final currentState = state;
    if (currentState is SetAccountDetails) {
      log('Updating username to: "$userName"');
      emit(
        currentState.copyWith(userName: userName, isUsernameAvailable: null),
      );
    } else {
      emit(
        SetAccountDetails(
          userName: userName,
          country: '',
          referralCode: null,
          prefferedImage: '',
          authProvider: null,
          passPhrase: '',
          isUsernameAvailable: null,
          isCheckingUsername: false,
          userInfo: UserInfoObject(
            userName: userName,
            country: '',
            referralCode: null,
            authProvider: null,
            isComplete: false,
          ),
          selectAvatar: SelectAvatarObject(
            prefferedImage: '',
            passPhrase: '',
            isSelectAvatarComplete: false,
          ),
        ),
      );
    }
  }

  void updateCountry(String country) {
    final currentState = state;
    if (currentState is SetAccountDetails) {
      log('Updating country to: "$country"');
      emit(currentState.copyWith(country: country));
    } else {
      emit(
        SetAccountDetails(
          userName: '',
          country: country,
          referralCode: null,
          prefferedImage: '',
          authProvider: null,
          passPhrase: '',
          isUsernameAvailable: null,
          isCheckingUsername: false,
          userInfo: UserInfoObject(
            userName: '',
            country: country,
            referralCode: null,
            authProvider: null,
            isComplete: false,
          ),
          selectAvatar: SelectAvatarObject(
            prefferedImage: '',
            passPhrase: '',
            isSelectAvatarComplete: false,
          ),
        ),
      );
    }
  }

  void updateReferralCode(String? referralCode) {
    final currentState = state;
    if (currentState is SetAccountDetails) {
      log('Updating referral code to: "$referralCode"');
      emit(currentState.copyWith(referralCode: referralCode));
    }
  }

  void setAvatar(String avatarPath) {
    log('setting avatar: $avatarPath');

    final currentState = state;
    if (currentState is SetAccountDetails) {
      emit(currentState.copyWith(prefferedImage: avatarPath));
    } else if (currentState is AccountSetupSucess) {
      emit(currentState.copyWith(prefferedImage: avatarPath));
    } else {
      emit(
        SetAccountDetails(
          userName: '',
          country: '',
          referralCode: null,
          prefferedImage: avatarPath,
          authProvider: null,
          passPhrase: '',
          isUsernameAvailable: null,
          isCheckingUsername: false,
          userInfo: UserInfoObject(
            userName: '',
            country: '',
            referralCode: null,
            authProvider: null,
            isComplete: false,
          ),
          selectAvatar: SelectAvatarObject(
            prefferedImage: avatarPath,
            passPhrase: '',
            isSelectAvatarComplete: true,
          ),
        ),
      );
    }
  }

  Future<void> selectPrefferedImage({
    required PreferredImage prefferedImage,
  }) async {
    final options = ImagePicker();
    XFile? image;

    if (prefferedImage == PreferredImage.camera) {
      image = await _takePhoto(options);
    } else if (prefferedImage == PreferredImage.gallery) {
      image = await _pickFromGallery(options);
    }

    if (image != null && image.path.isNotEmpty) {
      final currentState = state;
      if (currentState is SetAccountDetails) {
        log('Account setDetails() ${image.path}');
        emit(currentState.copyWith(prefferedImage: image.path));
      } else if (currentState is AccountSetupSucess) {
        log('Updating preffered image ${image.path}');
        emit(currentState.copyWith(prefferedImage: image.path));
      } else {
        emit(
          SetAccountDetails(
            userName: '',
            country: '',
            referralCode: null,
            prefferedImage: image.path,
            authProvider: null,
            passPhrase: '',
            isUsernameAvailable: null,
            isCheckingUsername: false,
            userInfo: UserInfoObject(
              userName: '',
              country: '',
              referralCode: null,
              authProvider: null,
              isComplete: false,
            ),
            selectAvatar: SelectAvatarObject(
              prefferedImage: image.path,
              passPhrase: '',
              isSelectAvatarComplete: true,
            ),
          ),
        );
      }
    }
  }

  Future<void> completeAccountSetup({String? userEmail}) async {
    final currentState = state;

    if (currentState is! SetAccountDetails) {
      emit(AccountSetupError('Invalid state for account setup'));
      return;
    }

    try {
      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.collectingInfo,
            message: 'Preparing your information...',
            progress: 0.1,
          ),
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));

      String? profileImagePath;
      if (currentState.prefferedImage.isNotEmpty) {
        emit(
          AccountSetupProgress(
            SetupProgress(
              currentStep: SetupStep.uploadingImage,
              message: 'Processing your profile image...',
              progress: 0.2,
            ),
          ),
        );

        profileImagePath = currentState.prefferedImage;
        log('Using profile image path: $profileImagePath');
        await Future.delayed(Duration(milliseconds: 800));
      }

      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.creatingAccount,
            message: 'Creating your account...',
            progress: 0.4,
          ),
        ),
      );

      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.generatingWallet,
            message: 'Generating your secure wallet...',
            progress: 0.6,
          ),
        ),
      );

      final result = await _setUpRepository.setUpWallet(
        country: currentState.country,
        userName: currentState.userName,
        userEmail: userEmail,
        referralCode: currentState.referralCode,
        authProvider: currentState.authProvider,
        profileImage: profileImagePath,
        userPassphrase: currentState.passPhrase,
      );

      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.generatingReferralCode,
            message: 'Generating your referral code...',
            progress: 0.75,
          ),
        ),
      );

      // Generate referral code once during account setup
      try {
        final referralRepository = ReferralRepository();
        final referralResult = await referralRepository.generateReferralCode();
        referralResult.fold(
          (failure) => log(
            'Failed to generate referral code during setup: ${failure.message}',
            name: 'AccountSetupCubit',
          ),
          (code) => log(
            'Referral code generated during setup: $code',
            name: 'AccountSetupCubit',
          ),
        );
      } catch (e) {
        log(
          'Error generating referral code during setup: $e',
          name: 'AccountSetupCubit',
        );
        // Don't fail the entire setup if referral code generation fails
      }

      await Future.delayed(Duration(milliseconds: 500));

      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.settingUpSecurity,
            message: 'Setting up security features...',
            progress: 0.85,
          ),
        ),
      );

      await Future.delayed(Duration(milliseconds: 800));

      result.fold(
        (error) {
          emit(
            AccountSetupProgress(
              SetupProgress(
                currentStep: SetupStep.generatingWallet,
                message: 'Setup failed',
                progress: 0.6,
                isError: true,
                errorMessage: _getErrorMessage(error.message),
              ),
            ),
          );

          Future.delayed(Duration(seconds: 2)).then((_) {
            emit(AccountSetupError(error.message));
          });
        },
        (success) async {
          if (success.$2 != null) {
            emit(
              AccountSetupProgress(
                SetupProgress(
                  currentStep: SetupStep.finalizing,
                  message: 'Finalizing your setup...',
                  progress: 0.95,
                ),
              ),
            );

            await Future.delayed(Duration(milliseconds: 500));

            emit(
              AccountSetupProgress(
                SetupProgress(
                  currentStep: SetupStep.completed,
                  message: 'Setup completed successfully!',
                  progress: 1.0,
                ),
              ),
            );

            await Future.delayed(Duration(milliseconds: 800));

            emit(
              AccountSetupSucess(
                userName: success.$1.userName ?? currentState.userName,
                phoneNumber: '',
                country: currentState.country,
                prefferedImage: currentState.prefferedImage,
                passPhrase: currentState.passPhrase,
                smartWallet: success.$2,
              ),
            );

            SharedPreferencesStore.hasRegistered(hasRegisteredKey, true);
            log(
              'Account setup completed successfully for: ${currentState.userName}',
            );
          } else {
            emit(AccountSetupError('Smart wallet creation failed'));
          }
        },
      );
    } catch (e) {
      log('Error during account setup: $e');

      emit(
        AccountSetupProgress(
          SetupProgress(
            currentStep: SetupStep.creatingAccount,
            message: 'Setup failed',
            progress: 0.4,
            isError: true,
            errorMessage: _getErrorMessage(e.toString()),
          ),
        ),
      );

      await Future.delayed(Duration(seconds: 2));
      emit(AccountSetupError(_getErrorMessage(e.toString())));
    }
  }

  String _getErrorMessage(String error) {
    final errorStr = error.toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network connection failed. Please check your internet and try again.';
    } else if (errorStr.contains('username') ||
        errorStr.contains('already exists')) {
      return 'This username is already taken. Please choose a different one.';
    } else if (errorStr.contains('wallet')) {
      return 'Failed to generate wallet. Please try again.';
    } else if (errorStr.contains('image') || errorStr.contains('upload')) {
      return 'Failed to upload profile image. Please try again.';
    } else {
      return 'Account setup failed. Please try again.';
    }
  }

  Future<XFile?> _takePhoto(final ImagePicker options) async {
    try {
      final image = await options.pickImage(source: ImageSource.camera);
      if (image == null) {
        log('No image selected');
        return null;
      }
      return image;
    } catch (e) {
      log('Error taking photo: $e');
      return null;
    }
  }

  Future<XFile?> _pickFromGallery(final ImagePicker options) async {
    try {
      final image = await options.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      log('Error picking from gallery: $e');
      return null;
    }
  }

  void clearState() {
    emit(AccountSetupInitial());
  }

  Future<void> checkUserName(String name) async {
    final currentState = state;

    if (currentState is SetAccountDetails) {
      // Set checking flag instead of emitting different state
      emit(currentState.copyWith(isCheckingUsername: true));
    }

    final result = await _setUpRepository.checkUserNames(name);

    result.fold(
      (error) {
        if (state is SetAccountDetails) {
          emit(
            (state as SetAccountDetails).copyWith(
              isCheckingUsername: false,
              isUsernameAvailable: null,
            ),
          );
        }
      },
      (success) {
        if (state is SetAccountDetails) {
          emit(
            (state as SetAccountDetails).copyWith(
              isCheckingUsername: false,
              isUsernameAvailable: success,
            ),
          );
        }
      },
    );
  }

  Future<void> fetchUserProfile() async {
    emit(FetchingUserProfile());
    try {
      final result = await _setUpRepository.fetchUserData();
      result.fold(
        (error) {
          log('Failed to fetch user profile: ${error.message}');

          emit(
            SetAccountDetails(
              userName: '',
              country: '',
              referralCode: null,
              prefferedImage: '',
              authProvider: null,
              passPhrase: '',
              isUsernameAvailable: null,
              isCheckingUsername: false,
              userInfo: UserInfoObject(
                userName: '',
                country: '',
                referralCode: null,
                authProvider: null,
                isComplete: false,
              ),
              selectAvatar: SelectAvatarObject(
                prefferedImage: '',
                passPhrase: '',
                isSelectAvatarComplete: false,
              ),
            ),
          );
        },
        (userProfile) {
          log('User profile fetched successfully: ${userProfile.username}');
          emit(
            SetAccountDetails(
              userName: userProfile.username ?? '',
              country: userProfile.country ?? '',
              referralCode: null,
              prefferedImage: userProfile.profileImageUrl ?? '',
              authProvider: null,
              passPhrase: '',
              isUsernameAvailable: null,
              isCheckingUsername: false,
              userInfo: UserInfoObject(
                userName: userProfile.username ?? '',
                country: userProfile.country ?? '',
                referralCode: null,
                authProvider: null,
                isComplete: true,
              ),
              selectAvatar: SelectAvatarObject(
                prefferedImage: userProfile.profileImageUrl ?? '',
                passPhrase: '',
                isSelectAvatarComplete:
                    userProfile.profileImageUrl != null &&
                    userProfile.profileImageUrl!.isNotEmpty,
              ),
            ),
          );
        },
      );
    } catch (e) {
      log('Error fetching user profile: $e');
      emit(
        SetAccountDetails(
          userName: '',
          country: '',
          referralCode: null,
          prefferedImage: '',
          authProvider: null,
          passPhrase: '',
          isUsernameAvailable: null,
          isCheckingUsername: false,
          userInfo: UserInfoObject(
            userName: '',
            country: '',
            referralCode: null,
            authProvider: null,
            isComplete: false,
          ),
          selectAvatar: SelectAvatarObject(
            prefferedImage: '',
            passPhrase: '',
            isSelectAvatarComplete: false,
          ),
        ),
      );
    }
  }

  void updateProgress(SetupStep step, String message, {double? progressValue}) {
    final progress =
        progressValue ?? (step.index / (SetupStep.values.length - 1));
    emit(
      AccountSetupProgress(
        SetupProgress(currentStep: step, message: message, progress: progress),
      ),
    );
  }

  void updateProgressWithError(String errorMessage) {
    final currentState = state;
    if (currentState is AccountSetupProgress) {
      emit(
        AccountSetupProgress(
          currentState.progress.copyWith(
            isError: true,
            errorMessage: errorMessage,
          ),
        ),
      );
    }
  }

  void retrySetup({String? userEmail}) {
    completeAccountSetup(userEmail: userEmail);
  }
}
