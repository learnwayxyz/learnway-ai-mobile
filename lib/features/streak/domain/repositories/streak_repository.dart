import 'package:learnwayv2/features/streak/domain/entities/streak_entity.dart';

abstract class StreakRepository {
  /// Get current streak data from user profile
  Future<StreakEntity> getStreakData();

  /// Claim daily reward
  Future<DailyClaimResult> claimDailyReward();
}

class DailyClaimResult {
  final bool success;
  final int gemsAwarded;
  final int xpAwarded;
  final int currentStreak;
  final bool streakReset;
  final DateTime? nextClaimAt;
  final BadgeEarned? badgeEarned;
  final int totalGems;
  final int totalXP;
  final String message;

  const DailyClaimResult({
    required this.success,
    required this.gemsAwarded,
    required this.xpAwarded,
    required this.currentStreak,
    required this.streakReset,
    this.nextClaimAt,
    this.badgeEarned,
    required this.totalGems,
    required this.totalXP,
    required this.message,
  });
}

class BadgeEarned {
  final String badgeType;
  final String tier;
  final String name;
  final int gemReward;

  const BadgeEarned({
    required this.badgeType,
    required this.tier,
    required this.name,
    required this.gemReward,
  });
}
