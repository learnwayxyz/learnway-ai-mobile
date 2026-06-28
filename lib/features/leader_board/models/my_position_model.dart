import 'package:equatable/equatable.dart';

class MyPositionModel extends Equatable {
  final String? userId;
  final PositionStats? weekly;
  final PositionStats? monthly;
  final PositionStats? alltime;

  const MyPositionModel({
    this.userId,
    this.weekly,
    this.monthly,
    this.alltime,
  });

  factory MyPositionModel.fromJson(Map<String, dynamic> json) {
    return MyPositionModel(
      userId: json['userId'] as String?,
      weekly: json['weekly'] != null
          ? PositionStats.fromJson(json['weekly'] as Map<String, dynamic>)
          : null,
      monthly: json['monthly'] != null
          ? PositionStats.fromJson(json['monthly'] as Map<String, dynamic>)
          : null,
      // Handle both "alltime" and "allTime" for backward compatibility
      alltime: json['allTime'] != null
          ? PositionStats.fromJson(json['allTime'] as Map<String, dynamic>)
          : (json['alltime'] != null
              ? PositionStats.fromJson(json['alltime'] as Map<String, dynamic>)
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'weekly': weekly?.toJson(),
      'monthly': monthly?.toJson(),
      'allTime': alltime?.toJson(),
    };
  }

  @override
  List<Object?> get props => [userId, weekly, monthly, alltime];
}

class PositionStats extends Equatable {
  final int rank;
  final int? totalXP;
  final int? totalGems;
  final int? quizzesCompleted;

  const PositionStats({
    required this.rank,
    this.totalXP,
    this.totalGems,
    this.quizzesCompleted,
  });

  factory PositionStats.fromJson(Map<String, dynamic> json) {
    return PositionStats(
      rank: json['rank'] as int,
      totalXP: json['totalXP'] as int?,
      totalGems: json['totalGems'] as int?,
      quizzesCompleted: json['quizzesCompleted'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      if (totalXP != null) 'totalXP': totalXP,
      if (totalGems != null) 'totalGems': totalGems,
      if (quizzesCompleted != null) 'quizzesCompleted': quizzesCompleted,
    };
  }

  @override
  List<Object?> get props => [rank, totalXP, totalGems, quizzesCompleted];
}
