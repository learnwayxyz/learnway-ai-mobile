part of 'profile_cubit.dart';

// Enums for different operation statuses
enum ProfileStatus { initial, loading, loaded, error }

enum UpdateStatus { none, updating, updated, error }

enum ProfileImageStatus { none, updating, updated, error }

enum UpdatingUserNameStatus { none, updating, updated, error }

enum UpdatingEmailStatus { none, updating, updated, error }

enum UpdatingPhoneStatus { none, updating, updated, error }

enum UpdatingCountryStatus { none, updating, updated, error }

enum UsernameCheckStatus { none, checking, available, unavailable, error }

enum DeleteStatus { none, deleting, deleted, error }

enum LogoutAccountStatus { none, loggingOut, loggedOut, error }

enum UpdateLanguageStatus { none, updating, updated, error }

enum FetchsupportedLanguageStatus { none, fetching, fetched, error }

// Single ProfileState class
class ProfileState extends Equatable {
  const ProfileState({
    this.profileStatus = ProfileStatus.initial,
    this.updateStatus = UpdateStatus.none,
    this.usernameCheckStatus = UsernameCheckStatus.none,
    this.deleteStatus = DeleteStatus.none,
    this.profileImageStatus = ProfileImageStatus.none,
    this.updatingUserNameStatus = UpdatingUserNameStatus.none,
    this.updatingCountryStatus = UpdatingCountryStatus.none,
    this.updatingEmailStatus = UpdatingEmailStatus.none,
    this.updatingPhoneStatus = UpdatingPhoneStatus.none,
    this.logoutAccountStatus = LogoutAccountStatus.none,
    this.supportedLanguageStatus = FetchsupportedLanguageStatus.none,
    this.updateLanguageStatus = UpdateLanguageStatus.none,
    this.supportedLanguage,
    this.user,
    this.selectedImagePath,
    this.errorMessage,
    this.updateErrorMessage,
    this.usernameCheckMessage,
    this.deleteErrorMessage,
    this.logoutErrorMessage,
    this.preferredLanguage,
  });

  final ProfileStatus profileStatus;
  final UpdateStatus updateStatus;
  final UsernameCheckStatus usernameCheckStatus;
  final DeleteStatus deleteStatus;
  final UserAccountModel? user;
  final ProfileImageStatus profileImageStatus;
  final UpdatingUserNameStatus updatingUserNameStatus;
  final UpdatingEmailStatus updatingEmailStatus;
  final UpdatingPhoneStatus updatingPhoneStatus;
  final UpdatingCountryStatus updatingCountryStatus;
  final UpdateLanguageStatus updateLanguageStatus;
  final LogoutAccountStatus logoutAccountStatus;
  final FetchsupportedLanguageStatus supportedLanguageStatus;
  final List<Language>? supportedLanguage;
  final String? selectedImagePath;
  final String? errorMessage;
  final String? logoutErrorMessage;
  final String? updateErrorMessage;
  final String? usernameCheckMessage;
  final String? deleteErrorMessage;
  final String? preferredLanguage;

  // Convenience getters
  bool get isLoading => profileStatus == ProfileStatus.loading;
  bool get isLoaded => profileStatus == ProfileStatus.loaded;
  bool get hasError => profileStatus == ProfileStatus.error;

  bool get isUpdating => updateStatus == UpdateStatus.updating;
  bool get isUpdated => updateStatus == UpdateStatus.updated;
  bool get hasUpdateError => updateStatus == UpdateStatus.error;

  bool get isUpdatingProfileImage =>
      profileImageStatus == ProfileImageStatus.updating;
  bool get isUpdatedProfileImage =>
      profileImageStatus == ProfileImageStatus.updated;
  bool get hasUpdateProfileImageError =>
      profileImageStatus == ProfileImageStatus.error;

  bool get isUpdatingUserName =>
      updatingUserNameStatus == UpdatingUserNameStatus.updating;
  bool get isUpdatedUserName =>
      updatingUserNameStatus == UpdatingUserNameStatus.updated;
  bool get hasUpdateUserNameError =>
      updatingUserNameStatus == UpdatingUserNameStatus.error;

  bool get isUpdatingEmail =>
      updatingEmailStatus == UpdatingEmailStatus.updating;
  bool get isUpdatedEmail => updatingEmailStatus == UpdatingEmailStatus.updated;
  bool get hasUpdateEmailError =>
      updatingEmailStatus == UpdatingEmailStatus.error;

  bool get isUpdatingPhone =>
      updatingPhoneStatus == UpdatingPhoneStatus.updating;
  bool get isUpdatedPhone => updatingPhoneStatus == UpdatingPhoneStatus.updated;
  bool get hasUpdatePhoneError =>
      updatingPhoneStatus == UpdatingPhoneStatus.error;

