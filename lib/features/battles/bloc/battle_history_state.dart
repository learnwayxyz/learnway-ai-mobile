part of 'battle_history_bloc.dart';

sealed class BattleHistoryState extends Equatable {
  const BattleHistoryState();

  @override
  List<Object?> get props => [];
}

final class BattleHistoryInitial extends BattleHistoryState {}

final class BattleHistoryLoading extends BattleHistoryState {}

final class BattleHistoryLoaded extends BattleHistoryState {
  const BattleHistoryLoaded(this.response);
  final BattleHistoryResponse response;

  @override
  List<Object?> get props => [response];
}

final class BattleHistoryError extends BattleHistoryState {
  const BattleHistoryError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BattleDetailLoading extends BattleHistoryState {}

final class BattleDetailLoaded extends BattleHistoryState {
  const BattleDetailLoaded(this.battle);
  final BattleDetailModel battle;

  @override
  List<Object?> get props => [battle];
}

final class BattleDetailError extends BattleHistoryState {
  const BattleDetailError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
