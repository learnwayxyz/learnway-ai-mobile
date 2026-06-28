import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/quiz/models/quiz_response.dart';
import 'package:learnwayv2/features/quiz/models/submit_quiz_response.dart';
import 'package:learnwayv2/features/quiz/quiz_repository/quiz_repository.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/connectivity_service.dart';
import 'package:core/core.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  Timer? _timer;
  Timer? _retryTimer;
  StreamSubscription<bool>? _connectivitySubscription;
  static const int _questionDuration = 30;
  static const int _maxRetryAttempts = 10;
  static const Duration _initialRetryDelay = Duration(seconds: 5);
  static const Duration _maxRetryDelay = Duration(minutes: 5);
  DateTime? _questionStartTime;
  final QuizRepository _quizRepository = locator<QuizRepository>();
  final ConnectivityService _connectivityService = ConnectivityService();
  String _lessonTitle = '';
  bool _isRetryingSubmission = false;

  // Silent retry tracking (doesn't affect user-facing state)
  ({
    String questionId,
    int scorePercentage,
    List<bool> answers,
    int totalTimeSpent,
    int retryCount,
  })?
  _silentRetryData;

  QuizBloc() : super(QuizInitial()) {
    on<FetchQuestions>(_fetchLessonQuestions);
    on<StartQuiz>(_onStartQuiz);
    on<SelectAnOption>(_onSelectAnOption);
    on<NextQuestion>(_onNextQuestion);
    on<TimerTick>(_onTimerTick);
    on<TimeExpired>(_onTimeExpired);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<ShowXPScreen>(_onShowXPScreen);
    on<ShowResultsScreen>(_onShowFinalResults);
    on<ResetQuiz>(_onResetQuiz);
    on<PlayAudio>(_onPlaySound);
    on<RetrySubmitQuiz>(_onRetrySubmitQuiz);
    on<CheckConnectivityAndRetry>(_onCheckConnectivityAndRetry);
    on<StopRetryPolling>(_onStopRetryPolling);
    on<StartBackgroundRetry>(_onStartBackgroundRetry);
    _initializeConnectivityMonitoring();
  }

  void _onStartQuiz(StartQuiz event, Emitter<QuizState> emit) {
    _lessonTitle = event.lessonTitle;
    final options = List<QuizOption?>.filled(event.questions.length, null);
    final questionTimes = List<int>.filled(event.questions.length, 0);

    emit(
      QuizInProgress(
        questions: event.questions,
        currentQuestionIndex: 0,
        timeRemaining: _questionDuration,
        userOptions: options,
        questionTimes: questionTimes,
        isAnswered: false,
        timerProgress: 1.0,
      ),
    );
    _startQuestionTimer();
  }

  Future<void> _fetchLessonQuestions(
    FetchQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(FetchingQuestions());
    final response = await _quizRepository.getQuestions(event.questionId);
    response.fold(
      (failure) {
        emit(ErrorFetchingQuestions(message: failure.message));
      },
      (success) {
        emit(QuestionsFetched(questions: success.content));
        add(StartQuiz(success.content, lessonTitle: event.lessonTitle));
      },
    );
  }

  Future<void> _onSelectAnOption(
    SelectAnOption event,
    Emitter<QuizState> emit,
  ) async {
    final currentState = state;
    if (currentState is! QuizInProgress || currentState.isAnswered) return;

    _timer?.cancel();

    // Calculate time spent on this question
    final timeSpent = _calculateTimeSpentOnCurrentQuestion();

    final updatedUserOptions = List<QuizOption?>.from(currentState.userOptions);
    updatedUserOptions[currentState.currentQuestionIndex] = event.option;

    final updatedQuestionTimes = List<int>.from(currentState.questionTimes);
    updatedQuestionTimes[currentState.currentQuestionIndex] = timeSpent;

    emit(
      currentState.copyWith(
        selectedOptions: event.option.option,
        isAnswered: true,
        userOptions: updatedUserOptions,
        questionTimes: updatedQuestionTimes,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!emit.isDone && state is QuizInProgress) {
      add(NextQuestion());
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
      emit(
        currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
          timeRemaining: _questionDuration,
          selectedOptions: null,
          isAnswered: false,
          timerProgress: 1.0,
        ),
      );
      _startQuestionTimer();
    } else {
      appRouter.push(QuizSubmitRoute(quizId: currentState.questions.first.id));
    }
  }

  void _onTimerTick(TimerTick event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is! QuizInProgress || currentState.isAnswered) return;

    final now = DateTime.now();
    final elapsed = now.difference(_questionStartTime!).inMilliseconds;
    final remaining = _questionDuration * 1000 - elapsed;
    final timeInSeconds = (remaining / 1000).ceil().clamp(0, _questionDuration);
    final progress = (remaining / (_questionDuration * 1000)).clamp(0.0, 1.0);

    if (timeInSeconds <= 0) {
      add(TimeExpired());
      return;
    }

    emit(
      currentState.copyWith(
        timeRemaining: timeInSeconds,
        timerProgress: progress,
      ),
    );
  }

  Future<void> _onTimeExpired(
    TimeExpired event,
    Emitter<QuizState> emit,
  ) async {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    _timer?.cancel();

    final updatedQuestionTimes = List<int>.from(currentState.questionTimes);
    updatedQuestionTimes[currentState.currentQuestionIndex] = _questionDuration;

    emit(
      currentState.copyWith(
        timeRemaining: 0,
        timerProgress: 0.0,
        isAnswered: true,
        questionTimes: updatedQuestionTimes,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (!emit.isDone && state is QuizInProgress) {
      add(NextQuestion());
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    _timer?.cancel();

    // Use consistent naming: this is the LESSON ID
    final lessonId = event.questionId;
    log('=== Starting Quiz Submission ===');
    log('Lesson ID: $lessonId');

    // Store quiz data before emitting QuizSubmitting state
    // This allows the catch block to access the data if a timeout occurs
    final storedQuestions = currentState.questions;
    final storedUserOptions = currentState.userOptions;
    final storedQuestionTimes = currentState.questionTimes;

    emit(QuizSubmitting());

    try {
      // Calculate score and answers
      int score = 0;
      List<bool> answers = [];

      for (int i = 0; i < storedQuestions.length; i++) {
        final selectedOption = storedUserOptions[i];
        final correctAnswer = storedQuestions[i].options.firstWhere(
          (opt) => opt.correct,
        );

        bool isCorrect = selectedOption?.id == correctAnswer.id;
        answers.add(isCorrect);

        if (isCorrect) {
          score++;
        }
      }

      // Calculate metrics
      final timeMetrics = _calculateTimeMetrics(
        storedQuestionTimes,
        storedQuestions.length,
      );

      final gemsEarned = _calculateGems(score, storedQuestions.length);
      final xpEarned = _calculateXP(storedUserOptions, storedQuestions);
      final scorePercentage = _calculatePercentage(
        score,
        storedQuestions.length,
      );

      // Check if lesson is already completed
      bool isLessonCompleted = false;
      try {
        if (locator.isRegistered<bool>(instanceName: 'isCompleted')) {
          isLessonCompleted = locator.get<bool>(instanceName: 'isCompleted');
        }
      } catch (e) {
        log('Error getting completion status: $e');
        isLessonCompleted = false;
      }

      if (isLessonCompleted) {
        log('Lesson already completed, skipping server submission');

        // Calculate correct and incorrect answers for result screen
        final correctAnswers = _calculateCorrectAnswers(
          storedUserOptions,
          storedQuestions,
        );
        final incorrectAnswers = _calculateIncorrectAnswers(
          storedUserOptions,
          storedQuestions,
        );

        // Go directly to QuizCompleted state (retake scenario)
        emit(
          QuizCompleted(
            questions: storedQuestions,
            userAnswers: storedUserOptions,
            score: score,
            totalQuestions: storedQuestions.length,
            gemsEarned: gemsEarned,
            xpEarned: xpEarned,
            scorePercentage: scorePercentage,
            totalTimeSpent: timeMetrics.totalTimeSpent,
            timePercentage: timeMetrics.timePercentage,
            averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
            correctAnswers: correctAnswers,
            incorrectAnswers: incorrectAnswers,
            questionTimes: storedQuestionTimes,
            lessonTitle: _lessonTitle,
            isRetake: true,
          ),
        );
        return;
      }

      // Lesson not completed - proceed with server submission
      log('Lesson not completed, proceeding with server submission');

      // Calculate correct and incorrect answers for local result
      final correctAnswers = _calculateCorrectAnswers(
        storedUserOptions,
        storedQuestions,
      );
      final incorrectAnswers = _calculateIncorrectAnswers(
        storedUserOptions,
        storedQuestions,
      );

      // Create local quiz result to show user immediately if submission fails
      final localQuizResult = QuizCompleted(
        questions: storedQuestions,
        userAnswers: storedUserOptions,
        score: score,
        totalQuestions: storedQuestions.length,
        gemsEarned: gemsEarned,
        xpEarned: xpEarned,
        scorePercentage: scorePercentage,
        totalTimeSpent: timeMetrics.totalTimeSpent,
        timePercentage: timeMetrics.timePercentage,
        averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
        correctAnswers: correctAnswers,
        incorrectAnswers: incorrectAnswers,
        questionTimes: storedQuestionTimes,
        lessonTitle: _lessonTitle,
        isRetake: false,
      );

      // Prepare submission data
      final submissionData = {
        "lessonId": lessonId,
        "score": scorePercentage,
        "answers": answers,
        "timeSpent": timeMetrics.totalTimeSpent * 1000,
      };
      log('Submission payload: $submissionData');

      // Attempt to submit quiz results to server
      final response = await _quizRepository.submitQuizResults(
        lessonId,
        scorePercentage,
        answers,
        timeMetrics.totalTimeSpent * 1000,
      );

      response.fold(
        // Submission failed
        (failure) {
          log('Initial submission failed: ${failure.message}');
          log('Starting retry mechanism');

          // Show user their results immediately
          emit(localQuizResult);
          appRouter.push(const QuizResultRoute());

          // Start background polling for submission retry
          emit(
            QuizSubmissionPending(
              questionId: lessonId,
              scorePercentage: scorePercentage,
              answers: answers,
              totalTimeSpent: timeMetrics.totalTimeSpent * 1000,
              retryCount: 0,
              nextRetryDelay: _initialRetryDelay,
              isPollingActive: true,
              localQuizResult: localQuizResult,
            ),
          );

          // Schedule first retry
          _scheduleNextRetry(_initialRetryDelay);
        },
        // Submission successful
        (success) {
          log('Initial submission successful');

          emit(
            QuizGemsEarned(
              gemsEarned: gemsEarned,
              score: score,
              totalQuestions: storedQuestions.length,
              xpEarned: xpEarned,
              scorePercentage: scorePercentage,
              totalTimeSpent: timeMetrics.totalTimeSpent,
              timePercentage: timeMetrics.timePercentage,
              averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
              userOptions: storedUserOptions,
              questions: storedQuestions,
              questionTimes: storedQuestionTimes,
              submissionData: success,
            ),
          );
        },
      );
    } catch (e) {
      log('Error in _onSubmitQuiz: $e');

      final isTimeout =
          e.toString().toLowerCase().contains('timeout') ||
          e.toString().toLowerCase().contains('timed out');

      if (isTimeout) {
        log('Request timed out, handling gracefully');

        // Recalculate everything using stored data
        int score = 0;
        List<bool> answers = [];

        for (int i = 0; i < storedQuestions.length; i++) {
          final selectedOption = storedUserOptions[i];
          final correctAnswer = storedQuestions[i].options.firstWhere(
            (opt) => opt.correct,
          );

          bool isCorrect = selectedOption?.id == correctAnswer.id;
          answers.add(isCorrect);

          if (isCorrect) {
            score++;
          }
        }

        final timeMetrics = _calculateTimeMetrics(
          storedQuestionTimes,
          storedQuestions.length,
        );

        final gemsEarned = _calculateGems(score, storedQuestions.length);
        final xpEarned = _calculateXP(storedUserOptions, storedQuestions);
        final scorePercentage = _calculatePercentage(
          score,
          storedQuestions.length,
        );

        final correctAnswers = _calculateCorrectAnswers(
          storedUserOptions,
          storedQuestions,
        );
        final incorrectAnswers = _calculateIncorrectAnswers(
          storedUserOptions,
          storedQuestions,
        );

        // Emit GemsEarned state immediately to unblock UI
        emit(
          QuizGemsEarned(
            gemsEarned: gemsEarned,
            score: score,
            totalQuestions: storedQuestions.length,
            xpEarned: xpEarned,
            scorePercentage: scorePercentage,
            totalTimeSpent: timeMetrics.totalTimeSpent,
            timePercentage: timeMetrics.timePercentage,
            averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
            userOptions: storedUserOptions,
            questions: storedQuestions,
            questionTimes: storedQuestionTimes,
            submissionData: null, // No submission data since request timed out
          ),
        );

        // Create local quiz result for background retry
        final localQuizResult = QuizCompleted(
          questions: storedQuestions,
          userAnswers: storedUserOptions,
          score: score,
          totalQuestions: storedQuestions.length,
          gemsEarned: gemsEarned,
          xpEarned: xpEarned,
          scorePercentage: scorePercentage,
          totalTimeSpent: timeMetrics.totalTimeSpent,
          timePercentage: timeMetrics.timePercentage,
          averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
          correctAnswers: correctAnswers,
          incorrectAnswers: incorrectAnswers,
          questionTimes: storedQuestionTimes,
          lessonTitle: _lessonTitle,
          isRetake: false,
        );

        // Start silent background retry
        log('Starting silent background retry for lesson: $lessonId');
        add(
          StartBackgroundRetry(
            questionId: lessonId,
            scorePercentage: scorePercentage,
            answers: answers,
            totalTimeSpent: timeMetrics.totalTimeSpent * 1000,
            localQuizResult: localQuizResult,
          ),
        );
      } else {
        // Non-timeout error
        log('Non-timeout error occurred: $e');
        emit(ErrorSubmittingQuiz(message: 'Failed to submit quiz: $e'));
      }
    }
  }

  void _onShowXPScreen(ShowXPScreen event, Emitter<QuizState> emit) {
    final currentState = state;
    if (currentState is! QuizGemsEarned) return;

    emit(
      QuizXPEarned(
        userOptions: currentState.userOptions,
        questions: currentState.questions,
        xpEarned: currentState.xpEarned,
        gemsEarned: currentState.gemsEarned,
        score: currentState.score,
        totalQuestions: currentState.totalQuestions,
        totalTimeSpent: currentState.totalTimeSpent,
        timePercentage: currentState.timePercentage,
        averageTimePerQuestion: currentState.averageTimePerQuestion,
        scorePercentage: currentState.scorePercentage,
        questionTimes: currentState.questionTimes,
      ),
    );
    appRouter.push(const QuizXPEarnedRoute());
  }

  final AudioPlayer _player = AudioPlayer();

  void _onPlaySound(PlayAudio event, Emitter<QuizState> emit) async {
    final isSoundEnabled = await SharedPreferencesStore.getSoundEnabled();
    if (!isSoundEnabled) return;
    await _player.stop();
    if (event.isCorrect) {
      await _player.setAsset('assets/sounds/assets_sounds_right.mp3');
    } else {
      await _player.setAsset('assets/sounds/assets_sounds_wrong.mp3');
    }
    _player.play();
  }

  void _onShowFinalResults(ShowResultsScreen event, Emitter<QuizState> emit) {
    final currentState = state;

    if (currentState is QuizXPEarned) {
      final correctAnswers = _calculateCorrectAnswers(
        currentState.userOptions,
        currentState.questions,
      );
      final inCorrectAnswers = _calculateIncorrectAnswers(
        currentState.userOptions,
        currentState.questions,
      );
      emit(
        QuizCompleted(
          questions: currentState.questions,
          userAnswers: currentState.userOptions,
          score: currentState.score,
          totalQuestions: currentState.totalQuestions,
          gemsEarned: currentState.gemsEarned,
          xpEarned: currentState.xpEarned,
          scorePercentage: currentState.scorePercentage,
          totalTimeSpent: currentState.totalTimeSpent,
          timePercentage: currentState.timePercentage,
          averageTimePerQuestion: currentState.averageTimePerQuestion,
          correctAnswers: correctAnswers,
          incorrectAnswers: inCorrectAnswers,
          questionTimes: currentState.questionTimes,
          lessonTitle: _lessonTitle,
          isRetake: false,
        ),
      );
      appRouter.push(const QuizResultRoute());
    }
  }

  int _calculateGems(int score, int totalQuestions) {
    final scorePercentage = _calculatePercentage(score, totalQuestions);
    final gems = 60 - (100 - scorePercentage);
    return gems < 0 ? 0 : gems.round();
  }

  int _calculateXP(List<QuizOption?> options, List<QuizQuestion> questions) {
    int xp = 0;

    for (int i = 0; i < questions.length; i++) {
      final selected = options[i];
      final correctOption = questions[i].options.firstWhere(
        (opt) => opt.correct,
      );

      if (selected?.id == correctOption.id) {
        xp += 4;
      } else {
        xp -= 2;
      }
    }

    return xp < 0 ? 0 : xp;
  }

  int _calculatePercentage(int score, int totalQuestions) {
    if (totalQuestions == 0) return 0;
    return ((score / totalQuestions) * 100).round();
  }

  int _calculateCorrectAnswers(
    List<QuizOption?> userOptions,
    List<QuizQuestion> questions,
  ) {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = userOptions[i];
      final correctOptions = questions[i].options.firstWhere(
        (opt) => opt.correct,
      );
      if (selected?.id == correctOptions.id) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  int _calculateIncorrectAnswers(
    List<QuizOption?> userOptions,
    List<QuizQuestion> questions,
  ) {
    int incorrectAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = userOptions[i];
      final correctOptions = questions[i].options.firstWhere(
        (opt) => opt.correct,
      );
      if (selected?.id != correctOptions.id) {
        incorrectAnswers++;
      }
    }
    return incorrectAnswers;
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizInitial());
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _questionStartTime = DateTime.now();

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      add(TimerTick());
    });
  }

  int _calculateTimeSpentOnCurrentQuestion() {
    if (_questionStartTime == null) return 0;
    final now = DateTime.now();
    final elapsed = now.difference(_questionStartTime!).inSeconds;
    return elapsed.clamp(0, _questionDuration);
  }

  TimeMetrics _calculateTimeMetrics(
    List<int> questionTimes,
    int totalQuestions,
  ) {
    final totalTimeSpent = questionTimes.reduce((a, b) => a + b);
    final maxPossibleTime = totalQuestions * _questionDuration;
    final timePercentage = (totalTimeSpent / maxPossibleTime) * 100;
    final averageTimePerQuestion = totalTimeSpent / totalQuestions;

    return TimeMetrics(
      totalTimeSpent: totalTimeSpent,
      timePercentage: timePercentage,
      averageTimePerQuestion: averageTimePerQuestion,
      maxPossibleTime: maxPossibleTime,
    );
  }

  void _cleanupCompletionStatus() {
    try {
      if (locator.isRegistered<bool>(instanceName: 'isCompleted')) {
        locator.unregister<bool>(instanceName: 'isCompleted');
        log('Cleaned up completion status');
      }
    } catch (e) {
      log('Error cleaning up completion status: $e');
    }
  }

  void _initializeConnectivityMonitoring() {
    _connectivitySubscription = _connectivityService.connectionStatus.listen((
      hasConnection,
    ) {
      log('Connectivity changed: $hasConnection');

      // Check for silent retry
      if (hasConnection && _silentRetryData != null && !_isRetryingSubmission) {
        log('Connection restored, triggering silent retry');
        add(CheckConnectivityAndRetry());
        return;
      }

      // Check for regular retry
      if (hasConnection && state is QuizSubmissionPending) {
        final pendingState = state as QuizSubmissionPending;
        if (!_isRetryingSubmission && pendingState.isPollingActive) {
          log('Connection restored, triggering retry');
          add(CheckConnectivityAndRetry());
        }
      }
    });
  }

  Future<void> _onRetrySubmitQuiz(
    RetrySubmitQuiz event,
    Emitter<QuizState> emit,
  ) async {
    log('_onRetrySubmitQuiz() ');
    // Check for silent retry first
    if (_silentRetryData != null) {
      await _handleSilentRetry(emit);
      return;
    }

    // Regular retry logic for QuizSubmissionPending state
    final currentState = state;
    if (currentState is! QuizSubmissionPending) {
      log(
        'Cannot retry: state is not QuizSubmissionPending and no silent retry data',
      );
      return;
    }

    if (_isRetryingSubmission) {
      log('Already retrying submission, skipping duplicate retry');
      return;
    }

    _isRetryingSubmission = true;
    _retryTimer?.cancel();

    log('Attempting submission retry ${currentState.retryCount + 1}');

    try {
      log('Attempting submission retry ${currentState.questionId}');
      final response = await _quizRepository.submitQuizResults(
        currentState.questionId,
        currentState.scorePercentage,
        currentState.answers,
        currentState.totalTimeSpent,
      );

      response.fold(
        (failure) {
          log('Submission retry failed: ${failure.message}');
          _handleRetryFailure(currentState, emit);
        },
        (success) {
          log(
            'Submission successful after ${currentState.retryCount + 1} retries',
          );
          _handleSuccessfulSubmission(currentState, success, emit);
        },
      );
    } catch (e) {
      log('Error during retry: $e');
      _handleRetryFailure(currentState, emit);
    } finally {
      _isRetryingSubmission = false;
    }
  }

  Future<void> _handleSilentRetry(Emitter<QuizState> emit) async {
    if (_silentRetryData == null) return;

    if (_isRetryingSubmission) {
      log('Already retrying submission, skipping duplicate retry');
      return;
    }

    _isRetryingSubmission = true;
    _retryTimer?.cancel();

    final retryData = _silentRetryData!;
    log(
      'Attempting silent retry ${retryData.retryCount + 1} with questionId: ${retryData.questionId}',
    );

    try {
      final response = await _quizRepository.submitQuizResults(
        retryData.questionId,
        retryData.scorePercentage,
        retryData.answers,
        retryData.totalTimeSpent,
      );

      response.fold(
        (failure) {
          log('Silent retry failed: ${failure.message}');
          _handleSilentRetryFailure();
        },
        (success) {
          log(
            'Silent retry successful after ${retryData.retryCount + 1} attempts',
          );
          _handleSilentRetrySuccess();
        },
      );
    } catch (e) {
      log('Error during silent retry: $e');
      _handleSilentRetryFailure();
    } finally {
      _isRetryingSubmission = false;
    }
  }

  void _handleSilentRetryFailure() {
    if (_silentRetryData == null) return;

    final newRetryCount = _silentRetryData!.retryCount + 1;

    if (newRetryCount >= _maxRetryAttempts) {
      log('Max silent retry attempts reached, stopping');
      _silentRetryData = null;
      return;
    }

    // Update retry count
    _silentRetryData = (
      questionId: _silentRetryData!.questionId,
      scorePercentage: _silentRetryData!.scorePercentage,
      answers: _silentRetryData!.answers,
      totalTimeSpent: _silentRetryData!.totalTimeSpent,
      retryCount: newRetryCount,
    );

    final nextDelay = _calculateNextRetryDelay(newRetryCount);
    log('Scheduling next silent retry in ${nextDelay.inSeconds} seconds');
    _scheduleNextRetry(nextDelay);
  }

  void _handleSilentRetrySuccess() {
    log('Silent retry completed successfully, clearing retry data');
    _silentRetryData = null;
    _retryTimer?.cancel();
  }

  void _handleRetryFailure(
    QuizSubmissionPending currentState,
    Emitter<QuizState> emit,
  ) {
    final newRetryCount = currentState.retryCount + 1;

    if (newRetryCount >= _maxRetryAttempts) {
      log('Max retry attempts reached, stopping polling');
      emit(
        currentState.copyWith(
          retryCount: newRetryCount,
          isPollingActive: false,
        ),
      );
      return;
    }

    final nextDelay = _calculateNextRetryDelay(newRetryCount);
    log('Scheduling next retry in ${nextDelay.inSeconds} seconds');

    emit(
      currentState.copyWith(
        retryCount: newRetryCount,
        nextRetryDelay: nextDelay,
      ),
    );

    _scheduleNextRetry(nextDelay);
  }

  void _handleSuccessfulSubmission(
    QuizSubmissionPending currentState,
    SubmitQuizResponse success,
    Emitter<QuizState> emit,
  ) {
    _retryTimer?.cancel();

    final localResult = currentState.localQuizResult;

    emit(
      QuizGemsEarned(
        gemsEarned: localResult.gemsEarned,
        score: localResult.score,
        totalQuestions: localResult.totalQuestions,
        xpEarned: localResult.xpEarned,
        scorePercentage: localResult.scorePercentage,
        totalTimeSpent: localResult.totalTimeSpent,
        timePercentage: localResult.timePercentage,
        averageTimePerQuestion: localResult.averageTimePerQuestion,
        userOptions: localResult.userAnswers,
        questions: localResult.questions,
        questionTimes: localResult.questionTimes,
        submissionData: success,
      ),
    );
  }

  Duration _calculateNextRetryDelay(int retryCount) {
    final delay = Duration(
      milliseconds: _initialRetryDelay.inMilliseconds * (1 << retryCount),
    );
    return delay > _maxRetryDelay ? _maxRetryDelay : delay;
  }

  void _scheduleNextRetry(Duration delay) {
    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      if (!isClosed) {
        add(CheckConnectivityAndRetry());
      }
    });
  }

  Future<void> _onCheckConnectivityAndRetry(
    CheckConnectivityAndRetry event,
    Emitter<QuizState> emit,
  ) async {
    if (!_connectivityService.hasConnection) {
      log('No connection available, waiting for connectivity');
      return;
    }

    // Check for silent retry first
    if (_silentRetryData != null) {
      add(RetrySubmitQuiz());
      return;
    }

    // Check for regular retry
    final currentState = state;
    if (currentState is! QuizSubmissionPending) return;

    add(RetrySubmitQuiz());
  }

  void _onStopRetryPolling(StopRetryPolling event, Emitter<QuizState> emit) {
    // Clear silent retry data
    if (_silentRetryData != null) {
      _silentRetryData = null;
      _retryTimer?.cancel();
      log('Silent retry polling stopped');
      return;
    }

    // Stop regular retry polling
    final currentState = state;
    if (currentState is QuizSubmissionPending) {
      _retryTimer?.cancel();
      emit(currentState.copyWith(isPollingActive: false));
      log('Retry polling stopped');
    }
  }

  void _onStartBackgroundRetry(
    StartBackgroundRetry event,
    Emitter<QuizState> emit,
  ) {
    log('Starting silent background retry mechanism');

    // Store retry data without emitting state (keeps user on QuizGemsEarned flow)
    _silentRetryData = (
      questionId: event.questionId,
      scorePercentage: event.scorePercentage,
      answers: event.answers,
      totalTimeSpent: event.totalTimeSpent,
      retryCount: 0,
    );

    // Trigger first retry after initial delay
    _scheduleNextRetry(_initialRetryDelay);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _retryTimer?.cancel();
    await _connectivitySubscription?.cancel();
    await _player.dispose();
    _cleanupCompletionStatus();
    return super.close();
  }
}

class TimeMetrics {
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final int maxPossibleTime;

  TimeMetrics({
    required this.totalTimeSpent,
    required this.timePercentage,
    required this.averageTimePerQuestion,
    required this.maxPossibleTime,
  });
}
