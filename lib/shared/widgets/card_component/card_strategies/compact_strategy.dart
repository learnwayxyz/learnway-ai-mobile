import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CompactProgressContentStrategy implements CardContentStrategy {
  final String title;
  final String description;
  final String buttonText;
  final List<String> userAvatars;
  final int totalUsers;
  final double progressValue;
  final String? progressLabel;
  final VoidCallback? onButtonPressed;
  final bool isCompact;

  const CompactProgressContentStrategy({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.userAvatars,
    required this.totalUsers,
    required this.progressValue,
    this.progressLabel,
    this.onButtonPressed,
    this.isCompact = false,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    final maxAvatars = 3;
    final displayedAvatars = userAvatars.take(maxAvatars).toList();
    final remainingUsers =
        totalUsers > displayedAvatars.length
            ? totalUsers - displayedAvatars.length
            : 0;

    return GestureDetector(
      onTap: onButtonPressed,
      child: SizedBox(
        child: Padding(
          padding:
              isCompact
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                  : const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: (isCompact
                              ? AppTextStyles.mdBold(context)
                              : AppTextStyles.lgBold(context))
                          .copyWith(color: Colors.white),
                      maxLines: isCompact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              HSpace(isCompact ? 8 : 12),
              Text(
                description,
                style: (isCompact
                        ? AppTextStyles.xsRegular(context)
                        : AppTextStyles.smRegular(context))
                    .copyWith(color: Colors.white.withValues(alpha: 0.9)),
                maxLines: isCompact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isCompact ? 12 : 20),
              _buildUserProgressRow(context, displayedAvatars, remainingUsers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProgressRow(
    BuildContext context,
    List<String> displayedAvatars,
    int remainingUsers,
  ) {
    final avatarSize = isCompact ? 24.0 : 32.0;
    final spacing = isCompact ? 16.0 : 24.0;

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (displayedAvatars.isNotEmpty)
                SizedBox(
                  height: avatarSize,
                  width: displayedAvatars.length * (spacing - 0.5),
                  child: Stack(
                    children:
                        displayedAvatars.asMap().entries.map((entry) {
                          final index = entry.key;
                          final avatar = entry.value;
                          return Positioned(
                            left: index * (spacing - 8),
                            child: Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: (avatarSize - 4) / 2,
                                backgroundImage:
                                    avatar.startsWith('http')
                                        ? NetworkImage(avatar)
                                        : AssetImage(avatar) as ImageProvider,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              if (remainingUsers > 0) ...[
                Text(
                  '+$remainingUsers',
                  style: AppTextStyles.smBold(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: constraints.maxWidth,
                    lineHeight: 6.0,
                    percent: progressValue.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    progressColor: Colors.white,
                    barRadius: const Radius.circular(3),
                    padding: EdgeInsets.zero,
                  ),
                ],
              );
            },
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (displayedAvatars.isNotEmpty)
                  SizedBox(
                    height: avatarSize,
                    width: displayedAvatars.length * (spacing - 8) + 8,
                    child: Stack(
                      children:
                          displayedAvatars.asMap().entries.map((entry) {
                            final index = entry.key;
                            final avatar = entry.value;
                            return Positioned(
                              left: index * (spacing - 8),
                              child: Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: (avatarSize - 4) / 2,
                                  backgroundImage:
                                      avatar.startsWith('http')
                                          ? NetworkImage(avatar)
                                          : AssetImage(avatar) as ImageProvider,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                if (remainingUsers > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '+$remainingUsers',
                    style: AppTextStyles.smBold(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                  width: 120,
                  lineHeight: 8.0,
                  percent: progressValue.clamp(0.0, 1.0),
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  progressColor: Colors.white,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
