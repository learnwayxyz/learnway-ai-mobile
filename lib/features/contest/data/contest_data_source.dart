import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/contest/contest_exceptions.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/contest/model/join_contest_model.dart';
import 'package:learnwayv2/features/contest/model/start_contest_model.dart';
import 'package:learnwayv2/features/contest/model/submit_contest_response.dart';

class ContestRemoteDataSource {
  final client = locator.get<BaseApiClients>();

  Future<SubmitContestResponse> submitContestResults({
    required Map<String, dynamic> submissionPayLoad,
    required String contestId,
  }) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);

      log('submitContestResults(): $submissionPayLoad');

      final response = await client
          .post(
            '${Endpoints.submitContestResults}$contestId/submit-quiz',
            body: submissionPayLoad,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      log('submitContestResults(): ${response.body}');

      if (response.statusCode == 404) {
        throw ContestNotFoundException('Contest not found');
      }

      if (response.statusCode == 400) {
        throw ContestFailure(jsonDecode(response.body)['message']);
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ContestFailure(jsonDecode(response.body)['message']);
      }

      final decoded = json.decode(response.body);
      return SubmitContestResponse.fromJson(decoded);
    } on SocketException catch (_) {
      throw ContestNetworkException('No Internet connection');
    } on HttpException catch (_) {
      throw ContestNetworkException('Network error');
    } catch (e) {
      log('Error: $e');
      throw ContestFailure('Error fetching contest questions');
    }
  }

  Future<List<Map<String, dynamic>>> getContestLeaderboard(
    String contestId,
  ) async {
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        '${Endpoints.getContestLeaderboard}/$contestId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('getContestLeaderboard(): ${response.body}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ContestFailure('Error fetching contest leaderboard');
      }

      final decoded = json.decode(response.body);
      return List<Map<String, dynamic>>.from(decoded['data'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<AllContestModel> getAllContests({
    int page = 1,
    int limit = 10,
    String order = 'DESC',
    String sort = 'createdAt',
  }) async {
    final token = await SharedPreferencesStore.getUserToken(userTokenKey);
    try {
      final response = await client.get(
        '${Endpoints.getAllContests}?page=$page&limit=$limit&order=$order&sort=$sort',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('getAllContests(): ${response.body}');

      if (response.statusCode == 404) {
        throw ContestNotFoundException('Contest not found');
      }

      if (response.statusCode == 410) {
        throw ContestExpiredException('Contest has expired');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ContestFailure('Error fetching contest questions');
      }

      final decoded = json.decode(response.body);
      return AllContestModel.fromJson(decoded);
    } on SocketException catch (_) {
      throw ContestNetworkException('No Internet connection');
    } on HttpException catch (_) {
      throw ContestNetworkException('Network error');
    } catch (e) {
      log('Error: $e');
      throw ContestFailure('Error fetching contest questions');
    }
  }

  Future<JoinContestModel> joinContest(
    String contestId, {
    String? accessCode,
  }) async {
    final token = await SharedPreferencesStore.getUserToken(userTokenKey);
    try {
      final response = await client.post(
        '${Endpoints.joinContest}$contestId/join',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: {"roomCode": accessCode},
      );

      log('joinContest(): ${response.body}');

      if (response.statusCode == 404) {
        throw ContestNotFoundException(jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 400) {
        throw ContestJoinFailure(jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 410) {
        throw ContestExpiredException(jsonDecode(response.body)['message']);
      }

      final decoded = json.decode(response.body);
      final serializedData = JoinContestModel.fromJson(decoded);
      log('Serialized join contest data: ${serializedData.toJson()}');
      return serializedData;
    } on SocketException catch (_) {
      throw ContestNetworkException('No Internet connection');
    } on HttpException catch (_) {
      throw ContestNetworkException('Network error');
    } catch (e) {
      rethrow;
    }
  }

  Future<StartContestModel> startContest(String contestId) async {
    final token = await SharedPreferencesStore.getUserToken(userTokenKey);
    try {
      final response = await client.post(
        '${Endpoints.startContest}$contestId/start-quiz',
        body: {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('startContest(): ${response.body}');

      if (response.statusCode == 404) {
        throw ContestNotFoundException('Contest not found');
      }

      if (response.statusCode == 400) {
        throw StartContestFailure(jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 410) {
        throw ContestExpiredException('Contest has expired');
      }

      final decoded = json.decode(response.body);
      return StartContestModel.fromJson(decoded);
    } on SocketException catch (_) {
      throw ContestNetworkException('No Internet connection');
    } on HttpException catch (_) {
      throw ContestNetworkException('Network error');
    } catch (e) {
      rethrow;
    }
  }
}
