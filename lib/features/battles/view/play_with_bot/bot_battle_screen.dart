import 'dart:async';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:learnwayv2/features/battles/repository/battle_repository.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/features/quiz/widgets/answer_option_widget.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/circular_timer_widget.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';

@RoutePage()
class BotBattleScreen extends StatefulWidget {
  final String battleId;

  const BotBattleScreen({super.key, required this.battleId});

  @override
  State<BotBattleScreen> createState() => _BotBattleScreenState();
}

class _BotBattleScreenState extends State<BotBattleScreen> {
  BattleQuestionEvent? _currentQuestion;
  String? _selectedOptionId;
  String? _correctOptionId;
  bool _answerSubmitted = false;
  int _timeRemaining = 30;
  int _myTimeRemaining = 30;
  int _totalQuestions = 10;
  Map<String, int> _scores = {};
  Timer? _countdownTimer;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  String get _currentUserId => LocalStorageService.getUserSync()?.id ?? '';
  String get _myUsername => LocalStorageService.getUserSync()?.username ?? 'Me';

  List<BattleRoomParticipant> get _participants =>
      locator<BattleEventService>().participants;

  BattleRoomParticipant? get _botOpponent => _participants
      .cast<BattleRoomParticipant?>()
      .firstWhere((p) => p?.userId != _currentUserId, orElse: () => null);

  int get _myScore => _scores[_currentUserId] ?? 0;
  int get _opponentScore => _scores[_botOpponent?.userId ?? ''] ?? 0;

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
      _myTimeRemaining = pending.timeLimit;
      svc.pendingQuestion = null;
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
      (failure) => log('[BotBattleScreen] prefetch failed: ${failure.message}'),
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

  void _onBattleComplete(BattleCompleteEvent event) {
    if (!mounted) return;
    final me = event.participants.cast<BattleCompleteParticipant?>().firstWhere(
      (p) => p?.userId == _currentUserId,
      orElse: () => null,
    );
    final opponent = event.participants
        .cast<BattleCompleteParticipant?>()
        .firstWhere((p) => p?.userId != _currentUserId, orElse: () => null);
    final opponentName = opponent?.username.isNotEmpty == true
        ? opponent!.username
        : 'Lenny';
    final userXpEarned = me?.xpEarned ?? 0;
    final opponentXpEarned = opponent?.xpEarned ?? 0;
    final userWon = event.isTie || userXpEarned >= opponentXpEarned;

    context.router.replace(
      userWon
          ? BattleWinRoute(
              userXpEarned: userXpEarned,
              userGemsEarned: me?.gemsWon ?? 0,
              opponentXpEarned: opponentXpEarned,
              myName: _myUsername,
              opponentName: opponentName,
              myProfileImageUrl: me?.profileImageUrl,
              opponentProfileImageUrl: opponent?.profileImageUrl,
              isTie: event.isTie,
              isBot: true,
            )
          : BattleLoseRoute(
              userXpEarned: userXpEarned,
              opponentXpEarned: opponentXpEarned,
              myName: _myUsername,
              opponentName: opponentName,
              myProfileImageUrl: me?.profileImageUrl,
              opponentProfileImageUrl: opponent?.profileImageUrl,
              isBot: true,
            ),
    );
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) LeaveGameDialog.show(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildCustomAppBar(context),
        body: _currentQuestion == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const VSpace(20),
                          ContentProgressTracker(
                            totalItems: _totalQuestions,
                            currentItem: _currentQuestion!.questionIndex,
                            showLabels: false,
                          ),
                          const VSpace(40),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildQuestionCard(),
                                  const VSpace(32),
                                  _buildAnswerOptions(),
                                  VSpace(
                                    140 + MediaQuery.of(context).padding.bottom,
                                  ),
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

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(
                onPress: () => LeaveGameDialog.show(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Battle',
                  style: const TextStyle(
                    color: Color(0xFF181D27),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
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
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Question ${q.questionIndex + 1}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mdBold(context, color: Colors.white),
                    ),
                    const VSpace(12),
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
    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final letter = String.fromCharCode(65 + index);
        final isSelected = _selectedOptionId == option.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
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
          child: _buildBotPlayerCard(
            name: _botOpponent?.username ?? 'Lenny',
            score: _opponentScore,
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
    final timeLimit =
        _currentQuestion != null && _currentQuestion!.timeLimit > 0
        ? _currentQuestion!.timeLimit
        : 1;
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF414651),
                      width: 3,
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(50, 50),
                  painter: CircularProgressPainter(
                    progress: _myTimeRemaining / timeLimit,
                  ),
                ),
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? Image.network(
                              profileImageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VSpace(8),
          Text(
            name,
            style: TextStyle(
              color: AppColors.gray800,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.20,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const VSpace(5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$score/$_totalQuestions',
              style: const TextStyle(
                color: Color(0xFFFDFDFD),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotPlayerCard({required String name, required int score}) {
    final timeLimit =
        _currentQuestion != null && _currentQuestion!.timeLimit > 0
        ? _currentQuestion!.timeLimit
        : 1;
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF414651),
                      width: 3,
                    ),
                  ),
                ),
                CustomPaint(
                  size: const Size(50, 50),
                  painter: CircularProgressPainter(
                    progress: _timeRemaining / timeLimit,
                  ),
                ),
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8AA8F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            color: const Color(0xFF8AA8F4),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/images/battles/lenny_bot.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VSpace(8),
          Text(
            name,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const VSpace(5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$score/$_totalQuestions',
              style: const TextStyle(
                color: Color(0xFFFDFDFD),
                fontSize: 12,
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
