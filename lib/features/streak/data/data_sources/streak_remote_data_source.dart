import 'dart:convert';
import 'dart:developer' as dev;
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';

class StreakRemoteDataSource {
  final client = locator<BaseApiClients>();

  /// Get streak data from user profile
  Future<UserProfileModel> getStreakData() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw Exception('User token is null, cannot fetch streak data.');
      }

      dev.log('Fetching streak data...');
      final response = await client.get(
        Endpoints.getUserProfile,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      dev.log('Streak data response: $decoded');

      if (decoded['error'] != null) {
        throw StreakException(
          'Error fetching streak data: ${decoded['message']}',
        );
      }

      return UserProfileModel.fromJson(decoded);
    } on FormatException {
      throw StreakException('Invalid response format.');
    } catch (e) {
      throw StreakException('Failed to fetch streak data: $e');
    }
  }

  /// Claim daily reward
  Future<Map<String, dynamic>> claimDailyReward() async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      if (token == null) {
        throw Exception('User token is null, cannot claim daily reward.');
      }

      dev.log('Claiming daily reward...');
      final response = await client.post(
        'user/daily-claim',
        body: <String, dynamic>{}, // Empty JSON body
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> decoded = json.decode(response.body);
      dev.log('Daily claim response: $decoded');

      if (decoded['error'] != null) {
        throw StreakException(
          'Error claiming daily reward: ${decoded['message']}',
        );
      }

      return decoded;
    } on FormatException {
      throw StreakException('Invalid response format.');
    } catch (e) {
      throw StreakException('Failed to claim daily reward: $e');
    }
  }
}

class StreakException implements Exception {
  final String message;
  StreakException(this.message);

  @override
  String toString() => 'StreakException: $message';
}
