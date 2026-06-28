part of 'account_setup_cubit.dart';

abstract class AccountSetupState extends Equatable {
  const AccountSetupState();

  @override
  List<Object?> get props => [];
}

class AccountSetupInitial extends AccountSetupState {}

class AccountSetupLoading extends AccountSetupState {}

class FetchingUserProfile extends AccountSetupState {}

class AccountSetupProgress extends AccountSetupState {
  final SetupProgress progress;

  const AccountSetupProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class SetAccountDetails extends AccountSetupState {
  const SetAccountDetails({
    required this.userName,
    required this.country,
    this.referralCode,
    required this.prefferedImage,
    this.authProvider,
    required this.passPhrase,
    this.isUsernameAvailable,
    this.isCheckingUsername = false,
    required this.userInfo,
    required this.selectAvatar,
  });

  final String userName;
  final String country;
  final String? referralCode;
  final String prefferedImage;
  final AuthProvider? authProvider;
  final String passPhrase;
  final bool? isUsernameAvailable;
  final bool isCheckingUsername;
  final UserInfoObject userInfo;
  final SelectAvatarObject selectAvatar;

  bool get hasUserDetails =>
      userName.trim().isNotEmpty && country.trim().isNotEmpty;

  bool get hasAvatar => prefferedImage.isNotEmpty;
  bool get hasPassphrase => passPhrase.isNotEmpty;

  bool get isComplete => hasUserDetails && hasAvatar;

  SetAccountDetails copyWith({
    String? userName,
    String? country,
    String? referralCode,
    String? prefferedImage,
    AuthProvider? authProvider,
    String? passPhrase,
    bool? isUsernameAvailable,
    bool? isCheckingUsername,
  }) {
    return SetAccountDetails(
      userInfo: UserInfoObject(
        userName: userName ?? this.userName,
        country: country ?? this.country,
        referralCode: referralCode ?? this.referralCode,
        authProvider: authProvider ?? this.authProvider,
        isComplete: isComplete,
      ),
      selectAvatar: SelectAvatarObject(
        prefferedImage: prefferedImage ?? this.prefferedImage,
        passPhrase: passPhrase ?? this.passPhrase,
        isSelectAvatarComplete: hasAvatar,
      ),
      userName: userName ?? this.userName,
      country: country ?? this.country,
      referralCode: referralCode ?? this.referralCode,
      prefferedImage: prefferedImage ?? this.prefferedImage,
      authProvider: authProvider ?? this.authProvider,
      passPhrase: passPhrase ?? this.passPhrase,
      isUsernameAvailable: isUsernameAvailable ?? this.isUsernameAvailable,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    country,
    referralCode,
    prefferedImage,
    authProvider,
    passPhrase,
    isUsernameAvailable,
    isCheckingUsername,
    userInfo,
    selectAvatar,
  ];
}

class CheckingUserName extends AccountSetupState {
  const CheckingUserName({
    required this.userName,
    required this.country,
    this.referralCode,
  });
  final String userName;
  final String country;
  final String? referralCode;
  @override
  List<Object?> get props => [userName, country, referralCode];
}

class UserNameNotAvailable extends AccountSetupState {}

class UserNameAvailable extends AccountSetupState {
  const UserNameAvailable({
    required this.isAvailable,
    required this.userName,
    required this.country,
    this.referralCode,
  });
  final bool isAvailable;
  final String userName;
  final String country;
  final String? referralCode;

  @override
  List<Object?> get props => [isAvailable, userName, country, referralCode];
}

class UserNameCheckError extends AccountSetupState {
  const UserNameCheckError({
    required this.error,
    required this.userName,
    required this.country,
    this.referralCode,
  });
  final String error;
  final String userName;
  final String country;
  final String? referralCode;
  @override
  List<Object?> get props => [error, userName, country, referralCode];
}

class AccountSetupSucess extends AccountSetupState {
  final String userName;
  final String phoneNumber;
  final String country;
  final String prefferedImage;
  final String passPhrase;
  final SmartWallet? smartWallet;

  const AccountSetupSucess({
    required this.userName,
    required this.phoneNumber,
    required this.country,
    required this.prefferedImage,
    required this.passPhrase,
    this.smartWallet,
  });

  AccountSetupSucess copyWith({
    String? userName,
    String? phoneNumber,
    String? country,
    String? prefferedImage,
    String? passPhrase,
    SmartWallet? smartWallet,
  }) {
    return AccountSetupSucess(
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      prefferedImage: prefferedImage ?? this.prefferedImage,
      passPhrase: passPhrase ?? this.passPhrase,
      smartWallet: smartWallet ?? this.smartWallet,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    phoneNumber,
    country,
    prefferedImage,
    passPhrase,
    smartWallet,
  ];
}

class AccountSetupError extends AccountSetupState {
  final String error;

  const AccountSetupError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserInfoObject {
  UserInfoObject({
    required this.userName,
    required this.country,
    this.referralCode,
    this.authProvider,
    this.isComplete = false,
  });
  final String userName;
  final String country;
  final String? referralCode;
  final AuthProvider? authProvider;
  final bool isComplete;
}

class SelectAvatarObject {
  SelectAvatarObject({
    required this.prefferedImage,
    this.passPhrase,
    this.isSelectAvatarComplete = false,
  });
  final String prefferedImage;
  final String? passPhrase;
  final bool isSelectAvatarComplete;
}
