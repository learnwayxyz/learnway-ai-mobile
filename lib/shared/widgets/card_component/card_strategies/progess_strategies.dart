import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learnwayv2/features/onboarding/onboarding.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:core/core.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';

class ProgressContentStrategy implements CardContentStrategy {
  final String title;
  final String description;
  final String buttonText;
  final List<User> userAvatars;
  final int totalUsers;
  final double progressValue;
  final String? progressLabel;
  final VoidCallback? onButtonPressed;

  const ProgressContentStrategy({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.userAvatars,
    required this.totalUsers,
    required this.progressValue,
    this.progressLabel,
    this.onButtonPressed,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    final displayedAvatars =
        userAvatars
            .take(3)
            .map((e) => e.profileThumbnailUrl)
            .whereType<String>()
            .toList();
    final remainingUsers = totalUsers - displayedAvatars.length;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 26, 17.7, 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.mdBold(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(
                description,
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: Colors.white.withValues(alpha: 0.9)),
              ),
              VSpace(16),
              _buildUserProgressRow(context, displayedAvatars, remainingUsers),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserProgressRow(
    BuildContext context,
    List<String> displayedAvatars,
    int remainingUsers,
  ) {
    log('Displayed Avatars: $displayedAvatars');
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: displayedAvatars.length * 24.0 + 8,
                child: Stack(
                  children:
                      displayedAvatars.asMap().entries.map((entry) {
                        final index = entry.key;
                        final avatar = entry.value;
                        return Positioned(
                          left: index * 24.0,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage:
                                avatar.startsWith('http')
                                    ? NetworkImage(avatar)
                                    : AssetImage(avatar) as ImageProvider,
                          ),
                        );
                      }).toList(),
                ),
              ),
              if (remainingUsers > 0) ...[
                HSpace(4),
                Text(
                  '+$remainingUsers',
                  style: AppTextStyles.smBold(context).copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                VSpace(20),
              ],
              Spacer(),
              _buildProgressSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (progressLabel != null) ...[
          Text(
            progressLabel!,
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 4),
        ],
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 0.35,
          lineHeight: 6.0,
          percent: progressValue.clamp(0.0, 1.0),
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          progressColor: Colors.white,
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class ListButton extends StatelessWidget {
  const ListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('pressed');
      },
      child: Container(
        height: 39,
        width: 41,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: SvgPicture.asset(Assets.icons.arrowRight),
        ),
      ),
    );
  }
}
