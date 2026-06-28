import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/exception/battle_exceptions.dart';
import 'package:learnwayv2/features/battles/models/battle_topics_response.dart';
import 'package:learnwayv2/features/battles/models/bot_battle_response.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:mockito/mockito.dart';

class _MockBattleRepository extends Mock implements BattleRepository {
  @override
  Future<Either<BattleExceptions, BotBattleResponse>> startBotBattle(
    String topicId,
  ) =>
      super.noSuchMethod(
        Invocation.method(#startBotBattle, [topicId]),
        returnValue: Future.value(
          Left<BattleExceptions, BotBattleResponse>(BattleExceptions.unknown()),
        ),
        returnValueForMissingStub: Future.value(
          Left<BattleExceptions, BotBattleResponse>(BattleExceptions.unknown()),
        ),
      );

  @override
  Future<Either<BattleExceptions, List<BattleTopic>>> getAllQuizBattleTopics() =>
      super.noSuchMethod(
        Invocation.method(#getAllQuizBattleTopics, []),
        returnValue: Future.value(Right<BattleExceptions, List<BattleTopic>>([])),
        returnValueForMissingStub:
            Future.value(Right<BattleExceptions, List<BattleTopic>>([])),
      );
}

void main() {
  group('BotBattleResponse', () {
    const sampleJson = {
      'battleId': 'c74cec39-d3d4-4aa1-b518-1d1ff6890332',
      'roomCode': null,
      'status': 'IN_PROGRESS',
      'stakeAmount': 15,
      'prizePool': 27,
      'adminFeeGems': 3,
      'botName': 'Lenny',
    };

    test('fromJson deserializes correctly', () {
      final response = BotBattleResponse.fromJson(sampleJson);

      expect(response.battleId, 'c74cec39-d3d4-4aa1-b518-1d1ff6890332');
      expect(response.roomCode, isNull);
      expect(response.status, 'IN_PROGRESS');
      expect(response.stakeAmount, 15);
      expect(response.prizePool, 27);
      expect(response.adminFeeGems, 3);
      expect(response.botName, 'Lenny');
    });

    test('toJson round-trips correctly', () {
      final original = BotBattleResponse.fromJson(sampleJson);
      final json = original.toJson();

      expect(json['battleId'], original.battleId);
      expect(json['roomCode'], isNull);
      expect(json['status'], original.status);
      expect(json['stakeAmount'], original.stakeAmount);
      expect(json['prizePool'], original.prizePool);
      expect(json['adminFeeGems'], original.adminFeeGems);
      expect(json['botName'], original.botName);
    });

    test('fromJson handles non-null roomCode', () {
      final json = {...sampleJson, 'roomCode': 'ROOM123'};
      final response = BotBattleResponse.fromJson(json);
      expect(response.roomCode, 'ROOM123');
    });
  });

  group('BattlesBloc — StartBotBattleEvent', () {
    late _MockBattleRepository mockRepository;
    late BattlesBloc bloc;

    const testTopicId = '7a585920-dc71-4857-9451-7161b1536e31';
    const testResponse = BotBattleResponse(
      battleId: 'c74cec39-d3d4-4aa1-b518-1d1ff6890332',
      roomCode: null,
      status: 'IN_PROGRESS',
      stakeAmount: 15,
      prizePool: 27,
      adminFeeGems: 3,
      botName: 'Lenny',
    );

    setUp(() {
      mockRepository = _MockBattleRepository();
      bloc = BattlesBloc(mockRepository);
    });

    tearDown(() => bloc.close());

    test('emits [BotBattleStarting, BotBattleStarted] on success', () async {
      when(
        mockRepository.startBotBattle(testTopicId),
      ).thenAnswer((_) async => const Right(testResponse));

      bloc.add(const StartBotBattleEvent(topicId: testTopicId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BotBattleStarting>(),
          isA<BotBattleStarted>().having(
            (s) => s.response.battleId,
            'battleId',
            testResponse.battleId,
          ),
        ]),
      );
    });

    test('emits [BotBattleStarting, BotBattleStartError] on failure', () async {
      when(
        mockRepository.startBotBattle(testTopicId),
      ).thenAnswer(
        (_) async => Left(BattleExceptions('Insufficient gems')),
      );

      bloc.add(const StartBotBattleEvent(topicId: testTopicId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BotBattleStarting>(),
          isA<BotBattleStartError>().having(
            (s) => s.message,
            'message',
            'Insufficient gems',
          ),
        ]),
      );
    });

    test('emits BotBattleStartError with network error on network failure', () async {
      when(
        mockRepository.startBotBattle(testTopicId),
      ).thenAnswer(
        (_) async => Left(BattleExceptions.network()),
      );

      bloc.add(const StartBotBattleEvent(topicId: testTopicId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BotBattleStarting>(),
          isA<BotBattleStartError>().having(
            (s) => s.message,
            'message',
            contains('Network'),
          ),
        ]),
      );
    });
  });
}
