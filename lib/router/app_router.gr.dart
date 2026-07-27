// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutLearnWayScreen]
class AboutLearnWayRoute extends PageRouteInfo<AboutLearnWayRouteArgs> {
  AboutLearnWayRoute({Key? key, String? title, List<PageRouteInfo>? children})
    : super(
        AboutLearnWayRoute.name,
        args: AboutLearnWayRouteArgs(key: key, title: title),
        rawPathParams: {'title': title},
        initialChildren: children,
      );

  static const String name = 'AboutLearnWayRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AboutLearnWayRouteArgs>(
        orElse: () =>
            AboutLearnWayRouteArgs(title: pathParams.optString('title')),
      );
      return AboutLearnWayScreen(key: args.key, title: args.title);
    },
  );
}

class AboutLearnWayRouteArgs {
  const AboutLearnWayRouteArgs({this.key, this.title});

  final Key? key;

  final String? title;

  @override
  String toString() {
    return 'AboutLearnWayRouteArgs{key: $key, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AboutLearnWayRouteArgs) return false;
    return key == other.key && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode;
}

/// generated route for
/// [AboutUsScreen]
class AboutUsRoute extends PageRouteInfo<void> {
  const AboutUsRoute({List<PageRouteInfo>? children})
    : super(AboutUsRoute.name, initialChildren: children);

  static const String name = 'AboutUsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutUsScreen();
    },
  );
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
    : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountScreen();
    },
  );
}

/// generated route for
/// [AccountSetupLoaderScreen]
class AccountSetupLoaderRoute
    extends PageRouteInfo<AccountSetupLoaderRouteArgs> {
  AccountSetupLoaderRoute({
    Key? key,
    required String userEmail,
    List<PageRouteInfo>? children,
  }) : super(
         AccountSetupLoaderRoute.name,
         args: AccountSetupLoaderRouteArgs(key: key, userEmail: userEmail),
         initialChildren: children,
       );

  static const String name = 'AccountSetupLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AccountSetupLoaderRouteArgs>();
      return AccountSetupLoaderScreen(key: args.key, userEmail: args.userEmail);
    },
  );
}

class AccountSetupLoaderRouteArgs {
  const AccountSetupLoaderRouteArgs({this.key, required this.userEmail});

  final Key? key;

  final String userEmail;

  @override
  String toString() {
    return 'AccountSetupLoaderRouteArgs{key: $key, userEmail: $userEmail}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccountSetupLoaderRouteArgs) return false;
    return key == other.key && userEmail == other.userEmail;
  }

  @override
  int get hashCode => key.hashCode ^ userEmail.hashCode;
}

/// generated route for
/// [AdvancedScreen]
class AdvancedRoute extends PageRouteInfo<void> {
  const AdvancedRoute({List<PageRouteInfo>? children})
    : super(AdvancedRoute.name, initialChildren: children);

  static const String name = 'AdvancedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdvancedScreen();
    },
  );
}

/// generated route for
/// [AiTutorTerminalScreen]
class AiTutorTerminalRoute extends PageRouteInfo<void> {
  const AiTutorTerminalRoute({List<PageRouteInfo>? children})
    : super(AiTutorTerminalRoute.name, initialChildren: children);

  static const String name = 'AiTutorTerminalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AiTutorTerminalScreen();
    },
  );
}

/// generated route for
/// [BadgeDetailsScreen]
class BadgeDetailsRoute extends PageRouteInfo<BadgeDetailsRouteArgs> {
  BadgeDetailsRoute({
    Key? key,
    required String badgeType,
    List<PageRouteInfo>? children,
  }) : super(
         BadgeDetailsRoute.name,
         args: BadgeDetailsRouteArgs(key: key, badgeType: badgeType),
         initialChildren: children,
       );

  static const String name = 'BadgeDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BadgeDetailsRouteArgs>();
      return BadgeDetailsScreen(key: args.key, badgeType: args.badgeType);
    },
  );
}

class BadgeDetailsRouteArgs {
  const BadgeDetailsRouteArgs({this.key, required this.badgeType});

  final Key? key;

  final String badgeType;

  @override
  String toString() {
    return 'BadgeDetailsRouteArgs{key: $key, badgeType: $badgeType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BadgeDetailsRouteArgs) return false;
    return key == other.key && badgeType == other.badgeType;
  }

  @override
  int get hashCode => key.hashCode ^ badgeType.hashCode;
}

/// generated route for
/// [BadgesScreen]
class BadgesRoute extends PageRouteInfo<void> {
  const BadgesRoute({List<PageRouteInfo>? children})
    : super(BadgesRoute.name, initialChildren: children);

  static const String name = 'BadgesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BadgesScreen();
    },
  );
}

/// generated route for
/// [BattleCompletionScreen]
class BattleCompletionRoute extends PageRouteInfo<BattleCompletionRouteArgs> {
  BattleCompletionRoute({
    Key? key,
    required int userScore,
    required int opponentScore,
    String opponentName = 'francis_owusu',
    List<PageRouteInfo>? children,
  }) : super(
         BattleCompletionRoute.name,
         args: BattleCompletionRouteArgs(
           key: key,
           userScore: userScore,
           opponentScore: opponentScore,
           opponentName: opponentName,
         ),
         initialChildren: children,
       );

  static const String name = 'BattleCompletionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleCompletionRouteArgs>();
      return BattleCompletionScreen(
        key: args.key,
        userScore: args.userScore,
        opponentScore: args.opponentScore,
        opponentName: args.opponentName,
      );
    },
  );
}

class BattleCompletionRouteArgs {
  const BattleCompletionRouteArgs({
    this.key,
    required this.userScore,
    required this.opponentScore,
    this.opponentName = 'francis_owusu',
  });

  final Key? key;

  final int userScore;

  final int opponentScore;

  final String opponentName;

  @override
  String toString() {
    return 'BattleCompletionRouteArgs{key: $key, userScore: $userScore, opponentScore: $opponentScore, opponentName: $opponentName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleCompletionRouteArgs) return false;
    return key == other.key &&
        userScore == other.userScore &&
        opponentScore == other.opponentScore &&
        opponentName == other.opponentName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userScore.hashCode ^
      opponentScore.hashCode ^
      opponentName.hashCode;
}

/// generated route for
/// [BattleFinalResultsScreen]
class BattleFinalResultsRoute
    extends PageRouteInfo<BattleFinalResultsRouteArgs> {
  BattleFinalResultsRoute({
    Key? key,
    required int userScore,
    required int opponentScore,
    String opponentName = 'francis_owusu',
    List<PageRouteInfo>? children,
  }) : super(
         BattleFinalResultsRoute.name,
         args: BattleFinalResultsRouteArgs(
           key: key,
           userScore: userScore,
           opponentScore: opponentScore,
           opponentName: opponentName,
         ),
         initialChildren: children,
       );

  static const String name = 'BattleFinalResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleFinalResultsRouteArgs>();
      return BattleFinalResultsScreen(
        key: args.key,
        userScore: args.userScore,
        opponentScore: args.opponentScore,
        opponentName: args.opponentName,
      );
    },
  );
}

class BattleFinalResultsRouteArgs {
  const BattleFinalResultsRouteArgs({
    this.key,
    required this.userScore,
    required this.opponentScore,
    this.opponentName = 'francis_owusu',
  });

  final Key? key;

  final int userScore;

  final int opponentScore;

  final String opponentName;

  @override
  String toString() {
    return 'BattleFinalResultsRouteArgs{key: $key, userScore: $userScore, opponentScore: $opponentScore, opponentName: $opponentName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleFinalResultsRouteArgs) return false;
    return key == other.key &&
        userScore == other.userScore &&
        opponentScore == other.opponentScore &&
        opponentName == other.opponentName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userScore.hashCode ^
      opponentScore.hashCode ^
      opponentName.hashCode;
}

/// generated route for
/// [BattleHistoryDetailsScreen]
class BattleHistoryDetailsRoute
    extends PageRouteInfo<BattleHistoryDetailsRouteArgs> {
  BattleHistoryDetailsRoute({
    Key? key,
    required String battleId,
    List<PageRouteInfo>? children,
  }) : super(
         BattleHistoryDetailsRoute.name,
         args: BattleHistoryDetailsRouteArgs(key: key, battleId: battleId),
         initialChildren: children,
       );

  static const String name = 'BattleHistoryDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleHistoryDetailsRouteArgs>();
      return BattleHistoryDetailsScreen(key: args.key, battleId: args.battleId);
    },
  );
}

class BattleHistoryDetailsRouteArgs {
  const BattleHistoryDetailsRouteArgs({this.key, required this.battleId});

  final Key? key;

  final String battleId;

  @override
  String toString() {
    return 'BattleHistoryDetailsRouteArgs{key: $key, battleId: $battleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleHistoryDetailsRouteArgs) return false;
    return key == other.key && battleId == other.battleId;
  }

  @override
  int get hashCode => key.hashCode ^ battleId.hashCode;
}

/// generated route for
/// [BattleHistoryScreen]
class BattleHistoryRoute extends PageRouteInfo<void> {
  const BattleHistoryRoute({List<PageRouteInfo>? children})
    : super(BattleHistoryRoute.name, initialChildren: children);

  static const String name = 'BattleHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BattleHistoryScreen();
    },
  );
}

/// generated route for
/// [BattleLoseScreen]
class BattleLoseRoute extends PageRouteInfo<BattleLoseRouteArgs> {
  BattleLoseRoute({
    Key? key,
    required int userXpEarned,
    required int opponentXpEarned,
    int userScore = 0,
    int totalQuestions = 10,
    String topic = '',
    String myName = 'You',
    String opponentName = 'Opponent',
    String? myProfileImageUrl,
    String? opponentProfileImageUrl,
    bool isBot = false,
    List<PageRouteInfo>? children,
  }) : super(
         BattleLoseRoute.name,
         args: BattleLoseRouteArgs(
           key: key,
           userXpEarned: userXpEarned,
           opponentXpEarned: opponentXpEarned,
           userScore: userScore,
           totalQuestions: totalQuestions,
           topic: topic,
           myName: myName,
           opponentName: opponentName,
           myProfileImageUrl: myProfileImageUrl,
           opponentProfileImageUrl: opponentProfileImageUrl,
           isBot: isBot,
         ),
         initialChildren: children,
       );

  static const String name = 'BattleLoseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleLoseRouteArgs>();
      return BattleLoseScreen(
        key: args.key,
        userXpEarned: args.userXpEarned,
        opponentXpEarned: args.opponentXpEarned,
        userScore: args.userScore,
        totalQuestions: args.totalQuestions,
        topic: args.topic,
        myName: args.myName,
        opponentName: args.opponentName,
        myProfileImageUrl: args.myProfileImageUrl,
        opponentProfileImageUrl: args.opponentProfileImageUrl,
        isBot: args.isBot,
      );
    },
  );
}

class BattleLoseRouteArgs {
  const BattleLoseRouteArgs({
    this.key,
    required this.userXpEarned,
    required this.opponentXpEarned,
    this.userScore = 0,
    this.totalQuestions = 10,
    this.topic = '',
    this.myName = 'You',
    this.opponentName = 'Opponent',
    this.myProfileImageUrl,
    this.opponentProfileImageUrl,
    this.isBot = false,
  });

  final Key? key;

  final int userXpEarned;

  final int opponentXpEarned;

  final int userScore;

  final int totalQuestions;

  final String topic;

  final String myName;

  final String opponentName;

  final String? myProfileImageUrl;

  final String? opponentProfileImageUrl;

  final bool isBot;

  @override
  String toString() {
    return 'BattleLoseRouteArgs{key: $key, userXpEarned: $userXpEarned, opponentXpEarned: $opponentXpEarned, userScore: $userScore, totalQuestions: $totalQuestions, topic: $topic, myName: $myName, opponentName: $opponentName, myProfileImageUrl: $myProfileImageUrl, opponentProfileImageUrl: $opponentProfileImageUrl, isBot: $isBot}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleLoseRouteArgs) return false;
    return key == other.key &&
        userXpEarned == other.userXpEarned &&
        opponentXpEarned == other.opponentXpEarned &&
        userScore == other.userScore &&
        totalQuestions == other.totalQuestions &&
        topic == other.topic &&
        myName == other.myName &&
        opponentName == other.opponentName &&
        myProfileImageUrl == other.myProfileImageUrl &&
        opponentProfileImageUrl == other.opponentProfileImageUrl &&
        isBot == other.isBot;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userXpEarned.hashCode ^
      opponentXpEarned.hashCode ^
      userScore.hashCode ^
      totalQuestions.hashCode ^
      topic.hashCode ^
      myName.hashCode ^
      opponentName.hashCode ^
      myProfileImageUrl.hashCode ^
      opponentProfileImageUrl.hashCode ^
      isBot.hashCode;
}

/// generated route for
/// [BattleReadyScreen]
class BattleReadyRoute extends PageRouteInfo<BattleReadyRouteArgs> {
  BattleReadyRoute({
    Key? key,
    required String battleId,
    List<PageRouteInfo>? children,
  }) : super(
         BattleReadyRoute.name,
         args: BattleReadyRouteArgs(key: key, battleId: battleId),
         initialChildren: children,
       );

  static const String name = 'BattleReadyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleReadyRouteArgs>();
      return BattleReadyScreen(key: args.key, battleId: args.battleId);
    },
  );
}

class BattleReadyRouteArgs {
  const BattleReadyRouteArgs({this.key, required this.battleId});

  final Key? key;

  final String battleId;

  @override
  String toString() {
    return 'BattleReadyRouteArgs{key: $key, battleId: $battleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleReadyRouteArgs) return false;
    return key == other.key && battleId == other.battleId;
  }

  @override
  int get hashCode => key.hashCode ^ battleId.hashCode;
}

/// generated route for
/// [BattleResultsScreen]
class BattleResultsRoute extends PageRouteInfo<BattleResultsRouteArgs> {
  BattleResultsRoute({
    Key? key,
    required int userScore,
    required int opponentScore,
    String myName = 'You',
    String opponentName = 'Opponent',
    String topic = '',
    int xpEarned = 0,
    List<PageRouteInfo>? children,
  }) : super(
         BattleResultsRoute.name,
         args: BattleResultsRouteArgs(
           key: key,
           userScore: userScore,
           opponentScore: opponentScore,
           myName: myName,
           opponentName: opponentName,
           topic: topic,
           xpEarned: xpEarned,
         ),
         initialChildren: children,
       );

