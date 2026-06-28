part of 'quiz_bloc.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizInProgress extends Equatable implements QuizState {
  const QuizInProgress({
    required this.questions,
    required this.currentQuestionIndex,
    required this.timeRemaining,
    required this.userOptions,
    required this.questionTimes,
    this.selectedOptions,
    required this.isAnswered,
    required this.timerProgress,
  });
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final int timeRemaining;
  final List<QuizOption?> userOptions;
  final List<int> questionTimes;
  final String? selectedOptions;
  final bool isAnswered;
  final double timerProgress;

  QuizInProgress copyWith({
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    int? timeRemaining,
    List<QuizOption?>? userOptions,
    List<int>? questionTimes,
    String? selectedOptions,
    bool? isAnswered,
    double? timerProgress,
  }) {
    return QuizInProgress(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      userOptions: userOptions ?? this.userOptions,
      questionTimes: questionTimes ?? this.questionTimes,
      selectedOptions: selectedOptions,
      isAnswered: isAnswered ?? this.isAnswered,
      timerProgress: timerProgress ?? this.timerProgress,
    );
  }

  @override
  List<Object?> get props => [
    questions,
    currentQuestionIndex,
    timeRemaining,
    userOptions,
    questionTimes,
    selectedOptions,
    isAnswered,
    timerProgress,
  ];
}

class QuizCompleted extends Equatable implements QuizState {
  final List<QuizQuestion> questions;
  final List<QuizOption?> userAnswers;
  final int score;
  final int totalQuestions;
  final int gemsEarned;
  final int xpEarned;
  final int scorePercentage;
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final int correctAnswers;
  final int incorrectAnswers;
  final List<int> questionTimes;
  final String lessonTitle;
  final bool isRetake; // New flag to indicate if this is a retake

  const QuizCompleted({
    required this.questions,
    required this.userAnswers,
    required this.score,
    required this.totalQuestions,
    required this.gemsEarned,
    required this.xpEarned,
    required this.scorePercentage,
    required this.totalTimeSpent,
    required this.timePercentage,
    required this.averageTimePerQuestion,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.questionTimes,
    required this.lessonTitle,
    this.isRetake = false, // Default to false for backward compatibility
  });

  @override
  List<Object?> get props => [
    questions,
    userAnswers,
    score,
    totalQuestions,
    gemsEarned,
    xpEarned,
    scorePercentage,
    totalTimeSpent,
    timePercentage,
    averageTimePerQuestion,
    correctAnswers,
    incorrectAnswers,
    questionTimes,
    lessonTitle,
    isRetake,
  ];
}

class QuizXPEarned extends Equatable implements QuizState {
  final List<QuizOption?> userOptions;
  final List<QuizQuestion> questions;
  final int xpEarned;
  final int gemsEarned;
  final int score;
  final int totalQuestions;
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final int scorePercentage;
  final List<int> questionTimes;

  const QuizXPEarned({
    required this.userOptions,
    required this.questions,
    required this.xpEarned,
    required this.gemsEarned,
    required this.score,
    required this.totalQuestions,
    required this.totalTimeSpent,
    required this.timePercentage,
    required this.averageTimePerQuestion,
    required this.scorePercentage,
    required this.questionTimes,
  });

  @override
  List<Object?> get props => [
    userOptions,
    questions,
    xpEarned,
    gemsEarned,
    score,
    totalQuestions,
    totalTimeSpent,
    timePercentage,
    averageTimePerQuestion,
    scorePercentage,
    questionTimes,
  ];
}

class QuizGemsEarned extends Equatable implements QuizState {
  const QuizGemsEarned({
    required this.gemsEarned,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.scorePercentage,
    required this.totalTimeSpent,
    required this.timePercentage,
    required this.averageTimePerQuestion,
    required this.userOptions,
    required this.questions,
    required this.questionTimes,
    this.submissionData,
  });

  final int gemsEarned;
  final int score;
  final int totalQuestions;
  final int xpEarned;
  final int scorePercentage;
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final List<QuizOption?> userOptions;
  final List<QuizQuestion> questions;
  final List<int> questionTimes;
  final SubmitQuizResponse? submissionData;
  @override
  List<Object?> get props => [
    gemsEarned,
    score,
    totalQuestions,
    xpEarned,
    scorePercentage,
    totalTimeSpent,
    timePercentage,
    averageTimePerQuestion,
    userOptions,
    questions,
    questionTimes,
    submissionData,
  ];
}

class QuizSubmitting extends QuizState {}

class ErrorSubmittingQuiz extends QuizState {
  final String message;
  ErrorSubmittingQuiz({required this.message});
}

class FetchingQuestions extends QuizState {}

class QuestionsFetched extends QuizState {
  final List<QuizQuestion> questions;
  QuestionsFetched({required this.questions});
}

class ErrorFetchingQuestions extends QuizState {
  final String message;
  ErrorFetchingQuestions({required this.message});
}

class PlayingAudio extends QuizState {
  final AudioPlayer audio;
  PlayingAudio({required this.audio});
}

class FinishedPlayingAudio extends QuizState {
  final bool playingAudio;
  FinishedPlayingAudio({required this.playingAudio});
}

class ErrorPlayingAudio extends QuizState {
  final String message;
  ErrorPlayingAudio({required this.message});
}

class QuizSubmissionPending extends Equatable implements QuizState {
  const QuizSubmissionPending({
    required this.questionId,
    required this.scorePercentage,
    required this.answers,
    required this.totalTimeSpent,
    required this.retryCount,
    required this.nextRetryDelay,
    required this.isPollingActive,
    required this.localQuizResult,
  });

  final String questionId;
  final int scorePercentage;
  final List<bool> answers;
  final int totalTimeSpent;
  final int retryCount;
  final Duration nextRetryDelay;
  final bool isPollingActive;
  final QuizCompleted localQuizResult;

  @override
  List<Object?> get props => [
    questionId,
    scorePercentage,
    answers,
    totalTimeSpent,
    retryCount,
    nextRetryDelay,
    isPollingActive,
    localQuizResult,
  ];

  QuizSubmissionPending copyWith({
    String? questionId,
    int? scorePercentage,
    List<bool>? answers,
    int? totalTimeSpent,
    int? retryCount,
    Duration? nextRetryDelay,
    bool? isPollingActive,
    QuizCompleted? localQuizResult,
  }) {
    return QuizSubmissionPending(
      questionId: questionId ?? this.questionId,
      scorePercentage: scorePercentage ?? this.scorePercentage,
      answers: answers ?? this.answers,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      retryCount: retryCount ?? this.retryCount,
      nextRetryDelay: nextRetryDelay ?? this.nextRetryDelay,
      isPollingActive: isPollingActive ?? this.isPollingActive,
      localQuizResult: localQuizResult ?? this.localQuizResult,
    );
  }
}
