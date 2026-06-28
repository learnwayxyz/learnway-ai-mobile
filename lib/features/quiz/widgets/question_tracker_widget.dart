import 'package:learnwayv2/app/app_barrel.dart';

import 'dart:math' as math;

class QuestionTrackerWidget extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestion;

  const QuestionTrackerWidget({
    super.key,
    required this.totalQuestions,
    required this.currentQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final double availableSpace = MediaQuery.of(context).size.width - 32;
    final double textSpace = 80;
    final double trackerSpace = availableSpace - textSpace;

    if (totalQuestions == 1) {
      return Row(
        children: [
          Text('1 ', style: AppTextStyles.sm(context)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('1', style: AppTextStyles.sm(context)),
        ],
      );
    }

    final double barWidth = math.min(
      50,
      (trackerSpace - (totalQuestions - 1) * 8) / totalQuestions,
    );

    return Row(
      children: [
        Text('0${currentQuestion + 1}', style: AppTextStyles.sm(context)),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalQuestions, (index) {
              final isCurrent = currentQuestion == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: barWidth,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      isCurrent ? AppColors.primaryColor : AppColors.blueGray25,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        Text('$totalQuestions', style: AppTextStyles.sm(context)),
      ],
    );
  }
}