  static const String name = 'BattleResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleResultsRouteArgs>();
      return BattleResultsScreen(
        key: args.key,
        userScore: args.userScore,
        opponentScore: args.opponentScore,
        myName: args.myName,
        opponentName: args.opponentName,
        topic: args.topic,
        xpEarned: args.xpEarned,
      );
    },
  );
}

class BattleResultsRouteArgs {
  const BattleResultsRouteArgs({
    this.key,
    required this.userScore,
    required this.opponentScore,
    this.myName = 'You',
    this.opponentName = 'Opponent',
    this.topic = '',
    this.xpEarned = 0,
  });

  final Key? key;

  final int userScore;

  final int opponentScore;

  final String myName;

  final String opponentName;

  final String topic;

  final int xpEarned;

  @override
  String toString() {
    return 'BattleResultsRouteArgs{key: $key, userScore: $userScore, opponentScore: $opponentScore, myName: $myName, opponentName: $opponentName, topic: $topic, xpEarned: $xpEarned}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleResultsRouteArgs) return false;
    return key == other.key &&
        userScore == other.userScore &&
        opponentScore == other.opponentScore &&
        myName == other.myName &&
        opponentName == other.opponentName &&
        topic == other.topic &&
        xpEarned == other.xpEarned;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userScore.hashCode ^
      opponentScore.hashCode ^
      myName.hashCode ^
      opponentName.hashCode ^
      topic.hashCode ^
      xpEarned.hashCode;
}

/// generated route for
/// [BattleScreen]
class BattleRoute extends PageRouteInfo<BattleRouteArgs> {
  BattleRoute({
    Key? key,
    required String battleId,
    List<PageRouteInfo>? children,
  }) : super(
         BattleRoute.name,
         args: BattleRouteArgs(key: key, battleId: battleId),
         initialChildren: children,
       );

  static const String name = 'BattleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleRouteArgs>();
      return BattleScreen(key: args.key, battleId: args.battleId);
    },
  );
}

class BattleRouteArgs {
  const BattleRouteArgs({this.key, required this.battleId});

  final Key? key;

  final String battleId;

  @override
  String toString() {
    return 'BattleRouteArgs{key: $key, battleId: $battleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleRouteArgs) return false;
    return key == other.key && battleId == other.battleId;
  }

  @override
  int get hashCode => key.hashCode ^ battleId.hashCode;
}

/// generated route for
/// [BattleWinScreen]
class BattleWinRoute extends PageRouteInfo<BattleWinRouteArgs> {
  BattleWinRoute({
    Key? key,
    required int userXpEarned,
    required int opponentXpEarned,
    int userScore = 0,
    int userGemsEarned = 0,
    int totalQuestions = 10,
    String myName = 'You',
    String opponentName = 'Opponent',
    String topic = '',
    String? myProfileImageUrl,
    String? opponentProfileImageUrl,
    bool isTie = false,
    bool isBot = false,
    List<PageRouteInfo>? children,
  }) : super(
         BattleWinRoute.name,
         args: BattleWinRouteArgs(
           key: key,
           userXpEarned: userXpEarned,
           opponentXpEarned: opponentXpEarned,
           userScore: userScore,
           userGemsEarned: userGemsEarned,
           totalQuestions: totalQuestions,
           myName: myName,
           opponentName: opponentName,
           topic: topic,
           myProfileImageUrl: myProfileImageUrl,
           opponentProfileImageUrl: opponentProfileImageUrl,
           isTie: isTie,
           isBot: isBot,
         ),
         initialChildren: children,
       );

  static const String name = 'BattleWinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BattleWinRouteArgs>();
      return BattleWinScreen(
        key: args.key,
        userXpEarned: args.userXpEarned,
        opponentXpEarned: args.opponentXpEarned,
        userScore: args.userScore,
        userGemsEarned: args.userGemsEarned,
        totalQuestions: args.totalQuestions,
        myName: args.myName,
        opponentName: args.opponentName,
        topic: args.topic,
        myProfileImageUrl: args.myProfileImageUrl,
        opponentProfileImageUrl: args.opponentProfileImageUrl,
        isTie: args.isTie,
        isBot: args.isBot,
      );
    },
  );
}

class BattleWinRouteArgs {
  const BattleWinRouteArgs({
    this.key,
    required this.userXpEarned,
    required this.opponentXpEarned,
    this.userScore = 0,
    this.userGemsEarned = 0,
    this.totalQuestions = 10,
    this.myName = 'You',
    this.opponentName = 'Opponent',
    this.topic = '',
    this.myProfileImageUrl,
    this.opponentProfileImageUrl,
    this.isTie = false,
    this.isBot = false,
  });

  final Key? key;

  final int userXpEarned;

  final int opponentXpEarned;

  final int userScore;

  final int userGemsEarned;

  final int totalQuestions;

  final String myName;

  final String opponentName;

  final String topic;

  final String? myProfileImageUrl;

  final String? opponentProfileImageUrl;

  final bool isTie;

  final bool isBot;

  @override
  String toString() {
    return 'BattleWinRouteArgs{key: $key, userXpEarned: $userXpEarned, opponentXpEarned: $opponentXpEarned, userScore: $userScore, userGemsEarned: $userGemsEarned, totalQuestions: $totalQuestions, myName: $myName, opponentName: $opponentName, topic: $topic, myProfileImageUrl: $myProfileImageUrl, opponentProfileImageUrl: $opponentProfileImageUrl, isTie: $isTie, isBot: $isBot}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BattleWinRouteArgs) return false;
    return key == other.key &&
        userXpEarned == other.userXpEarned &&
        opponentXpEarned == other.opponentXpEarned &&
        userScore == other.userScore &&
        userGemsEarned == other.userGemsEarned &&
        totalQuestions == other.totalQuestions &&
        myName == other.myName &&
        opponentName == other.opponentName &&
        topic == other.topic &&
        myProfileImageUrl == other.myProfileImageUrl &&
        opponentProfileImageUrl == other.opponentProfileImageUrl &&
        isTie == other.isTie &&
        isBot == other.isBot;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userXpEarned.hashCode ^
      opponentXpEarned.hashCode ^
      userScore.hashCode ^
      userGemsEarned.hashCode ^
      totalQuestions.hashCode ^
      myName.hashCode ^
      opponentName.hashCode ^
      topic.hashCode ^
      myProfileImageUrl.hashCode ^
      opponentProfileImageUrl.hashCode ^
      isTie.hashCode ^
      isBot.hashCode;
}

/// generated route for
/// [BattlesMainEntryScreen]
class BattlesMainEntryRoute extends PageRouteInfo<void> {
  const BattlesMainEntryRoute({List<PageRouteInfo>? children})
    : super(BattlesMainEntryRoute.name, initialChildren: children);

  static const String name = 'BattlesMainEntryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BattlesMainEntryScreen();
    },
  );
}

/// generated route for
/// [BeginnerScreen]
class BeginnerRoute extends PageRouteInfo<void> {
  const BeginnerRoute({List<PageRouteInfo>? children})
    : super(BeginnerRoute.name, initialChildren: children);

  static const String name = 'BeginnerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BeginnerScreen();
    },
  );
}

/// generated route for
/// [BookmarksScreen]
class BookmarksRoute extends PageRouteInfo<void> {
  const BookmarksRoute({List<PageRouteInfo>? children})
    : super(BookmarksRoute.name, initialChildren: children);

  static const String name = 'BookmarksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookmarksScreen();
    },
  );
}

/// generated route for
/// [BotBattleScreen]
class BotBattleRoute extends PageRouteInfo<BotBattleRouteArgs> {
  BotBattleRoute({
    Key? key,
    required String battleId,
    List<PageRouteInfo>? children,
  }) : super(
         BotBattleRoute.name,
         args: BotBattleRouteArgs(key: key, battleId: battleId),
         initialChildren: children,
       );

  static const String name = 'BotBattleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BotBattleRouteArgs>();
      return BotBattleScreen(key: args.key, battleId: args.battleId);
    },
  );
}

class BotBattleRouteArgs {
  const BotBattleRouteArgs({this.key, required this.battleId});

  final Key? key;

  final String battleId;

  @override
  String toString() {
    return 'BotBattleRouteArgs{key: $key, battleId: $battleId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BotBattleRouteArgs) return false;
    return key == other.key && battleId == other.battleId;
  }

  @override
  int get hashCode => key.hashCode ^ battleId.hashCode;
}

/// generated route for
/// [CareerGoalScreen]
class CareerGoalRoute extends PageRouteInfo<void> {
  const CareerGoalRoute({List<PageRouteInfo>? children})
    : super(CareerGoalRoute.name, initialChildren: children);

  static const String name = 'CareerGoalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CareerGoalScreen();
    },
  );
}

/// generated route for
/// [ChangeAvatarScreen]
class ChangeAvatarRoute extends PageRouteInfo<void> {
  const ChangeAvatarRoute({List<PageRouteInfo>? children})
    : super(ChangeAvatarRoute.name, initialChildren: children);

  static const String name = 'ChangeAvatarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangeAvatarScreen();
    },
  );
}

/// generated route for
/// [ChangeAvatarSuccessScreen]
class ChangeAvatarSuccessRoute
    extends PageRouteInfo<ChangeAvatarSuccessRouteArgs> {
  ChangeAvatarSuccessRoute({
    Key? key,
    required String imagePath,
    List<PageRouteInfo>? children,
  }) : super(
         ChangeAvatarSuccessRoute.name,
         args: ChangeAvatarSuccessRouteArgs(key: key, imagePath: imagePath),
         initialChildren: children,
       );

  static const String name = 'ChangeAvatarSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangeAvatarSuccessRouteArgs>();
      return ChangeAvatarSuccessScreen(
        key: args.key,
        imagePath: args.imagePath,
      );
    },
  );
}

class ChangeAvatarSuccessRouteArgs {
  const ChangeAvatarSuccessRouteArgs({this.key, required this.imagePath});

  final Key? key;

  final String imagePath;

  @override
  String toString() {
    return 'ChangeAvatarSuccessRouteArgs{key: $key, imagePath: $imagePath}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChangeAvatarSuccessRouteArgs) return false;
    return key == other.key && imagePath == other.imagePath;
  }

  @override
  int get hashCode => key.hashCode ^ imagePath.hashCode;
}

/// generated route for
/// [ChangeThemeScreen]
class ChangeThemeRoute extends PageRouteInfo<void> {
  const ChangeThemeRoute({List<PageRouteInfo>? children})
    : super(ChangeThemeRoute.name, initialChildren: children);

  static const String name = 'ChangeThemeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangeThemeScreen();
    },
  );
}

/// generated route for
/// [ContentReaderScreen]
class ContentReaderRoute extends PageRouteInfo<ContentReaderRouteArgs> {
  ContentReaderRoute({
    Key? key,
    required String id,
    required String title,
    required LessonSlidesResponse slidesResponse,
    required String lessonImage,
    List<PageRouteInfo>? children,
  }) : super(
         ContentReaderRoute.name,
         args: ContentReaderRouteArgs(
           key: key,
           id: id,
           title: title,
           slidesResponse: slidesResponse,
           lessonImage: lessonImage,
         ),
         initialChildren: children,
       );

  static const String name = 'ContentReaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContentReaderRouteArgs>();
      return ContentReaderScreen(
        key: args.key,
        id: args.id,
        title: args.title,
        slidesResponse: args.slidesResponse,
        lessonImage: args.lessonImage,
      );
    },
  );
}

class ContentReaderRouteArgs {
  const ContentReaderRouteArgs({
    this.key,
    required this.id,
    required this.title,
    required this.slidesResponse,
    required this.lessonImage,
  });

  final Key? key;

  final String id;

  final String title;

  final LessonSlidesResponse slidesResponse;

  final String lessonImage;

  @override
  String toString() {
    return 'ContentReaderRouteArgs{key: $key, id: $id, title: $title, slidesResponse: $slidesResponse, lessonImage: $lessonImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContentReaderRouteArgs) return false;
    return key == other.key &&
        id == other.id &&
        title == other.title &&
        slidesResponse == other.slidesResponse &&
        lessonImage == other.lessonImage;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      id.hashCode ^
      title.hashCode ^
      slidesResponse.hashCode ^
      lessonImage.hashCode;
}

/// generated route for
/// [ContestLeaderBoardScreen]
class ContestLeaderBoardRoute
    extends PageRouteInfo<ContestLeaderBoardRouteArgs> {
  ContestLeaderBoardRoute({
    Key? key,
    required String contestId,
    Map<String, dynamic>? arguments,
    List<PageRouteInfo>? children,
  }) : super(
         ContestLeaderBoardRoute.name,
         args: ContestLeaderBoardRouteArgs(
           key: key,
           contestId: contestId,
           arguments: arguments,
         ),
         initialChildren: children,
       );

  static const String name = 'ContestLeaderBoardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContestLeaderBoardRouteArgs>();
      return ContestLeaderBoardScreen(
        key: args.key,
        contestId: args.contestId,
        arguments: args.arguments,
      );
    },
  );
}

class ContestLeaderBoardRouteArgs {
  const ContestLeaderBoardRouteArgs({
    this.key,
    required this.contestId,
    this.arguments,
  });

  final Key? key;

  final String contestId;

  final Map<String, dynamic>? arguments;

  @override
  String toString() {
    return 'ContestLeaderBoardRouteArgs{key: $key, contestId: $contestId, arguments: $arguments}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContestLeaderBoardRouteArgs) return false;
    return key == other.key &&
        contestId == other.contestId &&
        const MapEquality<String, dynamic>().equals(arguments, other.arguments);
  }

  @override
  int get hashCode =>
      key.hashCode ^
      contestId.hashCode ^
      const MapEquality<String, dynamic>().hash(arguments);
}

/// generated route for
/// [ContestLoaderScreen]
class ContestLoaderRoute extends PageRouteInfo<ContestLoaderRouteArgs> {
  ContestLoaderRoute({
    Key? key,
    required String title,
    required String contestId,
    List<PageRouteInfo>? children,
  }) : super(
         ContestLoaderRoute.name,
         args: ContestLoaderRouteArgs(
           key: key,
           title: title,
           contestId: contestId,
         ),
         initialChildren: children,
       );

  static const String name = 'ContestLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContestLoaderRouteArgs>();
      return ContestLoaderScreen(
        key: args.key,
        title: args.title,
        contestId: args.contestId,
      );
    },
  );
}

