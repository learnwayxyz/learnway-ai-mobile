import 'dart:convert';
import 'dart:developer';

import 'package:core/core.dart';
import '../learning_path_failure.dart';
import '../models/learning_path_model.dart';
import '../models/path_course_model.dart';

class LearningPathDataSource {
  LearningPathDataSource(this._apiClient);

  final BaseApiClients _apiClient;

  Future<List<LearningPathModel>> getLearningPaths() async {
    try {
      final response = await _apiClient.get(Endpoints.learningPaths);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        log('LearningPathDataSource response: $body');
        final list = body as List<dynamic>;
        return list
            .map((e) => LearningPathModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to fetch learning paths';
      log('LearningPathDataSource error: $message');
      throw LearningPathFailure(message.toString());
    } on LearningPathFailure {
      rethrow;
    } catch (e) {
      log('LearningPathDataSource unexpected error: $e');
      throw LearningPathFailure(e.toString());
    }
  }

  Future<LearningPathModel> getLearningPathById(String id) async {
    try {
      final response = await _apiClient.get(Endpoints.learningPathById(id));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return LearningPathModel.fromJson(body);
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to fetch learning path';
      log('LearningPathDataSource getLearningPathById error: $message');
      throw LearningPathFailure(message.toString());
    } on LearningPathFailure {
      rethrow;
    } catch (e) {
      log('LearningPathDataSource getLearningPathById unexpected error: $e');
      throw LearningPathFailure(e.toString());
    }
  }

  Future<List<PathCourseModel>> getCoursesByPath(String pathId) async {
    try {
      final response = await _apiClient.get(Endpoints.coursesByPath(pathId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final list = json.decode(response.body) as List<dynamic>;
        return list
            .map((e) => PathCourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to fetch courses for path';
      log('LearningPathDataSource getCoursesByPath error: $message');
      throw LearningPathFailure(message.toString());
    } on LearningPathFailure {
      rethrow;
    } catch (e) {
      log('LearningPathDataSource getCoursesByPath unexpected error: $e');
      throw LearningPathFailure(e.toString());
    }
  }
}
