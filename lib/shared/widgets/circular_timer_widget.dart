import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';

class CircularTimerWidget extends StatelessWidget {
  final int timeRemaining;
  final double progress;

  const CircularTimerWidget({
    super.key,
    required this.timeRemaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final size = FigmaConverter.width(context, 60);
    final margin = FigmaConverter.width(context, 8);
    final padding = FigmaConverter.width(context, 8);
    final strokeWidth = FigmaConverter.width(context, 5);
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: Color(0xff130F26),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Stack(
          children: [
            Positioned.fill(
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: strokeWidth,
                color: AppColors.gray700,
                backgroundColor: AppColors.gray700,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.3
                      ? AppColors.primaryColor
                      : AppColors.errorColor,
                ),
              ),
            ),
            Center(
              child: Text(
                '$timeRemaining',
                style: AppTextStyles.mdBold(
                  context,
                  color: progress > 0.3 ? Colors.white : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
