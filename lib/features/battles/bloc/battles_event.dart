part of 'battles_bloc.dart';

sealed class BattlesEvent extends Equatable {
  const BattlesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBattleTopicsEvent extends BattlesEvent {
  const LoadBattleTopicsEvent();
}

final class CreateBattleRoomEvent extends BattlesEvent {
  const CreateBattleRoomEvent({
    required this.type,
    required this.topicId,
    required this.stakeAmount,
  });

  final RoomType type;
  final String topicId;
  final String stakeAmount;

  @override
  List<Object?> get props => [type, topicId, stakeAmount];
}

final class StartBattleEvent extends BattlesEvent {
  const StartBattleEvent({required this.battleId});

  final String battleId;

  @override
  List<Object?> get props => [battleId];
}

final class JoinBattleRoomEvent extends BattlesEvent {
  const JoinBattleRoomEvent({required this.roomCode});

  final String roomCode;

  @override
  List<Object?> get props => [roomCode];
}

final class StartBotBattleEvent extends BattlesEvent {
  const StartBotBattleEvent({required this.topicId});

  final String topicId;

  @override
  List<Object?> get props => [topicId];
}
