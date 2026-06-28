import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/battles/models/bot_battle_response.dart';
import 'package:learnwayv2/features/battles/models/battle_model.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/models/join_room_response.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:learnwayv2/features/battles/view/shared/enums/battle_quiz_enums.dart';

part 'battles_event.dart';
part 'battles_state.dart';

class BattlesBloc extends Bloc<BattlesEvent, BattlesState> {
  final BattleRepository _repository;

  BattlesBloc(this._repository) : super(BattlesInitial()) {
    on<LoadBattleTopicsEvent>(_onLoadTopics);
    on<CreateBattleRoomEvent>(_onCreateRoom);
    on<StartBattleEvent>(_onStartBattle);
    on<JoinBattleRoomEvent>(_onJoinRoom);
    on<StartBotBattleEvent>(_onStartBotBattle);
  }

  Future<void> _onLoadTopics(
    LoadBattleTopicsEvent event,
    Emitter<BattlesState> emit,
  ) async {
    emit(BattleTopicsLoading());
    final result = await _repository.getAllQuizBattleTopics();
    result.fold(
      (failure) {
        log('LoadBattleTopics error: ${failure.message}');
        emit(BattleTopicsError(failure.message));
      },
      (topics) => emit(BattleTopicsLoaded(topics)),
    );
  }

  Future<void> _onStartBattle(
    StartBattleEvent event,
    Emitter<BattlesState> emit,
  ) async {
    emit(BattleStarting());
    final result = await _repository.startBattle(event.battleId);
    result.fold(
      (failure) {
        log('StartBattle error: ${failure.message}');
        emit(BattleStartError(failure.message));
      },
      (_) => emit(BattleStarted()),
    );
  }

  Future<void> _onJoinRoom(
    JoinBattleRoomEvent event,
    Emitter<BattlesState> emit,
  ) async {
    emit(BattleRoomJoining());
    final result = await _repository.joinRoom(event.roomCode);
    result.fold(
      (failure) {
        log('JoinBattleRoom error: ${failure.message}');
        emit(BattleRoomJoinError(failure.message));
      },
      (battle) => emit(BattleRoomJoined(battle)),
    );
  }

  Future<void> _onStartBotBattle(
    StartBotBattleEvent event,
    Emitter<BattlesState> emit,
  ) async {
    emit(BotBattleStarting());
    final result = await _repository.startBotBattle(event.topicId);
    result.fold(
      (failure) {
        log('StartBotBattle error: ${failure.message}');
        emit(BotBattleStartError(failure.message));
      },
      (response) => emit(BotBattleStarted(response)),
    );
  }

  Future<void> _onCreateRoom(
    CreateBattleRoomEvent event,
    Emitter<BattlesState> emit,
  ) async {
    final currentTopics = switch (state) {
      BattleTopicsLoaded(:final topics) => topics,
      BattleRoomCreateError(:final topics) => topics,
      _ => <BattleTopic>[],
    };

    emit(BattleRoomCreating(currentTopics));

    final result = await _repository.createFriendOrGroup(
      event.type,
      event.topicId,
      event.stakeAmount,
    );

    result.fold(
      (failure) {
        log('CreateBattleRoom error: ${failure.message}');
        emit(BattleRoomCreateError(message: failure.message, topics: currentTopics));
      },
      (battle) => emit(BattleRoomCreated(battle: battle, topics: currentTopics)),
    );
  }
}