  bool get isUpdatingCountry =>
      updatingCountryStatus == UpdatingCountryStatus.updating;
  bool get isUpdatedCountry =>
      updatingCountryStatus == UpdatingCountryStatus.updated;
  bool get hasUpdateCountryError =>
      updatingCountryStatus == UpdatingCountryStatus.error;

  bool get isCheckingUsername =>
      usernameCheckStatus == UsernameCheckStatus.checking;
  bool get isUsernameAvailable =>
      usernameCheckStatus == UsernameCheckStatus.available;
  bool get isUsernameUnavailable =>
      usernameCheckStatus == UsernameCheckStatus.unavailable;
  bool get hasUsernameCheckError =>
      usernameCheckStatus == UsernameCheckStatus.error;

  bool get isDeleting => deleteStatus == DeleteStatus.deleting;
  bool get isDeleted => deleteStatus == DeleteStatus.deleted;
  bool get hasDeleteError => deleteStatus == DeleteStatus.error;

  bool get hasSelectedImage =>
      selectedImagePath != null && selectedImagePath!.isNotEmpty;
  bool get hasUser => user != null;

  bool get isLoggingOut =>
      logoutAccountStatus == LogoutAccountStatus.loggingOut;
  bool get isLoggedOut => logoutAccountStatus == LogoutAccountStatus.loggedOut;
  bool get hasLogoutError => logoutAccountStatus == LogoutAccountStatus.error;

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UpdateStatus? updateStatus,
    ProfileImageStatus? profileImageStatus,
    UsernameCheckStatus? usernameCheckStatus,
    DeleteStatus? deleteStatus,
    UserAccountModel? user,
    UpdatingUserNameStatus? updatingUserNameStatus,
    UpdatingEmailStatus? updatingEmailStatus,
    UpdatingPhoneStatus? updatingPhoneStatus,
    UpdatingCountryStatus? updatingCountryStatus,
    LogoutAccountStatus? logoutAccountStatus,
    UpdateLanguageStatus? updateLanguageStatus,
    FetchsupportedLanguageStatus? supportedLanguageStatus,
    List<Language>? supportedLanguage,
    String? selectedImagePath,
    String? errorMessage,
    String? updateErrorMessage,
    String? usernameCheckMessage,
    String? deleteErrorMessage,
    String? logoutErrorMessage,
    bool clearSelectedImagePath = false,
    bool clearErrorMessage = false,
    bool clearUpdateErrorMessage = false,
    bool clearUsernameCheckMessage = false,
    bool clearDeleteErrorMessage = false,
    String? preferredLanguage,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      usernameCheckStatus: usernameCheckStatus ?? this.usernameCheckStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      profileImageStatus: profileImageStatus ?? this.profileImageStatus,
      updatingCountryStatus:
          updatingCountryStatus ?? this.updatingCountryStatus,
      updatingEmailStatus: updatingEmailStatus ?? this.updatingEmailStatus,
      updatingPhoneStatus: updatingPhoneStatus ?? this.updatingPhoneStatus,
      updatingUserNameStatus:
          updatingUserNameStatus ?? this.updatingUserNameStatus,
      user: user ?? this.user,
      selectedImagePath: clearSelectedImagePath
          ? null
          : (selectedImagePath ?? this.selectedImagePath),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      updateErrorMessage: clearUpdateErrorMessage
          ? null
          : (updateErrorMessage ?? this.updateErrorMessage),
      usernameCheckMessage: clearUsernameCheckMessage
          ? null
          : (usernameCheckMessage ?? this.usernameCheckMessage),
      deleteErrorMessage: clearDeleteErrorMessage
          ? null
          : (deleteErrorMessage ?? this.deleteErrorMessage),
      logoutAccountStatus: logoutAccountStatus ?? this.logoutAccountStatus,
      logoutErrorMessage: logoutErrorMessage ?? this.logoutErrorMessage,
      updateLanguageStatus: updateLanguageStatus ?? this.updateLanguageStatus,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      supportedLanguageStatus:
          supportedLanguageStatus ?? this.supportedLanguageStatus,
      supportedLanguage: supportedLanguage ?? this.supportedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    profileStatus,
    updateStatus,
    usernameCheckStatus,
    deleteStatus,
    profileImageStatus,
    user,
    selectedImagePath,
    errorMessage,
    updateErrorMessage,
    usernameCheckMessage,
    deleteErrorMessage,
    updatingCountryStatus,
    updatingEmailStatus,
    updatingPhoneStatus,
    updatingUserNameStatus,
    logoutAccountStatus,
    logoutErrorMessage,
    updateLanguageStatus,
    preferredLanguage,
    supportedLanguageStatus,
    supportedLanguage,
  ];
}
