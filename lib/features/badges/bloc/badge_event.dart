import 'package:equatable/equatable.dart';

abstract class BadgeEvent extends Equatable {
  const BadgeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserBadges extends BadgeEvent {
  final String userId;

  const LoadUserBadges(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshBadges extends BadgeEvent {
  final String userId;

  const RefreshBadges(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearCache extends BadgeEvent {
  final String? userId;

  const ClearCache({this.userId});

  @override
  List<Object?> get props => [userId];
}
