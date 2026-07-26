import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/career_goal_cubit.dart';
import '../models/career_goal_model.dart';
import '../models/career_roadmap_model.dart';

final List<LinearGradient> _goalGradients = [
  AppColors.blueGradient3,
  AppColors.purpleGradient,
  AppColors.playNowGradient,
  AppColors.quizeChallengeGradient,
  AppColors.blueGradient2,
  AppColors.contestGradient,
  AppColors.blueGradient,
  AppColors.startLessonGradient,
];

class CareerGoalView extends StatelessWidget {
  const CareerGoalView({
    super.key,
    required this.cubit,
    required this.onComplete,
    required this.getUserId,
  });

  final CareerGoalCubit cubit;
  final VoidCallback onComplete;
  final String Function() getUserId;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider.value(
        value: cubit,
        child: BlocListener<CareerGoalCubit, CareerGoalState>(
          listener: (context, state) {
            if (state is CareerGoalError) {
              onComplete();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundLight,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'Career Goal',
                style: AppTextStyles.baseBold(
                  context,
                  color: AppColors.gray950,
                ),
              ),
            ),
            body: BlocBuilder<CareerGoalCubit, CareerGoalState>(
              builder: (context, state) {
                if (state is CareerGoalRoadmapReady) {
                  return _CareerRoadmapResult(
                    roadmap: state.roadmap,
                    onDone: onComplete,
                  );
                }
                return _CareerGoalSelector(
                  isGenerating: state is CareerGoalGenerating,
                  onSkip: onComplete,
                  getUserId: getUserId,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CareerGoalSelector extends StatefulWidget {
  const _CareerGoalSelector({
    required this.isGenerating,
    required this.onSkip,
    required this.getUserId,
  });

  final bool isGenerating;
  final VoidCallback onSkip;
  final String Function() getUserId;

  @override
  State<_CareerGoalSelector> createState() => _CareerGoalSelectorState();
}

class _CareerGoalSelectorState extends State<_CareerGoalSelector> {
  String? _selectedGoalId;

  void _confirm() {
    final goal = predefinedCareerGoals.firstWhere(
      (g) => g.id == _selectedGoalId,
    );
    final userId = widget.getUserId();
    context.read<CareerGoalCubit>().generateGoal(userId, goal.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Text(
            'What career path are you building?',
            style: AppTextStyles.smRegular(context, color: AppColors.gray500),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: predefinedCareerGoals.length,
            itemBuilder: (context, i) {
              final goal = predefinedCareerGoals[i];
              return _GoalCard(
                title: goal.title,
                gradient: _goalGradients[i % _goalGradients.length],
                isSelected: _selectedGoalId == goal.id,
                onTap: () => setState(() => _selectedGoalId = goal.id),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Column(
            children: [
              if (_selectedGoalId != null) ...[
                _PrimaryButton(
                  label: 'Confirm Goal',
                  isLoading: widget.isGenerating,
                  onTap: widget.isGenerating ? null : _confirm,
                ),
                const SizedBox(height: 12),
              ],
              Center(
                child: GestureDetector(
                  onTap: widget.isGenerating ? null : widget.onSkip,
                  child: Text(
                    'Skip for now',
                    style:
                        AppTextStyles.smSemiBold(
                          context,
                          color: AppColors.gray500,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.gray500,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final LinearGradient gradient;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              right: -14,
              bottom: -14,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.smBold(context, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CareerRoadmapResult extends StatelessWidget {
  const _CareerRoadmapResult({required this.roadmap, required this.onDone});

  final CareerRoadmap roadmap;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            children: [
              ...roadmap.stages.map((stage) => _StageCard(stage: stage)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${roadmap.totalEstimatedWeeks} weeks to complete',
                      style: AppTextStyles.xsSemiBold(
                        context,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: _PrimaryButton(label: "Let's Start Learning →", onTap: onDone),
        ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.stage});

  final RoadmapStage stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient3,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '${stage.stage}'.padLeft(2, '0'),
              style: AppTextStyles.xsSemiBold(context, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stage.title,
                        style: AppTextStyles.smBold(
                          context,
                          color: AppColors.gray950,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '~${stage.estimatedWeeks}w',
                        style: AppTextStyles.xsSemiBold(
                          context,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  stage.description,
                  style: AppTextStyles.xsRegular(
                    context,
                    color: AppColors.gray500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: stage.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Text(
                        skill,
                        style: AppTextStyles.xsRegular(
                          context,
                          color: AppColors.gray600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    this.isLoading = false,
    required this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.gray300
              : AppColors.activeButtonColor,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: AppTextStyles.baseBold(context, color: Colors.white),
              ),
      ),
    );
  }
}
