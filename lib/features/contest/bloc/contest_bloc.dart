import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/contest/model/all_contest_model.dart';
import 'package:learnwayv2/features/contest/model/join_contest_model.dart';
import 'package:learnwayv2/features/contest/model/start_contest_model.dart';
import 'package:learnwayv2/features/contest/repository/contest_repository.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

part 'contest_event.dart';
part 'contest_state.dart';

class ContestBloc extends Bloc<ContestEvent, ContestState> {
  Timer? _timer;
  static const int _questionDuration = 30;
  DateTime? _questionStartTime;
  final ContestRepository _contestRepository = locator<ContestRepository>();
  AllContestData? _cachedContests;
  int? _cachedPage;
  bool? _cachedHasMoreData;

  final Map<String, AllContestData> _contestCacheByStatus = {};
  final Map<String, int> _pageByStatus = {};
  final Map<String, bool> _hasMoreDataByStatus = {};

  ContestBloc() : super(ContestInitial()) {
    on<StartContest>(_onStartContest);
    on<SelectContestOption>(_onSelectContestOption);
    on<NextContestQuestion>(_onNextContestQuestion);
    on<ContestTimerTick>(_onTimerTick);
    on<ContestTimeExpired>(_onTimeExpired);
    on<SubmitContest>(_onSubmitContest);
    on<ShowContestResultsScreen>(_onShowFinalResults);
    on<ResetContest>(_onResetContest);
    on<PlayContestAudio>(_onPlaySound);
    on<GetAllContestsEvent>(_onGetAllContests);
    on<JoinContestEvent>(_onJoinContests);
    on<JoinPrivateContestEvent>(_onJoinPrivateContest);
    on<InitializeEntry>(_onInitializeEntry);
    on<SubmitAccessCode>(_onSubmitAccessCode);
    on<RetryAccessCode>(_onRetryAccessCode);
    on<ProcessPayment>(_onProcessPayment);
    on<BackToCodeEntry>(_onBackToCodeEntry);
    on<RetryStartContest>(_onRetryStartContest);
    on<RestoreCachedContestsEvent>(_onRestoreCachedContests);
    on<ShowPaymentScreen>(_onShowPaymentScreen);
  }

  bool get hasCachedContests => _cachedContests != null;

  void clearContestCache() {
    _cachedContests = null;
    _cachedPage = null;
    _cachedHasMoreData = null;
    _contestCacheByStatus.clear();
    _pageByStatus.clear();
    _hasMoreDataByStatus.clear();
  }

  String _getCacheKey(ContestStatus? status) {
    return status?.toString() ?? 'all';
  }

  void restoreCachedContests(Emitter<ContestState> emit) {
    if (_cachedContests != null) {
      emit(
        FetchingContestsCompleted(
          contests: _cachedContests!,
          hasMoreData: _cachedHasMoreData ?? false,
          currentPage: _cachedPage ?? 1,
        ),
      );
    } else {
      emit(ContestInitial());
    }
  }

  Future<void> _onRestoreCachedContests(
    RestoreCachedContestsEvent event,
    Emitter<ContestState> emit,
  ) async {
    restoreCachedContests(emit);
  }

  Future<void> _onInitializeEntry(
    InitializeEntry event,
    Emitter<ContestState> emit,
  ) async {
    if (event.contest.type != ContestType.private) {
      final userBalance = await _getUserGemBalance();
      emit(
        ShowingPayment(
          contest: event.contest,
          accessCode: null,
          userGemBalance: userBalance,
        ),
      );
    } else {
      emit(EnteringAccessCode(contest: event.contest));
    }
  }

  Future<void> _onSubmitAccessCode(
    SubmitAccessCode event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EnteringAccessCode) return;

    if (event.code.length != 6) {
      emit(
        EnteringAccessCode(
          contest: currentState.contest,
          errorMessage: 'Please enter a valid 6-digit code',
        ),
      );
      return;
    }

