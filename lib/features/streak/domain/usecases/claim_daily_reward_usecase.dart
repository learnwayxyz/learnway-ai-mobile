import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';

class ClaimDailyRewardUseCase {
  final StreakRepository repository;

  ClaimDailyRewardUseCase(this.repository);

  Future<DailyClaimResult> call() async {
    return await repository.claimDailyReward();
  }
}
