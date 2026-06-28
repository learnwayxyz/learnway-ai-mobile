part of 'quiz_bloc.dart';

abstract class QuizEvent {}

class StartQuiz extends QuizEvent {
  final List<QuizQuestion> questions;
  final String lessonTitle;
  StartQuiz(this.questions, {required this.lessonTitle});
}

class StopQuiz extends QuizEvent {}

class FetchQuestions extends QuizEvent {
  FetchQuestions(this.questionId, {required this.lessonTitle});
  final String questionId;
  final String lessonTitle;
}

class SelectAnOption extends QuizEvent {
  final QuizOption option;
  SelectAnOption(this.option);
}

class NextQuestion extends QuizEvent {}

class TimerTick extends QuizEvent {}

class TimeExpired extends QuizEvent {}

class SubmitQuiz extends QuizEvent {
  final String questionId;
  SubmitQuiz(this.questionId);
}

class ShowXPScreen extends QuizEvent {}

class ShowGemsScreen extends QuizEvent {}

class ShowResultsScreen extends QuizEvent {}

class ResetQuiz extends QuizEvent {}

class PlayAudio extends QuizEvent {
  final bool isCorrect;
  PlayAudio(this.isCorrect);
}

class RetrySubmitQuiz extends QuizEvent {}

class CheckConnectivityAndRetry extends QuizEvent {}

class StopRetryPolling extends QuizEvent {}

class StartBackgroundRetry extends QuizEvent {
  final String questionId;
  final int scorePercentage;
  final List<bool> answers;
  final int totalTimeSpent;
  final QuizCompleted localQuizResult;

  StartBackgroundRetry({
    required this.questionId,
    required this.scorePercentage,
    required this.answers,
    required this.totalTimeSpent,
    required this.localQuizResult,
  });
}
