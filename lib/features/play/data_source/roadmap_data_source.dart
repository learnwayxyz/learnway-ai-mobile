import 'dart:convert';

import 'package:core/core.dart';
import 'package:learnwayv2/features/play/models/career_path_model.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/features/play/play_failure.dart';

class RoadmapDataSource {
  RoadmapDataSource(this._apiClient, this._aiApiClient);

  final BaseApiClients _apiClient;
  final BaseApiClients _aiApiClient;

  Future<RoadmapModel> fetchMyRoadmap() async {
    final response = await _apiClient.get(Endpoints.myRoadmap);

    if (response.statusCode == 200) {
      return RoadmapModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }

    final body = json.decode(response.body);
    final message = body['message'] ?? 'Failed to fetch learning roadmap';
    throw PlayFailure(message.toString());
  }

  Future<List<CareerPathModel>> fetchCareerPaths(String userId) async {
    final response = await _aiApiClient.get('/ai-mentor/career-path/$userId');

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => CareerPathModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final body = json.decode(response.body);
    final message = body['message'] ?? 'Failed to fetch career paths';
    throw PlayFailure(message.toString());
  }
}
