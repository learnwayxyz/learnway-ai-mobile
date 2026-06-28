import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:learnwayv2/features/battles/data/battle_data_source.dart';
import 'package:learnwayv2/features/battles/exception/battle_exceptions.dart';
import 'package:learnwayv2/features/battles/models/battle_detail_model.dart';
import 'package:learnwayv2/features/battles/models/battle_config_model.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/models/battle_history_model.dart';
import 'package:learnwayv2/features/battles/models/battle_model.dart';
import 'package:learnwayv2/features/battles/models/bot_battle_response.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/models/join_room_response.dart';
import 'package:learnwayv2/features/battles/view/shared/enums/battle_quiz_enums.dart';

class BattleRepository {
  final BattleDataSource _dataSource;

  BattleRepository(this._dataSource);

  Future<Either<BattleExceptions, BattleModel>> createFriendOrGroup(
    RoomType type,
    String topicId,
    String stakeAmount,
  ) async {
    try {
      final result = await _dataSource.createFriendOrGroup(
        type,
        topicId,
        stakeAmount,
      );
      return Right(result);
    } on BattleExceptions catch (e) {
      log('createFriendOrGroup error: $e');
      return Left(e);
    } catch (e) {
      log('createFriendOrGroup unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, void>> deleteBattle(String battleId) async {
    try {
      await _dataSource.deleteBattle(battleId);
      return const Right(null);
    } on BattleExceptions catch (e) {
      log('deleteBattle error: $e');
      return Left(e);
    } catch (e) {
      log('deleteBattle unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, void>> startBattle(String battleId) async {
    try {
      await _dataSource.startBattle(battleId);
      return const Right(null);
    } on BattleExceptions catch (e) {
      log('startBattle error: $e');
      return Left(e);
    } catch (e) {
      log('startBattle unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, JoinRoomResponse>> joinRoom(
    String roomCode,
  ) async {
    try {
      final result = await _dataSource.joinRoom(roomCode);
      return Right(result);
    } on BattleExceptions catch (e) {
      log('joinRoom error: $e');
      return Left(e);
    } catch (e) {
      log('joinRoom unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, BattleHistoryResponse>> getBattleHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _dataSource.getBattleHistory(
        page: page,
        limit: limit,
      );
      return Right(result);
    } on BattleExceptions catch (e) {
      log('getBattleHistory error: $e');
      return Left(e);
    } catch (e) {
      log('getBattleHistory unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, BattleDetailModel>> getBattleHistoryDetail(
    String battleId,
  ) async {
    try {
      final result = await _dataSource.getBattleHistoryDetail(battleId);
      return Right(result);
    } on BattleExceptions catch (e) {
      log('getBattleHistoryDetail error: $e');
      return Left(e);
    } catch (e) {
      log('getBattleHistoryDetail unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, List<PrefetchedBattleQuestion>>>
  prefetchBattleQuestions(String battleId) async {
    try {
      final result = await _dataSource.prefetchBattleQuestions(battleId);
      return Right(result);
    } on BattleExceptions catch (e) {
      log('prefetchBattleQuestions error: $e');
      return Left(e);
    } catch (e) {
      log('prefetchBattleQuestions unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, BotBattleResponse>> startBotBattle(
    String topicId,
  ) async {
    try {
      final result = await _dataSource.startBotBattle(topicId);
      return Right(result);
    } on BattleExceptions catch (e) {
      log('startBotBattle error: $e');
      return Left(e);
    } catch (e) {
      log('startBotBattle unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, BattleConfigModel>> getBattleConfig() async {
    try {
      final result = await _dataSource.getBattleConfig();
      return Right(result);
    } on BattleExceptions catch (e) {
      log('getBattleConfig error: $e');
      return Left(e);
    } catch (e) {
      log('getBattleConfig unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }

  Future<Either<BattleExceptions, List<BattleTopic>>>
  getAllQuizBattleTopics() async {
    try {
      final result = await _dataSource.getAllQuizBattleTopics();
      return Right(result);
    } on BattleExceptions catch (e) {
      log('getAllQuizBattleTopics error: $e');
      return Left(e);
    } catch (e) {
      log('getAllQuizBattleTopics unexpected error: $e');
      return Left(BattleExceptions.unknown());
    }
  }
}
