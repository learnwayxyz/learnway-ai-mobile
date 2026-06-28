import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logLessonStarted(String lessonId, String lessonName) async {
    await _analytics.logEvent(
      name: 'lesson_started',
      parameters: {
        'lesson_id': lessonId,
        'lesson_name': lessonName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logLessonCompleted(String lessonId, int timeSpentSeconds) async {
    await _analytics.logEvent(
      name: 'lesson_completed',
      parameters: {
        'lesson_id': lessonId,
        'time_spent_seconds': timeSpentSeconds,
      },
    );
  }

  Future<void> logQuizStarted(String quizId, String quizName) async {
    await _analytics.logEvent(
      name: 'quiz_started',
      parameters: {'quiz_id': quizId, 'quiz_name': quizName},
    );
  }

  Future<void> logQuizCompleted(
    String quizId,
    int score,
    int timeSpentSeconds,
  ) async {
    await _analytics.logEvent(
      name: 'quiz_completed',
      parameters: {
        'quiz_id': quizId,
        'score': score,
        'time_spent_seconds': timeSpentSeconds,
      },
    );
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  // Set user properties
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
