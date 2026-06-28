part of 'contest_bloc.dart';

abstract class ContestState {}

class ContestInitial extends ContestState {}

class ContestInProgress extends Equatable
    implements ContestState, ContestDataCache {
  const ContestInProgress({
    required this.questions,
    required this.currentQuestionIndex,
    required this.timeRemaining,
    required this.userOptions,
    required this.questionTimes,
    this.selectedOptions,
    required this.isAnswered,
    required this.timerProgress,
    required this.contestId,
    this.cachedContests,
    this.cachedPage,
  });
  final List<Question> questions;
  final int currentQuestionIndex;
  final int timeRemaining;
  final List<QuestionOption?> userOptions;
  final List<int> questionTimes;
  final String? selectedOptions;
  final bool isAnswered;
  final double timerProgress;
  final String contestId;
  @override
  final AllContestData? cachedContests;

  @override
  final int? cachedPage;

  ContestInProgress copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? timeRemaining,
    List<QuestionOption?>? userOptions,
    List<int>? questionTimes,
    String? selectedOptions,
    bool? isAnswered,
    double? timerProgress,
    String? contestId,
    AllContestData? cachedContests,
    int? cachedPage,
  }) {
    return ContestInProgress(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      userOptions: userOptions ?? this.userOptions,
      questionTimes: questionTimes ?? this.questionTimes,
      selectedOptions: selectedOptions,
      isAnswered: isAnswered ?? this.isAnswered,
      timerProgress: timerProgress ?? this.timerProgress,
      contestId: contestId ?? this.contestId,
      cachedContests: cachedContests ?? this.cachedContests,
      cachedPage: cachedPage ?? this.cachedPage,
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
    contestId,
    cachedContests,
    cachedPage,
  ];
}

class ContestXPEarned extends Equatable
    implements ContestState, ContestDataCache {
  const ContestXPEarned({
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
    required this.contestId,
    required this.correctAnswers,
    required this.incorrectAnswers,
    this.cachedContests,
    this.cachedPage,
  });

  final List<QuestionOption?> userOptions;
  final List<Question> questions;
  final int xpEarned;
  final int gemsEarned;
  final int score;
  final int totalQuestions;
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final double scorePercentage;
  final List<int> questionTimes;
  final String contestId;
  final int correctAnswers;
  final int incorrectAnswers;
  @override
  final AllContestData? cachedContests;

  @override
  final int? cachedPage;

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
    contestId,
    correctAnswers,
    incorrectAnswers,
    cachedContests,
    cachedPage,
  ];
}

class ContestSubmitting extends ContestState {}

class ErrorSubmittingContest extends Equatable
    implements ContestState, ContestDataCache {
  const ErrorSubmittingContest({
    required this.message,
    required this.questions,
    required this.userOptions,
    required this.questionTimes,
    required this.contestId,
    this.cachedContests,
    this.cachedPage,
  });

  final String message;
  final List<Question> questions;
  final List<QuestionOption?> userOptions;
  final List<int> questionTimes;
  final String contestId;
  @override
  final AllContestData? cachedContests;

  @override
  final int? cachedPage;

  @override
  List<Object?> get props => [
    message,
    questions,
    userOptions,
    questionTimes,
    contestId,
    cachedContests,
    cachedPage,
  ];
}

class FetchingContestQuestions extends ContestState {}

class FetchingAllContests extends ContestState {
  FetchingAllContests({this.cachedContests, this.cachedPage});

  final AllContestData? cachedContests;
  final int? cachedPage;
}

class JoiningContest extends ContestState {
  JoiningContest({this.cachedContests, this.cachedPage});

  final AllContestData? cachedContests;
  final int? cachedPage;
}

class ContestJoined extends Equatable implements ContestState {
  const ContestJoined({
    required this.participation,
    this.hasStartedContest = false,
  });

  final ContestParticipation participation;
  final bool hasStartedContest;

  ContestJoined copyWith({
    ContestParticipation? participation,
    bool? hasStartedContest,
  }) {
    return ContestJoined(
      participation: participation ?? this.participation,
      hasStartedContest: hasStartedContest ?? this.hasStartedContest,
    );
  }

  @override
  List<Object?> get props => [participation, hasStartedContest];
}

class ErrorJoiningContest extends Equatable implements ContestState {
  const ErrorJoiningContest({
    required this.message,
    this.cachedContests,
    this.cachedPage,
  });
  final String message;
  final AllContestData? cachedContests;
  final int? cachedPage;

  @override
  List<Object?> get props => [message];
}

class EnteringAccessCode extends Equatable implements ContestState {
  const EnteringAccessCode({required this.contest, this.errorMessage});
  final Contest contest;
  final String? errorMessage;

