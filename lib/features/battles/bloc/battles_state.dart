part of 'battles_bloc.dart';

sealed class BattlesState extends Equatable {
  const BattlesState();

  @override
  List<Object?> get props => [];
}

final class BattlesInitial extends BattlesState {}

final class BattleTopicsLoading extends BattlesState {}

final class BattleTopicsLoaded extends BattlesState {
  const BattleTopicsLoaded(this.topics);
  final List<BattleTopic> topics;

  @override
  List<Object?> get props => [topics];
}

final class BattleTopicsError extends BattlesState {
  const BattleTopicsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BattleRoomCreating extends BattlesState {
  const BattleRoomCreating(this.topics);
  final List<BattleTopic> topics;

  @override
  List<Object?> get props => [topics];
}

final class BattleRoomCreated extends BattlesState {
  const BattleRoomCreated({required this.battle, required this.topics});
  final BattleModel battle;
  final List<BattleTopic> topics;

  @override
  List<Object?> get props => [battle, topics];
}

final class BattleRoomCreateError extends BattlesState {
  const BattleRoomCreateError({required this.message, required this.topics});
  final String message;
  final List<BattleTopic> topics;

  @override
  List<Object?> get props => [message, topics];
}

final class BattleStarting extends BattlesState {}

final class BattleStarted extends BattlesState {}

final class BattleStartError extends BattlesState {
  const BattleStartError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BattleRoomJoining extends BattlesState {}

final class BattleRoomJoined extends BattlesState {
  const BattleRoomJoined(this.battle);
  final JoinRoomResponse battle;

  @override
  List<Object?> get props => [battle];
}

final class BattleRoomJoinError extends BattlesState {
  const BattleRoomJoinError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BotBattleStarting extends BattlesState {}

final class BotBattleStarted extends BattlesState {
  const BotBattleStarted(this.response);
  final BotBattleResponse response;

  @override
  List<Object?> get props => [response];
}

final class BotBattleStartError extends BattlesState {
  const BotBattleStartError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
