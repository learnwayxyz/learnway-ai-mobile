import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeDataEvent extends HomeEvent {
  const FetchHomeDataEvent();
}

class RefreshHomeDataEvent extends HomeEvent {}

class AttemptWalletRecoveryEvent extends HomeEvent {
  const AttemptWalletRecoveryEvent(this.args);
  final Map<String, dynamic> args;
}

class FetchUserBlobEvent extends HomeEvent {
  const FetchUserBlobEvent(this.userId);
  final String userId;
}

class UpdateUserProfileEvent extends HomeEvent {
  const UpdateUserProfileEvent(this.userProfile);
  final UserProfileModel userProfile;
}

class ResetHomeBlocEvent extends HomeEvent {
  const ResetHomeBlocEvent();
}
