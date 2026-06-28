import 'dart:async';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/features/quiz/widgets/answer_option_widget.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/circular_timer_widget.dart';
import 'package:learnwayv2/shared/widgets/content_progress_tracker.dart';

@RoutePage()
class GroupBattleScreen extends StatefulWidget {
  const GroupBattleScreen({super.key});

  @override
  State<GroupBattleScreen> createState() => _GroupBattleScreenState();
}

class _GroupBattleScreenState extends State<GroupBattleScreen> {
  int currentQuestion = 1;
  int totalQuestions = 10;
  String? selectedAnswer;
  int player1Score = 0;
  int player2Score = 0;
  int player3Score = 0;
  int player4Score = 0;
  int timeRemaining = 60;
  Timer? _countdownTimer;
  bool _answerSubmitted = false;
  String? _correctAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _userAnswered = false;
  bool _player2Answered = false;
  bool _player3Answered = false;
  bool _player4Answered = false;
  String? _player2Answer;
  String? _player3Answer;
  String? _player4Answer;
  Timer? _player2Timer;
  Timer? _player3Timer;
  Timer? _player4Timer;
  int _player2AnswerDelay = 0;
  int _player3AnswerDelay = 0;
  int _player4AnswerDelay = 0;
  int _userAnswerTime = 60;
  int _player2AnswerTime = 60;
  int _player3AnswerTime = 60;
  int _player4AnswerTime = 60;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What incentivizes miners to validate transactions?',
      'options': [
        'Validate transactions',
        'Computational power',
        'Block Reward',
        'An additional income source',
      ],
      'correct': 'C',
    },
    {
      'question': 'What is the primary purpose of a blockchain?',
      'options': [
        'To store data',
        'To create a decentralized ledger',
        'To mine cryptocurrency',
        'To validate transactions',
      ],
      'correct': 'B',
    },
    {
      'question': 'Which consensus mechanism does Bitcoin use?',
      'options': [
        'Proof of Stake',
        'Proof of Work',
        'Delegated Proof of Stake',
        'Proof of Authority',
      ],
      'correct': 'B',
    },
    {
      'question': 'What happens when a block is added to the blockchain?',
      'options': [
        'It becomes immutable',
        'It can be easily modified',
        'It gets deleted',
        'It becomes private',
      ],
      'correct': 'A',
    },
    {
      'question': 'What is a smart contract?',
      'options': [
        'A legal document',
        'Self-executing code on blockchain',
        'A cryptocurrency',
        'A mining algorithm',
      ],
      'correct': 'B',
    },
    {
      'question':
          'Which cryptocurrency was the first to implement smart contracts?',
      'options': ['Bitcoin', 'Ethereum', 'Litecoin', 'Ripple'],
      'correct': 'B',
    },
    {
      'question': 'What is the purpose of a hash function in blockchain?',
      'options': [
        'To encrypt data',
        'To create unique identifiers',
        'To mine blocks',
        'To validate transactions',
      ],
      'correct': 'B',
    },
    {
      'question': 'What is a fork in blockchain?',
      'options': [
        'A mining tool',
        'A split in the blockchain',
        'A type of cryptocurrency',
        'A validation method',
      ],
      'correct': 'B',
    },
    {
      'question': 'Which of these is NOT a type of blockchain?',
      'options': [
        'Public blockchain',
        'Private blockchain',
        'Hybrid blockchain',
        'Centralized blockchain',
      ],
      'correct': 'D',
    },
    {
      'question': 'What is the main advantage of blockchain technology?',
      'options': ['Speed', 'Decentralization', 'Low cost', 'Simplicity'],
      'correct': 'B',
    },
  ];

  @override
  void initState() {
    super.initState();
    _correctAnswer = _questions[currentQuestion - 1]['correct'];
    _setupPlayerSimulation();
    _startCountdown();
  }

  void _setupPlayerSimulation() {
    _player2Answered = false;
    _player3Answered = false;
    _player4Answered = false;
    _player2Answer = null;
    _player3Answer = null;
    _player4Answer = null;
    _player2Timer?.cancel();
    _player3Timer?.cancel();
    _player4Timer?.cancel();

    _player2AnswerDelay = 2 + (currentQuestion % 5);
    _player3AnswerDelay = 3 + (currentQuestion % 4);
    _player4AnswerDelay = 4 + (currentQuestion % 3);

    _startPlayerTimer(2, _player2AnswerDelay);
    _startPlayerTimer(3, _player3AnswerDelay);
    _startPlayerTimer(4, _player4AnswerDelay);
  }

  void _startPlayerTimer(int playerNumber, int delay) {
    Timer? timer;
    timer = Timer(Duration(seconds: delay), () {
      if (mounted) {
        _simulatePlayerAnswer(playerNumber);
      }
    });

    switch (playerNumber) {
      case 2:
        _player2Timer = timer;
        break;
      case 3:
        _player3Timer = timer;
        break;
      case 4:
        _player4Timer = timer;
        break;
    }
  }

  void _simulatePlayerAnswer(int playerNumber) {
    if (mounted) {
      setState(() {
        switch (playerNumber) {
          case 2:
            _player2Answered = true;
            _player2AnswerTime = timeRemaining;
            _player2Answer = _getSimulatedAnswer();
            break;
          case 3:
            _player3Answered = true;
            _player3AnswerTime = timeRemaining;
            _player3Answer = _getSimulatedAnswer();
            break;
          case 4:
            _player4Answered = true;
            _player4AnswerTime = timeRemaining;
            _player4Answer = _getSimulatedAnswer();
            break;
        }
      });

      if (_userAnswered &&
          _player2Answered &&
          _player3Answered &&
          _player4Answered) {
        _proceedToNextQuestionWithDelay();
      }
    }
  }

  String _getSimulatedAnswer() {
    final options = ['A', 'B', 'C', 'D'];

    if (currentQuestion <= 3) {
      return _correctAnswer!;
    } else if (currentQuestion <= 6) {
      return (currentQuestion % 2 == 0)
          ? _correctAnswer!
          : options[currentQuestion % 4];
    } else {
      return (currentQuestion % 3 == 0)
          ? _correctAnswer!
          : options[currentQuestion % 4];
    }
  }

  void _submitAnswer(String answer) {
    if (_answerSubmitted) return;

    // Optimistic UI: show selected border immediately
    setState(() {
      selectedAnswer = answer;
    });

    _countdownTimer?.cancel();

    // Simulate server verification delay — confirms answer after brief pause
    Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _answerSubmitted = true;
        _userAnswered = true;
        _userAnswerTime = timeRemaining;
      });

      if (answer == _correctAnswer) {
        HapticFeedback.lightImpact();
        _audioPlayer.setAsset('assets/sounds/assets_sounds_right.mp3');
        _audioPlayer.play();
      } else {
        HapticFeedback.heavyImpact();
        _audioPlayer.setAsset('assets/sounds/assets_sounds_wrong.mp3');
        _audioPlayer.play();
      }

      if (_player2Answered && _player3Answered && _player4Answered) {
        _proceedToNextQuestionWithDelay();
      }
    });
  }

  void _proceedToNextQuestionWithDelay() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _proceedToNextQuestion();
      }
    });
  }

  void _proceedToNextQuestion() {
    if (selectedAnswer == _correctAnswer) {
      player1Score++;
    }
    if (_player2Answer == _correctAnswer) {
      player2Score++;
    }
    if (_player3Answer == _correctAnswer) {
      player3Score++;
    }
    if (_player4Answer == _correctAnswer) {
      player4Score++;
    }

    if (currentQuestion >= totalQuestions) {
      _navigateToResults();
      return;
    }

    setState(() {
      currentQuestion++;
      selectedAnswer = null;
      _answerSubmitted = false;
      _userAnswered = false;
      _player2Answered = false;
      _player3Answered = false;
      _player4Answered = false;
      _player2Answer = null;
      _player3Answer = null;
      _player4Answer = null;
      timeRemaining = 60;
      _userAnswerTime = 60;
      _player2AnswerTime = 60;
      _player3AnswerTime = 60;
      _player4AnswerTime = 60;
    });

    _correctAnswer = _questions[currentQuestion - 1]['correct'];
    _setupPlayerSimulation();
    _startCountdown();
  }

  void _navigateToResults() {
    final allScores = [player1Score, player2Score, player3Score, player4Score];
    final maxScore = allScores.reduce((a, b) => a > b ? a : b);
    final userWon = player1Score == maxScore;

    if (userWon) {
      context.router.push(
        GroupBattleWinRoute(
          userScore: player1Score,
          player2Score: player2Score,
          player3Score: player3Score,
          player4Score: player4Score,
        ),
      );
    } else {
      context.router.push(
        GroupBattleDefeatRoute(
          userScore: player1Score,
          player2Score: player2Score,
          player3Score: player3Score,
          player4Score: player4Score,
        ),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _player2Timer?.cancel();
    _player3Timer?.cancel();
    _player4Timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeRemaining > 0) {
            timeRemaining--;
          } else {
            timer.cancel();
            _handleTimeout();
          }
        });
      }
    });
  }

  void _handleTimeout() {
    if (!_userAnswered) {
      setState(() {
        _userAnswered = true;
        selectedAnswer = null;
        _userAnswerTime = timeRemaining;
      });
    }

    if (!_player2Answered) {
      setState(() {
        _player2Answered = true;
        _player2AnswerTime = 0;
      });
    }
    if (!_player3Answered) {
      setState(() {
        _player3Answered = true;
        _player3AnswerTime = 0;
      });
    }
    if (!_player4Answered) {
      setState(() {
        _player4Answered = true;
        _player4AnswerTime = 0;
      });
    }

    if (_userAnswered &&
        _player2Answered &&
        _player3Answered &&
        _player4Answered) {
      _proceedToNextQuestionWithDelay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildCustomAppBar(context),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const VSpace(20),

                  ContentProgressTracker(
                    totalItems: totalQuestions,
                    currentItem: currentQuestion - 1,
                    showLabels: false,
                  ),

                  const VSpace(40),

                  _buildQuestionCard(),

                  const VSpace(32),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: _buildAnswerOptions(),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: AppColors.backgroundLight),
              child: SafeArea(child: _buildPlayerCards()),
            ),
          ),
        ],
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
                      'Question $currentQuestion',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mdBold(context, color: Colors.white),
                    ),
                    const VSpace(12),
                    Text(
                      _questions[currentQuestion - 1]['question'],
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
              timeRemaining: timeRemaining,
              progress: timeRemaining / 60.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOptions() {
    final options = _questions[currentQuestion - 1]['options'] as List<String>;

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final letter = String.fromCharCode(65 + index);
        final isSelected = selectedAnswer == letter;
        final isCorrect = letter == _correctAnswer;
        final showCorrect = _answerSubmitted && isSelected && isCorrect;
        final showWrong = _answerSubmitted && isSelected && !isCorrect;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AnswerOptionWidget(
            letter: letter,
            text: option,
            isSelected: isSelected,
            isAnswered: _answerSubmitted,
            isCorrectAnswer: showCorrect,
            isWrongAnswer: showWrong,
            onTap: () {
              if (!_answerSubmitted) {
                _submitAnswer(letter);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlayerCards() {
    return Row(
      children: [
        Expanded(
          child: _buildPlayerCard(
            name: 'Me',
            score: player1Score,
            isCurrentPlayer: true,
            playerNumber: 1,
          ),
        ),

        const HSpace(5),

        Expanded(
          child: _buildPlayerCard(
            name: 'Kwaku01',
            score: player2Score,
            isCurrentPlayer: false,
            playerNumber: 2,
          ),
        ),

        const HSpace(5),

        Expanded(
          child: _buildPlayerCard(
            name: 'Chi_God',
            score: player3Score,
            isCurrentPlayer: false,
            playerNumber: 3,
          ),
        ),

        const HSpace(5),

        Expanded(
          child: _buildPlayerCard(
            name: 'Nakamoto',
            score: player4Score,
            isCurrentPlayer: false,
            playerNumber: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int score,
    required bool isCurrentPlayer,
    required int playerNumber,
  }) {
    double progress;
    bool hasAnswered;

    switch (playerNumber) {
      case 1:
        hasAnswered = _userAnswered;
        progress = hasAnswered ? _userAnswerTime / 60.0 : timeRemaining / 60.0;
        break;
      case 2:
        hasAnswered = _player2Answered;
        progress = hasAnswered
            ? _player2AnswerTime / 60.0
            : timeRemaining / 60.0;
        break;
      case 3:
        hasAnswered = _player3Answered;
        progress = hasAnswered
            ? _player3AnswerTime / 60.0
            : timeRemaining / 60.0;
        break;
      case 4:
        hasAnswered = _player4Answered;
        progress = hasAnswered
            ? _player4AnswerTime / 60.0
            : timeRemaining / 60.0;
        break;
      default:
        hasAnswered = false;
        progress = timeRemaining / 60.0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF414651),
                      width: 2,
                    ),
                  ),
                ),

                CustomPaint(
                  size: const Size(40, 40),
                  painter: CircularProgressPainter(progress: 0.25),
                ),

                Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        _getAvatarPath(playerNumber),
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const VSpace(4),

          Text(
            name,
            style: TextStyle(
              color: AppColors.gray800,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: 0.20,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const VSpace(2),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              '$score/$totalQuestions',
              style: const TextStyle(
                color: Color(0xFFFDFDFD),
                fontSize: 8,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAvatarPath(int playerNumber) {
    switch (playerNumber) {
      case 1:
        return 'assets/avatars/male1.png';
      case 2:
        return 'assets/avatars/female1.png';
      case 3:
        return 'assets/avatars/male3.png';
      case 4:
        return 'assets/avatars/male4.png';
      default:
        return 'assets/avatars/male0.png';
    }
  }
}
