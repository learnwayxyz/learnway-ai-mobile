import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/features/main_activity/cubit/main_activity_cubit.dart';
import 'package:learnwayv2/features/quiz/widgets/answer_option_widget.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/circular_timer_widget.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';
import 'package:sentry/sentry.dart';

@RoutePage()
class BattleScreen extends StatefulWidget {
  final String battleId;

  const BattleScreen({super.key, required this.battleId});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  BattleQuestionEvent? _currentQuestion;
  String? _selectedOptionId;
  String? _correctOptionId;
  bool _answerSubmitted = false;
  int _timeRemaining = 30;
  int _myTimeRemaining = 30;
  int _totalQuestions = 10;
  Timer? _countdownTimer;
  Map<String, int> _scores = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  String get _currentUserId => LocalStorageService.getUserSync()?.id ?? '';

  List<BattleRoomParticipant> get _participants =>
      locator<BattleEventService>().participants;

  String get _myUsername => LocalStorageService.getUserSync()?.username ?? 'Me';

  BattleRoomParticipant? get _opponent => _participants
      .cast<BattleRoomParticipant?>()
      .firstWhere((p) => p?.userId != _currentUserId, orElse: () => null);

  int get _myScore => _scores[_currentUserId] ?? 0;
  int get _opponentScore => _scores[_opponent?.userId ?? ''] ?? 0;

