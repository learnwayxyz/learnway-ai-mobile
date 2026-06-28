import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:variance_dart/variance_dart.dart';

abstract class HomeState extends Equatable {
  const HomeState({this.userProfile});

  final UserProfileModel? userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class FetchHomeDataInitial extends HomeState {
  const FetchHomeDataInitial({super.userProfile});
}

class FetchingHomeData extends HomeState {
  const FetchingHomeData({super.userProfile});
}

class FetchHomeDataSuccess extends HomeState {
  const FetchHomeDataSuccess({required UserProfileModel userProfile})
    : super(userProfile: userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class FetchingHomeDataError extends HomeState {
  const FetchingHomeDataError(this.message, {super.userProfile});
  final String message;

  @override
  List<Object?> get props => [message, userProfile];
}

class RecoveringInBackground extends HomeState {
  const RecoveringInBackground({super.userProfile});
}

class RecoverySuccess extends HomeState {
  const RecoverySuccess(this.smartWallet, {super.userProfile});
  final SmartWallet smartWallet;
  @override
  List<Object?> get props => [smartWallet, userProfile];
}

class RecoveryError extends HomeState {
  const RecoveryError(this.message, {super.userProfile});
  final String message;

  @override
  List<Object?> get props => [message, userProfile];
}

class FetchingUserBlobPhrase extends HomeState {
  const FetchingUserBlobPhrase({super.userProfile});
}

class FetchingUserBlobPhraseSuccess extends HomeState {
  const FetchingUserBlobPhraseSuccess({
    required this.walletSeedPhrase,
    super.userProfile,
  });
  final String walletSeedPhrase;

  @override
  List<Object?> get props => [walletSeedPhrase, userProfile];
}

class FetchingUserBlobPhraseError extends HomeState {
  const FetchingUserBlobPhraseError(this.message, {super.userProfile});
  final String message;

  @override
  List<Object?> get props => [message, userProfile];
}