class ContestLoaderRouteArgs {
  const ContestLoaderRouteArgs({
    this.key,
    required this.title,
    required this.contestId,
  });

  final Key? key;

  final String title;

  final String contestId;

  @override
  String toString() {
    return 'ContestLoaderRouteArgs{key: $key, title: $title, contestId: $contestId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContestLoaderRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        contestId == other.contestId;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ contestId.hashCode;
}

/// generated route for
/// [ContestQuizScreen]
class ContestQuizRoute extends PageRouteInfo<ContestQuizRouteArgs> {
  ContestQuizRoute({
    Key? key,
    required String contestTitle,
    List<PageRouteInfo>? children,
  }) : super(
         ContestQuizRoute.name,
         args: ContestQuizRouteArgs(key: key, contestTitle: contestTitle),
         initialChildren: children,
       );

  static const String name = 'ContestQuizRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContestQuizRouteArgs>();
      return ContestQuizScreen(key: args.key, contestTitle: args.contestTitle);
    },
  );
}

class ContestQuizRouteArgs {
  const ContestQuizRouteArgs({this.key, required this.contestTitle});

  final Key? key;

  final String contestTitle;

  @override
  String toString() {
    return 'ContestQuizRouteArgs{key: $key, contestTitle: $contestTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContestQuizRouteArgs) return false;
    return key == other.key && contestTitle == other.contestTitle;
  }

  @override
  int get hashCode => key.hashCode ^ contestTitle.hashCode;
}

/// generated route for
/// [ContestResultScreen]
class ContestResultRoute extends PageRouteInfo<void> {
  const ContestResultRoute({List<PageRouteInfo>? children})
    : super(ContestResultRoute.name, initialChildren: children);

  static const String name = 'ContestResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContestResultScreen();
    },
  );
}

/// generated route for
/// [ContestReviewScreen]
class ContestReviewRoute extends PageRouteInfo<void> {
  const ContestReviewRoute({List<PageRouteInfo>? children})
    : super(ContestReviewRoute.name, initialChildren: children);

  static const String name = 'ContestReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContestReviewScreen();
    },
  );
}

/// generated route for
/// [ContestScreen]
class ContestRoute extends PageRouteInfo<void> {
  const ContestRoute({List<PageRouteInfo>? children})
    : super(ContestRoute.name, initialChildren: children);

  static const String name = 'ContestRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContestScreen();
    },
  );
}

/// generated route for
/// [ContestSubmitScreen]
class ContestSubmitRoute extends PageRouteInfo<ContestSubmitRouteArgs> {
  ContestSubmitRoute({
    Key? key,
    required String contestId,
    List<PageRouteInfo>? children,
  }) : super(
         ContestSubmitRoute.name,
         args: ContestSubmitRouteArgs(key: key, contestId: contestId),
         initialChildren: children,
       );

  static const String name = 'ContestSubmitRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContestSubmitRouteArgs>();
      return ContestSubmitScreen(key: args.key, contestId: args.contestId);
    },
  );
}

class ContestSubmitRouteArgs {
  const ContestSubmitRouteArgs({this.key, required this.contestId});

  final Key? key;

  final String contestId;

  @override
  String toString() {
    return 'ContestSubmitRouteArgs{key: $key, contestId: $contestId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContestSubmitRouteArgs) return false;
    return key == other.key && contestId == other.contestId;
  }

  @override
  int get hashCode => key.hashCode ^ contestId.hashCode;
}

/// generated route for
/// [ContestXPEarnedScreen]
class ContestXPEarnedRoute extends PageRouteInfo<void> {
  const ContestXPEarnedRoute({List<PageRouteInfo>? children})
    : super(ContestXPEarnedRoute.name, initialChildren: children);

  static const String name = 'ContestXPEarnedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContestXPEarnedScreen();
    },
  );
}

/// generated route for
/// [CoursesPathInfoScreen]
class CoursesPathInfoRoute extends PageRouteInfo<CoursesPathInfoRouteArgs> {
  CoursesPathInfoRoute({
    Key? key,
    required PathCourseModel course,
    required String pathTitle,
    List<PageRouteInfo>? children,
  }) : super(
         CoursesPathInfoRoute.name,
         args: CoursesPathInfoRouteArgs(
           key: key,
           course: course,
           pathTitle: pathTitle,
         ),
         initialChildren: children,
       );

  static const String name = 'CoursesPathInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CoursesPathInfoRouteArgs>();
      return CoursesPathInfoScreen(
        key: args.key,
        course: args.course,
        pathTitle: args.pathTitle,
      );
    },
  );
}

class CoursesPathInfoRouteArgs {
  const CoursesPathInfoRouteArgs({
    this.key,
    required this.course,
    required this.pathTitle,
  });

  final Key? key;

  final PathCourseModel course;

  final String pathTitle;

  @override
  String toString() {
    return 'CoursesPathInfoRouteArgs{key: $key, course: $course, pathTitle: $pathTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CoursesPathInfoRouteArgs) return false;
    return key == other.key &&
        course == other.course &&
        pathTitle == other.pathTitle;
  }

  @override
  int get hashCode => key.hashCode ^ course.hashCode ^ pathTitle.hashCode;
}

/// generated route for
/// [DepositAndBuyScreen]
class DepositAndBuyRoute extends PageRouteInfo<DepositAndBuyRouteArgs> {
  DepositAndBuyRoute({
    Key? key,
    required String params,
    bool isOffRamp = false,
    String? address,
    String? amount,
    String? countryIsoCode,
    String? paymentChannel,
    String? offRampParams,
    List<PageRouteInfo>? children,
  }) : super(
         DepositAndBuyRoute.name,
         args: DepositAndBuyRouteArgs(
           key: key,
           params: params,
           isOffRamp: isOffRamp,
           address: address,
           amount: amount,
           countryIsoCode: countryIsoCode,
           paymentChannel: paymentChannel,
           offRampParams: offRampParams,
         ),
         initialChildren: children,
       );

  static const String name = 'DepositAndBuyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DepositAndBuyRouteArgs>();
      return DepositAndBuyScreen(
        key: args.key,
        params: args.params,
        isOffRamp: args.isOffRamp,
        address: args.address,
        amount: args.amount,
        countryIsoCode: args.countryIsoCode,
        paymentChannel: args.paymentChannel,
        offRampParams: args.offRampParams,
      );
    },
  );
}

class DepositAndBuyRouteArgs {
  const DepositAndBuyRouteArgs({
    this.key,
    required this.params,
    this.isOffRamp = false,
    this.address,
    this.amount,
    this.countryIsoCode,
    this.paymentChannel,
    this.offRampParams,
  });

  final Key? key;

  final String params;

  final bool isOffRamp;

  final String? address;

  final String? amount;

  final String? countryIsoCode;

  final String? paymentChannel;

  final String? offRampParams;

  @override
  String toString() {
    return 'DepositAndBuyRouteArgs{key: $key, params: $params, isOffRamp: $isOffRamp, address: $address, amount: $amount, countryIsoCode: $countryIsoCode, paymentChannel: $paymentChannel, offRampParams: $offRampParams}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DepositAndBuyRouteArgs) return false;
    return key == other.key &&
        params == other.params &&
        isOffRamp == other.isOffRamp &&
        address == other.address &&
        amount == other.amount &&
        countryIsoCode == other.countryIsoCode &&
        paymentChannel == other.paymentChannel &&
        offRampParams == other.offRampParams;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      params.hashCode ^
      isOffRamp.hashCode ^
      address.hashCode ^
      amount.hashCode ^
      countryIsoCode.hashCode ^
      paymentChannel.hashCode ^
      offRampParams.hashCode;
}

/// generated route for
/// [DepositConverterScreen]
class DepositConverterRoute extends PageRouteInfo<DepositConverterRouteArgs> {
  DepositConverterRoute({
    Key? key,
    required String walletAddress,
    required String selectedCountry,
    required String selectedCountryCode,
    required String selectedPaymentChannel,
    required String selectedNetwork,
    required String selectedCarrierCode,
    required String phoneNumber,
    String fullName = '',
    String bankCode = '',
    String bankAccountNumber = '',
    double minDepositAmount = 0.0,
    double maxDepositAmount = 0.0,
    List<PageRouteInfo>? children,
  }) : super(
         DepositConverterRoute.name,
         args: DepositConverterRouteArgs(
           key: key,
           walletAddress: walletAddress,
           selectedCountry: selectedCountry,
           selectedCountryCode: selectedCountryCode,
           selectedPaymentChannel: selectedPaymentChannel,
           selectedNetwork: selectedNetwork,
           selectedCarrierCode: selectedCarrierCode,
           phoneNumber: phoneNumber,
           fullName: fullName,
           bankCode: bankCode,
           bankAccountNumber: bankAccountNumber,
           minDepositAmount: minDepositAmount,
           maxDepositAmount: maxDepositAmount,
         ),
         initialChildren: children,
       );

  static const String name = 'DepositConverterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DepositConverterRouteArgs>();
      return DepositConverterScreen(
        key: args.key,
        walletAddress: args.walletAddress,
        selectedCountry: args.selectedCountry,
        selectedCountryCode: args.selectedCountryCode,
        selectedPaymentChannel: args.selectedPaymentChannel,
        selectedNetwork: args.selectedNetwork,
        selectedCarrierCode: args.selectedCarrierCode,
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        bankCode: args.bankCode,
        bankAccountNumber: args.bankAccountNumber,
        minDepositAmount: args.minDepositAmount,
        maxDepositAmount: args.maxDepositAmount,
      );
    },
  );
}

class DepositConverterRouteArgs {
  const DepositConverterRouteArgs({
    this.key,
    required this.walletAddress,
    required this.selectedCountry,
    required this.selectedCountryCode,
    required this.selectedPaymentChannel,
    required this.selectedNetwork,
    required this.selectedCarrierCode,
    required this.phoneNumber,
    this.fullName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
    this.minDepositAmount = 0.0,
    this.maxDepositAmount = 0.0,
  });

  final Key? key;

  final String walletAddress;

  final String selectedCountry;

  final String selectedCountryCode;

  final String selectedPaymentChannel;

  final String selectedNetwork;

  final String selectedCarrierCode;

  final String phoneNumber;

  final String fullName;

  final String bankCode;

  final String bankAccountNumber;

  final double minDepositAmount;

  final double maxDepositAmount;

  @override
  String toString() {
    return 'DepositConverterRouteArgs{key: $key, walletAddress: $walletAddress, selectedCountry: $selectedCountry, selectedCountryCode: $selectedCountryCode, selectedPaymentChannel: $selectedPaymentChannel, selectedNetwork: $selectedNetwork, selectedCarrierCode: $selectedCarrierCode, phoneNumber: $phoneNumber, fullName: $fullName, bankCode: $bankCode, bankAccountNumber: $bankAccountNumber, minDepositAmount: $minDepositAmount, maxDepositAmount: $maxDepositAmount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DepositConverterRouteArgs) return false;
    return key == other.key &&
        walletAddress == other.walletAddress &&
        selectedCountry == other.selectedCountry &&
        selectedCountryCode == other.selectedCountryCode &&
        selectedPaymentChannel == other.selectedPaymentChannel &&
        selectedNetwork == other.selectedNetwork &&
        selectedCarrierCode == other.selectedCarrierCode &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        bankCode == other.bankCode &&
        bankAccountNumber == other.bankAccountNumber &&
        minDepositAmount == other.minDepositAmount &&
        maxDepositAmount == other.maxDepositAmount;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      walletAddress.hashCode ^
      selectedCountry.hashCode ^
      selectedCountryCode.hashCode ^
      selectedPaymentChannel.hashCode ^
      selectedNetwork.hashCode ^
      selectedCarrierCode.hashCode ^
      phoneNumber.hashCode ^
      fullName.hashCode ^
      bankCode.hashCode ^
      bankAccountNumber.hashCode ^
      minDepositAmount.hashCode ^
      maxDepositAmount.hashCode;
}

/// generated route for
/// [DepositLoaderScreen]
class DepositLoaderRoute extends PageRouteInfo<DepositLoaderRouteArgs> {
  DepositLoaderRoute({
    Key? key,
    required String selectedImage,
    required String phoneNumber,
    required String fullName,
    required String paymentChannel,
    required double fiatAmount,
    required double usdtAmount,
    required double exchangeRate,
    required double feeAmount,
    required String localCurrencyCode,
    required String localCurrencySymbol,
    required String countryCode,
    required String quoteId,
    String carrierCode = '',
    String carrierName = '',
    String bankCode = '',
    String bankAccountNumber = '',
    List<PageRouteInfo>? children,
  }) : super(
         DepositLoaderRoute.name,
         args: DepositLoaderRouteArgs(
           key: key,
           selectedImage: selectedImage,
           phoneNumber: phoneNumber,
           fullName: fullName,
           paymentChannel: paymentChannel,
           fiatAmount: fiatAmount,
           usdtAmount: usdtAmount,
           exchangeRate: exchangeRate,
           feeAmount: feeAmount,
           localCurrencyCode: localCurrencyCode,
           localCurrencySymbol: localCurrencySymbol,
           countryCode: countryCode,
           quoteId: quoteId,
           carrierCode: carrierCode,
           carrierName: carrierName,
           bankCode: bankCode,
           bankAccountNumber: bankAccountNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'DepositLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DepositLoaderRouteArgs>();
      return DepositLoaderScreen(
        key: args.key,
        selectedImage: args.selectedImage,
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        paymentChannel: args.paymentChannel,
        fiatAmount: args.fiatAmount,
        usdtAmount: args.usdtAmount,
        exchangeRate: args.exchangeRate,
        feeAmount: args.feeAmount,
        localCurrencyCode: args.localCurrencyCode,
        localCurrencySymbol: args.localCurrencySymbol,
        countryCode: args.countryCode,
        quoteId: args.quoteId,
        carrierCode: args.carrierCode,
        carrierName: args.carrierName,
        bankCode: args.bankCode,
        bankAccountNumber: args.bankAccountNumber,
      );
    },
  );
}

class DepositLoaderRouteArgs {
  const DepositLoaderRouteArgs({
    this.key,
    required this.selectedImage,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
  });

  final Key? key;

  final String selectedImage;

  final String phoneNumber;

  final String fullName;

  final String paymentChannel;

