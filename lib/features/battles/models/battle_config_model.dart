class BattleConfigModel {
  const BattleConfigModel({
    required this.botEntryFee,
    required this.questionsPerBattle,
    required this.secondsPerQuestion,
  });

  final int botEntryFee;
  final int questionsPerBattle;
  final int secondsPerQuestion;

  factory BattleConfigModel.fromJson(Map<String, dynamic> json) =>
      BattleConfigModel(
        botEntryFee: (json['botEntryFee'] as num).toInt(),
        questionsPerBattle: (json['questionsPerBattle'] as num).toInt(),
        secondsPerQuestion: (json['secondsPerQuestion'] as num).toInt(),
      );
}
