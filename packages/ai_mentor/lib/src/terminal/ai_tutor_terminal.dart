import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'blinking_cursor.dart';

class AiTutorTerminal extends StatefulWidget {
  const AiTutorTerminal({
    super.key,
    this.initialUsername,
    this.usernameUpdates,
    required this.onNavigateToHome,
    required this.onNavigateToCareerGoal,
    this.onInit,
  });

  final String? initialUsername;
  final Stream<String?>? usernameUpdates;
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToCareerGoal;
  final VoidCallback? onInit;

  @override
  State<AiTutorTerminal> createState() => _AiTutorTerminalState();
}

class _AiTutorTerminalState extends State<AiTutorTerminal> {
  static const _initLine = 'Personalizing your experience...';
  static const _promptLine = 'What would you like to do?';
  static const _welcomePrefix = 'Welcome, ';
  static const _welcomePrefixNoName = 'Welcome to LearnWay!';

  String _displayedInit = '';
  String _displayedWelcome = '';
  String _displayedPrompt = '';
  bool _showButtons = false;
  bool _typingComplete = false;
  String _userName = '';
  bool _phase1Done = false;
  bool _phase2Done = false;

  Timer? _timer;
  StreamSubscription<String?>? _usernameSubscription;

  @override
  void initState() {
    super.initState();
    _userName = widget.initialUsername ?? '';
    widget.onInit?.call();

    _usernameSubscription = widget.usernameUpdates?.listen((username) {
      if (username != null && !_typingComplete && _phase1Done && !_phase2Done) {
        _userName = username;
        _typeWelcomeLine();
      }
    });

    _startTypingSequence();
  }

  @override
  void dispose() {
    _usernameSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _startTypingSequence() {
    _typeText(_initLine, (s) => setState(() => _displayedInit = s), () {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() => _phase1Done = true);
        _resolveUserName();
      });
    });
  }

  void _resolveUserName() {
    if (_userName.isNotEmpty || widget.usernameUpdates == null) {
      _typeWelcomeLine();
    }
  }

  void _typeWelcomeLine() {
    if (_phase2Done) return;
    final fullWelcome = _userName.isNotEmpty
        ? '$_welcomePrefix$_userName!'
        : _welcomePrefixNoName;
    _typeText(fullWelcome, (s) => setState(() => _displayedWelcome = s), () {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => _phase2Done = true);
        _typeText(_promptLine, (s) => setState(() => _displayedPrompt = s), () {
          if (!mounted) return;
          setState(() {
            _typingComplete = true;
            _showButtons = true;
          });
        });
      });
    });
  }

  void _typeText(
    String text,
    void Function(String) onUpdate,
    VoidCallback onDone,
  ) {
    int index = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (index < text.length) {
        onUpdate(text.substring(0, index + 1));
        index++;
      } else {
        timer.cancel();
        onDone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'AI Tutor',
          style: AppTextStyles.baseBold(context, color: AppColors.gray950),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_phase1Done) ...[
                const SizedBox(height: 20),
                _WelcomeHeading(
                  text: _displayedWelcome,
                  showCursor: _phase1Done && !_phase2Done,
                  prefixLength:
                      _userName.isNotEmpty ? _welcomePrefix.length : 0,
                ),
              ],
              if (_phase2Done) ...[
                const SizedBox(height: 8),
                _TypedCaption(
                  text: _displayedPrompt,
                  showCursor: !_showButtons,
                ),
              ],
              const SizedBox(height: 50),
              if (_showButtons) ...[
                _ActionCard(
                  title: 'Set Career Goal',
                  subtitle: 'Get a personalized roadmap for your dream role.',
                  buttonText: 'Get Started',
                  onPressed: widget.onNavigateToCareerGoal,
                  gradient: AppColors.blueGradient3,
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  title: 'Start Learning',
                  subtitle: 'Explore courses and dive right in.',
                  buttonText: 'Skip for Now',
                  onPressed: widget.onNavigateToHome,
                  gradient: AppColors.quizeChallengeGradient,
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TypedCaption extends StatelessWidget {
  const _TypedCaption({required this.text, required this.showCursor});

  final String text;
  final bool showCursor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.smRegular(context, color: AppColors.gray500),
          ),
        ),
        if (showCursor)
          BlinkingCursor(color: AppColors.primaryColor, fontSize: 14),
      ],
    );
  }
}

class _WelcomeHeading extends StatelessWidget {
  const _WelcomeHeading({
    required this.text,
    required this.showCursor,
    required this.prefixLength,
  });

  final String text;
  final bool showCursor;
  final int prefixLength;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.xxlBold(
      context,
      color: AppColors.gray950,
    ).copyWith(height: 1.3);
    final highlightStyle = baseStyle.copyWith(color: AppColors.primaryColor);

    final hasHighlight = prefixLength > 0 && text.length > prefixLength;

    final textWidget = hasHighlight
        ? Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: text.substring(0, prefixLength),
                  style: baseStyle,
                ),
                TextSpan(
                  text: text.substring(prefixLength),
                  style: highlightStyle,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
        : Text(text, textAlign: TextAlign.center, style: baseStyle);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: textWidget),
        if (showCursor)
          BlinkingCursor(color: AppColors.primaryColor, fontSize: 30),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.smBold(context, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.xsRegular(
                    context,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.gray950,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              buttonText,
              style: AppTextStyles.xsSemiBold(
                context,
                color: AppColors.gray950,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
