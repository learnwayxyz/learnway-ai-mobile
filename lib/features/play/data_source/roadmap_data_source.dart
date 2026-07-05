import 'dart:convert';

import 'package:core/core.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/features/play/play_failure.dart';

class RoadmapDataSource {
  RoadmapDataSource(this._apiClient);

  final BaseApiClients _apiClient;

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
}