    final userBalance = await _getUserGemBalance();
    emit(
      AccessCodeVerified(
        contest: currentState.contest,
        accessCode: event.code,
        userGemBalance: userBalance,
      ),
    );
  }

  Future<void> _onRetryAccessCode(
    RetryAccessCode event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is AccessCodeInvalid) {
      emit(EnteringAccessCode(contest: currentState.contest));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShowingPayment) return;

    final entryFee = currentState.contest.entryFee;
    if (!currentState.hasEnoughGems) {
      emit(
        InsufficientGems(
          contest: currentState.contest,
          userGemBalance: currentState.userGemBalance,
          requiredGems: entryFee ?? 0,
        ),
      );
      return;
    }
    emit(
      ProcessingPayment(
        contest: currentState.contest,
        accessCode: currentState.accessCode,
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      log(' Payment successful: $entryFee gems');

      if (entryFee == null) return;
      final newBalance = currentState.userGemBalance - entryFee;
      emit(
        PaymentSuccessful(
          contest: currentState.contest,
          accessCode: currentState.accessCode,
          newBalance: newBalance,
        ),
      );
    } catch (e) {
      log('Payment failed: $e');
      emit(
        PaymentFailed(
          contest: currentState.contest,
          accessCode: currentState.accessCode,
          errorMessage: 'Payment failed. Please try again.',
          userGemBalance: currentState.userGemBalance,
        ),
      );
    }
  }

  Future<void> _onBackToCodeEntry(
    BackToCodeEntry event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is ShowingPayment && currentState.accessCode != null) {
      emit(EnteringAccessCode(contest: currentState.contest));
    }
  }

  Future<void> _onShowPaymentScreen(
    ShowPaymentScreen event,
    Emitter<ContestState> emit,
  ) async {
    final userBalance = await _getUserGemBalance();
    emit(
      ShowingPayment(
        contest: event.contest,
        accessCode: event.accessCode,
        userGemBalance: userBalance,
      ),
    );
  }

  Future<int> _getUserGemBalance() async {
    final gemBalance = LocalStorageService.getUserSync()?.totalGems;
    if (gemBalance != null) {
      return gemBalance;
    }
    return 0;
  }

  Future<void> _onStartContest(
    StartContest event,
    Emitter<ContestState> emit,
  ) async {
    try {
      emit(StartingContest());
      final result = await _contestRepository.startContest(event.contestId);
      await result.fold(
        (left) async {
          emit(
            ErrorStartingContest(
              message: left.message,
              failedToStartContest: true,
              contestId: event.contestId,
            ),
          );
        },
        (right) async {
          final options = List<QuestionOption?>.filled(
            right.questions.length,
            null,
          );
          final questionTimes = List<int>.filled(right.questions.length, 0);

          emit(ContestStarted());

          await Future.delayed(const Duration(milliseconds: 500));

          emit(
            ContestInProgress(
              questions: right.questions,
              currentQuestionIndex: 0,
              timeRemaining: _questionDuration,
              userOptions: options,
              questionTimes: questionTimes,
              isAnswered: false,
              timerProgress: 1.0,
              contestId: event.contestId,
              cachedContests: _cachedContests,
              cachedPage: _cachedPage,
            ),
          );
          _startQuestionTimer();
        },
      );
    } catch (e) {
      log('Error starting contest: $e');
      emit(
        ErrorStartingContest(
          message: 'Failed to start contest: $e',
          failedToStartContest: true,
          contestId: event.contestId,
        ),
      );
    }
  }

  Future<void> _onRetryStartContest(
    RetryStartContest event,
    Emitter<ContestState> emit,
  ) async {
    emit(StartingContest());
    add(StartContest(event.contestId));
  }

  Future<void> _onGetAllContests(
    GetAllContestsEvent event,
    Emitter<ContestState> emit,
  ) async {
    final cacheKey = _getCacheKey(event.contestStatus);
    final cachedData = _contestCacheByStatus[cacheKey];
    final cachedPage = _pageByStatus[cacheKey];
    final cachedHasMoreData = _hasMoreDataByStatus[cacheKey];
    if (cachedData != null &&
        !event.forceRefresh &&
        !event.isLoadMore &&
        !event.isBackgroundRefresh) {
      emit(
        FetchingContestsCompleted(
          contests: cachedData,
          hasMoreData: cachedHasMoreData ?? false,
          currentPage: cachedPage ?? 1,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    if (event.isBackgroundRefresh && cachedData != null && !event.isLoadMore) {
      emit(
        FetchingContestsCompleted(
          contests: cachedData,
          hasMoreData: cachedHasMoreData ?? false,
          currentPage: cachedPage ?? 1,
          isBackgroundRefresh: false,
        ),
      );
    }

    if (!event.isLoadMore && !event.isBackgroundRefresh) {
      emit(
        FetchingAllContests(
          cachedContests: _cachedContests,
          cachedPage: _cachedPage,
        ),
      );
    }

    try {
      final contests = await _contestRepository.getAllContests(
        page: event.page,
        limit: event.limit,
        order: event.order,
        sort: event.sort,
      );
      contests.fold(
        (failure) {
          if (event.isBackgroundRefresh) {
            return;
          }

          if (event.isLoadMore && cachedData != null) {
            emit(
              FetchingContestsCompleted(
                contests: cachedData,
                hasMoreData: false,
                currentPage: cachedPage ?? 1,
                isBackgroundRefresh: false,
              ),
            );
          } else {
            emit(
              ErrorFetchingAllContests(
                message: 'Failed to load contests: ${failure.message}',
              ),
            );
          }
        },
        (data) {
          log(
            'Fetched page ${data.page}: ${data.content.length} contests (total pages: ${data.totalPages}, status filter: ${event.contestStatus})',
          );
          AllContestData filteredData = data;
          if (event.contestStatus != null) {
            final filteredContent = data.content
                .where(
                  (contest) => contest.contestStatus == event.contestStatus,
                )
                .toList();
            filteredData = AllContestData(
              content: filteredContent,
              page: data.page,
              limit: data.limit,
              totalPages: data.totalPages,
            );
            log(
              'After filtering for ${event.contestStatus}: ${filteredContent.length} contests',
            );
          }

          AllContestData updatedData;
          bool hasMoreData;
          int currentPage;

          if (event.isLoadMore && cachedData != null) {
            final updateList = [...cachedData.content, ...filteredData.content];

            updatedData = AllContestData(
              content: updateList,
              page: filteredData.page,
              limit: filteredData.limit,
              totalPages: filteredData.totalPages,
            );

            hasMoreData = filteredData.page < filteredData.totalPages;
            currentPage = filteredData.page;
          } else {
            updatedData = filteredData;
            hasMoreData = filteredData.page < filteredData.totalPages;
            currentPage = filteredData.page;
          }
          _contestCacheByStatus[cacheKey] = updatedData;
          _pageByStatus[cacheKey] = currentPage;
          _hasMoreDataByStatus[cacheKey] = hasMoreData;

          _cachedContests = updatedData;
          _cachedPage = currentPage;
          _cachedHasMoreData = hasMoreData;

          emit(
            FetchingContestsCompleted(
              contests: updatedData,
              hasMoreData: hasMoreData,
              currentPage: currentPage,
              isBackgroundRefresh: event.isBackgroundRefresh,
            ),
          );

          if (updatedData.content.isEmpty && hasMoreData) {
            log(
              'Auto-fetching next page: current page $currentPage has no items but more pages exist (total: ${data.totalPages})',
            );
            add(
              GetAllContestsEvent(
                page: currentPage + 1,
                limit: event.limit,
                isLoadMore: true,
                contestStatus: event.contestStatus,
                order: event.order,
                sort: event.sort,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (event.isBackgroundRefresh) {
        return;
      }

      if (event.isLoadMore && cachedData != null) {
        emit(
          FetchingContestsCompleted(
            contests: cachedData,
            hasMoreData: false,
            currentPage: cachedPage ?? 1,
            isBackgroundRefresh: false,
          ),
        );
      } else {
        emit(ErrorFetchingAllContests(message: 'Failed to load contests: $e'));
      }
    }
  }

  Future<void> _onJoinContests(
    JoinContestEvent event,
    Emitter<ContestState> emit,
  ) async {
    emit(
      JoiningContest(cachedContests: _cachedContests, cachedPage: _cachedPage),
    );
    try {
      final contests = await _contestRepository.joinContest(
        event.contestId,
        accessCode: event.accessCode,
      );
      contests.fold(
        (failure) {
          emit(ErrorJoiningContest(message: failure.message));
        },
        (data) {
          emit(ContestJoined(participation: data));
        },
      );
    } catch (e) {
      emit(ErrorJoiningContest(message: 'Failed to join contests: $e'));
    }
  }

  Future<void> _onJoinPrivateContest(
    JoinPrivateContestEvent event,
    Emitter<ContestState> emit,
  ) async {
    final preservedContests = _cachedContests;
    final preservedPage = _cachedPage;

    try {
      final result = await _contestRepository.joinContest(
        event.contestId,
        accessCode: event.accessCode,
      );

      result.fold(
        (failure) {
          emit(
            ErrorJoiningContest(
              message: failure.message,
              cachedContests: preservedContests,
              cachedPage: preservedPage,
            ),
          );
        },
        (data) {
          emit(ContestJoined(participation: data));
        },
      );
    } catch (e) {
      emit(
        ErrorJoiningContest(
          message: 'Failed to join contest: $e',
          cachedContests: preservedContests,
          cachedPage: preservedPage,
        ),
      );
    }
  }

  Future<void> _onSelectContestOption(
    SelectContestOption event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContestInProgress || currentState.isAnswered) return;

    _timer?.cancel();
    final timeSpent = _calculateTimeSpentOnCurrentQuestion();

    final updatedUserOptions = List<QuestionOption?>.from(
      currentState.userOptions,
    );
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

    if (!emit.isDone && state is ContestInProgress) {
      add(NextContestQuestion());
    }
  }

  void _onNextContestQuestion(
    NextContestQuestion event,
    Emitter<ContestState> emit,
  ) {
    final currentState = state;
    if (currentState is! ContestInProgress) return;

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
      appRouter.push(ContestSubmitRoute(contestId: currentState.contestId));
    }
  }

  void _onTimerTick(ContestTimerTick event, Emitter<ContestState> emit) {
    final currentState = state;
    if (currentState is! ContestInProgress || currentState.isAnswered) return;

    final now = DateTime.now();
    final elapsed = now.difference(_questionStartTime!).inMilliseconds;
    final remaining = _questionDuration * 1000 - elapsed;
    final timeInSeconds = (remaining / 1000).ceil().clamp(0, _questionDuration);
    final progress = (remaining / (_questionDuration * 1000)).clamp(0.0, 1.0);

    if (timeInSeconds <= 0) {
      add(ContestTimeExpired());
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
    ContestTimeExpired event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContestInProgress) return;

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

    if (!emit.isDone && state is ContestInProgress) {
      add(NextContestQuestion());
    }
  }

  Future<void> _onSubmitContest(
    SubmitContest event,
    Emitter<ContestState> emit,
  ) async {
    final currentState = state;
    List<Question> questions;
    List<QuestionOption?> userOptions;
    List<int> questionTimes;
    String contestId;

    if (currentState is ContestInProgress) {
      questions = currentState.questions;
      userOptions = currentState.userOptions;
      questionTimes = currentState.questionTimes;
      contestId = currentState.contestId;
    } else if (currentState is ErrorSubmittingContest) {
      questions = currentState.questions;
      userOptions = currentState.userOptions;
      questionTimes = currentState.questionTimes;
      contestId = currentState.contestId;
    } else {
      log('Cannot submit: invalid state ${currentState.runtimeType}');
      return;
    }

    _timer?.cancel();
    emit(ContestSubmitting());

    try {
      int score = 0;
      List<bool> answers = [];

      for (int i = 0; i < questions.length; i++) {
        final selected = userOptions[i];
        final correctAnswer = questions[i].options?.firstWhere(
          (opt) => opt.correct,
        );

        bool isCorrect = selected?.id == correctAnswer?.id;
        answers.add(isCorrect);

        if (isCorrect) {
          score++;
        }
      }

      final timeMetrics = _calculateTimeMetrics(
        questionTimes,
        questions.length,
      );

      final gemsEarned = _calculateGems(score, questions.length);
      final xpEarned = _calculateXP(userOptions, questions, questionTimes);
      final scorePercentage = _calculatePercentage(score, questions.length);

      final submissionPayload = {
        'answers': userOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final selectedOption = entry.value;
          final question = questions[index];
          final timeSpent = questionTimes[index];

          return {
            'questionId': question.id,
            'selectedOptions': selectedOption != null
                ? [selectedOption.id]
                : [],
            'timeSeconds': timeSpent,
          };
        }).toList(),
        'totalTimeSeconds': timeMetrics.totalTimeSpent,
      };

      log('Contest submission payload: ${submissionPayload.toString()}');
      final response = await _contestRepository.submitContestResults(
        submissionPayLoad: submissionPayload,
        contestId: contestId,
      );

      response.fold(
        (failure) {
          emit(
            ErrorSubmittingContest(
              message: failure.message,
              questions: questions,
              userOptions: userOptions,
              questionTimes: questionTimes,
              contestId: contestId,
              cachedContests: _cachedContests,
              cachedPage: _cachedPage,
            ),
          );
        },
        (data) {
          final correctAnswers = _calculateCorrectAnswers(
            userOptions,
            questions,
          );
          final incorrectAnswers = _calculateIncorrectAnswers(
            userOptions,
            questions,
          );

          emit(
            ContestXPEarned(
              userOptions: userOptions,
              questions: questions,
              xpEarned: xpEarned,
              gemsEarned: gemsEarned,
              score: score,
              totalQuestions: questions.length,
              totalTimeSpent: timeMetrics.totalTimeSpent,
              timePercentage: timeMetrics.timePercentage,
              averageTimePerQuestion: timeMetrics.averageTimePerQuestion,
              scorePercentage: scorePercentage,
              questionTimes: questionTimes,
              contestId: contestId,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
              cachedContests: _cachedContests,
              cachedPage: _cachedPage,
            ),
          );
          appRouter.push(const ContestXPEarnedRoute());
        },
      );
    } catch (e) {
      log('Error in _onSubmitContest: $e');
      emit(
        ErrorSubmittingContest(
          message: 'Failed to submit contest: $e',
          questions: questions,
          userOptions: userOptions,
          questionTimes: questionTimes,
          contestId: contestId,
          cachedContests: _cachedContests,
          cachedPage: _cachedPage,
        ),
      );
    }
  }

  final AudioPlayer _player = AudioPlayer();

  void _onPlaySound(PlayContestAudio event, Emitter<ContestState> emit) async {
    await _player.stop();
    if (event.isCorrect) {
      await _player.setAsset('assets/sounds/assets_sounds_right.mp3');
    } else {
      await _player.setAsset('assets/sounds/assets_sounds_wrong.mp3');
    }
    _player.play();
  }

  void _onShowFinalResults(
    ShowContestResultsScreen event,
    Emitter<ContestState> emit,
  ) {
    final currentState = state;

    if (currentState is ContestXPEarned) {
      appRouter.push(const ContestResultRoute());
    }
  }

  int _calculateGems(int score, int totalQuestions) {
    final scorePercentage = _calculatePercentage(score, totalQuestions);
    const int minContestScore = 70;
    if (scorePercentage >= minContestScore) {
      return ((scorePercentage - minContestScore) * 2).round();
    }
    return 0;
  }

  int _calculateXP(
    List<QuestionOption?> options,
    List<Question> questions,
    List<int> questionTimes,
  ) {
    int xp = 0;

    for (int i = 0; i < questions.length; i++) {
      final selected = options[i];
      final correctOption = questions[i].options?.firstWhere(
        (opt) => opt.correct,
      );
      final timeSpent = questionTimes[i];

      if (selected?.id == correctOption?.id) {
        // Correct answer base XP
        xp += 4;

        // Time-based bonus for correct answers
        if (timeSpent <= 2) {
          xp += 2; // Extra 2 XP for answers within 2 seconds
        } else if (timeSpent <= 4) {
          xp += 1; // Extra 1 XP for answers within 4 seconds
        }
      } else {
        // Wrong answer penalty
        xp -= 2;
      }
    }

    // Assign 0 XP to all negative results
    return xp < 0 ? 0 : xp;
  }

  double _calculatePercentage(int score, int totalQuestions) {
    if (totalQuestions == 0) return 0.0;
    return (score / totalQuestions) * 100;
  }

  int _calculateCorrectAnswers(
    List<QuestionOption?> userOptions,
    List<Question> questions,
  ) {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = userOptions[i];
      final correctOptions = questions[i].options?.firstWhere(
        (opt) => opt.correct,
      );
      if (selected?.id == correctOptions?.id) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  int _calculateIncorrectAnswers(
    List<QuestionOption?> userOptions,
    List<Question> questions,
  ) {
    int incorrectAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      final selected = userOptions[i];
      final correctOptions = questions[i].options?.firstWhere(
        (opt) => opt.correct,
      );
      if (selected?.id != correctOptions?.id) {
        incorrectAnswers++;
      }
    }
    return incorrectAnswers;
  }

  void _onResetContest(ResetContest event, Emitter<ContestState> emit) {
    _timer?.cancel();
    if (_cachedContests != null) {
      log('ResetContest: Restoring cached contests');
      emit(
        FetchingContestsCompleted(
          contests: _cachedContests!,
          hasMoreData: _cachedHasMoreData ?? false,
          currentPage: _cachedPage ?? 1,
        ),
      );
    } else {
      log('ResetContest: No cache available, going to initial state');
      emit(ContestInitial());
    }
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _questionStartTime = DateTime.now();

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      add(ContestTimerTick());
    });
  }

  int _calculateTimeSpentOnCurrentQuestion() {
    if (_questionStartTime == null) return 0;
    final now = DateTime.now();
    final elapsed = now.difference(_questionStartTime!).inSeconds;
    return elapsed.clamp(0, _questionDuration);
  }

  ContestTimeMetrics _calculateTimeMetrics(
    List<int> questionTimes,
    int totalQuestions,
  ) {
    final totalTimeSpent = questionTimes.reduce((a, b) => a + b);
    final maxPossibleTime = totalQuestions * _questionDuration;
    final timePercentage = (totalTimeSpent / maxPossibleTime) * 100;
    final averageTimePerQuestion = totalTimeSpent / totalQuestions;

    return ContestTimeMetrics(
      totalTimeSpent: totalTimeSpent,
      timePercentage: timePercentage,
      averageTimePerQuestion: averageTimePerQuestion,
      maxPossibleTime: maxPossibleTime,
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _player.dispose();
    return super.close();
  }
}

class ContestTimeMetrics {
  final int totalTimeSpent;
  final double timePercentage;
  final double averageTimePerQuestion;
  final int maxPossibleTime;

  ContestTimeMetrics({
    required this.totalTimeSpent,
    required this.timePercentage,
    required this.averageTimePerQuestion,
    required this.maxPossibleTime,
  });
}
