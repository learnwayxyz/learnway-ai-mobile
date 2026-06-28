import 'package:flutter/material.dart';
import 'package:core/core.dart';

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
    required this.isCorrectAnswer,
    required this.isWrongAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Widget? trailingIcon;

    if (isCorrectAnswer) {
      backgroundColor = AppColors.success100;
      borderColor = AppColors.success500;
      trailingIcon = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.success500,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else if (isWrongAnswer) {
      backgroundColor = AppColors.error100;
      borderColor = AppColors.error500;
      trailingIcon = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.error500,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 16),
      );
    } else if (isSelected && !isAnswered) {
      backgroundColor = AppColors.blueLight100;
      borderColor = AppColors.primary50;
      trailingIcon = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.circle, color: Colors.white, size: 12),
      );
    } else {
      backgroundColor = Colors.white;
      borderColor = AppColors.gray300;
      trailingIcon = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gray300, width: 1),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$letter. ',
                          style: AppTextStyles.baseBold(context),
                        ),
                        TextSpan(
                          text: text,
                          style: AppTextStyles.baseRegular(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
