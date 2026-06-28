import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LessonContentStrategy implements CardContentStrategy {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool isLocked;

  const LessonContentStrategy({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
    this.isLocked = false,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 30, 27, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.55,
            child: Text(
              title,
              style: AppTextStyles.mdBold(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: screenWidth * 0.55,
            child: Text(
              subtitle,
              style: AppTextStyles.xsRegular(
                context,
              ).copyWith(color: Colors.white, height: 1.3, fontSize: 11.5),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: screenWidth * 0.4,
            child: ButtonFactory.whiteButtonSmart(
              child: isLocked
                  ? Icon(Icons.lock)
                  : Expanded(
                      child: AutoSizeText(
                        buttonText,
                        style: AppTextStyles.smBold(
                          context,
                        ).copyWith(color: Colors.black),
                        maxLines: 1,
                        minFontSize: 5,
                        maxFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
              padding: EdgeInsets.zero,
              onPressed: onButtonPressed ?? () {},
              mainAxisAlignment: MainAxisAlignment.center,
              height: 0,
              style: AppTextStyles.smBold(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveLessonContentStrategy implements CardContentStrategy {
  const ActiveLessonContentStrategy({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
    required this.progressValue,
    required this.completedLessons,
    required this.totaLessons,
    required this.progressLabel,
    this.isLocked = false,
  });
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final double progressValue;
  final int completedLessons;
  final int totaLessons;
  final String progressLabel;
  final bool isLocked;

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 26, 29, 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.mdBold(context).copyWith(color: Colors.white),
          ),
          const VSpace(4),
          Text(
            subtitle,
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: Colors.white),
          ),
          const VSpace(28),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearPercentIndicator(
                    width: constraints.maxWidth,
                    lineHeight: 6.0,
                    percent: progressValue.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    progressColor: Colors.white,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                  const VSpace(5),
                  Row(
                    children: [
                      Text(
                        '$progressLabel%',
                        style: AppTextStyles.smBold(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        '$completedLessons/$totaLessons lessons',
                        style: AppTextStyles.smBold(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
