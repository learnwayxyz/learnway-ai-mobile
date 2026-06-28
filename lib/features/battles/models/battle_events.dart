import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';

class BattleStartedEvent {
  final String battleId;

  const BattleStartedEvent({required this.battleId});

  factory BattleStartedEvent.fromJson(Map<String, dynamic> json) {
    return BattleStartedEvent(battleId: json['battleId'] as String);
  }
}

class PrefetchedBattleQuestion {
  final int questionIndex;
  final String questionId;
  final String question;
  final List<BattleQuestionOption> options;

  const PrefetchedBattleQuestion({
    required this.questionIndex,
    required this.questionId,
    required this.question,
    required this.options,
  });

  factory PrefetchedBattleQuestion.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List<dynamic>? ?? [];
    return PrefetchedBattleQuestion(
      questionIndex: json['questionIndex'] as int,
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      options: optionsList
          .map((o) => BattleQuestionOption.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BattleRoomEvent {
  final String battleId;
  final List<BattleRoomParticipant> participants;

  const BattleRoomEvent({required this.battleId, required this.participants});

  factory BattleRoomEvent.fromJson(Map<String, dynamic> json) {
    final list = json['participants'] as List<dynamic>? ?? [];
    return BattleRoomEvent(
      battleId: json['battleId'] as String,
      participants: list
          .map((p) => BattleRoomParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BattleQuestionOption {
  final String id;
  final String text;

  const BattleQuestionOption({required this.id, required this.text});

  factory BattleQuestionOption.fromJson(Map<String, dynamic> json) {
    return BattleQuestionOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }
}

class BattleQuestionEvent {
  final int questionIndex;
  final String questionId;
  final String question;
  final List<BattleQuestionOption> options;
  final int timeLimit;

  const BattleQuestionEvent({
    required this.questionIndex,
    required this.questionId,
    required this.question,
    required this.options,
    required this.timeLimit,
  });

  factory BattleQuestionEvent.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List<dynamic>? ?? [];
    return BattleQuestionEvent(
      questionIndex: json['questionIndex'] as int,
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      options: optionsList
          .map(
            (o) => BattleQuestionOption.fromJson(o as Map<String, dynamic>),
          )
          .toList(),
      timeLimit: json['timeLimit'] as int,
    );
  }
}

class BattleQuestionTimeoutEvent {
  final int questionIndex;

  const BattleQuestionTimeoutEvent({required this.questionIndex});

  factory BattleQuestionTimeoutEvent.fromJson(Map<String, dynamic> json) {
    return BattleQuestionTimeoutEvent(
      questionIndex: json['questionIndex'] as int,
    );
  }
}

class BattleScoreParticipant {
  final String userId;
  final bool isBot;
  final int score;
  final int xpEarned;

  const BattleScoreParticipant({
    required this.userId,
    required this.isBot,
    required this.score,
    required this.xpEarned,
  });

  factory BattleScoreParticipant.fromJson(Map<String, dynamic> json) {
    return BattleScoreParticipant(
      userId: json['userId'] as String? ?? '',
      isBot: json['isBot'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      xpEarned: json['xpEarned'] as int? ?? 0,
    );
  }
}

class BattleCountdownEvent {
  final int count;

  const BattleCountdownEvent({required this.count});

  factory BattleCountdownEvent.fromJson(Map<String, dynamic> json) {
    return BattleCountdownEvent(count: json['count'] as int);
  }
}

class BattleScoresUpdateEvent {
  final List<BattleScoreParticipant> participants;

  const BattleScoresUpdateEvent({required this.participants});

  factory BattleScoresUpdateEvent.fromJson(Map<String, dynamic> json) {
    final list = json['participants'] as List<dynamic>? ?? [];
    return BattleScoresUpdateEvent(
      participants: list
          .map(
            (p) =>
                BattleScoreParticipant.fromJson(p as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class BattleCompleteParticipant {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final bool isBot;
  final int score;
  final int xpEarned;
  final int gemsWon;
  final int? position;
  final bool forfeited;

  const BattleCompleteParticipant({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    required this.isBot,
    required this.score,
    required this.xpEarned,
    required this.gemsWon,
    required this.position,
    required this.forfeited,
  });

  factory BattleCompleteParticipant.fromJson(Map<String, dynamic> json) {
    return BattleCompleteParticipant(
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      isBot: json['isBot'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      xpEarned: json['xpEarned'] as int? ?? 0,
      gemsWon: json['gemsWon'] as int? ?? 0,
      position: json['position'] as int?,
      forfeited: json['forfeited'] as bool? ?? false,
    );
  }
}

class BattleCompleteEvent {
  final String battleId;
  final bool isTie;
  final bool isGroupTie;
  final String? winnerId;
  final int prizePool;
  final List<BattleCompleteParticipant> participants;

  const BattleCompleteEvent({
    required this.battleId,
    required this.isTie,
    required this.isGroupTie,
    required this.winnerId,
    required this.prizePool,
    required this.participants,
  });

  factory BattleCompleteEvent.fromJson(Map<String, dynamic> json) {
    final list = json['participants'] as List<dynamic>? ?? [];
    return BattleCompleteEvent(
      battleId: json['battleId'] as String,
      isTie: json['isTie'] as bool? ?? false,
      isGroupTie: json['isGroupTie'] as bool? ?? false,
      winnerId: json['winnerId'] as String?,
      prizePool: json['prizePool'] as int? ?? 0,
      participants: list
          .map((p) => BattleCompleteParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BattleAnswerAckEvent {
  final int questionIndex;
  final bool isCorrect;
  final String correctOptionId;
  final int xpDelta;

  const BattleAnswerAckEvent({
    required this.questionIndex,
    required this.isCorrect,
    required this.correctOptionId,
    required this.xpDelta,
  });

  factory BattleAnswerAckEvent.fromJson(Map<String, dynamic> json) {
    return BattleAnswerAckEvent(
      questionIndex: json['questionIndex'] as int,
      isCorrect: json['isCorrect'] as bool,
      correctOptionId: json['correctOptionId'] as String,
      xpDelta: json['xpDelta'] as int? ?? 0,
    );
  }
}
