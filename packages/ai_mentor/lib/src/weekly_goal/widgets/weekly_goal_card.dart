import 'package:core/core.dart';
import 'package:flutter/material.dart';

class WeeklyGoalCard extends StatefulWidget {
  const WeeklyGoalCard({
    super.key,
    required this.icon,
    required this.weeklyGoal,
    required this.onDismiss,
  });

  final Widget icon;
  final String weeklyGoal;
  final VoidCallback onDismiss;

  @override
  State<WeeklyGoalCard> createState() => _WeeklyGoalCardState();
}

class _WeeklyGoalCardState extends State<WeeklyGoalCard> {
  @override
  Widget build(BuildContext context) {
    AppTextStyles.xsRegular(context, color: AppColors.gray600);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient3,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 50,
            height: 50,
            child: widget.icon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Weekly Goal',
                  style: AppTextStyles.smSemiBold(
                    context,
                  ).copyWith(color: AppColors.primary25),
                ),
                SizedBox(height: 6),
                Text(
                  widget.weeklyGoal,
                  style: AppTextStyles.xs(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onDismiss,
            child: Icon(Icons.close, size: 16, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }
}
