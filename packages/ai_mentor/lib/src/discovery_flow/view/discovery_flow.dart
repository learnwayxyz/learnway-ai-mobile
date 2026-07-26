import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../career_goal/models/career_recommendation_model.dart';
import '../../career_goal/repository/career_goal_repository.dart';
import '../../terminal/blinking_cursor.dart';
import '../cubit/discovery_cubit.dart';

final _recommendationGradients = [
  AppColors.blueGradient3,
  AppColors.purpleGradient,
  AppColors.playNowGradient,
];

class DiscoveryFlow extends StatefulWidget {
  const DiscoveryFlow({
    super.key,
    required this.repository,
    required this.onComplete,
    required this.getUserId,
    this.onEnterRecommendations,
    this.onSkip,
    this.allowBack = false,
  });

  final CareerGoalRepository repository;
  final VoidCallback onComplete;
  final String Function() getUserId;
  final VoidCallback? onEnterRecommendations;

  /// When provided, shows a "Skip" text button in the header that exits the
  /// flow without saving a career goal.
  final VoidCallback? onSkip;

  /// Whether the user can leave the flow (back gesture / back button on the
  /// first step). Keep false during onboarding, true when re-entering the
  /// flow from elsewhere in the app (e.g. changing career goal).
  final bool allowBack;

  @override
  State<DiscoveryFlow> createState() => _DiscoveryFlowState();
}