  final double fiatAmount;

  final double usdtAmount;

  final double exchangeRate;

  final double feeAmount;

  final String localCurrencyCode;

  final String localCurrencySymbol;

  final String countryCode;

  final String quoteId;

  final String carrierCode;

  final String carrierName;

  final String bankCode;

  final String bankAccountNumber;

  @override
  String toString() {
    return 'DepositLoaderRouteArgs{key: $key, selectedImage: $selectedImage, phoneNumber: $phoneNumber, fullName: $fullName, paymentChannel: $paymentChannel, fiatAmount: $fiatAmount, usdtAmount: $usdtAmount, exchangeRate: $exchangeRate, feeAmount: $feeAmount, localCurrencyCode: $localCurrencyCode, localCurrencySymbol: $localCurrencySymbol, countryCode: $countryCode, quoteId: $quoteId, carrierCode: $carrierCode, carrierName: $carrierName, bankCode: $bankCode, bankAccountNumber: $bankAccountNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DepositLoaderRouteArgs) return false;
    return key == other.key &&
        selectedImage == other.selectedImage &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        paymentChannel == other.paymentChannel &&
        fiatAmount == other.fiatAmount &&
        usdtAmount == other.usdtAmount &&
        exchangeRate == other.exchangeRate &&
        feeAmount == other.feeAmount &&
        localCurrencyCode == other.localCurrencyCode &&
        localCurrencySymbol == other.localCurrencySymbol &&
        countryCode == other.countryCode &&
        quoteId == other.quoteId &&
        carrierCode == other.carrierCode &&
        carrierName == other.carrierName &&
        bankCode == other.bankCode &&
        bankAccountNumber == other.bankAccountNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      selectedImage.hashCode ^
      phoneNumber.hashCode ^
      fullName.hashCode ^
      paymentChannel.hashCode ^
      fiatAmount.hashCode ^
      usdtAmount.hashCode ^
      exchangeRate.hashCode ^
      feeAmount.hashCode ^
      localCurrencyCode.hashCode ^
      localCurrencySymbol.hashCode ^
      countryCode.hashCode ^
      quoteId.hashCode ^
      carrierCode.hashCode ^
      carrierName.hashCode ^
      bankCode.hashCode ^
      bankAccountNumber.hashCode;
}

/// generated route for
/// [DepositPaymentMethodScreen]
class DepositPaymentMethodRoute extends PageRouteInfo<void> {
  const DepositPaymentMethodRoute({List<PageRouteInfo>? children})
    : super(DepositPaymentMethodRoute.name, initialChildren: children);

  static const String name = 'DepositPaymentMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DepositPaymentMethodScreen();
    },
  );
}

/// generated route for
/// [DepositSuccessfulScreen]
class DepositSuccessfulRoute extends PageRouteInfo<DepositSuccessfulRouteArgs> {
  DepositSuccessfulRoute({
    Key? key,
    required String selectedImage,
    required String phoneNumber,
    required String fullName,
    required String paymentChannel,
    required double fiatAmount,
    required double usdtAmount,
    required double exchangeRate,
    required double feeAmount,
    required String localCurrencyCode,
    required String localCurrencySymbol,
    required String countryCode,
    required String quoteId,
    String carrierCode = '',
    String carrierName = '',
    String bankCode = '',
    String bankAccountNumber = '',
    List<PageRouteInfo>? children,
  }) : super(
         DepositSuccessfulRoute.name,
         args: DepositSuccessfulRouteArgs(
           key: key,
           selectedImage: selectedImage,
           phoneNumber: phoneNumber,
           fullName: fullName,
           paymentChannel: paymentChannel,
           fiatAmount: fiatAmount,
           usdtAmount: usdtAmount,
           exchangeRate: exchangeRate,
           feeAmount: feeAmount,
           localCurrencyCode: localCurrencyCode,
           localCurrencySymbol: localCurrencySymbol,
           countryCode: countryCode,
           quoteId: quoteId,
           carrierCode: carrierCode,
           carrierName: carrierName,
           bankCode: bankCode,
           bankAccountNumber: bankAccountNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'DepositSuccessfulRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DepositSuccessfulRouteArgs>();
      return DepositSuccessfulScreen(
        key: args.key,
        selectedImage: args.selectedImage,
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        paymentChannel: args.paymentChannel,
        fiatAmount: args.fiatAmount,
        usdtAmount: args.usdtAmount,
        exchangeRate: args.exchangeRate,
        feeAmount: args.feeAmount,
        localCurrencyCode: args.localCurrencyCode,
        localCurrencySymbol: args.localCurrencySymbol,
        countryCode: args.countryCode,
        quoteId: args.quoteId,
        carrierCode: args.carrierCode,
        carrierName: args.carrierName,
        bankCode: args.bankCode,
        bankAccountNumber: args.bankAccountNumber,
      );
    },
  );
}

class DepositSuccessfulRouteArgs {
  const DepositSuccessfulRouteArgs({
    this.key,
    required this.selectedImage,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
  });

  final Key? key;

  final String selectedImage;

  final String phoneNumber;

  final String fullName;

  final String paymentChannel;

  final double fiatAmount;

  final double usdtAmount;

  final double exchangeRate;

  final double feeAmount;

  final String localCurrencyCode;

  final String localCurrencySymbol;

  final String countryCode;

  final String quoteId;

  final String carrierCode;

  final String carrierName;

  final String bankCode;

  final String bankAccountNumber;

  @override
  String toString() {
    return 'DepositSuccessfulRouteArgs{key: $key, selectedImage: $selectedImage, phoneNumber: $phoneNumber, fullName: $fullName, paymentChannel: $paymentChannel, fiatAmount: $fiatAmount, usdtAmount: $usdtAmount, exchangeRate: $exchangeRate, feeAmount: $feeAmount, localCurrencyCode: $localCurrencyCode, localCurrencySymbol: $localCurrencySymbol, countryCode: $countryCode, quoteId: $quoteId, carrierCode: $carrierCode, carrierName: $carrierName, bankCode: $bankCode, bankAccountNumber: $bankAccountNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DepositSuccessfulRouteArgs) return false;
    return key == other.key &&
        selectedImage == other.selectedImage &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        paymentChannel == other.paymentChannel &&
        fiatAmount == other.fiatAmount &&
        usdtAmount == other.usdtAmount &&
        exchangeRate == other.exchangeRate &&
        feeAmount == other.feeAmount &&
        localCurrencyCode == other.localCurrencyCode &&
        localCurrencySymbol == other.localCurrencySymbol &&
        countryCode == other.countryCode &&
        quoteId == other.quoteId &&
        carrierCode == other.carrierCode &&
        carrierName == other.carrierName &&
        bankCode == other.bankCode &&
        bankAccountNumber == other.bankAccountNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      selectedImage.hashCode ^
      phoneNumber.hashCode ^
      fullName.hashCode ^
      paymentChannel.hashCode ^
      fiatAmount.hashCode ^
      usdtAmount.hashCode ^
      exchangeRate.hashCode ^
      feeAmount.hashCode ^
      localCurrencyCode.hashCode ^
      localCurrencySymbol.hashCode ^
      countryCode.hashCode ^
      quoteId.hashCode ^
      carrierCode.hashCode ^
      carrierName.hashCode ^
      bankCode.hashCode ^
      bankAccountNumber.hashCode;
}

/// generated route for
/// [DepositUssdScreen]
class DepositUssdRoute extends PageRouteInfo<DepositUssdRouteArgs> {
  DepositUssdRoute({
    Key? key,
    required String selectedImage,
    required String phoneNumber,
    required String fullName,
    required String paymentChannel,
    required double fiatAmount,
    required double usdtAmount,
    required double exchangeRate,
    required double feeAmount,
    required String localCurrencyCode,
    required String localCurrencySymbol,
    required String countryCode,
    required String quoteId,
    String carrierCode = '',
    String carrierName = '',
    List<PageRouteInfo>? children,
  }) : super(
         DepositUssdRoute.name,
         args: DepositUssdRouteArgs(
           key: key,
           selectedImage: selectedImage,
           phoneNumber: phoneNumber,
           fullName: fullName,
           paymentChannel: paymentChannel,
           fiatAmount: fiatAmount,
           usdtAmount: usdtAmount,
           exchangeRate: exchangeRate,
           feeAmount: feeAmount,
           localCurrencyCode: localCurrencyCode,
           localCurrencySymbol: localCurrencySymbol,
           countryCode: countryCode,
           quoteId: quoteId,
           carrierCode: carrierCode,
           carrierName: carrierName,
         ),
         initialChildren: children,
       );

  static const String name = 'DepositUssdRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DepositUssdRouteArgs>();
      return DepositUssdScreen(
        key: args.key,
        selectedImage: args.selectedImage,
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        paymentChannel: args.paymentChannel,
        fiatAmount: args.fiatAmount,
        usdtAmount: args.usdtAmount,
        exchangeRate: args.exchangeRate,
        feeAmount: args.feeAmount,
        localCurrencyCode: args.localCurrencyCode,
        localCurrencySymbol: args.localCurrencySymbol,
        countryCode: args.countryCode,
        quoteId: args.quoteId,
        carrierCode: args.carrierCode,
        carrierName: args.carrierName,
      );
    },
  );
}

class DepositUssdRouteArgs {
  const DepositUssdRouteArgs({
    this.key,
    required this.selectedImage,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
  });

  final Key? key;

  final String selectedImage;

  final String phoneNumber;

  final String fullName;

  final String paymentChannel;

  final double fiatAmount;

  final double usdtAmount;

  final double exchangeRate;

  final double feeAmount;

  final String localCurrencyCode;

  final String localCurrencySymbol;

  final String countryCode;

  final String quoteId;

  final String carrierCode;

  final String carrierName;

  @override
  String toString() {
    return 'DepositUssdRouteArgs{key: $key, selectedImage: $selectedImage, phoneNumber: $phoneNumber, fullName: $fullName, paymentChannel: $paymentChannel, fiatAmount: $fiatAmount, usdtAmount: $usdtAmount, exchangeRate: $exchangeRate, feeAmount: $feeAmount, localCurrencyCode: $localCurrencyCode, localCurrencySymbol: $localCurrencySymbol, countryCode: $countryCode, quoteId: $quoteId, carrierCode: $carrierCode, carrierName: $carrierName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DepositUssdRouteArgs) return false;
    return key == other.key &&
        selectedImage == other.selectedImage &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        paymentChannel == other.paymentChannel &&
        fiatAmount == other.fiatAmount &&
        usdtAmount == other.usdtAmount &&
        exchangeRate == other.exchangeRate &&
        feeAmount == other.feeAmount &&
        localCurrencyCode == other.localCurrencyCode &&
        localCurrencySymbol == other.localCurrencySymbol &&
        countryCode == other.countryCode &&
        quoteId == other.quoteId &&
        carrierCode == other.carrierCode &&
        carrierName == other.carrierName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      selectedImage.hashCode ^
      phoneNumber.hashCode ^
      fullName.hashCode ^
      paymentChannel.hashCode ^
      fiatAmount.hashCode ^
      usdtAmount.hashCode ^
      exchangeRate.hashCode ^
      feeAmount.hashCode ^
      localCurrencyCode.hashCode ^
      localCurrencySymbol.hashCode ^
      countryCode.hashCode ^
      quoteId.hashCode ^
      carrierCode.hashCode ^
      carrierName.hashCode;
}

/// generated route for
/// [DiscoveryFlowScreen]
class DiscoveryFlowRoute extends PageRouteInfo<DiscoveryFlowRouteArgs> {
  DiscoveryFlowRoute({
    Key? key,
    bool allowBack = false,
    List<PageRouteInfo>? children,
  }) : super(
         DiscoveryFlowRoute.name,
         args: DiscoveryFlowRouteArgs(key: key, allowBack: allowBack),
         initialChildren: children,
       );

  static const String name = 'DiscoveryFlowRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DiscoveryFlowRouteArgs>(
        orElse: () => const DiscoveryFlowRouteArgs(),
      );
      return DiscoveryFlowScreen(key: args.key, allowBack: args.allowBack);
    },
  );
}

class DiscoveryFlowRouteArgs {
  const DiscoveryFlowRouteArgs({this.key, this.allowBack = false});

  final Key? key;

  final bool allowBack;

  @override
  String toString() {
    return 'DiscoveryFlowRouteArgs{key: $key, allowBack: $allowBack}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DiscoveryFlowRouteArgs) return false;
    return key == other.key && allowBack == other.allowBack;
  }

  @override
  int get hashCode => key.hashCode ^ allowBack.hashCode;
}

/// generated route for
/// [EnterEmailScreen]
class EnterEmailRoute extends PageRouteInfo<void> {
  const EnterEmailRoute({List<PageRouteInfo>? children})
    : super(EnterEmailRoute.name, initialChildren: children);

  static const String name = 'EnterEmailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EnterEmailScreen();
    },
  );
}

/// generated route for
/// [ExplorePathsScreen]
class ExplorePathsRoute extends PageRouteInfo<void> {
  const ExplorePathsRoute({List<PageRouteInfo>? children})
    : super(ExplorePathsRoute.name, initialChildren: children);

  static const String name = 'ExplorePathsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExplorePathsScreen();
    },
  );
}

/// generated route for
/// [GroupBattleDefeatScreen]
class GroupBattleDefeatRoute extends PageRouteInfo<GroupBattleDefeatRouteArgs> {
  GroupBattleDefeatRoute({
    Key? key,
    required int userScore,
    required int player2Score,
    required int player3Score,
    required int player4Score,
    List<PageRouteInfo>? children,
  }) : super(
         GroupBattleDefeatRoute.name,
         args: GroupBattleDefeatRouteArgs(
           key: key,
           userScore: userScore,
           player2Score: player2Score,
           player3Score: player3Score,
           player4Score: player4Score,
         ),
         initialChildren: children,
       );

  static const String name = 'GroupBattleDefeatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupBattleDefeatRouteArgs>();
      return GroupBattleDefeatScreen(
        key: args.key,
        userScore: args.userScore,
        player2Score: args.player2Score,
        player3Score: args.player3Score,
        player4Score: args.player4Score,
      );
    },
  );
}

class GroupBattleDefeatRouteArgs {
  const GroupBattleDefeatRouteArgs({
    this.key,
    required this.userScore,
    required this.player2Score,
    required this.player3Score,
    required this.player4Score,
  });

  final Key? key;

