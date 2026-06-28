class StatisticsModel {
  final int totalQuestionsAnswered;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalBattles;
  final int battlesWon;
  final int battlesLost;
  final int battlesDraw;
  final double totalXP;
  final List<MonthlyXPData> monthlyXPData;

  const StatisticsModel({
    required this.totalQuestionsAnswered,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalBattles,
    required this.battlesWon,
    required this.battlesLost,
    required this.battlesDraw,
    required this.totalXP,
    required this.monthlyXPData,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalQuestionsAnswered: json['totalQuestionsAnswered'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      totalBattles: json['totalBattles'] ?? 0,
      battlesWon: json['battlesWon'] ?? 0,
      battlesLost: json['battlesLost'] ?? 0,
      battlesDraw: json['battlesDraw'] ?? 0,
      totalXP: (json['totalXP'] ?? 0).toDouble(),
      monthlyXPData:
          (json['monthlyXPData'] as List<dynamic>?)
              ?.map((e) => MonthlyXPData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'totalBattles': totalBattles,
      'battlesWon': battlesWon,
      'battlesLost': battlesLost,
      'battlesDraw': battlesDraw,
      'totalXP': totalXP,
      'monthlyXPData': monthlyXPData.map((e) => e.toJson()).toList(),
    };
  }

  double get correctAnswerPercentage {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (correctAnswers / totalQuestionsAnswered) * 100;
  }

  double get wrongAnswerPercentage {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (wrongAnswers / totalQuestionsAnswered) * 100;
  }

  double get battleWinPercentage {
    if (totalBattles == 0) return 0.0;
    return (battlesWon / totalBattles) * 100;
  }

  double get battleLossPercentage {
    if (totalBattles == 0) return 0.0;
    return (battlesLost / totalBattles) * 100;
  }

  double get battleDrawPercentage {
    if (totalBattles == 0) return 0.0;
    return (battlesDraw / totalBattles) * 100;
  }
}

class MonthlyXPData {
  final String month;
  final double xp;
  final bool isHighest;

  const MonthlyXPData({
    required this.month,
    required this.xp,
    this.isHighest = false,
  });

  factory MonthlyXPData.fromJson(Map<String, dynamic> json) {
    return MonthlyXPData(
      month: json['month'] ?? '',
      xp: (json['xp'] ?? 0).toDouble(),
      isHighest: json['isHighest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'xp': xp, 'isHighest': isHighest};
  }
}
