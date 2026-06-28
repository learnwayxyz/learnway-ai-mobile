import 'dart:convert';
import 'package:core/core.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_response_model.dart';
import 'package:learnwayv2/features/leader_board/models/my_position_model.dart';
import 'package:learnwayv2/features/leader_board/repository/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final BaseApiClients _apiClient;

  LeaderboardRepositoryImpl(this._apiClient);

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await SharedPreferencesStore.getUserToken(userTokenKey);
    if (token == null) {
      throw Exception('User token is null, cannot fetch leaderboard data.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<LeaderboardResponseModel> getAllTimeLeaderboard({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        '${Endpoints.leaderboardAllTime}?limit=$limit&offset=$offset',
        headers: headers,
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true && decoded['data'] != null) {
        return LeaderboardResponseModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          decoded['message'] ?? 'Failed to fetch all-time leaderboard',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch all-time leaderboard: ${e.toString()}');
    }
  }

  @override
  Future<LeaderboardResponseModel> getMonthlyLeaderboard({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        '${Endpoints.leaderboardMonthly}?limit=$limit&offset=$offset',
        headers: headers,
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true && decoded['data'] != null) {
        return LeaderboardResponseModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          decoded['message'] ?? 'Failed to fetch monthly leaderboard',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch monthly leaderboard: ${e.toString()}');
    }
  }

  @override
  Future<LeaderboardResponseModel> getWeeklyLeaderboard({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        '${Endpoints.leaderboardWeekly}?limit=$limit&offset=$offset',
        headers: headers,
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true && decoded['data'] != null) {
        return LeaderboardResponseModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          decoded['message'] ?? 'Failed to fetch weekly leaderboard',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch weekly leaderboard: ${e.toString()}');
    }
  }

  @override
  Future<MyPositionModel> getMyPosition() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        Endpoints.leaderboardMyPosition,
        headers: headers,
      );

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] == true && decoded['data'] != null) {
        return MyPositionModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch user position');
      }
    } catch (e) {
      throw Exception('Failed to fetch user position: ${e.toString()}');
    }
  }
}
