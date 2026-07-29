import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
    this.showCompletedCount = true,
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
  final bool showCompletedCount;

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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                        showCompletedCount
                            ? '$completedLessons/$totaLessons lessons'
                            : '$totaLessons lessons',
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

class AIActiveLessonContentStrategy implements CardContentStrategy {
  const AIActiveLessonContentStrategy({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.progressValue,
    required this.completedLessons,
    required this.totaLessons,
    required this.progressLabel,
  });
  final String title;
  final String subtitle;
  final String buttonText;
  final double progressValue;
  final int completedLessons;
  final int totaLessons;
  final String progressLabel;

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 17),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: Colors.white),
          ),
          const VSpace(28),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LessonStatusCard(
                    completedLessons: completedLessons,
                    totaLessons: totaLessons,
                    gemValue: '10',
                    xpValue: '50',
                  ),
                  CircularPercentIndicator(
                    radius: 28.0,
                    lineWidth: 5.0,
                    percent: progressValue.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    progressColor: Colors.white,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$progressLabel%',
                          style: AppTextStyles.smBold(
                            context,
                          ).copyWith(color: Colors.white, fontSize: 10),
                        ),
                        SizedBox(
                          width: 36,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              completedLessons == totaLessons
                                  ? 'Completed'
                                  : 'In-progress',
                              style: AppTextStyles.xsRegular(
                                context,
                              ).copyWith(color: Colors.white, fontSize: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class LessonStatusCard extends StatelessWidget {
  const LessonStatusCard({
    super.key,
    required this.completedLessons,
    required this.totaLessons,
    required this.xpValue,
    required this.gemValue,
  });
  final int completedLessons;
  final int totaLessons;
  final String xpValue;
  final String gemValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(11, 8, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LessonCountRow(
            completed: completedLessons,
            total: totaLessons,
            iconPath: Assets.images.a3dBook.path,
            lessonCardTexts: '$completedLessons/$totaLessons',
            label: 'Lessons',
          ),
          HSpace(12),
          LessonCountRow(
            completed: completedLessons,
            total: totaLessons,
            iconPath: Assets.images.xpImage.path,
            lessonCardTexts: xpValue,
            label: 'XP',
          ),
          HSpace(12),
          LessonCountRow(
            completed: completedLessons,
            total: totaLessons,
            lessonCardTexts: gemValue,
            label: 'Gems',
            iconPath: Assets.images.blueGem.path,
          ),
        ],
      ),
    );
  }
}

class LessonCountRow extends StatelessWidget {
  const LessonCountRow({
    super.key,
    required this.completed,
    required this.total,
    this.label = 'Lessons',
    this.iconPath,
    required this.lessonCardTexts,
    this.gap = 5,
  });

  final int completed;
  final int total;
  final String label;
  final String? iconPath;
  final String lessonCardTexts;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPath != null) ...[
          if (iconPath!.contains('.svg'))
            SvgPicture.asset(iconPath!, height: 30, width: 30)
          else
            Image.asset(iconPath!, height: 30, width: 30),
          const HSpace(5),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.smRegular(context)),
            HSpace(gap),
            Text(
              lessonCardTexts,
              style: AppTextStyles.smBold(context).copyWith(letterSpacing: 5),
            ),
          ],
        ),
      ],
    );
  }
}
