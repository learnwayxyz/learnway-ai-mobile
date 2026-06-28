import 'dart:async';
import 'dart:developer';

import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/services/websocket/websocket_service.dart';
import 'package:sentry/sentry.dart';

class BotBattleEventService {
  final WebsocketService _ws;

  BotBattleEventService(this._ws);

  List<BattleRoomParticipant> participants = [];
  BattleQuestionEvent? pendingQuestion;
  String _battleId = '';
  String get battleId => _battleId;

  final _roomUpdated = StreamController<BattleRoomEvent>.broadcast();
  final _countdown = StreamController<BattleCountdownEvent>.broadcast();
  final _questionStart = StreamController<BattleQuestionEvent>.broadcast();
  final _questionTimeout =
      StreamController<BattleQuestionTimeoutEvent>.broadcast();
  final _scoresUpdate = StreamController<BattleScoresUpdateEvent>.broadcast();
  final _answerAck = StreamController<BattleAnswerAckEvent>.broadcast();
  final _battleComplete = StreamController<BattleCompleteEvent>.broadcast();

  Stream<BattleRoomEvent> get onRoomUpdated => _roomUpdated.stream;

  Stream<BattleCountdownEvent> get onCountdown => _countdown.stream;

  Stream<BattleQuestionEvent> get onQuestionStart => _questionStart.stream;

  Stream<BattleQuestionTimeoutEvent> get onQuestionTimeout =>
      _questionTimeout.stream;

  Stream<BattleScoresUpdateEvent> get onScoresUpdate => _scoresUpdate.stream;

  Stream<BattleAnswerAckEvent> get onAnswerAck => _answerAck.stream;

  Stream<BattleCompleteEvent> get onBattleComplete => _battleComplete.stream;

  void _resetState() {
    participants = [];
    pendingQuestion = null;
    _battleId = '';
  }

  Future<void> connect(String battleId) async {
    _resetState();
    _battleId = battleId;
    final token = await SharedPreferencesStore.getUserToken(userTokenKey);

    Sentry.addBreadcrumb(
      Breadcrumb(
        message: '[BotBattle] Connecting to battle',
        category: 'bot_battle.websocket',
        level: SentryLevel.info,
        data: {'battleId': battleId, 'url': '${Env.webSocketUrl}/quiz-battle'},
      ),
    );

    _ws.setOnConnectCallback(() {
      log('[BotBattleEventService] Connected — joining battle: $battleId');
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] WS connected — emitting battle:join',
          category: 'bot_battle.websocket',
          level: SentryLevel.info,
          data: {'battleId': battleId},
        ),
      );
      _ws.emit('battle:join', {'battleId': battleId});
    });

    _registerEventListeners();
    log('[BotBattleEventService] socket url: ${Env.webSocketUrl}/quiz-battle');
    _ws.connect('${Env.webSocketUrl}/quiz-battle', authToken: token);
  }

  void submitAnswer(int questionIndex, String optionId) {
    _ws.emit('battle:answer', {
      'battleId': _battleId,
      'questionIndex': questionIndex,
      'optionId': optionId,
    });
  }

  void leaveBattle() {
    _ws.emit('battle:leave', {'battleId': _battleId});
  }

  void disconnect() {
    _resetState();
    _ws.off('battle:room:updated');
    _ws.off('battle:countdown');
    _ws.off('battle:question:start');
    _ws.off('battle:question:timeout');
    _ws.off('battle:scores:update');
    _ws.off('battle:answer:ack');
    _ws.off('battle:complete');
    _ws.disconnect();
  }

  void dispose() {
    disconnect();
    _roomUpdated.close();
    _countdown.close();
    _questionStart.close();
    _questionTimeout.close();
    _scoresUpdate.close();
    _answerAck.close();
    _battleComplete.close();
  }

  void _registerEventListeners() {
    _ws.onEvent('battle:room:updated', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:room:updated',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleRoomEvent>(
        data,
        'battle:room:updated',
        BattleRoomEvent.fromJson,
        _roomUpdated,
        onParsed: (event) => participants = event.participants,
      );
    });

    _ws.onEvent('battle:countdown', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:countdown',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleCountdownEvent>(
        data,
        'battle:countdown',
        BattleCountdownEvent.fromJson,
        _countdown,
      );
    });

    _ws.onEvent('battle:question:start', (data) {
      log('[BotBattleEventService] battle:question:start: $data');
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:question:start',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleQuestionEvent>(
        data,
        'battle:question:start',
        BattleQuestionEvent.fromJson,
        _questionStart,
        onParsed: (event) {
          pendingQuestion = event;
          Sentry.addBreadcrumb(
            Breadcrumb(
              message:
                  '[BotBattle] Question parsed: index=${event.questionIndex} timeLimit=${event.timeLimit}s',
              category: 'bot_battle.question',
              level: SentryLevel.info,
              data: {
                'battleId': _battleId,
                'questionIndex': event.questionIndex,
                'questionId': event.questionId,
                'timeLimit': event.timeLimit,
              },
            ),
          );
        },
      );
    });

    _ws.onEvent('battle:question:timeout', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:question:timeout',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleQuestionTimeoutEvent>(
        data,
        'battle:question:timeout',
        BattleQuestionTimeoutEvent.fromJson,
        _questionTimeout,
      );
    });

    _ws.onEvent('battle:scores:update', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:scores:update',
          category: 'bot_battle.event',
          level: SentryLevel.debug,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleScoresUpdateEvent>(
        data,
        'battle:scores:update',
        BattleScoresUpdateEvent.fromJson,
        _scoresUpdate,
      );
    });

    _ws.onEvent('battle:answer:ack', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:answer:ack',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleAnswerAckEvent>(
        data,
        'battle:answer:ack',
        BattleAnswerAckEvent.fromJson,
        _answerAck,
      );
    });

    _ws.onEvent('battle:complete', (data) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BotBattle] Event: battle:complete',
          category: 'bot_battle.event',
          level: SentryLevel.info,
          data: {'battleId': _battleId, 'raw': data?.toString()},
        ),
      );
      _parse<BattleCompleteEvent>(
        data,
        'battle:complete',
        BattleCompleteEvent.fromJson,
        _battleComplete,
      );
    });
  }

  void _parse<T>(
    dynamic data,
    String eventName,
    T Function(Map<String, dynamic>) fromJson,
    StreamController<T> controller, {
    void Function(T)? onParsed,
  }) {
    try {
      final json = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data as Map);
      final event = fromJson(json);
      onParsed?.call(event);
      controller.add(event);
    } catch (e, stackTrace) {
      log('[BotBattleEventService] Parse error for $eventName: $e');
      Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'source': 'BotBattleEventService._parse',
          'event': eventName,
          'battleId': _battleId,
          'rawData': data?.toString() ?? 'null',
        }),
      );
    }
  }
}
