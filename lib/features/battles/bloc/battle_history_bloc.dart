import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/battles/models/battle_detail_model.dart';
import 'package:learnwayv2/features/battles/models/battle_history_model.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';

part 'battle_history_event.dart';
part 'battle_history_state.dart';

class BattleHistoryBloc extends Bloc<BattleHistoryEvent, BattleHistoryState> {
  final BattleRepository _repository;

  BattleHistoryBloc(this._repository) : super(BattleHistoryInitial()) {
    on<LoadBattleHistoryEvent>(_onLoadHistory);
    on<LoadBattleDetailEvent>(_onLoadDetail);
  }

  Future<void> _onLoadHistory(
    LoadBattleHistoryEvent event,
    Emitter<BattleHistoryState> emit,
  ) async {
    emit(BattleHistoryLoading());
    final result = await _repository.getBattleHistory(
      page: event.page,
      limit: event.limit,
    );
    result.fold(
      (failure) {
        log('LoadBattleHistory error: ${failure.message}');
        emit(BattleHistoryError(failure.message));
      },
      (response) => emit(BattleHistoryLoaded(response)),
    );
  }

  Future<void> _onLoadDetail(
    LoadBattleDetailEvent event,
    Emitter<BattleHistoryState> emit,
  ) async {
    emit(BattleDetailLoading());
    final result = await _repository.getBattleHistoryDetail(event.battleId);
    result.fold(
      (failure) {
        log('LoadBattleDetail error: ${failure.message}');
        emit(BattleDetailError(failure.message));
      },
      (battle) => emit(BattleDetailLoaded(battle)),
    );
  }
}
