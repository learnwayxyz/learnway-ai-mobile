part of 'battle_history_bloc.dart';

sealed class BattleHistoryEvent extends Equatable {
  const BattleHistoryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBattleHistoryEvent extends BattleHistoryEvent {
  const LoadBattleHistoryEvent({this.page = 1, this.limit = 20});

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}

final class LoadBattleDetailEvent extends BattleHistoryEvent {
  const LoadBattleDetailEvent({required this.battleId});

  final String battleId;

  @override
  List<Object?> get props => [battleId];
}
