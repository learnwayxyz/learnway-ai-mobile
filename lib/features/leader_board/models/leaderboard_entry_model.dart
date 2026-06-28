import 'package:equatable/equatable.dart';

class LeaderboardEntryModel extends Equatable {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final int rank;
  final int totalXP;
  final int totalGems;
  final int quizzesCompleted;
  final int currentStreak;

  const LeaderboardEntryModel({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    required this.rank,
    required this.totalXP,
    required this.totalGems,
    required this.quizzesCompleted,
    required this.currentStreak,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      rank: json['rank'] is int ? json['rank'] : int.parse(json['rank'].toString()),
      totalXP: json['totalXP'] is int ? json['totalXP'] : int.parse(json['totalXP'].toString()),
      totalGems: json['totalGems'] is int ? json['totalGems'] : int.parse(json['totalGems'].toString()),
      quizzesCompleted: json['quizzesCompleted'] is int ? json['quizzesCompleted'] : int.parse(json['quizzesCompleted'].toString()),
      currentStreak: json['currentStreak'] is int ? json['currentStreak'] : int.parse(json['currentStreak'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'rank': rank,
      'totalXP': totalXP,
      'totalGems': totalGems,
      'quizzesCompleted': quizzesCompleted,
      'currentStreak': currentStreak,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        profileImageUrl,
        rank,
        totalXP,
        totalGems,
        quizzesCompleted,
        currentStreak,
      ];
}