  final int userScore;

  final int player2Score;

  final int player3Score;

  final int player4Score;

  @override
  String toString() {
    return 'GroupBattleDefeatRouteArgs{key: $key, userScore: $userScore, player2Score: $player2Score, player3Score: $player3Score, player4Score: $player4Score}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupBattleDefeatRouteArgs) return false;
    return key == other.key &&
        userScore == other.userScore &&
        player2Score == other.player2Score &&
        player3Score == other.player3Score &&
        player4Score == other.player4Score;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userScore.hashCode ^
      player2Score.hashCode ^
      player3Score.hashCode ^
      player4Score.hashCode;
}

/// generated route for
/// [GroupBattleScreen]
class GroupBattleRoute extends PageRouteInfo<void> {
  const GroupBattleRoute({List<PageRouteInfo>? children})
    : super(GroupBattleRoute.name, initialChildren: children);

  static const String name = 'GroupBattleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GroupBattleScreen();
    },
  );
}

/// generated route for
/// [GroupBattleWinScreen]
class GroupBattleWinRoute extends PageRouteInfo<GroupBattleWinRouteArgs> {
  GroupBattleWinRoute({
    Key? key,
    required int userScore,
    required int player2Score,
    required int player3Score,
    required int player4Score,
    List<PageRouteInfo>? children,
  }) : super(
         GroupBattleWinRoute.name,
         args: GroupBattleWinRouteArgs(
           key: key,
           userScore: userScore,
           player2Score: player2Score,
           player3Score: player3Score,
           player4Score: player4Score,
         ),
         initialChildren: children,
       );

  static const String name = 'GroupBattleWinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupBattleWinRouteArgs>();
      return GroupBattleWinScreen(
        key: args.key,
        userScore: args.userScore,
        player2Score: args.player2Score,
        player3Score: args.player3Score,
        player4Score: args.player4Score,
      );
    },
  );
}

class GroupBattleWinRouteArgs {
  const GroupBattleWinRouteArgs({
    this.key,
    required this.userScore,
    required this.player2Score,
    required this.player3Score,
    required this.player4Score,
  });

  final Key? key;

  final int userScore;

  final int player2Score;

  final int player3Score;

  final int player4Score;

  @override
  String toString() {
    return 'GroupBattleWinRouteArgs{key: $key, userScore: $userScore, player2Score: $player2Score, player3Score: $player3Score, player4Score: $player4Score}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupBattleWinRouteArgs) return false;
    return key == other.key &&
        userScore == other.userScore &&
        player2Score == other.player2Score &&
        player3Score == other.player3Score &&
        player4Score == other.player4Score;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      userScore.hashCode ^
      player2Score.hashCode ^
      player3Score.hashCode ^
      player4Score.hashCode;
}

/// generated route for
/// [HelpCenterScreen]
class HelpCenterRoute extends PageRouteInfo<void> {
  const HelpCenterRoute({List<PageRouteInfo>? children})
    : super(HelpCenterRoute.name, initialChildren: children);

  static const String name = 'HelpCenterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpCenterScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [IntermediateScreen]
class IntermediateRoute extends PageRouteInfo<void> {
  const IntermediateRoute({List<PageRouteInfo>? children})
    : super(IntermediateRoute.name, initialChildren: children);

  static const String name = 'IntermediateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntermediateScreen();
    },
  );
}

/// generated route for
/// [InviteFriendsScreen]
class InviteFriendsRoute extends PageRouteInfo<void> {
  const InviteFriendsRoute({List<PageRouteInfo>? children})
    : super(InviteFriendsRoute.name, initialChildren: children);

  static const String name = 'InviteFriendsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InviteFriendsScreen();
    },
  );
}

/// generated route for
/// [KycDoneScreen]
class KycDoneRoute extends PageRouteInfo<void> {
  const KycDoneRoute({List<PageRouteInfo>? children})
    : super(KycDoneRoute.name, initialChildren: children);

  static const String name = 'KycDoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KycDoneScreen();
    },
  );
}

/// generated route for
/// [KycInReviewScreen]
class KycInReviewRoute extends PageRouteInfo<void> {
  const KycInReviewRoute({List<PageRouteInfo>? children})
    : super(KycInReviewRoute.name, initialChildren: children);

  static const String name = 'KycInReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KycInReviewScreen();
    },
  );
}

/// generated route for
/// [KycNotDoneScreen]
class KycNotDoneRoute extends PageRouteInfo<void> {
  const KycNotDoneRoute({List<PageRouteInfo>? children})
    : super(KycNotDoneRoute.name, initialChildren: children);

  static const String name = 'KycNotDoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const KycNotDoneScreen();
    },
  );
}

/// generated route for
/// [LanguageScreen]
class LanguageRoute extends PageRouteInfo<void> {
  const LanguageRoute({List<PageRouteInfo>? children})
    : super(LanguageRoute.name, initialChildren: children);

  static const String name = 'LanguageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguageScreen();
    },
  );
}

/// generated route for
/// [LearnAndEarnScreen]
class LearnAndEarnRoute extends PageRouteInfo<void> {
  const LearnAndEarnRoute({List<PageRouteInfo>? children})
    : super(LearnAndEarnRoute.name, initialChildren: children);

  static const String name = 'LearnAndEarnRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LearnAndEarnScreen();
    },
  );
}

/// generated route for
/// [LearningProgressScreen]
class LearningProgressRoute extends PageRouteInfo<void> {
  const LearningProgressRoute({List<PageRouteInfo>? children})
    : super(LearningProgressRoute.name, initialChildren: children);

  static const String name = 'LearningProgressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LearningProgressScreen();
    },
  );
}

/// generated route for
/// [LessonOnboardScreen]
class LessonOnboardRoute extends PageRouteInfo<LessonOnboardRouteArgs> {
  LessonOnboardRoute({
    Key? key,
    String title = '',
    required String lessonId,
    required LevelType levelType,
    List<PageRouteInfo>? children,
  }) : super(
         LessonOnboardRoute.name,
         args: LessonOnboardRouteArgs(
           key: key,
           title: title,
           lessonId: lessonId,
           levelType: levelType,
         ),
         initialChildren: children,
       );

  static const String name = 'LessonOnboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonOnboardRouteArgs>();
      return LessonOnboardScreen(
        key: args.key,
        title: args.title,
        lessonId: args.lessonId,
        levelType: args.levelType,
      );
    },
  );
}

class LessonOnboardRouteArgs {
  const LessonOnboardRouteArgs({
    this.key,
    this.title = '',
    required this.lessonId,
    required this.levelType,
  });

  final Key? key;

  final String title;

  final String lessonId;

  final LevelType levelType;

  @override
  String toString() {
    return 'LessonOnboardRouteArgs{key: $key, title: $title, lessonId: $lessonId, levelType: $levelType}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LessonOnboardRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        lessonId == other.lessonId &&
        levelType == other.levelType;
  }

  @override
  int get hashCode =>
      key.hashCode ^ title.hashCode ^ lessonId.hashCode ^ levelType.hashCode;
}

/// generated route for
/// [LessonScreen]
class LessonRoute extends PageRouteInfo<LessonRouteArgs> {
  LessonRoute({
    Key? key,
    required LevelType levelType,
    String? pathTitle,
    List<PageRouteInfo>? children,
  }) : super(
         LessonRoute.name,
         args: LessonRouteArgs(
           key: key,
           levelType: levelType,
           pathTitle: pathTitle,
         ),
         initialChildren: children,
       );

  static const String name = 'LessonRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LessonRouteArgs>();
      return LessonScreen(
        key: args.key,
        levelType: args.levelType,
        pathTitle: args.pathTitle,
      );
    },
  );
}

class LessonRouteArgs {
  const LessonRouteArgs({this.key, required this.levelType, this.pathTitle});

  final Key? key;

  final LevelType levelType;

  final String? pathTitle;

  @override
  String toString() {
    return 'LessonRouteArgs{key: $key, levelType: $levelType, pathTitle: $pathTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LessonRouteArgs) return false;
    return key == other.key &&
        levelType == other.levelType &&
        pathTitle == other.pathTitle;
  }

  @override
  int get hashCode => key.hashCode ^ levelType.hashCode ^ pathTitle.hashCode;
}

/// generated route for
/// [MainActivityScreen]
class MainActivityRoute extends PageRouteInfo<void> {
  const MainActivityRoute({List<PageRouteInfo>? children})
    : super(MainActivityRoute.name, initialChildren: children);

  static const String name = 'MainActivityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainActivityScreen();
    },
  );
}

/// generated route for
/// [ManageSubscriptionScreen]
class ManageSubscriptionRoute extends PageRouteInfo<void> {
  const ManageSubscriptionRoute({List<PageRouteInfo>? children})
    : super(ManageSubscriptionRoute.name, initialChildren: children);

  static const String name = 'ManageSubscriptionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManageSubscriptionScreen();
    },
  );
}

/// generated route for
/// [MobileMoneyScreen]
class MobileMoneyRoute extends PageRouteInfo<MobileMoneyRouteArgs> {
  MobileMoneyRoute({
    Key? key,
    required String phoneNumber,
    required String accountName,
    required String selectedNetwork,
    required String selectedImage,
    List<PageRouteInfo>? children,
  }) : super(
         MobileMoneyRoute.name,
         args: MobileMoneyRouteArgs(
           key: key,
           phoneNumber: phoneNumber,
           accountName: accountName,
           selectedNetwork: selectedNetwork,
           selectedImage: selectedImage,
         ),
         initialChildren: children,
       );

  static const String name = 'MobileMoneyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MobileMoneyRouteArgs>();
      return MobileMoneyScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        accountName: args.accountName,
        selectedNetwork: args.selectedNetwork,
        selectedImage: args.selectedImage,
      );
    },
  );
}

class MobileMoneyRouteArgs {
  const MobileMoneyRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.accountName,
    required this.selectedNetwork,
    required this.selectedImage,
  });

  final Key? key;

  final String phoneNumber;

  final String accountName;

  final String selectedNetwork;

  final String selectedImage;

  @override
  String toString() {
    return 'MobileMoneyRouteArgs{key: $key, phoneNumber: $phoneNumber, accountName: $accountName, selectedNetwork: $selectedNetwork, selectedImage: $selectedImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MobileMoneyRouteArgs) return false;
    return key == other.key &&
        phoneNumber == other.phoneNumber &&
        accountName == other.accountName &&
        selectedNetwork == other.selectedNetwork &&
        selectedImage == other.selectedImage;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneNumber.hashCode ^
      accountName.hashCode ^
      selectedNetwork.hashCode ^
      selectedImage.hashCode;
}

/// generated route for
/// [MyPathsScreen]
class MyPathsRoute extends PageRouteInfo<void> {
  const MyPathsRoute({List<PageRouteInfo>? children})
    : super(MyPathsRoute.name, initialChildren: children);

  static const String name = 'MyPathsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyPathsScreen();
    },
  );
}

/// generated route for
/// [NativeAdScreen]
class NativeAdRoute extends PageRouteInfo<void> {
  const NativeAdRoute({List<PageRouteInfo>? children})
    : super(NativeAdRoute.name, initialChildren: children);

  static const String name = 'NativeAdRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NativeAdScreen();
    },
  );
}

/// generated route for
/// [NotificationDetailScreen]
class NotificationDetailRoute
    extends PageRouteInfo<NotificationDetailRouteArgs> {
  NotificationDetailRoute({
    Key? key,
    required NotificationModel notification,
    List<PageRouteInfo>? children,
  }) : super(
         NotificationDetailRoute.name,
         args: NotificationDetailRouteArgs(
           key: key,
           notification: notification,
         ),
         initialChildren: children,
       );

  static const String name = 'NotificationDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotificationDetailRouteArgs>();
      return NotificationDetailScreen(
        key: args.key,
        notification: args.notification,
      );
    },
  );
}

class NotificationDetailRouteArgs {
  const NotificationDetailRouteArgs({this.key, required this.notification});

  final Key? key;

  final NotificationModel notification;

  @override
  String toString() {
    return 'NotificationDetailRouteArgs{key: $key, notification: $notification}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationDetailRouteArgs) return false;
    return key == other.key && notification == other.notification;
  }

  @override
  int get hashCode => key.hashCode ^ notification.hashCode;
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<NotificationsRouteArgs> {
  NotificationsRoute({
    Key? key,
    String? notificationId,
    List<PageRouteInfo>? children,
  }) : super(
         NotificationsRoute.name,
         args: NotificationsRouteArgs(key: key, notificationId: notificationId),
         initialChildren: children,
       );

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotificationsRouteArgs>(
        orElse: () => const NotificationsRouteArgs(),
      );
      return NotificationsScreen(
        key: args.key,
        notificationId: args.notificationId,
      );
    },
  );
}

class NotificationsRouteArgs {
  const NotificationsRouteArgs({this.key, this.notificationId});

  final Key? key;

  final String? notificationId;

  @override
  String toString() {
    return 'NotificationsRouteArgs{key: $key, notificationId: $notificationId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationsRouteArgs) return false;
    return key == other.key && notificationId == other.notificationId;
  }

  @override
  int get hashCode => key.hashCode ^ notificationId.hashCode;
}

/// generated route for
/// [OfframpAmountScreen]
class OfframpAmountRoute extends PageRouteInfo<OfframpAmountRouteArgs> {
  OfframpAmountRoute({
    Key? key,
    required String paymentChannel,
    required OffRampDetailsParam? offrampDetailsParam,
    List<PageRouteInfo>? children,
  }) : super(
         OfframpAmountRoute.name,
         args: OfframpAmountRouteArgs(
           key: key,
           paymentChannel: paymentChannel,
           offrampDetailsParam: offrampDetailsParam,
         ),
         initialChildren: children,
       );

  static const String name = 'OfframpAmountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfframpAmountRouteArgs>();
      return OfframpAmountScreen(
        key: args.key,
        paymentChannel: args.paymentChannel,
        offrampDetailsParam: args.offrampDetailsParam,
      );
    },
  );
}

class OfframpAmountRouteArgs {
  const OfframpAmountRouteArgs({
    this.key,
    required this.paymentChannel,
    required this.offrampDetailsParam,
  });

  final Key? key;

  final String paymentChannel;

  final OffRampDetailsParam? offrampDetailsParam;

