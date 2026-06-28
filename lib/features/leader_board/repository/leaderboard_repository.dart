import 'package:learnwayv2/features/leader_board/models/leaderboard_response_model.dart';
import 'package:learnwayv2/features/leader_board/models/my_position_model.dart';

abstract class LeaderboardRepository {
  Future<LeaderboardResponseModel> getAllTimeLeaderboard({
    int limit = 100,
    int offset = 0,
  });

  Future<LeaderboardResponseModel> getMonthlyLeaderboard({
    int limit = 100,
    int offset = 0,
  });

  Future<LeaderboardResponseModel> getWeeklyLeaderboard({
    int limit = 100,
    int offset = 0,
  });

  Future<MyPositionModel> getMyPosition();
}
