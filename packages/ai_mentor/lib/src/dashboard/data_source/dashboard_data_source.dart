import 'dart:convert';
import 'dart:developer';

import 'package:core/core.dart';

import '../dashboard_failure.dart';
import '../models/mentor_dashboard_model.dart';

class DashboardDataSource {
  DashboardDataSource(this._apiClient);

  final BaseApiClients _apiClient;

  Future<MentorDashboardModel> getDashboard(String userId) async {
    try {
      final response = await _apiClient.get(Endpoints.aiMentorDashboard(userId));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        log('DashboardDataSource response: $body');
        return MentorDashboardModel.fromJson(
          body['data'] as Map<String, dynamic>? ?? const {},
        );
      }

      final body = json.decode(response.body);
      final message = body['message'] ?? 'Failed to fetch mentor dashboard';
      log('DashboardDataSource error: $message');
      throw DashboardFailure(message.toString());
    } on DashboardFailure {
      rethrow;
    } catch (e) {
      log('DashboardDataSource unexpected error: $e');
      throw DashboardFailure(e.toString());
    }
  }
}