  @override
  String toString() {
    return 'OfframpAmountRouteArgs{key: $key, paymentChannel: $paymentChannel, offrampDetailsParam: $offrampDetailsParam}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfframpAmountRouteArgs) return false;
    return key == other.key &&
        paymentChannel == other.paymentChannel &&
        offrampDetailsParam == other.offrampDetailsParam;
  }

  @override
  int get hashCode =>
      key.hashCode ^ paymentChannel.hashCode ^ offrampDetailsParam.hashCode;
}

/// generated route for
/// [OfframpConfirmationScreen]
class OfframpConfirmationRoute
    extends PageRouteInfo<OfframpConfirmationRouteArgs> {
  OfframpConfirmationRoute({
    Key? key,
    required String recipientNumber,
    required double amountUsdt,
    required double amountToReceive,
    required double exchangeRate,
    required String paymentChannel,
    required String localCurrency,
    String? carrierName,
    StoreOffRampScreenTranscientData? offrampData,
    List<PageRouteInfo>? children,
  }) : super(
         OfframpConfirmationRoute.name,
         args: OfframpConfirmationRouteArgs(
           key: key,
           recipientNumber: recipientNumber,
           amountUsdt: amountUsdt,
           amountToReceive: amountToReceive,
           exchangeRate: exchangeRate,
           paymentChannel: paymentChannel,
           localCurrency: localCurrency,
           carrierName: carrierName,
           offrampData: offrampData,
         ),
         initialChildren: children,
       );

  static const String name = 'OfframpConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfframpConfirmationRouteArgs>();
      return OfframpConfirmationScreen(
        key: args.key,
        recipientNumber: args.recipientNumber,
        amountUsdt: args.amountUsdt,
        amountToReceive: args.amountToReceive,
        exchangeRate: args.exchangeRate,
        paymentChannel: args.paymentChannel,
        localCurrency: args.localCurrency,
        carrierName: args.carrierName,
        offrampData: args.offrampData,
      );
    },
  );
}

class OfframpConfirmationRouteArgs {
  const OfframpConfirmationRouteArgs({
    this.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    this.carrierName,
    this.offrampData,
  });

  final Key? key;

  final String recipientNumber;

  final double amountUsdt;

  final double amountToReceive;

  final double exchangeRate;

  final String paymentChannel;

  final String localCurrency;

  final String? carrierName;

  final StoreOffRampScreenTranscientData? offrampData;

  @override
  String toString() {
    return 'OfframpConfirmationRouteArgs{key: $key, recipientNumber: $recipientNumber, amountUsdt: $amountUsdt, amountToReceive: $amountToReceive, exchangeRate: $exchangeRate, paymentChannel: $paymentChannel, localCurrency: $localCurrency, carrierName: $carrierName, offrampData: $offrampData}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfframpConfirmationRouteArgs) return false;
    return key == other.key &&
        recipientNumber == other.recipientNumber &&
        amountUsdt == other.amountUsdt &&
        amountToReceive == other.amountToReceive &&
        exchangeRate == other.exchangeRate &&
        paymentChannel == other.paymentChannel &&
        localCurrency == other.localCurrency &&
        carrierName == other.carrierName &&
        offrampData == other.offrampData;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      recipientNumber.hashCode ^
      amountUsdt.hashCode ^
      amountToReceive.hashCode ^
      exchangeRate.hashCode ^
      paymentChannel.hashCode ^
      localCurrency.hashCode ^
      carrierName.hashCode ^
      offrampData.hashCode;
}

/// generated route for
/// [OfframpLoaderScreen]
class OfframpLoaderRoute extends PageRouteInfo<OfframpLoaderRouteArgs> {
  OfframpLoaderRoute({
    Key? key,
    required String recipientNumber,
    required double amountUsdt,
    required double amountToReceive,
    required double exchangeRate,
    required String paymentChannel,
    required String localCurrency,
    required StoreOffRampScreenTranscientData offrampData,
    String? carrierName,
    List<PageRouteInfo>? children,
  }) : super(
         OfframpLoaderRoute.name,
         args: OfframpLoaderRouteArgs(
           key: key,
           recipientNumber: recipientNumber,
           amountUsdt: amountUsdt,
           amountToReceive: amountToReceive,
           exchangeRate: exchangeRate,
           paymentChannel: paymentChannel,
           localCurrency: localCurrency,
           offrampData: offrampData,
           carrierName: carrierName,
         ),
         initialChildren: children,
       );

  static const String name = 'OfframpLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfframpLoaderRouteArgs>();
      return OfframpLoaderScreen(
        key: args.key,
        recipientNumber: args.recipientNumber,
        amountUsdt: args.amountUsdt,
        amountToReceive: args.amountToReceive,
        exchangeRate: args.exchangeRate,
        paymentChannel: args.paymentChannel,
        localCurrency: args.localCurrency,
        offrampData: args.offrampData,
        carrierName: args.carrierName,
      );
    },
  );
}

class OfframpLoaderRouteArgs {
  const OfframpLoaderRouteArgs({
    this.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.offrampData,
    this.carrierName,
  });

  final Key? key;

  final String recipientNumber;

  final double amountUsdt;

  final double amountToReceive;

  final double exchangeRate;

  final String paymentChannel;

  final String localCurrency;

  final StoreOffRampScreenTranscientData offrampData;

  final String? carrierName;

  @override
  String toString() {
    return 'OfframpLoaderRouteArgs{key: $key, recipientNumber: $recipientNumber, amountUsdt: $amountUsdt, amountToReceive: $amountToReceive, exchangeRate: $exchangeRate, paymentChannel: $paymentChannel, localCurrency: $localCurrency, offrampData: $offrampData, carrierName: $carrierName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfframpLoaderRouteArgs) return false;
    return key == other.key &&
        recipientNumber == other.recipientNumber &&
        amountUsdt == other.amountUsdt &&
        amountToReceive == other.amountToReceive &&
        exchangeRate == other.exchangeRate &&
        paymentChannel == other.paymentChannel &&
        localCurrency == other.localCurrency &&
        offrampData == other.offrampData &&
        carrierName == other.carrierName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      recipientNumber.hashCode ^
      amountUsdt.hashCode ^
      amountToReceive.hashCode ^
      exchangeRate.hashCode ^
      paymentChannel.hashCode ^
      localCurrency.hashCode ^
      offrampData.hashCode ^
      carrierName.hashCode;
}

/// generated route for
/// [OfframpScreen]
class OfframpRoute extends PageRouteInfo<void> {
  const OfframpRoute({List<PageRouteInfo>? children})
    : super(OfframpRoute.name, initialChildren: children);

  static const String name = 'OfframpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OfframpScreen();
    },
  );
}

/// generated route for
/// [OfframpSuccessScreen]
class OfframpSuccessRoute extends PageRouteInfo<OfframpSuccessRouteArgs> {
  OfframpSuccessRoute({
    Key? key,
    required String recipientNumber,
    required double amountUsdt,
    required double amountToReceive,
    required double exchangeRate,
    required String paymentChannel,
    required String localCurrency,
    required String orderId,
    required String depositAddress,
    String? carrierName,
    List<PageRouteInfo>? children,
  }) : super(
         OfframpSuccessRoute.name,
         args: OfframpSuccessRouteArgs(
           key: key,
           recipientNumber: recipientNumber,
           amountUsdt: amountUsdt,
           amountToReceive: amountToReceive,
           exchangeRate: exchangeRate,
           paymentChannel: paymentChannel,
           localCurrency: localCurrency,
           orderId: orderId,
           depositAddress: depositAddress,
           carrierName: carrierName,
         ),
         initialChildren: children,
       );

  static const String name = 'OfframpSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfframpSuccessRouteArgs>();
      return OfframpSuccessScreen(
        key: args.key,
        recipientNumber: args.recipientNumber,
        amountUsdt: args.amountUsdt,
        amountToReceive: args.amountToReceive,
        exchangeRate: args.exchangeRate,
        paymentChannel: args.paymentChannel,
        localCurrency: args.localCurrency,
        orderId: args.orderId,
        depositAddress: args.depositAddress,
        carrierName: args.carrierName,
      );
    },
  );
}

class OfframpSuccessRouteArgs {
  const OfframpSuccessRouteArgs({
    this.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.orderId,
    required this.depositAddress,
    this.carrierName,
  });

  final Key? key;

  final String recipientNumber;

  final double amountUsdt;

  final double amountToReceive;

  final double exchangeRate;

  final String paymentChannel;

  final String localCurrency;

  final String orderId;

  final String depositAddress;

  final String? carrierName;

  @override
  String toString() {
    return 'OfframpSuccessRouteArgs{key: $key, recipientNumber: $recipientNumber, amountUsdt: $amountUsdt, amountToReceive: $amountToReceive, exchangeRate: $exchangeRate, paymentChannel: $paymentChannel, localCurrency: $localCurrency, orderId: $orderId, depositAddress: $depositAddress, carrierName: $carrierName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfframpSuccessRouteArgs) return false;
    return key == other.key &&
        recipientNumber == other.recipientNumber &&
        amountUsdt == other.amountUsdt &&
        amountToReceive == other.amountToReceive &&
        exchangeRate == other.exchangeRate &&
        paymentChannel == other.paymentChannel &&
        localCurrency == other.localCurrency &&
        orderId == other.orderId &&
        depositAddress == other.depositAddress &&
        carrierName == other.carrierName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      recipientNumber.hashCode ^
      amountUsdt.hashCode ^
      amountToReceive.hashCode ^
      exchangeRate.hashCode ^
      paymentChannel.hashCode ^
      localCurrency.hashCode ^
      orderId.hashCode ^
      depositAddress.hashCode ^
      carrierName.hashCode;
}

/// generated route for
/// [OfframpVerificationScreen]
class OfframpVerificationRoute
    extends PageRouteInfo<OfframpVerificationRouteArgs> {
  OfframpVerificationRoute({
    Key? key,
    required String recipientNumber,
    required double amountUsdt,
    required double amountToReceive,
    required double exchangeRate,
    required String paymentChannel,
    required String localCurrency,
    required StoreOffRampScreenTranscientData offrampData,
    String? carrierName,
    List<PageRouteInfo>? children,
  }) : super(
         OfframpVerificationRoute.name,
         args: OfframpVerificationRouteArgs(
           key: key,
           recipientNumber: recipientNumber,
           amountUsdt: amountUsdt,
           amountToReceive: amountToReceive,
           exchangeRate: exchangeRate,
           paymentChannel: paymentChannel,
           localCurrency: localCurrency,
           offrampData: offrampData,
           carrierName: carrierName,
         ),
         initialChildren: children,
       );

  static const String name = 'OfframpVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OfframpVerificationRouteArgs>();
      return OfframpVerificationScreen(
        key: args.key,
        recipientNumber: args.recipientNumber,
        amountUsdt: args.amountUsdt,
        amountToReceive: args.amountToReceive,
        exchangeRate: args.exchangeRate,
        paymentChannel: args.paymentChannel,
        localCurrency: args.localCurrency,
        offrampData: args.offrampData,
        carrierName: args.carrierName,
      );
    },
  );
}

class OfframpVerificationRouteArgs {
  const OfframpVerificationRouteArgs({
    this.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.offrampData,
    this.carrierName,
  });

  final Key? key;

  final String recipientNumber;

  final double amountUsdt;

  final double amountToReceive;

  final double exchangeRate;

  final String paymentChannel;

  final String localCurrency;

  final StoreOffRampScreenTranscientData offrampData;

  final String? carrierName;

  @override
  String toString() {
    return 'OfframpVerificationRouteArgs{key: $key, recipientNumber: $recipientNumber, amountUsdt: $amountUsdt, amountToReceive: $amountToReceive, exchangeRate: $exchangeRate, paymentChannel: $paymentChannel, localCurrency: $localCurrency, offrampData: $offrampData, carrierName: $carrierName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OfframpVerificationRouteArgs) return false;
    return key == other.key &&
        recipientNumber == other.recipientNumber &&
        amountUsdt == other.amountUsdt &&
        amountToReceive == other.amountToReceive &&
        exchangeRate == other.exchangeRate &&
        paymentChannel == other.paymentChannel &&
        localCurrency == other.localCurrency &&
        offrampData == other.offrampData &&
        carrierName == other.carrierName;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      recipientNumber.hashCode ^
      amountUsdt.hashCode ^
      amountToReceive.hashCode ^
      exchangeRate.hashCode ^
      paymentChannel.hashCode ^
      localCurrency.hashCode ^
      offrampData.hashCode ^
      carrierName.hashCode;
}

/// generated route for
/// [OnBoardingScreen]
class OnBoardingRoute extends PageRouteInfo<void> {
  const OnBoardingRoute({List<PageRouteInfo>? children})
    : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnBoardingScreen();
    },
  );
}

/// generated route for
/// [OnboardingInitialScreen]
class OnboardingInitialRoute extends PageRouteInfo<void> {
  const OnboardingInitialRoute({List<PageRouteInfo>? children})
    : super(OnboardingInitialRoute.name, initialChildren: children);

  static const String name = 'OnboardingInitialRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingInitialScreen();
    },
  );
}

/// generated route for
/// [OnlineOpponentScreen]
class OnlineOpponentRoute extends PageRouteInfo<OnlineOpponentRouteArgs> {
  OnlineOpponentRoute({
    Key? key,
    bool autoStartCountdown = false,
    List<PageRouteInfo>? children,
  }) : super(
         OnlineOpponentRoute.name,
         args: OnlineOpponentRouteArgs(
           key: key,
           autoStartCountdown: autoStartCountdown,
         ),
         initialChildren: children,
       );

  static const String name = 'OnlineOpponentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnlineOpponentRouteArgs>(
        orElse: () => const OnlineOpponentRouteArgs(),
      );
      return OnlineOpponentScreen(
        key: args.key,
        autoStartCountdown: args.autoStartCountdown,
      );
    },
  );
}

class OnlineOpponentRouteArgs {
  const OnlineOpponentRouteArgs({this.key, this.autoStartCountdown = false});

  final Key? key;

  final bool autoStartCountdown;

  @override
  String toString() {
    return 'OnlineOpponentRouteArgs{key: $key, autoStartCountdown: $autoStartCountdown}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnlineOpponentRouteArgs) return false;
    return key == other.key && autoStartCountdown == other.autoStartCountdown;
  }

  @override
  int get hashCode => key.hashCode ^ autoStartCountdown.hashCode;
}