class _DiscoveryFlowState extends State<DiscoveryFlow> {
  late final DiscoveryCubit _cubit;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _cubit = DiscoveryCubit(widget.repository);
    _cubit.setGetUserId(widget.getUserId);
    _cubit.start();
  }

  @override
  void dispose() {
    _cubit.close();
    _pageController.dispose();
    super.dispose();
  }

  void _syncToStep(DiscoveryStep step) {
    final index = DiscoveryStep.values.indexOf(step);
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.allowBack,
      child: BlocProvider.value(
        value: _cubit,
        child: BlocListener<DiscoveryCubit, DiscoveryState>(
          listener: (context, state) {
            if (state is DiscoveryComplete) {
              widget.onComplete();
            } else if (state is DiscoveryInProgress) {
              _syncToStep(state.currentStep);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: SafeArea(
              child: Column(
                children: [
                  _DiscoveryHeader(
                    controller: _pageController,
                    allowBack: widget.allowBack,
                    onSkip: widget.onSkip,
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const _GoalsStep(),
                        const _ExperienceStep(),
                        const _TopicsStep(),
                        _AiRecommendationStep(
                          onInit: widget.onEnterRecommendations,
                          getUserId: widget.getUserId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscoveryHeader extends StatelessWidget {
  const _DiscoveryHeader({
    required this.controller,
    this.allowBack = false,
    this.onSkip,
  });

  final PageController controller;
  final bool allowBack;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        final stepIndex = state is DiscoveryInProgress
            ? DiscoveryStep.values.indexOf(state.currentStep)
            : 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              if (stepIndex > 0 || allowBack)
                GestureDetector(
                  onTap: stepIndex > 0
                      ? () => context.read<DiscoveryCubit>().goBack()
                      : () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.gray950,
                    ),
                  ),
                ),
              // Skip is onboarding-only: re-entries (allowBack) already have a
              // back button to leave the flow.
              if (onSkip != null && !allowBack)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.smMedium(
                      context,
                    ).copyWith(color: AppColors.gray600),
                  ),
                ),
              const Spacer(),
              SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: ExpandingDotsEffect(
                  dotColor: AppColors.gray300,
                  activeDotColor: AppColors.blueLight700,
                  dotHeight: 6,
                  dotWidth: MediaQuery.of(context).size.width * 0.04,
                  spacing: 5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep();

  static const _goals = [
    'Learn digital skills',
    'Get a better job',
    'Earn money online',
    'Learn AI',
    'Learn Web3',
    'Improve financial literacy',
    'Start a business',
    'Prepare for university',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        final selected = state is DiscoveryInProgress
            ? state.selectedGoals
            : const <String>[];
        final canContinue = selected.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What do you want to achieve?',
                    style: AppTextStyles.xxl(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select up to 5 interests',
                    style: AppTextStyles.smRegular(
                      context,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: _goals.map((goal) {
                    final isSelected = selected.contains(goal);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SelectableChip(
                        label: goal,
                        isSelected: isSelected,
                        onTap: () =>
                            context.read<DiscoveryCubit>().toggleGoal(goal),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: _PrimaryButton(
                label: 'Continue',
                enabled: canContinue,
                onTap: canContinue
                    ? () => context.read<DiscoveryCubit>().advanceFromGoals()
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  const _ExperienceStep();

  static const _levels = [
    (ExperienceLevel.beginner, 'Beginner', 'Just starting out'),
    (ExperienceLevel.intermediate, 'Intermediate', 'Some experience already'),
    (ExperienceLevel.advanced, 'Advanced', 'Confident and looking to grow'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        final selected = state is DiscoveryInProgress
            ? state.selectedExperience
            : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your experience level?',
                    style: AppTextStyles.xxl(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This helps us tailor your recommendations',
                    style: AppTextStyles.smRegular(
                      context,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: _levels.map((level) {
                  final isSelected = selected == level.$1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => context
                          .read<DiscoveryCubit>()
                          .selectExperience(level.$1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.gray300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.$2,
                                    style: AppTextStyles.smBold(
                                      context,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.gray950,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    level.$3,
                                    style: AppTextStyles.xsRegular(
                                      context,
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.8)
                                          : AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TopicsStep extends StatelessWidget {
  const _TopicsStep();

  static const _topics = [
    'AI & Automation',
    'Software Development',
    'Design & Creativity',
    'Digital Marketing',
    'Finance & Investing',
    'Blockchain & Web3',
    'Data & Analytics',
    'Entrepreneurship',
    'Cybersecurity',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        final selected = state is DiscoveryInProgress
            ? state.selectedTopics
            : const <String>[];
        final count = selected.length;
        final canContinue = count >= 3;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Which topics interest you?',
                    style: AppTextStyles.xxl(
                      context,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select up to 5 interests',
                    style: AppTextStyles.smRegular(
                      context,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _topics.map((topic) {
                    final isSelected = selected.contains(topic);
                    return _TopicChip(
                      label: topic,
                      isSelected: isSelected,
                      onTap: () =>
                          context.read<DiscoveryCubit>().toggleTopic(topic),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: _PrimaryButton(
                label: 'Continue',
                enabled: canContinue,
                onTap: canContinue
                    ? () => context.read<DiscoveryCubit>().advanceFromTopics()
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AiRecommendationStep extends StatefulWidget {
  const _AiRecommendationStep({required this.getUserId, this.onInit});

  final String Function() getUserId;
  final VoidCallback? onInit;

  @override
  State<_AiRecommendationStep> createState() => _AiRecommendationStepState();
}

class _AiRecommendationStepState extends State<_AiRecommendationStep> {
  static const _phrases = [
    'Analyzing your goals...',
    'Matching career paths...',
    'Found your best matches!',
  ];

  String _displayedText = '';
  int _phraseIndex = 0;
  bool _typingDone = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
    _typeNextPhrase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _typeNextPhrase() {
    final text = _phrases[_phraseIndex];
    int index = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (index < text.length) {
        setState(() => _displayedText = text.substring(0, index + 1));
        index++;
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          if (_phraseIndex < _phrases.length - 1) {
            setState(() {
              _phraseIndex++;
              _displayedText = '';
            });
            _typeNextPhrase();
          } else {
            setState(() => _typingDone = true);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryCubit, DiscoveryState>(
      builder: (context, state) {
        if (state is! DiscoveryInProgress) return const SizedBox.shrink();

        if (_typingDone && state.recommendations.isNotEmpty) {
          return _buildRecommendations(context, state);
        }

        if (_typingDone && state.errorMessage != null) {
          return _buildError(context, state.errorMessage!);
        }

        return _buildTypingPhase(context);
      },
    );
  }

  Widget _buildTypingPhase(BuildContext context) {
    final isLastPhrase = _phraseIndex == _phrases.length - 1;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              _phraseIndex,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _phrases[i],
                  style: AppTextStyles.smRegular(
                    context,
                    color: AppColors.gray400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _displayedText,
                    style: isLastPhrase
                        ? AppTextStyles.smBold(
                            context,
                            color: AppColors.primaryColor,
                          )
                        : AppTextStyles.smRegular(
                            context,
                            color: AppColors.gray500,
                          ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (!_typingDone)
                  BlinkingCursor(color: AppColors.primaryColor, fontSize: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong',
              style: AppTextStyles.baseBold(context, color: AppColors.gray950),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.smRegular(context, color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _PrimaryButton(
              label: 'Try Again',
              enabled: true,
              onTap: () =>
                  context.read<DiscoveryCubit>().retryRecommendations(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    DiscoveryInProgress state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for You',
                style: AppTextStyles.xxl(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Based on your interests and goals',
                style: AppTextStyles.smRegular(
                  context,
                  color: AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: List.generate(state.recommendations.length, (i) {
                final rec = state.recommendations[i];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < state.recommendations.length - 1 ? 12 : 0,
                  ),
                  child: _RecommendationCard(
                    recommendation: rec,
                    gradient:
                        _recommendationGradients[i %
                            _recommendationGradients.length],
                    isSelected: state.selectedRecommendationIndex == i,
                    isBestMatch: i == 0,
                    onTap: () =>
                        context.read<DiscoveryCubit>().selectRecommendation(i),
                  ),
                );
              }),
            ),
          ),
        ),
        if (state.saveError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
            child: Text(
              state.saveError!,
              style: AppTextStyles.xsRegular(context, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: _PrimaryButton(
            label: 'Start My Journey →',
            enabled:
                state.selectedRecommendationIndex != null && !state.isSaving,
            isLoading: state.isSaving,
            onTap: state.selectedRecommendationIndex != null && !state.isSaving
                ? () {
                    final userId = widget.getUserId();
                    context.read<DiscoveryCubit>().confirmSelection(userId);
                  }
                : null,
          ),
        ),
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.gray300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTextStyles.smRegular(context).copyWith(
            color: isSelected ? Colors.white : AppColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.gray300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.smRegular(context).copyWith(
                color: isSelected ? Colors.white : AppColors.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_rounded, color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.recommendation,
    required this.gradient,
    required this.isSelected,
    required this.isBestMatch,
    required this.onTap,
  });

  final CareerRecommendation recommendation;
  final LinearGradient gradient;
  final bool isSelected;
  final bool isBestMatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.gray950, width: 2.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: isSelected ? 10 : 6,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBestMatch) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Best Match',
                        style: AppTextStyles.xsSemiBold(
                          context,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    recommendation.careerTitle,
                    style: AppTextStyles.baseBold(context, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  if (recommendation.whyItFitsYou.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      recommendation.whyItFitsYou,
                      style: AppTextStyles.xsRegular(
                        context,
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 12),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: enabled ? Colors.black : AppColors.gray300,
          borderRadius: BorderRadius.circular(50),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.baseBold(context, color: Colors.white),
              ),
      ),
    );
  }
}
