import 'package:learnwayv2/features/streak/data/data_sources/streak_remote_data_source.dart';
import 'package:learnwayv2/features/streak/domain/entities/streak_entity.dart';
import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';

class StreakRepositoryImpl implements StreakRepository {
  final StreakRemoteDataSource remoteDataSource;

  StreakRepositoryImpl(this.remoteDataSource);

  @override
  Future<StreakEntity> getStreakData() async {
    try {
      final userProfile = await remoteDataSource.getStreakData();

      return StreakEntity(
        currentStreak: userProfile.currentStreak ?? 0,
        longestStreak: userProfile.longestStreak ?? 0,
        dailyClaimStreak: userProfile.dailyClaimStreak ?? 0,
        totalGems: userProfile.totalGems ?? 0,
        totalXP: userProfile.totalXp ?? 0,
        nextClaimAt: userProfile.nextClaimAt,
        biWeeklyStreak: userProfile.biWeeklyStreak,
      );
    } catch (e) {
      throw StreakException('Failed to get streak data: $e');
    }
  }

  @override
  Future<DailyClaimResult> claimDailyReward() async {
    try {
      final response = await remoteDataSource.claimDailyReward();

      return DailyClaimResult(
        success: response['success'] ?? false,
        gemsAwarded: response['gemsAwarded'] ?? 0,
        xpAwarded: response['xpAwarded'] ?? 0,
        currentStreak: response['currentStreak'] ?? 0,
        streakReset: response['streakReset'] ?? false,
        nextClaimAt: response['nextClaimAt'] != null
            ? DateTime.tryParse(response['nextClaimAt'])
            : null,
        badgeEarned: response['badgeEarned'] != null
            ? BadgeEarned(
                badgeType: response['badgeEarned']['badgeType'] ?? '',
                tier: response['badgeEarned']['tier'] ?? '',
                name: response['badgeEarned']['name'] ?? '',
                gemReward: response['badgeEarned']['gemReward'] ?? 0,
              )
            : null,
        totalGems: response['totalGems'] ?? 0,
        totalXP: response['totalXP'] ?? 0,
        message: response['message'] ?? '',
      );
    } on StreakException {
      // Don't wrap StreakException, just rethrow
      rethrow;
    } catch (e) {
      throw StreakException('Failed to claim daily reward: $e');
    }
  }
}