/// generated route for
/// [OnrampDepositConfirmationScreen]
class OnrampDepositConfirmationRoute
    extends PageRouteInfo<OnrampDepositConfirmationRouteArgs> {
  OnrampDepositConfirmationRoute({
    Key? key,
    required String phoneNumber,
    required String fullName,
    required String paymentChannel,
    required double fiatAmount,
    required double usdtAmount,
    required double exchangeRate,
    required double feeAmount,
    required String localCurrencyCode,
    required String localCurrencySymbol,
    required String countryCode,
    required String quoteId,
    String carrierCode = '',
    String carrierName = '',
    String bankCode = '',
    String bankAccountNumber = '',
    List<PageRouteInfo>? children,
  }) : super(
         OnrampDepositConfirmationRoute.name,
         args: OnrampDepositConfirmationRouteArgs(
           key: key,
           phoneNumber: phoneNumber,
           fullName: fullName,
           paymentChannel: paymentChannel,
           fiatAmount: fiatAmount,
           usdtAmount: usdtAmount,
           exchangeRate: exchangeRate,
           feeAmount: feeAmount,
           localCurrencyCode: localCurrencyCode,
           localCurrencySymbol: localCurrencySymbol,
           countryCode: countryCode,
           quoteId: quoteId,
           carrierCode: carrierCode,
           carrierName: carrierName,
           bankCode: bankCode,
           bankAccountNumber: bankAccountNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'OnrampDepositConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnrampDepositConfirmationRouteArgs>();
      return OnrampDepositConfirmationScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        fullName: args.fullName,
        paymentChannel: args.paymentChannel,
        fiatAmount: args.fiatAmount,
        usdtAmount: args.usdtAmount,
        exchangeRate: args.exchangeRate,
        feeAmount: args.feeAmount,
        localCurrencyCode: args.localCurrencyCode,
        localCurrencySymbol: args.localCurrencySymbol,
        countryCode: args.countryCode,
        quoteId: args.quoteId,
        carrierCode: args.carrierCode,
        carrierName: args.carrierName,
        bankCode: args.bankCode,
        bankAccountNumber: args.bankAccountNumber,
      );
    },
  );
}

class OnrampDepositConfirmationRouteArgs {
  const OnrampDepositConfirmationRouteArgs({
    this.key,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
  });

  final Key? key;

  final String phoneNumber;

  final String fullName;

  final String paymentChannel;

  final double fiatAmount;

  final double usdtAmount;

  final double exchangeRate;

  final double feeAmount;

  final String localCurrencyCode;

  final String localCurrencySymbol;

  final String countryCode;

  final String quoteId;

  final String carrierCode;

  final String carrierName;

  final String bankCode;

  final String bankAccountNumber;

  @override
  String toString() {
    return 'OnrampDepositConfirmationRouteArgs{key: $key, phoneNumber: $phoneNumber, fullName: $fullName, paymentChannel: $paymentChannel, fiatAmount: $fiatAmount, usdtAmount: $usdtAmount, exchangeRate: $exchangeRate, feeAmount: $feeAmount, localCurrencyCode: $localCurrencyCode, localCurrencySymbol: $localCurrencySymbol, countryCode: $countryCode, quoteId: $quoteId, carrierCode: $carrierCode, carrierName: $carrierName, bankCode: $bankCode, bankAccountNumber: $bankAccountNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnrampDepositConfirmationRouteArgs) return false;
    return key == other.key &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        paymentChannel == other.paymentChannel &&
        fiatAmount == other.fiatAmount &&
        usdtAmount == other.usdtAmount &&
        exchangeRate == other.exchangeRate &&
        feeAmount == other.feeAmount &&
        localCurrencyCode == other.localCurrencyCode &&
        localCurrencySymbol == other.localCurrencySymbol &&
        countryCode == other.countryCode &&
        quoteId == other.quoteId &&
        carrierCode == other.carrierCode &&
        carrierName == other.carrierName &&
        bankCode == other.bankCode &&
        bankAccountNumber == other.bankAccountNumber;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneNumber.hashCode ^
      fullName.hashCode ^
      paymentChannel.hashCode ^
      fiatAmount.hashCode ^
      usdtAmount.hashCode ^
      exchangeRate.hashCode ^
      feeAmount.hashCode ^
      localCurrencyCode.hashCode ^
      localCurrencySymbol.hashCode ^
      countryCode.hashCode ^
      quoteId.hashCode ^
      carrierCode.hashCode ^
      carrierName.hashCode ^
      bankCode.hashCode ^
      bankAccountNumber.hashCode;
}

/// generated route for
/// [PassphraseScreen]
class PassphraseRoute extends PageRouteInfo<void> {
  const PassphraseRoute({List<PageRouteInfo>? children})
    : super(PassphraseRoute.name, initialChildren: children);

  static const String name = 'PassphraseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PassphraseScreen();
    },
  );
}

/// generated route for
/// [PathCoursesScreen]
class PathCoursesRoute extends PageRouteInfo<PathCoursesRouteArgs> {
  PathCoursesRoute({
    Key? key,
    required String learningPathId,
    required String pathTitle,
    List<PageRouteInfo>? children,
  }) : super(
         PathCoursesRoute.name,
         args: PathCoursesRouteArgs(
           key: key,
           learningPathId: learningPathId,
           pathTitle: pathTitle,
         ),
         initialChildren: children,
       );

  static const String name = 'PathCoursesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PathCoursesRouteArgs>();
      return PathCoursesScreen(
        key: args.key,
        learningPathId: args.learningPathId,
        pathTitle: args.pathTitle,
      );
    },
  );
}

class PathCoursesRouteArgs {
  const PathCoursesRouteArgs({
    this.key,
    required this.learningPathId,
    required this.pathTitle,
  });

  final Key? key;

  final String learningPathId;

  final String pathTitle;

  @override
  String toString() {
    return 'PathCoursesRouteArgs{key: $key, learningPathId: $learningPathId, pathTitle: $pathTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PathCoursesRouteArgs) return false;
    return key == other.key &&
        learningPathId == other.learningPathId &&
        pathTitle == other.pathTitle;
  }

  @override
  int get hashCode =>
      key.hashCode ^ learningPathId.hashCode ^ pathTitle.hashCode;
}

/// generated route for
/// [PayWallScreen]
class PayWallRoute extends PageRouteInfo<void> {
  const PayWallRoute({List<PageRouteInfo>? children})
    : super(PayWallRoute.name, initialChildren: children);

  static const String name = 'PayWallRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PayWallScreen();
    },
  );
}

/// generated route for
/// [PlayInGroupScreen]
class PlayInGroupRoute extends PageRouteInfo<PlayInGroupRouteArgs> {
  PlayInGroupRoute({
    Key? key,
    bool autoStartCountdown = false,
    List<PageRouteInfo>? children,
  }) : super(
         PlayInGroupRoute.name,
         args: PlayInGroupRouteArgs(
           key: key,
           autoStartCountdown: autoStartCountdown,
         ),
         initialChildren: children,
       );

  static const String name = 'PlayInGroupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlayInGroupRouteArgs>(
        orElse: () => const PlayInGroupRouteArgs(),
      );
      return PlayInGroupScreen(
        key: args.key,
        autoStartCountdown: args.autoStartCountdown,
      );
    },
  );
}

class PlayInGroupRouteArgs {
  const PlayInGroupRouteArgs({this.key, this.autoStartCountdown = false});

  final Key? key;

  final bool autoStartCountdown;

  @override
  String toString() {
    return 'PlayInGroupRouteArgs{key: $key, autoStartCountdown: $autoStartCountdown}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayInGroupRouteArgs) return false;
    return key == other.key && autoStartCountdown == other.autoStartCountdown;
  }

  @override
  int get hashCode => key.hashCode ^ autoStartCountdown.hashCode;
}

/// generated route for
/// [PlayWithBotScreen]
class PlayWithBotRoute extends PageRouteInfo<void> {
  const PlayWithBotRoute({List<PageRouteInfo>? children})
    : super(PlayWithBotRoute.name, initialChildren: children);

  static const String name = 'PlayWithBotRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlayWithBotScreen();
    },
  );
}

/// generated route for
/// [PlayWithFriendEntryScreen]
class PlayWithFriendEntryRoute extends PageRouteInfo<void> {
  const PlayWithFriendEntryRoute({List<PageRouteInfo>? children})
    : super(PlayWithFriendEntryRoute.name, initialChildren: children);

  static const String name = 'PlayWithFriendEntryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PlayWithFriendEntryScreen();
    },
  );
}

/// generated route for
/// [PreferenceScreen]
class PreferenceRoute extends PageRouteInfo<void> {
  const PreferenceRoute({List<PageRouteInfo>? children})
    : super(PreferenceRoute.name, initialChildren: children);

  static const String name = 'PreferenceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PreferenceScreen();
    },
  );
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [QuizGemsEarnedScreen]
class QuizGemsEarnedRoute extends PageRouteInfo<void> {
  const QuizGemsEarnedRoute({List<PageRouteInfo>? children})
    : super(QuizGemsEarnedRoute.name, initialChildren: children);

  static const String name = 'QuizGemsEarnedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizGemsEarnedScreen();
    },
  );
}

/// generated route for
/// [QuizLoaderScreen]
class QuizLoaderRoute extends PageRouteInfo<QuizLoaderRouteArgs> {
  QuizLoaderRoute({
    Key? key,
    required String title,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
         QuizLoaderRoute.name,
         args: QuizLoaderRouteArgs(key: key, title: title, id: id),
         initialChildren: children,
       );

  static const String name = 'QuizLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizLoaderRouteArgs>();
      return QuizLoaderScreen(key: args.key, title: args.title, id: args.id);
    },
  );
}

class QuizLoaderRouteArgs {
  const QuizLoaderRouteArgs({this.key, required this.title, required this.id});

  final Key? key;

  final String title;

  final String id;

  @override
  String toString() {
    return 'QuizLoaderRouteArgs{key: $key, title: $title, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizLoaderRouteArgs) return false;
    return key == other.key && title == other.title && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ id.hashCode;
}

/// generated route for
/// [QuizOnboardScreen]
class QuizOnboardRoute extends PageRouteInfo<QuizOnboardRouteArgs> {
  QuizOnboardRoute({
    Key? key,
    String title = '',
    required String lessonId,
    List<PageRouteInfo>? children,
  }) : super(
         QuizOnboardRoute.name,
         args: QuizOnboardRouteArgs(key: key, title: title, lessonId: lessonId),
         initialChildren: children,
       );

  static const String name = 'QuizOnboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizOnboardRouteArgs>();
      return QuizOnboardScreen(
        key: args.key,
        title: args.title,
        lessonId: args.lessonId,
      );
    },
  );
}

class QuizOnboardRouteArgs {
  const QuizOnboardRouteArgs({
    this.key,
    this.title = '',
    required this.lessonId,
  });

  final Key? key;

  final String title;

  final String lessonId;

  @override
  String toString() {
    return 'QuizOnboardRouteArgs{key: $key, title: $title, lessonId: $lessonId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizOnboardRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        lessonId == other.lessonId;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ lessonId.hashCode;
}

/// generated route for
/// [QuizResultScreen]
class QuizResultRoute extends PageRouteInfo<void> {
  const QuizResultRoute({List<PageRouteInfo>? children})
    : super(QuizResultRoute.name, initialChildren: children);

  static const String name = 'QuizResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizResultScreen();
    },
  );
}

/// generated route for
/// [QuizReviewScreen]
class QuizReviewRoute extends PageRouteInfo<void> {
  const QuizReviewRoute({List<PageRouteInfo>? children})
    : super(QuizReviewRoute.name, initialChildren: children);

  static const String name = 'QuizReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizReviewScreen();
    },
  );
}

/// generated route for
/// [QuizScreen]
class QuizRoute extends PageRouteInfo<QuizRouteArgs> {
  QuizRoute({
    Key? key,
    required String quizTitle,
    List<PageRouteInfo>? children,
  }) : super(
         QuizRoute.name,
         args: QuizRouteArgs(key: key, quizTitle: quizTitle),
         initialChildren: children,
       );

  static const String name = 'QuizRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizRouteArgs>();
      return QuizScreen(key: args.key, quizTitle: args.quizTitle);
    },
  );
}

class QuizRouteArgs {
  const QuizRouteArgs({this.key, required this.quizTitle});

  final Key? key;

  final String quizTitle;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, quizTitle: $quizTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizRouteArgs) return false;
    return key == other.key && quizTitle == other.quizTitle;
  }

  @override
  int get hashCode => key.hashCode ^ quizTitle.hashCode;
}

/// generated route for
/// [QuizSubmitScreen]
class QuizSubmitRoute extends PageRouteInfo<QuizSubmitRouteArgs> {
  QuizSubmitRoute({
    Key? key,
    required String quizId,
    List<PageRouteInfo>? children,
  }) : super(
         QuizSubmitRoute.name,
         args: QuizSubmitRouteArgs(key: key, quizId: quizId),
         initialChildren: children,
       );

  static const String name = 'QuizSubmitRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizSubmitRouteArgs>();
      return QuizSubmitScreen(key: args.key, quizId: args.quizId);
    },
  );
}

class QuizSubmitRouteArgs {
  const QuizSubmitRouteArgs({this.key, required this.quizId});

  final Key? key;

  final String quizId;

  @override
  String toString() {
    return 'QuizSubmitRouteArgs{key: $key, quizId: $quizId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuizSubmitRouteArgs) return false;
    return key == other.key && quizId == other.quizId;
  }

  @override
  int get hashCode => key.hashCode ^ quizId.hashCode;
}

/// generated route for
/// [QuizXPEarnedScreen]
class QuizXPEarnedRoute extends PageRouteInfo<void> {
  const QuizXPEarnedRoute({List<PageRouteInfo>? children})
    : super(QuizXPEarnedRoute.name, initialChildren: children);

  static const String name = 'QuizXPEarnedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QuizXPEarnedScreen();
    },
  );
}

/// generated route for
/// [ReceiveScreen]
class ReceiveRoute extends PageRouteInfo<void> {
  const ReceiveRoute({List<PageRouteInfo>? children})
    : super(ReceiveRoute.name, initialChildren: children);

  static const String name = 'ReceiveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReceiveScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [ReportProblemScreen]
class ReportProblemRoute extends PageRouteInfo<void> {
  const ReportProblemRoute({List<PageRouteInfo>? children})
    : super(ReportProblemRoute.name, initialChildren: children);

