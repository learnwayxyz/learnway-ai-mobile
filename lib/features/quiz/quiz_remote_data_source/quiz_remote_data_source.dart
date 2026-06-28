import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:core/core.dart';
import 'package:learnwayv2/core/di/locator.dart';

import 'package:learnwayv2/features/quiz/exceptions/quiz_exceptions.dart';
import 'package:learnwayv2/features/quiz/models/quiz_response.dart';
import 'package:learnwayv2/features/quiz/models/submit_quiz_response.dart';

class QuizRemoteDataSource {
  Future<QuizResponse> getQuestions(String questionId) async {
    final client = locator.get<BaseApiClients>();
    try {
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      final response = await client.get(
        '${Endpoints.getQuestions}/$questionId',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      log('getQuestions(): ${response.body}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw QuizFailure.unauthorized();
      }

      if (response.statusCode >= 500) {
        throw QuizFailure.server(
          'Status ${response.statusCode}: ${response.body}',
        );
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw QuizFailure.fetchQuestions(
          'Status ${response.statusCode}: ${response.body}',
        );
      }

      final decoded = json.decode(response.body);
      return QuizResponse.fromJson(decoded);
    } on SocketException {
      throw QuizFailure.network();
    } on FormatException {
      throw QuizFailure.invalidData('Failed to parse quiz questions');
    } on QuizFailure {
      rethrow;
    } catch (e) {
      throw QuizFailure.fetchQuestions(e.toString());
    }
  }

  Future<SubmitQuizResponse> submitQuizResults({
    required String questionId,
    required int score,
    required List<bool> answers,
    required int timeTaken,
  }) async {
    try {
      final client = locator.get<BaseApiClients>();
      final token = await SharedPreferencesStore.getUserToken(userTokenKey);
      log('Token retrieved: ${token != null ? "Yes" : "No"}');

      final requestBody = {
        'score': score,
        'answers': answers,
        'timeTaken': timeTaken,
      };
      log('Request payload: $requestBody');

      final response = await client.post(
        '${Endpoints.completeLesson}/$questionId',
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw QuizFailure.unauthorized();
      }

      if (response.statusCode >= 500) {
        throw QuizFailure.server(
          'Status ${response.statusCode}: ${response.body}',
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        log('Quiz submission response: $decoded');
        final result = SubmitQuizResponse.fromJson(decoded);

        return result;
      } else {
        throw QuizFailure.submitQuiz(
          'Status ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException {
      throw QuizFailure.network();
    } on NetworkException catch (e) {
      throw QuizFailure.network(e.message);
    } on FormatException {
      throw QuizFailure.invalidData('Failed to parse quiz submission response');
    } on QuizFailure {
      rethrow;
    } catch (e, stackTrace) {
      log('✗ Exception in submitQuizResults: $e');
      log('Stack trace: $stackTrace');
      throw QuizFailure.submitQuiz(e.toString());
    }
  }
}

extension BaseClientWithTimeout on BaseApiClients {
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) => http
      .get(Uri.parse(url), headers: headers)
      .timeout(timeout ?? const Duration(seconds: 15));

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration? timeout,
  }) => http
      .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
      .timeout(timeout ?? const Duration(seconds: 15));
}
