import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/home/bloc/streak_state.dart';
import 'package:learnwayv2/features/streak/data/data_sources/streak_remote_data_source.dart';
import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';
import 'package:learnwayv2/features/streak/domain/usecases/claim_daily_reward_usecase.dart';

import 'streak_event.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  Timer? _playButtonTimer;
  final StreakRepository _streakRepository;
  final ClaimDailyRewardUseCase _claimDailyRewardUseCase;

  StreakBloc({
    required StreakRepository streakRepository,
    required ClaimDailyRewardUseCase claimDailyRewardUseCase,
  }) : _streakRepository = streakRepository,
       _claimDailyRewardUseCase = claimDailyRewardUseCase,
       super(const StreakInitial()) {
    on<LoadStreakData>(_onLoadStreakData);
    on<UpdateStreakDays>(_onUpdateStreakDays);
    on<UpdateProgress>(_onUpdateProgress);
    on<PlayButtonPressed>(_onPlayButtonPressed);
    on<ResetStreak>(_onResetStreak);
    on<InitializeWeeklyProgress>(_onInitializeWeeklyProgress);
    on<InitializeStreakFromProfile>(_onInitializeStreakFromProfile);
  }

  DateTime _tomorrowMidnightUtc() {
    final now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month, now.day + 1);
  }

  Future<void> _onLoadStreakData(
    LoadStreakData event,
    Emitter<StreakState> emit,
  ) async {
    emit(const StreakLoading());

    try {
      final streakEntity = await _streakRepository.getStreakData();

      emit(
        StreakLoaded(
          streakDays: streakEntity.currentStreak,
          currentDay: streakEntity.currentDay,
          totalDays: streakEntity.totalDays,
          weeklyProgress: streakEntity.weeklyProgress,
          lastUpdated: DateTime.now(),
          nextClaimAt: streakEntity.nextClaimAt,
        ),
      );
    } catch (e) {
      emit(StreakError('Failed to load streak data: ${e.toString()}'));
    }
  }

  void _onInitializeStreakFromProfile(
    InitializeStreakFromProfile event,
    Emitter<StreakState> emit,
  ) {
    final profile = event.profile;
    final streakDays = profile.currentStreak ?? 0;
    final currentDay = profile.biWeeklyStreak?.currentDay ?? 0;
    final totalDays = 14;

    final claimDates = profile.biWeeklyStreak?.claimDates ?? [];

    developer.log(
      'Streak initialization - currentDay: $currentDay, claimDates: ${claimDates.length}, canClaimNow: ${profile.canClaimNow}',
      name: 'StreakBloc',
    );

    final weeklyProgress = _calculateWeeklyProgressFromProfile(
      currentDay,
      claimDates,
    );

    developer.log(
      'Weekly progress calculated: $weeklyProgress',
      name: 'StreakBloc',
    );

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    DateTime? nextClaimAt;

    if (claimDates.isNotEmpty) {
      final lastClaimDateStr = claimDates.last;
      final lastClaimDate = DateTime.tryParse(lastClaimDateStr);

      if (lastClaimDate != null) {
        final lastClaimDay = DateTime.utc(
          lastClaimDate.year,
          lastClaimDate.month,
          lastClaimDate.day,
        );

        if (lastClaimDay.isAtSameMomentAs(today)) {
          nextClaimAt = _tomorrowMidnightUtc();
        } else {
          nextClaimAt = null;
        }
      } else {
        nextClaimAt = (profile.canClaimNow == true)
            ? null
            : _tomorrowMidnightUtc();
      }
    } else {
      if (profile.canClaimNow == false) {
        nextClaimAt = _tomorrowMidnightUtc();
      } else {
        nextClaimAt = null;
      }
    }

    developer.log(
      'nextClaimAt resolved to: $nextClaimAt (canClaimNow: ${profile.canClaimNow})',
      name: 'StreakBloc',
    );

    emit(
      StreakLoaded(
        streakDays: streakDays,
        currentDay: currentDay,
        totalDays: totalDays,
        weeklyProgress: weeklyProgress,
        lastUpdated: DateTime.now(),
        nextClaimAt: nextClaimAt,
      ),
    );
  }

  void _onUpdateStreakDays(UpdateStreakDays event, Emitter<StreakState> emit) {
    if (state is StreakLoaded) {
      final currentState = state as StreakLoaded;
      emit(
        currentState.copyWith(
          streakDays: event.streakDays,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void _onUpdateProgress(UpdateProgress event, Emitter<StreakState> emit) {
    if (state is StreakLoaded) {
      final currentState = state as StreakLoaded;

      // Validate progress values
      if (event.currentDay < 0 ||
          event.totalDays <= 0 ||
          event.currentDay > event.totalDays) {
        emit(const StreakError('Invalid progress values'));
        return;
      }

      emit(
        currentState.copyWith(
          currentDay: event.currentDay,
          totalDays: event.totalDays,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _onPlayButtonPressed(
    PlayButtonPressed event,
    Emitter<StreakState> emit,
  ) async {
    if (state is StreakLoaded) {
      final currentState = state as StreakLoaded;

      // Check if user can claim today
      if (!currentState.canClaimToday) {
        emit(
          const StreakClaimFailed(
            'You have already claimed your daily reward. Come back tomorrow!',
          ),
        );
        // Return to loaded state so button can be clicked again
        await Future.delayed(Duration.zero);
        emit(currentState);
        return;
      }

      // Emit claiming state to show loading dialog
      emit(const StreakClaiming());

      try {
        // Call the daily claim use case
        final claimResult = await _claimDailyRewardUseCase();

        if (claimResult.success) {
          // Emit success state to trigger success dialog
          emit(
            StreakClaimSuccess(
              gemsAwarded: claimResult.gemsAwarded,
              xpAwarded: claimResult.xpAwarded,
              currentStreak: claimResult.currentStreak,
              nextClaimAt: claimResult.nextClaimAt,
            ),
          );

          // Reload streak data to get updated values including longestStreak
          await Future.delayed(Duration.zero);

          try {
            final updatedStreakEntity = await _streakRepository.getStreakData();

            // Calculate weeklyProgress using rolling window logic with clearing rules
            final claimDates =
                updatedStreakEntity.biWeeklyStreak?.claimDates ?? [];
            final weeklyProgress = _calculateWeeklyProgressFromProfile(
              updatedStreakEntity.currentDay,
              claimDates,
            );

            // ─── FIX: Safe nextClaimAt after successful claim ───
            //
            // We JUST successfully claimed. So the user absolutely cannot
            // claim again until tomorrow. If the backend returns null for
            // nextClaimAt (which happens when the 14-day cycle resets and
            // clears the streak data), we fall back to tomorrow midnight.
            //
            // This is the instant-update approach: we don't wait for a
            // websocket or another API call — we KNOW the answer locally.
            final safeNextClaimAt =
                updatedStreakEntity.nextClaimAt ?? _tomorrowMidnightUtc();

            emit(
              StreakLoaded(
                streakDays: updatedStreakEntity.currentStreak,
                currentDay: updatedStreakEntity.currentDay,
                totalDays: updatedStreakEntity.totalDays,
                weeklyProgress: weeklyProgress,
                lastUpdated: DateTime.now(),
                nextClaimAt: safeNextClaimAt,
              ),
            );
          } catch (e) {
            // Fallback to claim result data if reload fails
            // Note: This fallback doesn't have access to claimDates, so use simple calculation
            //
            // ─── FIX: Same safe fallback here ───
            final safeNextClaimAt =
                claimResult.nextClaimAt ?? _tomorrowMidnightUtc();

            emit(
              StreakLoaded(
                streakDays: claimResult.currentStreak,
                currentDay: claimResult.currentStreak,
                totalDays: 14,
                weeklyProgress: _calculateWeeklyProgress(
                  claimResult.currentStreak,
                ),
                lastUpdated: DateTime.now(),
                nextClaimAt: safeNextClaimAt,
              ),
            );
          }
        } else {
          emit(StreakClaimFailed(claimResult.message));
          // Return to loaded state so button can be clicked again
          await Future.delayed(Duration.zero);
          emit(currentState);
        }
      } catch (e) {
        // Extract the actual error message without wrapping
        String errorMessage = e.toString();
        if (e is StreakException) {
          errorMessage = e.message;
        }
        emit(StreakClaimFailed(errorMessage));
        // Return to loaded state so button can be clicked again
        await Future.delayed(Duration.zero);
        emit(currentState);
      }
    }
  }

  /// Calculate weekly progress based on dailyClaimStreak
  List<bool> _calculateWeeklyProgress(int dailyClaimStreak) {
    final progress = List<bool>.filled(7, false);

    // Calculate which days should be selected based on dailyClaimStreak
    // If dailyClaimStreak = 4, first 4 days (Mon-Thu) are selected
    for (int i = 0; i < dailyClaimStreak && i < 7; i++) {
      progress[i] = true;
    }

    return progress;
  }

  /// Calculate weekly progress with rolling window and clearing logic
  /// Clearing rules rally on week boundaries (Sunday):
  /// 1. Days 1-6: Show all claims
  /// 2. Day 7+: Clear all positions before the most recent Sunday, show from Sunday onwards
  /// 3. Day 9+: If position 2's weekday repeats, clear from Sunday to day before position 8
  List<bool> _calculateWeeklyProgressFromProfile(
    int currentDay,
    List<String> claimDates,
  ) {
    if (currentDay == 0 || claimDates.isEmpty) {
      return List<bool>.filled(7, false);
    }

    // Parse all claim dates
    final parsedDates = <DateTime>[];
    for (final dateStr in claimDates) {
      try {
        parsedDates.add(DateTime.parse(dateStr));
      } catch (e) {
        print('Error parsing date: $dateStr - $e');
      }
    }

    if (parsedDates.isEmpty) {
      return List<bool>.filled(7, false);
    }

    int claimsToShow;

    if (currentDay <= 6) {
      // Days 1-6: Show all claims
      claimsToShow = currentDay;
      print('Days 1-6: Showing all $claimsToShow claims');
    } else {
      // Day 7+: Find the most recent Sunday in the claims
      int sundayPosition = -1;
      for (int i = parsedDates.length - 1; i >= 0; i--) {
        if (parsedDates[i].weekday == 7) {
          // Sunday
          sundayPosition = i;
          break;
        }
      }

      if (currentDay >= 7 && currentDay <= 8) {
        // Days 7-8: Show from Sunday onwards
        if (sundayPosition >= 0) {
          claimsToShow = parsedDates.length - sundayPosition;
          print(
            'Day $currentDay: Cleared before Sunday (position $sundayPosition), showing last $claimsToShow claims',
          );
        } else {
          // No Sunday found, show all (edge case)
          claimsToShow = currentDay;
          print(
            'Day $currentDay: No Sunday found, showing all $claimsToShow claims',
          );
        }
      } else if (currentDay >= 9) {
        // Day 9+: Check if we just claimed on Saturday (Saturday clearing)
        // Check if there's a Saturday claimed after day 7
        int saturdayAfterDay7 = -1;
        for (int i = 6; i < parsedDates.length; i++) {
          // Start from position 7 (index 6)
          if (parsedDates[i].weekday == 6) {
            // Saturday
            saturdayAfterDay7 = i;
            break; // Get the first Saturday in week 2
          }
        }

        if (saturdayAfterDay7 >= 0) {
          // Saturday clearing happened - show from position 8 onwards
          claimsToShow = parsedDates.length - 7; // Show from position 8
          print(
            'Day $currentDay: Saturday clearing at position $saturdayAfterDay7, showing last $claimsToShow claims (from position 8)',
          );
        } else {
          // No Saturday yet - continue from Sunday baseline
          if (sundayPosition >= 0) {
            claimsToShow = parsedDates.length - sundayPosition;
            print(
              'Day $currentDay: Before Saturday clearing, showing from Sunday: $claimsToShow claims',
            );
          } else {
            claimsToShow = currentDay.clamp(1, 7);
            print('Day $currentDay: Fallback, showing $claimsToShow claims');
          }
        }
      } else {
        claimsToShow = currentDay.clamp(1, 7);
        print('Fallback: showing $claimsToShow claims');
      }
    }

    // Get the last 'claimsToShow' claims to display
    final displayClaimDates = <String>[];
    if (claimDates.length >= claimsToShow) {
      final startIndex = claimDates.length - claimsToShow;
      displayClaimDates.addAll(claimDates.sublist(startIndex));
    } else {
      // If we have fewer claims than needed, show all
      displayClaimDates.addAll(claimDates);
    }

    print('displayClaimDates (last $claimsToShow): $displayClaimDates');

    // Parse claim dates and map each to its weekday
    final claimWeekdays = <int>[];
    for (final dateStr in displayClaimDates) {
      try {
        final date = DateTime.parse(dateStr);
        // weekday: 1 = Monday, 7 = Sunday
        claimWeekdays.add(date.weekday);
        print(
          'Claimed on: $dateStr → ${_getWeekdayName(date.weekday)} (weekday: ${date.weekday})',
        );
      } catch (e) {
        print('Error parsing date: $dateStr - $e');
      }
    }

    print('Claim weekdays: $claimWeekdays');

    // Convert to Set to get unique weekdays that should be marked
    final uniqueClaimedDays = claimWeekdays.toSet();
    print('Unique claimed weekdays: $uniqueClaimedDays');

    // Map to weeklyProgress (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    final weeklyProgress = List<bool>.generate(7, (index) {
      // index 0 = Sunday (weekday 7), index 1 = Monday (weekday 1), etc.
      final weekday = index == 0 ? 7 : index;
      final isClaimed = uniqueClaimedDays.contains(weekday);
      print(
        'Circle $index (${_getWeekdayNameByIndex(index)}) - weekday $weekday: $isClaimed',
      );
      return isClaimed;
    });

    return weeklyProgress;
  }

  /// Helper to get weekday name from DateTime.weekday (1=Mon, 7=Sun)
  String _getWeekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  /// Helper to get weekday name from index (0=Sun, 1=Mon, ..., 6=Sat)
  String _getWeekdayNameByIndex(int index) {
    const names = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return names[index];
  }

  void _onResetStreak(ResetStreak event, Emitter<StreakState> emit) {
    if (state is StreakLoaded) {
      final currentState = state as StreakLoaded;
      emit(
        currentState.copyWith(
          streakDays: 0,
          currentDay: 0,
          weeklyProgress: List.filled(7, false),
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  void _onInitializeWeeklyProgress(
    InitializeWeeklyProgress event,
    Emitter<StreakState> emit,
  ) {
    if (state is StreakLoaded) {
      final currentState = state as StreakLoaded;

      // Validate weekly progress length
      if (event.weeklyProgress.length != 7) {
        emit(const StreakError('Weekly progress must have exactly 7 days'));
        return;
      }

      emit(
        currentState.copyWith(
          weeklyProgress: event.weeklyProgress,
          lastUpdated: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _playButtonTimer?.cancel();
    return super.close();
  }
}
