import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/battles/exception/battle_exceptions.dart';
import 'package:learnwayv2/features/battles/models/battle_config_model.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/models/battle_model.dart';
import 'package:learnwayv2/features/battles/models/battle_detail_model.dart';
import 'package:learnwayv2/features/battles/models/battle_history_model.dart';
import 'package:learnwayv2/features/battles/models/bot_battle_response.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/models/join_room_response.dart';
import 'package:learnwayv2/features/battles/view/shared/enums/battle_quiz_enums.dart';

class BattleDataSource {
  final client = locator<BaseApiClients>();

  Future<BattleModel> createFriendOrGroup(
    RoomType type,
    String topicId,
    String stakeAmount,
  ) async {
    try {
      final response = await client.post(
        Endpoints.createFriendOrGroupRoom,
        body: {
          'type': type == RoomType.friend ? 'FRIEND' : 'GROUP',
          'topicId': topicId,
          'stakeAmount': stakeAmount,
        },
      );

      log('createFriendOrGroup(): ${response.body}');

      if (response.statusCode == 400) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return BattleModel.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('createFriendOrGroup() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<void> startBattle(String battleId) async {
    try {
      final response = await client.post(
        Endpoints.startBattle(battleId),
        body: {},
      );

      log('startBattle(): ${response.body}');

      if (response.statusCode == 400) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('startBattle() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<void> deleteBattle(String battleId) async {
    try {
      final response = await client.delete(Endpoints.deleteBattle(battleId));

      log('deleteBattle(): ${response.body}');

      if (response.statusCode == 400 || response.statusCode == 403) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('deleteBattle() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<JoinRoomResponse> joinRoom(String roomCode) async {
    try {
      final response = await client.post(
        Endpoints.joinRoom(roomCode),
        body: {},
      );

      log('joinRoom(): ${response.body}');

      if (response.statusCode == 400 || response.statusCode == 404) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return JoinRoomResponse.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('joinRoom() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<BattleHistoryResponse> getBattleHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await client.get(
        '${Endpoints.battleHistory}?page=$page&limit=$limit',
      );

      log('getBattleHistory(): ${response.body}');

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return BattleHistoryResponse.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('getBattleHistory() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<BattleDetailModel> getBattleHistoryDetail(String battleId) async {
    try {
      final response = await client.get(Endpoints.getBattleDetail(battleId));

      log('getBattleDetail(): ${response.body}');

      if (response.statusCode == 403) {
        throw BattleExceptions('You are not a participant in this battle');
      }

      if (response.statusCode == 404) {
        throw BattleExceptions('Battle not found');
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return BattleDetailModel.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('getBattleHistoryDetail() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<List<PrefetchedBattleQuestion>> prefetchBattleQuestions(
    String battleId,
  ) async {
    try {
      final response = await client.get(
        Endpoints.prefetchBattleQuestions(battleId),
      );

      log('prefetchBattleQuestions(): ${response.body}');

      if (response.statusCode == 400) {
        throw BattleExceptions('Battle has not started yet');
      }

      if (response.statusCode == 403) {
        throw BattleExceptions('You are not a participant in this battle');
      }

      if (response.statusCode == 404) {
        throw BattleExceptions('Battle not found');
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body) as List;
      return decoded.map((e) => PrefetchedBattleQuestion.fromJson(e)).toList();
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('prefetchBattleQuestions() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<BotBattleResponse> startBotBattle(String topicId) async {
    try {
      final response = await client.post(
        Endpoints.startBotBattle,
        body: {'topicId': topicId},
      );

      log('startBotBattle(): ${response.body}');

      if (response.statusCode == 400) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return BotBattleResponse.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('startBotBattle() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<BattleConfigModel> getBattleConfig() async {
    try {
      final response = await client.get(Endpoints.battleConfig);

      log('getBattleConfig(): ${response.body}');

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body);
      return BattleConfigModel.fromJson(decoded);
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('getBattleConfig() error: $e');
      throw BattleExceptions.unknown();
    }
  }

  Future<List<BattleTopic>> getAllQuizBattleTopics() async {
    try {
      final response = await client.get(Endpoints.fetchAllTopics);

      log('getAllQuizBattleTopics(): ${response.body}');

      if (response.statusCode >= 500) {
        throw BattleExceptions.server();
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BattleExceptions(jsonDecode(response.body)['message']);
      }

      final decoded = jsonDecode(response.body) as List;
      return decoded.map((e) => BattleTopic.fromJson(e)).toList();
    } on SocketException {
      throw BattleExceptions.network();
    } on HttpException {
      throw BattleExceptions.network();
    } on NetworkException {
      throw BattleExceptions.network();
    } on BattleExceptions {
      rethrow;
    } catch (e) {
      log('getAllQuizBattleTopics() error: $e');
      throw BattleExceptions.unknown();
    }
  }
}
