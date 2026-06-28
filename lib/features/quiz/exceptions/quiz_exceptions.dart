import 'package:core/core.dart';

class QuizFailure extends Failure {
  QuizFailure(super.message);

  // Network-related failures
  factory QuizFailure.network([String? details]) =>
      QuizFailure(details ?? "Network error occurred. Please check your connection.");

  // Server-related failures
  factory QuizFailure.server([String? details]) =>
      QuizFailure(details ?? "Server error occurred. Please try again later.");

  // Failed to fetch questions
  factory QuizFailure.fetchQuestions([String? details]) =>
      QuizFailure(details ?? "Failed to fetch quiz questions");

  // Failed to submit quiz
  factory QuizFailure.submitQuiz([String? details]) =>
      QuizFailure(details ?? "Failed to submit quiz results");

  // Unauthorized access
  factory QuizFailure.unauthorized() =>
      QuizFailure("Unauthorized. Please log in again.");

  // Invalid data/parsing errors
  factory QuizFailure.invalidData([String? details]) =>
      QuizFailure(details ?? "Invalid quiz data received");

  // Timeout errors
  factory QuizFailure.timeout() =>
      QuizFailure("Request timed out. Please try again.");

  // Unknown/unexpected errors
  factory QuizFailure.unknown([String? details]) =>
      QuizFailure(details ?? "An unexpected error occurred");

  @override
  String toString() => 'QuizFailure: $message';
}
