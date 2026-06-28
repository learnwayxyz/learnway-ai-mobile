import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ShareableAvatar {
  const ShareableAvatar({
    this.imageUrl,
    required this.initial,
    this.name,
    this.xpValue,
    this.isAsset = false,
  });
  final String? imageUrl;
  final String initial;
  final String? name;
  final int? xpValue;
  final bool isAsset;
}

abstract class ShareableCardSkin {
  const ShareableCardSkin();
  Color get defaultAvatarColor;
}

abstract class QuizSkin extends ShareableCardSkin {
  const QuizSkin();

  static const blue = _QuizBlueSkin();

  String get backgroundAsset;
}

class _QuizBlueSkin extends QuizSkin {
  const _QuizBlueSkin();

  @override
  String get backgroundAsset => 'assets/images/lesson_card_background.png';

  @override
  Color get defaultAvatarColor => AppColors.gray300;
}

abstract class BattleSkin extends ShareableCardSkin {
  const BattleSkin();

  static const win = _BattleWinSkin();
  static const lose = _BattleLoseSkin();

  String get backgroundAsset;
  Color get headlineColor;
  Color get subtitleColor;
  Color get nameColor;
  Color get avatarBorderColor;
}

class _BattleWinSkin extends BattleSkin {
  const _BattleWinSkin();

  @override
  String get backgroundAsset => 'assets/images/lesson_card_background.png';

  @override
  Color get headlineColor => const Color(0xFFFDFDFD);

  @override
  Color get subtitleColor => const Color(0xFFFDFDFD);

  @override
  Color get nameColor => const Color(0xFFFDFDFD);

  @override
  Color get avatarBorderColor => Colors.white;

  @override
  Color get defaultAvatarColor => AppColors.gray300;
}

class _BattleLoseSkin extends BattleSkin {
  const _BattleLoseSkin();

  @override
  String get backgroundAsset => 'assets/images/battle_lose_doodles.png';

  @override
  Color get headlineColor => const Color(0xFF252B37);

  @override
  Color get subtitleColor => const Color(0xFF252B37);

  @override
  Color get nameColor => const Color(0xFF252B37);

  @override
  Color get avatarBorderColor => const Color(0xFF252B37);

  @override
  Color get defaultAvatarColor => AppColors.gray300;
}

abstract class ShareableCardStrategy {
  List<ShareableAvatar> get avatars;

  String get primaryStatValue;
  String get primaryStatLabel;

  int get xpValue;
  int get gemsValue;

  String get bannerName;

  String get headline;

  String get subtext;
}

class LessonShareStrategy implements ShareableCardStrategy {
  const LessonShareStrategy({
    required this.scorePercentage,
    required this.xpEarned,
    required this.gemsEarned,
    required this.username,
    this.profileImageUrl,
    required this.lessonTitle,
  });

  final int scorePercentage;
  final int xpEarned;
  final int gemsEarned;
  final String username;
  final String? profileImageUrl;
  final String lessonTitle;

  @override
  List<ShareableAvatar> get avatars => [
    ShareableAvatar(
      imageUrl: profileImageUrl,
      initial: username.isNotEmpty ? username[0].toUpperCase() : 'U',
      name: username,
    ),
  ];

  @override
  String get primaryStatValue => '$scorePercentage%';

  @override
  String get primaryStatLabel => 'SCORE';

  @override
  int get xpValue => xpEarned;

  @override
  int get gemsValue => gemsEarned;

  @override
  String get bannerName => username;

  @override
  String get headline => 'Lesson  Completed';

  @override
  String get subtext => '"$lessonTitle"';
}

class BattleShareStrategy implements ShareableCardStrategy {
  const BattleShareStrategy({
    required this.userWon,
    required this.isDraw,
    required this.userScore,
    required this.totalQuestions,
    required this.xpEarned,
    required this.gemsEarned,
    required this.username,
    this.profileImageUrl,
    required this.opponentName,
    required this.opponentXpEarned,
    this.opponentProfileImageUrl,
    required this.topic,
    this.isBot = false,
  });

  final bool userWon;
  final bool isDraw;
  final int userScore;
  final int totalQuestions;
  final int xpEarned;
  final int gemsEarned;
  final String username;
  final String? profileImageUrl;
  final String opponentName;
  final int opponentXpEarned;
  final String? opponentProfileImageUrl;
  final String topic;
  final bool isBot;

  @override
  List<ShareableAvatar> get avatars => [
    ShareableAvatar(
      imageUrl: profileImageUrl,
      initial: username.isNotEmpty ? username[0].toUpperCase() : 'U',
      name: username,
      xpValue: xpEarned,
    ),
    if (isBot)
      ShareableAvatar(
        imageUrl: 'assets/images/battles/lenny_bot.png',
        isAsset: true,
        initial: opponentName.isNotEmpty ? opponentName[0].toUpperCase() : 'B',
        name: opponentName,
        xpValue: opponentXpEarned,
      )
    else
      ShareableAvatar(
        imageUrl: opponentProfileImageUrl,
        initial: opponentName.isNotEmpty ? opponentName[0].toUpperCase() : 'O',
        name: opponentName,
        xpValue: opponentXpEarned,
      ),
  ];

  @override
  String get primaryStatValue {
    final pct = totalQuestions > 0
        ? ((userScore / totalQuestions) * 100).round()
        : 0;
    return '$pct%';
  }

  @override
  String get primaryStatLabel => 'SCORE';

  @override
  int get xpValue => xpEarned;

  @override
  int get gemsValue => gemsEarned;

  @override
  String get bannerName => username;

  @override
  String get headline => userWon
      ? 'I Won the Battle.'
      : isDraw
      ? "It's a Draw!"
      : 'I Lost the Battle';

  @override
  String get subtext => userWon
      ? 'I earned $gemsEarned Gems'
      : isDraw
      ? 'You fought hard!'
      : 'Better Luck Next Time';
}