  @override
  List<Object?> get props => [contest, errorMessage];
}

class VerifyingAccessCode extends ContestState {
  final Contest contest;
  final String code;

  VerifyingAccessCode({required this.contest, required this.code});
}

class AccessCodeVerified extends Equatable implements ContestState {
  const AccessCodeVerified({
    required this.contest,
    required this.accessCode,
    required this.userGemBalance,
  });
  final Contest contest;
  final String accessCode;
  final int userGemBalance;
  @override
  List<Object?> get props => [contest, accessCode, userGemBalance];
}

class AccessCodeInvalid extends Equatable implements ContestState {
  const AccessCodeInvalid({required this.contest, required this.errorMessage});
  final Contest contest;
  final String errorMessage;

  @override
  List<Object?> get props => [contest, errorMessage];
}

class ShowingPayment extends Equatable implements ContestState {
  const ShowingPayment({
    required this.contest,
    this.accessCode,
    required this.userGemBalance,
  });

  final Contest contest;
  final String? accessCode;
  final int userGemBalance;

  bool get hasEnoughGems {
    final entryFee = int.tryParse(contest.entryFee.toString()) ?? 0;
    return userGemBalance >= entryFee;
  }

  int get remainingBalance {
    final entryFee = contest.entryFee;
    if (entryFee == null) return 0;
    return userGemBalance - entryFee;
  }

  int get entryFee => contest.entryFee ?? 0;

  @override
  List<Object?> get props => [contest, accessCode, userGemBalance];
}

class ProcessingPayment extends Equatable implements ContestState {
  const ProcessingPayment({required this.contest, this.accessCode});
  final Contest contest;
  final String? accessCode;

  @override
  List<Object?> get props => [contest, accessCode];
}

class PaymentSuccessful extends Equatable implements ContestState {
  const PaymentSuccessful({
    required this.contest,
    this.accessCode,
    required this.newBalance,
  });

  final Contest contest;
  final String? accessCode;
  final int newBalance;

  @override
  List<Object?> get props => [contest, accessCode, newBalance];
}

class PaymentFailed extends Equatable implements ContestState {
  final Contest contest;
  final String? accessCode;
  final String errorMessage;
  final int userGemBalance;

  const PaymentFailed({
    required this.contest,
    this.accessCode,
    required this.errorMessage,
    required this.userGemBalance,
  });

  @override
  List<Object?> get props => [
    contest,
    accessCode,
    errorMessage,
    userGemBalance,
  ];
}

class InsufficientGems extends Equatable implements ContestState {
  const InsufficientGems({
    required this.contest,
    required this.userGemBalance,
    required this.requiredGems,
  });
  final Contest contest;
  final int userGemBalance;
  final int requiredGems;

  int get shortfall => requiredGems - userGemBalance;

  @override
  List<Object?> get props => [contest, userGemBalance, requiredGems];
}

class StartingContest extends ContestState {}

class ContestStarted extends ContestState {}

class ErrorStartingContest extends Equatable implements ContestState {
  const ErrorStartingContest({
    required this.message,
    this.failedToStartContest = false,
    this.contestId,
  });

  final String message;
  final bool failedToStartContest;
  final String? contestId;

  @override
  List<Object?> get props => [message, failedToStartContest, contestId];
}

class FetchingContestsCompleted extends ContestState {
  FetchingContestsCompleted({
    required this.contests,
    this.hasMoreData = true,
    this.currentPage = 1,
    this.isBackgroundRefresh = false,
  });

  final AllContestData contests;
  final bool hasMoreData;
  final int currentPage;
  final bool isBackgroundRefresh;
}

class ErrorFetchingAllContests extends ContestState {
  final String message;
  ErrorFetchingAllContests({required this.message});
}

class ContestQuestionsFetched extends ContestState {
  final List<Question> questions;
  ContestQuestionsFetched({required this.questions});
}

class ErrorFetchingContestQuestions extends ContestState {
  final String message;
  ErrorFetchingContestQuestions({required this.message});
}

class PlayingContestAudio extends ContestState {
  final AudioPlayer audio;
  PlayingContestAudio({required this.audio});
}

class FinishedPlayingContestAudio extends ContestState {
  final bool playingAudio;
  FinishedPlayingContestAudio({required this.playingAudio});
}

class ErrorPlayingContestAudio extends ContestState {
  final String message;
  ErrorPlayingContestAudio({required this.message});
}

mixin ContestDataCache {
  AllContestData? get cachedContests => null;
  int? get cachedPage => null;
}

class JoingPrivateContest extends ContestState {}
