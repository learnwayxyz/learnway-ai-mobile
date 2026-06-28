import 'package:equatable/equatable.dart';

class ContestLeaderboardEntry extends Equatable {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final int rank;
  final int score;
  final int totalXP;
  final bool isCurrentUser;

  const ContestLeaderboardEntry({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    required this.rank,
    required this.score,
    required this.totalXP,
    this.isCurrentUser = false,
  });

  factory ContestLeaderboardEntry.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final userId = json['userId'] as String? ?? json['user_id'] as String;
    return ContestLeaderboardEntry(
      userId: userId,
      username: json['username'] as String? ?? json['user_name'] as String,
      profileImageUrl: json['profileImageUrl'] as String? ??
          json['profile_image_url'] as String?,
      rank: json['rank'] is int
          ? json['rank']
          : int.tryParse(json['rank']?.toString() ?? '0') ?? 0,
      score: json['score'] is int
          ? json['score']
          : int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      totalXP: json['totalXP'] is int
          ? json['totalXP']
          : (json['total_xp'] is int
              ? json['total_xp']
              : int.tryParse(json['totalXP']?.toString() ?? '0') ?? 0),
      isCurrentUser: currentUserId != null && userId == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'rank': rank,
      'score': score,
      'totalXP': totalXP,
      'isCurrentUser': isCurrentUser,
    };
  }

  ContestLeaderboardEntry copyWith({
    String? userId,
    String? username,
    String? profileImageUrl,
    int? rank,
    int? score,
    int? totalXP,
    bool? isCurrentUser,
  }) {
    return ContestLeaderboardEntry(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      totalXP: totalXP ?? this.totalXP,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        profileImageUrl,
        rank,
        score,
        totalXP,
        isCurrentUser,
      ];
}
