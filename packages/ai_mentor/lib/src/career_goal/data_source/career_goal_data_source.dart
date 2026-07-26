import 'dart:convert';
import 'dart:developer';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import '../career_goal_failure.dart';
import '../models/career_recommendation_model.dart';
import '../models/career_roadmap_model.dart';
import '../models/recommendations_model.dart';

class CareerGoalDataSource {
  CareerGoalDataSource(this._apiClient);

  final BaseApiClients _apiClient;

  Future<void> saveCareerGoal(String userId, String goal) async {
    try {
      final response = await _apiClient.post(
        Endpoints.saveCareer,
        body: {'userId': userId, 'careerGoal': goal},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to save career goal';
      debugPrint('CareerGoalDataSource error: $message');
      throw CareerGoalFailure(message.toString());
    } on CareerGoalFailure {
      rethrow;
    } catch (e) {
      debugPrint('CareerGoalDataSource unexpected error: $e');
      throw CareerGoalFailure(e.toString());
    }
  }

  Future<CareerRoadmap> generateRoadmap(String userId, String goal) async {
    debugPrint('generateRoadmap called with userId: $userId, goal: $goal');
    try {
      final response = await _apiClient.post(
        '/ai-mentor/career-path/generate',
        body: {'userId': userId, 'careerGoal': goal},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        debugPrint('GenerateRoadmap response: $body');
        return CareerRoadmapResponse.fromJson(
          body as Map<String, dynamic>,
        ).data;
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to generate roadmap';
      log('CareerGoalDataSource generateRoadmap error: $message');
      throw CareerGoalFailure(message.toString());
    } on CareerGoalFailure {
      rethrow;
    } catch (e) {
      log('CareerGoalDataSource generateRoadmap unexpected error: $e');
      throw CareerGoalFailure(e.toString());
    }
  }

  Future<List<CareerRecommendation>> getDiscoveryRecommendations({
    required String userId,
    required List<String> goals,
    required String experience,
    required List<String> topics,
  }) async {
    try {
      final response = await _apiClient.post(
        Endpoints.discoveryRecommendations,
        body: {
          'userId': userId,
          'goals': goals,
          'experience': experience,
          'topics': topics,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;
        final list = data['recommendations'] as List<dynamic>;
        return list
            .map(
              (e) => CareerRecommendation.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }

      final body = json.decode(response.body);
      final message =
          body['message'] ?? 'Failed to fetch discovery recommendations';
      log('CareerGoalDataSource getDiscoveryRecommendations error: $message');
      throw CareerGoalFailure(message.toString());
    } on CareerGoalFailure {
      rethrow;
    } catch (e) {
      log(
        'CareerGoalDataSource getDiscoveryRecommendations unexpected error: $e',
      );
      throw CareerGoalFailure(e.toString());
    }
  }

  Future<LearningInsightsData> recommendations(String userId) async {
    try {
      final response = await _apiClient.get(
        Endpoints.getRecommendations(userId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        debugPrint('recommendations response: $body');
        return RecommendationsModel.fromJson(body as Map<String, dynamic>).data;
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to give recommendations';
      log('CareerGoalDataSource recommendations error: $message');
      throw CareerGoalFailure(message.toString());
    } on CareerGoalFailure {
      rethrow;
    } catch (e) {
      log('CareerGoalDataSource recommendations unexpected error: $e');
      throw CareerGoalFailure(e.toString());
    }
  }
}
