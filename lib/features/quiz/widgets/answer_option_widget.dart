import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';

class AnswerOptionWidget extends StatelessWidget {
  final String letter;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrectAnswer;
  final bool isWrongAnswer;
  final VoidCallback onTap;

  const AnswerOptionWidget({
    super.key,
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
    required this.isCorrectAnswer,
    required this.isWrongAnswer,
  });

  @override
  Widget build(BuildContext context) {
    Icon? marker;
    if (isCorrectAnswer) {
      marker = const Icon(Icons.check_circle, color: Colors.green, size: 24);
    } else if (isWrongAnswer) {
      marker = const Icon(Icons.cancel, color: Colors.red, size: 24);
    }

    // final isDark = Theme.of(context).brightness == Brightness.dark;
    log(
      'AnswerOptionWidget: isSelected=$isSelected, isAnswered=$isAnswered, isCorrectAnswer=$isCorrectAnswer, isWrongAnswer=$isWrongAnswer',
    );

    // log('Determine check $(isSelected && !isAnswered)');
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected && !isCorrectAnswer && !isWrongAnswer
                    ? AppColors.warning400
                    : AppColors.gray300,
                width: isSelected && !isCorrectAnswer && !isWrongAnswer ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$letter. ',
                          style: AppTextStyles.baseMedium(context),
                        ),
                        TextSpan(
                          text: text,
                          style: AppTextStyles.baseMedium(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected || isCorrectAnswer || isWrongAnswer
                        ? null
                        : Border.all(color: AppColors.gray300, width: 1),
                  ),

                  child: marker,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
