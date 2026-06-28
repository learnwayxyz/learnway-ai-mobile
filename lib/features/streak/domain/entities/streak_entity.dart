import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';

class StreakEntity extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final int dailyClaimStreak;
  final int totalGems;
  final int totalXP;
  final DateTime? nextClaimAt;
  final BiWeeklyStreak? biWeeklyStreak;

  const StreakEntity({
    required this.currentStreak,
    required this.longestStreak,
    required this.dailyClaimStreak,
    required this.totalGems,
    required this.totalXP,
    this.nextClaimAt,
    this.biWeeklyStreak,
  });

  @override
  List<Object?> get props => [
    currentStreak,
    longestStreak,
    dailyClaimStreak,
    totalGems,
    totalXP,
    nextClaimAt,
    biWeeklyStreak,
  ];

  /// Calculate weekly progress based on claimDates from biWeeklyStreak
  /// Returns array of 7 booleans representing Mon-Sun
  List<bool> get weeklyProgress {
    final progress = List<bool>.filled(7, false);

    if (biWeeklyStreak?.claimDates != null && biWeeklyStreak!.claimDates!.isNotEmpty) {
      // Use claimDates to accurately mark which days were claimed
      final claimDates = biWeeklyStreak!.claimDates!;
      final now = DateTime.now();
      
      // Get the start of the current week (Monday)
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      
      for (int i = 0; i < 7; i++) {
        final dayToCheck = startOfWeek.add(Duration(days: i));
        final dayString = dayToCheck.toIso8601String().split('T')[0];
        
        // Check if this day exists in claimDates
        for (final claimDate in claimDates) {
          if (claimDate.startsWith(dayString)) {
            progress[i] = true;
            break;
          }
        }
      }
    }

    return progress;
  }

  /// Get current day in the 14-day cycle (1-14)
  int get currentDay => biWeeklyStreak?.currentDay ?? dailyClaimStreak;

  /// Total days in the streak cycle (always 14)
  int get totalDays => 14;

  /// Check if user can claim today
  bool get canClaimToday {
    if (nextClaimAt == null) return true;
    return DateTime.now().isAfter(nextClaimAt!);
  }
}