  @override
  void initState() {
    super.initState();
    final svc = locator<BattleEventService>();
    if (svc.prefetchedQuestions.isNotEmpty) {
      _totalQuestions = svc.prefetchedQuestions.length;
    }
    final pending = svc.pendingQuestion;
    if (pending != null) {
      _currentQuestion = pending;
      _timeRemaining = pending.timeLimit;
      svc.pendingQuestion = null;
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              '[BattleScreen] Init with pendingQuestion — questionIndex=${pending.questionIndex} timeLimit=${pending.timeLimit}s',
          category: 'battle.screen',
          level: SentryLevel.info,
          data: {
            'battleId': widget.battleId,
            'questionIndex': pending.questionIndex,
            'questionId': pending.questionId,
            'timeLimit': pending.timeLimit,
            'note':
                'pendingQuestion may have lost elapsed time since server sent it',
          },
        ),
      );
    } else {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              '[BattleScreen] Init — no pendingQuestion, waiting for battle:question:start',
          category: 'battle.screen',
          level: SentryLevel.info,
          data: {'battleId': widget.battleId},
        ),
      );
    }
    _fetchQuestionCount();
    _subscribeToEvents();
    if (_currentQuestion != null) _startTimer();
  }

  Future<void> _fetchQuestionCount() async {
    final svc = locator<BattleEventService>();
    if (svc.prefetchedQuestions.isNotEmpty) return;
    final result = await locator<BattleRepository>().prefetchBattleQuestions(
      widget.battleId,
    );
    result.fold(
      (failure) => log('[BattleScreen] prefetch failed: ${failure.message}'),
      (questions) {
        svc.cachePrefetchedQuestions(questions);
        if (mounted && questions.isNotEmpty) {
          setState(() => _totalQuestions = questions.length);
        }
      },
    );
  }

  void _subscribeToEvents() {
    final svc = locator<BattleEventService>();
    _subscriptions.addAll([
      svc.onQuestionStart.listen(_onQuestionStart),
      svc.onQuestionTimeout.listen(_onQuestionTimeout),
      svc.onScoresUpdate.listen(_onScoresUpdate),
      svc.onAnswerAck.listen(_onAnswerAck),
      svc.onBattleComplete.listen(_onBattleComplete),
    ]);
  }

  void _onQuestionStart(BattleQuestionEvent event) {
    if (!mounted) return;
    Sentry.addBreadcrumb(
      Breadcrumb(
        message:
            '[BattleScreen] battle:question:start received — index=${event.questionIndex} timeLimit=${event.timeLimit}s',
        category: 'battle.question',
        level: SentryLevel.info,
        data: {
          'battleId': widget.battleId,
          'questionIndex': event.questionIndex,
          'questionId': event.questionId,
          'timeLimit': event.timeLimit,
          'previousTimeRemaining': _timeRemaining,
        },
      ),
    );
    if (event.timeLimit < 30) {
      Sentry.captureException(
        Exception(
          '[BattleScreen] Unexpected short timeLimit: ${event.timeLimit}s for questionIndex=${event.questionIndex}',
        ),
        hint: Hint.withMap({
          'source': 'BattleScreen._onQuestionStart',
          'battleId': widget.battleId,
          'questionIndex': event.questionIndex.toString(),
          'timeLimit': event.timeLimit.toString(),
        }),
      );
    }
    _countdownTimer?.cancel();
    setState(() {
      _currentQuestion = event;
      _selectedOptionId = null;
      _correctOptionId = null;
      _answerSubmitted = false;
      _timeRemaining = event.timeLimit;
      _myTimeRemaining = event.timeLimit;
    });
    _startTimer();
  }

  void _onQuestionTimeout(BattleQuestionTimeoutEvent event) {
    if (!mounted) return;
    _countdownTimer?.cancel();
    setState(() {
      if (!_answerSubmitted) _answerSubmitted = true;
    });
  }

  void _onBattleComplete(BattleCompleteEvent event) {
    if (!mounted) return;
    Sentry.addBreadcrumb(
      Breadcrumb(
        message:
            '[BattleScreen] battle:complete received — isTie=${event.isTie} participants=${event.participants.length}',
        category: 'battle.complete',
        level: SentryLevel.info,
        data: {
          'battleId': widget.battleId,
          'isTie': event.isTie,
          'winnerId': event.winnerId ?? 'null',
          'prizePool': event.prizePool,
        },
      ),
    );
    final currentUserId = _currentUserId;
    final me = event.participants.cast<BattleCompleteParticipant?>().firstWhere(
      (p) => p?.userId == currentUserId,
      orElse: () => null,
    );
    final opponent = event.participants
        .cast<BattleCompleteParticipant?>()
        .firstWhere((p) => p?.userId != currentUserId, orElse: () => null);
    final isBot = opponent?.isBot == true;
    final opponentName = isBot
        ? 'Lenny'
        : (opponent?.username.isNotEmpty == true
              ? opponent!.username
              : _opponent?.username ?? 'Opponent');
    _navigateToResults(
      userXpEarned: me?.xpEarned ?? 0,
      userGemsEarned: me?.gemsWon ?? 0,
      opponentXpEarned: opponent?.xpEarned ?? 0,
      opponentName: opponentName,
      myProfileImageUrl: me?.profileImageUrl,
      opponentProfileImageUrl: opponent?.profileImageUrl,
      isTie: event.isTie,
      isBot: isBot,
    );
  }

  void _onScoresUpdate(BattleScoresUpdateEvent event) {
    if (!mounted) return;
    final updated = <String, int>{};
    for (final p in event.participants) {
      updated[p.userId] = p.score;
    }
    setState(() => _scores = updated);
  }

  void _onAnswerAck(BattleAnswerAckEvent event) {
    if (!mounted) return;
    setState(() => _correctOptionId = event.correctOptionId);
    final isCorrect = _selectedOptionId == event.correctOptionId;
    _audioPlayer.setAsset(
      isCorrect
          ? 'assets/sounds/assets_sounds_right.mp3'
          : 'assets/sounds/assets_sounds_wrong.mp3',
    );
    _audioPlayer.play();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
          if (!_answerSubmitted) _myTimeRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _submitAnswer(BattleQuestionOption option) {
    if (_answerSubmitted || _currentQuestion == null) return;
    setState(() {
      _selectedOptionId = option.id;
      _answerSubmitted = true;
    });
    locator<BattleEventService>().submitAnswer(
      _currentQuestion!.questionIndex,
      option.id,
    );
    HapticFeedback.lightImpact();
  }

  void _showLeaveDialog(BuildContext context) {
    LeaveGameDialog.show(
      context,
      title: 'Are you sure you want to forfeit this battle?',
      onLeave: () async {
        Navigator.of(context).pop();
        final router = context.router;
        locator<BattleEventService>().leaveBattle();
        locator<BattleEventService>().disconnect();
        if (!mounted) return;
        locator.get<MainActivityCubit>().navigateTo(1);
        router.pushAndPopUntil(
          const MainActivityRoute(),
          predicate: (route) => false,
        );
      },
    );
  }

  void _navigateToResults({
    required int userXpEarned,
    required int userGemsEarned,
    required int opponentXpEarned,
    String? opponentName,
    String? myProfileImageUrl,
    String? opponentProfileImageUrl,
    bool isTie = false,
    bool isBot = false,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message:
            '[BattleScreen] Navigating to results — userXp=$userXpEarned opponentXp=$opponentXpEarned isTie=$isTie',
        category: 'battle.navigation',
        level: SentryLevel.info,
        data: {
          'battleId': widget.battleId,
          'userXpEarned': userXpEarned,
          'userGemsEarned': userGemsEarned,
          'opponentXpEarned': opponentXpEarned,
          'isTie': isTie,
          'opponentName': opponentName ?? 'null',
        },
      ),
    );
    final oppName =
        opponentName ??
        _opponent?.username ??
        AppLocalizations.of(context)!.opponent;
    final userWon = isTie || userXpEarned >= opponentXpEarned;

    context.router.replace(
      userWon
          ? BattleWinRoute(
              userXpEarned: userXpEarned,
              userGemsEarned: userGemsEarned,
              opponentXpEarned: opponentXpEarned,
              myName: _myUsername,
              opponentName: oppName,
              myProfileImageUrl: myProfileImageUrl,
              opponentProfileImageUrl: opponentProfileImageUrl,
              isTie: isTie,
              isBot: isBot,
            )
          : BattleLoseRoute(
              userXpEarned: userXpEarned,
              opponentXpEarned: opponentXpEarned,
              myName: _myUsername,
              opponentName: oppName,
              myProfileImageUrl: myProfileImageUrl,
              opponentProfileImageUrl: opponentProfileImageUrl,
              isBot: isBot,
            ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    locator<BattleEventService>().disconnect();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final topSpacing = FigmaConverter.height(context, 23);
    final afterProgressSpacing = FigmaConverter.height(context, 29);
    final afterQuestionSpacing = FigmaConverter.height(context, 23);
    final playerCardsHeight = FigmaConverter.height(context, 140) + bottomInset;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showLeaveDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarFactory.standardAppBar(
          title: AppLocalizations.of(context)!.battle,
          onBackPressed: () => _showLeaveDialog(context),
        ),
        body: _currentQuestion == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          VSpace(topSpacing),
                          ContentProgressTracker(
                            totalItems: _totalQuestions,
                            currentItem: _currentQuestion!.questionIndex,
                            showLabels: false,
                          ),
                          VSpace(afterProgressSpacing),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildQuestionCard(),
                                  VSpace(afterQuestionSpacing),
                                  _buildAnswerOptions(),
                                  VSpace(playerCardsHeight),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                      ),
                      child: SafeArea(child: _buildPlayerCards()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final q = _currentQuestion!;
    final timeLimit = q.timeLimit > 0 ? q.timeLimit : 1;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: FigmaConverter.height(context, 30)),
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                height: FigmaConverter.height(context, 30),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(FigmaConverter.width(context, 24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.questionNumber(q.questionIndex + 1),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mdBold(context, color: Colors.white),
                    ),
                    VSpace(FigmaConverter.height(context, 12)),
                    Text(
                      q.question,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.base(context, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: CircularTimerWidget(
              timeRemaining: _timeRemaining,
              progress: _timeRemaining / timeLimit,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOptions() {
    final options = _currentQuestion!.options;
    final optionSpacing = FigmaConverter.height(context, 16);
    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final letter = String.fromCharCode(65 + index);
        final isSelected = _selectedOptionId == option.id;

        return Padding(
          padding: EdgeInsets.only(bottom: optionSpacing),
          child: AnswerOptionWidget(
            letter: letter,
            text: option.text,
            isSelected: isSelected,
            isAnswered: _answerSubmitted,
            isCorrectAnswer:
                _correctOptionId != null &&
                isSelected &&
                option.id == _correctOptionId,
            isWrongAnswer:
                _correctOptionId != null &&
                isSelected &&
                option.id != _correctOptionId,
            onTap: () {
              if (!_answerSubmitted) {
                _submitAnswer(option);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlayerCards() {
    final currentUser = LocalStorageService.getUserSync();
    return Row(
      children: [
        Expanded(
          child: _buildPlayerCard(
            name: _myUsername,
            score: _myScore,
            isCurrentPlayer: true,
            profileImageUrl: currentUser?.profileImageUrl,
          ),
        ),
        const HSpace(10),
        Expanded(
          child: _buildPlayerCard(
            name: _opponent?.username ?? AppLocalizations.of(context)!.opponent,
            score: _opponentScore,
            isCurrentPlayer: false,
            profileImageUrl: _opponent?.profileImageUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int score,
    required bool isCurrentPlayer,
    String? profileImageUrl,
  }) {
    final avatarSize = FigmaConverter.width(context, 50);
    final innerAvatarSize = FigmaConverter.width(context, 40);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FigmaConverter.width(context, 12),
        vertical: FigmaConverter.height(context, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: Stack(
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF414651),
                      width: 3,
                    ),
                  ),
                ),
                CustomPaint(
                  size: Size(avatarSize, avatarSize),
                  painter: CircularProgressPainter(
                    progress:
                        _currentQuestion != null &&
                            _currentQuestion!.timeLimit > 0
                        ? (isCurrentPlayer
                                  ? _myTimeRemaining
                                  : _timeRemaining) /
                              _currentQuestion!.timeLimit
                        : 1.0,
                  ),
                ),
                Center(
                  child: Container(
                    width: innerAvatarSize,
                    height: innerAvatarSize,
                    decoration: BoxDecoration(
                      color: isCurrentPlayer
                          ? AppColors.primaryColor
                          : AppColors.gray300,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(47.5),
                      child:
                          profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: profileImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 48,
                              ),
                              errorWidget: (_, _, _) => const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 48,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 48,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VSpace(FigmaConverter.height(context, 8)),
          Text(
            name,
            style: TextStyle(
              color: AppColors.gray800,
              fontSize: FigmaConverter.width(context, 14),
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.20,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          VSpace(FigmaConverter.height(context, 5)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FigmaConverter.width(context, 8),
              vertical: FigmaConverter.height(context, 2),
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$score/$_totalQuestions',
              style: TextStyle(
                color: const Color(0xFFFDFDFD),
                fontSize: FigmaConverter.width(context, 12),
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