  static const String name = 'ReportProblemRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReportProblemScreen();
    },
  );
}

/// generated route for
/// [RouteLoaderScreen]
class RouteLoaderRoute extends PageRouteInfo<RouteLoaderRouteArgs> {
  RouteLoaderRoute({
    Key? key,
    String? title,
    String? lessonId,
    LevelType? levelType,
    String? lessonImage,
    List<PageRouteInfo>? children,
  }) : super(
         RouteLoaderRoute.name,
         args: RouteLoaderRouteArgs(
           key: key,
           title: title,
           lessonId: lessonId,
           levelType: levelType,
           lessonImage: lessonImage,
         ),
         initialChildren: children,
       );

  static const String name = 'RouteLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RouteLoaderRouteArgs>(
        orElse: () => const RouteLoaderRouteArgs(),
      );
      return RouteLoaderScreen(
        key: args.key,
        title: args.title,
        lessonId: args.lessonId,
        levelType: args.levelType,
        lessonImage: args.lessonImage,
      );
    },
  );
}

class RouteLoaderRouteArgs {
  const RouteLoaderRouteArgs({
    this.key,
    this.title,
    this.lessonId,
    this.levelType,
    this.lessonImage,
  });

  final Key? key;

  final String? title;

  final String? lessonId;

  final LevelType? levelType;

  final String? lessonImage;

  @override
  String toString() {
    return 'RouteLoaderRouteArgs{key: $key, title: $title, lessonId: $lessonId, levelType: $levelType, lessonImage: $lessonImage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RouteLoaderRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        lessonId == other.lessonId &&
        levelType == other.levelType &&
        lessonImage == other.lessonImage;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      lessonId.hashCode ^
      levelType.hashCode ^
      lessonImage.hashCode;
}

/// generated route for
/// [SecurityScreen]
class SecurityRoute extends PageRouteInfo<void> {
  const SecurityRoute({List<PageRouteInfo>? children})
    : super(SecurityRoute.name, initialChildren: children);

  static const String name = 'SecurityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecurityScreen();
    },
  );
}

/// generated route for
/// [SelectAvatarScreen]
class SelectAvatarRoute extends PageRouteInfo<void> {
  const SelectAvatarRoute({List<PageRouteInfo>? children})
    : super(SelectAvatarRoute.name, initialChildren: children);

  static const String name = 'SelectAvatarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectAvatarScreen();
    },
  );
}

/// generated route for
/// [SendConfirmationScreen]
class SendConfirmationRoute extends PageRouteInfo<SendConfirmationRouteArgs> {
  SendConfirmationRoute({
    Key? key,
    required String recipientAddress,
    required String amount,
    List<PageRouteInfo>? children,
  }) : super(
         SendConfirmationRoute.name,
         args: SendConfirmationRouteArgs(
           key: key,
           recipientAddress: recipientAddress,
           amount: amount,
         ),
         initialChildren: children,
       );

  static const String name = 'SendConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendConfirmationRouteArgs>();
      return SendConfirmationScreen(
        key: args.key,
        recipientAddress: args.recipientAddress,
        amount: args.amount,
      );
    },
  );
}

class SendConfirmationRouteArgs {
  const SendConfirmationRouteArgs({
    this.key,
    required this.recipientAddress,
    required this.amount,
  });

  final Key? key;

  final String recipientAddress;

  final String amount;

  @override
  String toString() {
    return 'SendConfirmationRouteArgs{key: $key, recipientAddress: $recipientAddress, amount: $amount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SendConfirmationRouteArgs) return false;
    return key == other.key &&
        recipientAddress == other.recipientAddress &&
        amount == other.amount;
  }

  @override
  int get hashCode =>
      key.hashCode ^ recipientAddress.hashCode ^ amount.hashCode;
}

/// generated route for
/// [SendLoaderScreen]
class SendLoaderRoute extends PageRouteInfo<SendLoaderRouteArgs> {
  SendLoaderRoute({
    Key? key,
    String? title,
    String? recipientAddress,
    String? amount,
    List<PageRouteInfo>? children,
  }) : super(
         SendLoaderRoute.name,
         args: SendLoaderRouteArgs(
           key: key,
           title: title,
           recipientAddress: recipientAddress,
           amount: amount,
         ),
         initialChildren: children,
       );

  static const String name = 'SendLoaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendLoaderRouteArgs>(
        orElse: () => const SendLoaderRouteArgs(),
      );
      return SendLoaderScreen(
        key: args.key,
        title: args.title,
        recipientAddress: args.recipientAddress,
        amount: args.amount,
      );
    },
  );
}

class SendLoaderRouteArgs {
  const SendLoaderRouteArgs({
    this.key,
    this.title,
    this.recipientAddress,
    this.amount,
  });

  final Key? key;

  final String? title;

  final String? recipientAddress;

  final String? amount;

  @override
  String toString() {
    return 'SendLoaderRouteArgs{key: $key, title: $title, recipientAddress: $recipientAddress, amount: $amount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SendLoaderRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        recipientAddress == other.recipientAddress &&
        amount == other.amount;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      recipientAddress.hashCode ^
      amount.hashCode;
}

/// generated route for
/// [SendScreen]
class SendRoute extends PageRouteInfo<void> {
  const SendRoute({List<PageRouteInfo>? children})
    : super(SendRoute.name, initialChildren: children);

  static const String name = 'SendRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SendScreen();
    },
  );
}

/// generated route for
/// [SendSuccessScreen]
class SendSuccessRoute extends PageRouteInfo<SendSuccessRouteArgs> {
  SendSuccessRoute({
    Key? key,
    required String recipientAddress,
    required String amount,
    required String transactionHash,
    List<PageRouteInfo>? children,
  }) : super(
         SendSuccessRoute.name,
         args: SendSuccessRouteArgs(
           key: key,
           recipientAddress: recipientAddress,
           amount: amount,
           transactionHash: transactionHash,
         ),
         initialChildren: children,
       );

  static const String name = 'SendSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SendSuccessRouteArgs>();
      return SendSuccessScreen(
        key: args.key,
        recipientAddress: args.recipientAddress,
        amount: args.amount,
        transactionHash: args.transactionHash,
      );
    },
  );
}

class SendSuccessRouteArgs {
  const SendSuccessRouteArgs({
    this.key,
    required this.recipientAddress,
    required this.amount,
    required this.transactionHash,
  });

  final Key? key;

  final String recipientAddress;

  final String amount;

  final String transactionHash;

  @override
  String toString() {
    return 'SendSuccessRouteArgs{key: $key, recipientAddress: $recipientAddress, amount: $amount, transactionHash: $transactionHash}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SendSuccessRouteArgs) return false;
    return key == other.key &&
        recipientAddress == other.recipientAddress &&
        amount == other.amount &&
        transactionHash == other.transactionHash;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      recipientAddress.hashCode ^
      amount.hashCode ^
      transactionHash.hashCode;
}

/// generated route for
/// [SetUpAccountViewScreen]
class SetUpAccountViewRoute extends PageRouteInfo<void> {
  const SetUpAccountViewRoute({List<PageRouteInfo>? children})
    : super(SetUpAccountViewRoute.name, initialChildren: children);

  static const String name = 'SetUpAccountViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SetUpAccountViewScreen();
    },
  );
}

/// generated route for
/// [SetUpSuccessScreen]
class SetUpSuccessRoute extends PageRouteInfo<void> {
  const SetUpSuccessRoute({List<PageRouteInfo>? children})
    : super(SetUpSuccessRoute.name, initialChildren: children);

  static const String name = 'SetUpSuccessRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SetUpSuccessScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [StatisticsScreen]
class StatisticsRoute extends PageRouteInfo<void> {
  const StatisticsRoute({List<PageRouteInfo>? children})
    : super(StatisticsRoute.name, initialChildren: children);

  static const String name = 'StatisticsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StatisticsScreen();
    },
  );
}

/// generated route for
/// [SwapScreen]
class SwapRoute extends PageRouteInfo<void> {
  const SwapRoute({List<PageRouteInfo>? children})
    : super(SwapRoute.name, initialChildren: children);

  static const String name = 'SwapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SwapScreen();
    },
  );
}

/// generated route for
/// [TermsAndConditionScreen]
class TermsAndConditionRoute extends PageRouteInfo<TermsAndConditionRouteArgs> {
  TermsAndConditionRoute({
    Key? key,
    String? title,
    List<PageRouteInfo>? children,
  }) : super(
         TermsAndConditionRoute.name,
         args: TermsAndConditionRouteArgs(key: key, title: title),
         rawPathParams: {'title': title},
         initialChildren: children,
       );

  static const String name = 'TermsAndConditionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TermsAndConditionRouteArgs>(
        orElse: () =>
            TermsAndConditionRouteArgs(title: pathParams.optString('title')),
      );
      return TermsAndConditionScreen(key: args.key, title: args.title);
    },
  );
}

class TermsAndConditionRouteArgs {
  const TermsAndConditionRouteArgs({this.key, this.title});

  final Key? key;

  final String? title;

  @override
  String toString() {
    return 'TermsAndConditionRouteArgs{key: $key, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TermsAndConditionRouteArgs) return false;
    return key == other.key && title == other.title;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode;
}

/// generated route for
/// [TransactionVerifyOtpScreen]
class TransactionVerifyOtpRoute
    extends PageRouteInfo<TransactionVerifyOtpRouteArgs> {
  TransactionVerifyOtpRoute({
    Key? key,
    required String amount,
    required String recipientAddress,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionVerifyOtpRoute.name,
         args: TransactionVerifyOtpRouteArgs(
           key: key,
           amount: amount,
           recipientAddress: recipientAddress,
         ),
         initialChildren: children,
       );

  static const String name = 'TransactionVerifyOtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionVerifyOtpRouteArgs>();
      return TransactionVerifyOtpScreen(
        key: args.key,
        amount: args.amount,
        recipientAddress: args.recipientAddress,
      );
    },
  );
}

class TransactionVerifyOtpRouteArgs {
  const TransactionVerifyOtpRouteArgs({
    this.key,
    required this.amount,
    required this.recipientAddress,
  });

  final Key? key;

  final String amount;

  final String recipientAddress;

  @override
  String toString() {
    return 'TransactionVerifyOtpRouteArgs{key: $key, amount: $amount, recipientAddress: $recipientAddress}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionVerifyOtpRouteArgs) return false;
    return key == other.key &&
        amount == other.amount &&
        recipientAddress == other.recipientAddress;
  }

  @override
  int get hashCode =>
      key.hashCode ^ amount.hashCode ^ recipientAddress.hashCode;
}

/// generated route for
/// [UpcomingDetailsScreen]
class UpcomingDetailsRoute extends PageRouteInfo<UpcomingDetailsRouteArgs> {
  UpcomingDetailsRoute({
    Key? key,
    required Contest contest,
    List<PageRouteInfo>? children,
  }) : super(
         UpcomingDetailsRoute.name,
         args: UpcomingDetailsRouteArgs(key: key, contest: contest),
         initialChildren: children,
       );

  static const String name = 'UpcomingDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpcomingDetailsRouteArgs>();
      return UpcomingDetailsScreen(key: args.key, contest: args.contest);
    },
  );
}

class UpcomingDetailsRouteArgs {
  const UpcomingDetailsRouteArgs({this.key, required this.contest});

  final Key? key;

  final Contest contest;

  @override
  String toString() {
    return 'UpcomingDetailsRouteArgs{key: $key, contest: $contest}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UpcomingDetailsRouteArgs) return false;
    return key == other.key && contest == other.contest;
  }

  @override
  int get hashCode => key.hashCode ^ contest.hashCode;
}

/// generated route for
/// [UserNameScreen]
class UserNameRoute extends PageRouteInfo<void> {
  const UserNameRoute({List<PageRouteInfo>? children})
    : super(UserNameRoute.name, initialChildren: children);

  static const String name = 'UserNameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserNameScreen();
    },
  );
}

/// generated route for
/// [VerificationScreen]
class VerificationRoute extends PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    Key? key,
    required String sessionUrl,
    required String sessionId,
    dynamic Function(String, Map<String, dynamic>?)? onComplete,
    dynamic Function(String)? onError,
    List<PageRouteInfo>? children,
  }) : super(
         VerificationRoute.name,
         args: VerificationRouteArgs(
           key: key,
           sessionUrl: sessionUrl,
           sessionId: sessionId,
           onComplete: onComplete,
           onError: onError,
         ),
         initialChildren: children,
       );

  static const String name = 'VerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return VerificationScreen(
        key: args.key,
        sessionUrl: args.sessionUrl,
        sessionId: args.sessionId,
        onComplete: args.onComplete,
        onError: args.onError,
      );
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({
    this.key,
    required this.sessionUrl,
    required this.sessionId,
    this.onComplete,
    this.onError,
  });

  final Key? key;

  final String sessionUrl;

  final String sessionId;

  final dynamic Function(String, Map<String, dynamic>?)? onComplete;

  final dynamic Function(String)? onError;

  @override
  String toString() {
    return 'VerificationRouteArgs{key: $key, sessionUrl: $sessionUrl, sessionId: $sessionId, onComplete: $onComplete, onError: $onError}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerificationRouteArgs) return false;
    return key == other.key &&
        sessionUrl == other.sessionUrl &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode => key.hashCode ^ sessionUrl.hashCode ^ sessionId.hashCode;
}

/// generated route for
/// [VerifyEmailScreen]
class VerifyEmailRoute extends PageRouteInfo<void> {
  const VerifyEmailRoute({List<PageRouteInfo>? children})
    : super(VerifyEmailRoute.name, initialChildren: children);

  static const String name = 'VerifyEmailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VerifyEmailScreen();
    },
  );
}

/// generated route for
/// [VocabularyViewScreen]
class VocabularyViewRoute extends PageRouteInfo<void> {
  const VocabularyViewRoute({List<PageRouteInfo>? children})
    : super(VocabularyViewRoute.name, initialChildren: children);

  static const String name = 'VocabularyViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VocabularyViewScreen();
    },
  );
}

/// generated route for
/// [WelcomeToSetupScreen]
class WelcomeToSetupRoute extends PageRouteInfo<void> {
  const WelcomeToSetupRoute({List<PageRouteInfo>? children})
    : super(WelcomeToSetupRoute.name, initialChildren: children);

  static const String name = 'WelcomeToSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeToSetupScreen();
    },
  );
}
