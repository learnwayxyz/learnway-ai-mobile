import 'package:flutter/material.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrolled_learnway_courses.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CurrentTabStrategy implements CardContentStrategy {
  final String title;
  final String description;
  final String buttonText;
  final List<User> userAvatars;
  final int totalUsers;
  final double progressValue;
  final String? progressLabel;
  final VoidCallback? onButtonPressed;
  final ResponsiveInfo? responsiveInfo;
  final bool isGrid;

  const CurrentTabStrategy({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.userAvatars,
    required this.totalUsers,
    required this.progressValue,
    this.progressLabel,
    this.onButtonPressed,
    this.responsiveInfo,
    this.isGrid = true,
  });

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    final maxAvatars = 3;
    final displayedAvatars =
        userAvatars
            .take(maxAvatars)
            .map((e) => e.profileThumbnailUrl)
            .whereType<String>()
            .toList();
    final remainingUsers =
        totalUsers > displayedAvatars.length
            ? totalUsers - displayedAvatars.length
            : 0;

    // Use responsive info if available, otherwise fallback to defaults
    final responsive = responsiveInfo;
    final basePadding = responsive?.responsivePadding ?? const EdgeInsets.all(16);
    final padding = isGrid
        ? basePadding.copyWith(
            top: basePadding.top + 6,
            bottom: basePadding.bottom + 6,
          )
        : basePadding;
    final scaleFactor = responsive?.scaleFactor ?? 1.0;
    final fontSizeMultiplier = responsive?.fontSizeMultiplier ?? 1.0;

    return GestureDetector(
      onTap: onButtonPressed,
      child: Stack(
        children: [
          Container(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.mdBold(context).copyWith(
                    color: Colors.white,
                    fontSize: 14 * fontSizeMultiplier,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4 * scaleFactor),
                Expanded(
                  child: Text(
                    description,
                    style: AppTextStyles.xsRegular(context).copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12 * fontSizeMultiplier,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8 * scaleFactor),
                if (displayedAvatars.isNotEmpty) ...[
                  _buildResponsiveAvatarsRow(
                    context,
                    displayedAvatars,
                    remainingUsers,
                    scaleFactor,
                    fontSizeMultiplier,
                  ),
                  SizedBox(height: 8 * scaleFactor),
                ],
                _buildResponsiveProgressSection(
                  context,
                  scaleFactor,
                  fontSizeMultiplier,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveAvatarsRow(
    BuildContext context,
    List<String> displayedAvatars,
    int remainingUsers,
    double scaleFactor,
    double fontSizeMultiplier,
  ) {
    final avatarSize = 24.0 * scaleFactor;
    final overlap = 8.0 * scaleFactor;
    final avatarsWidth =
        displayedAvatars.isNotEmpty
            ? avatarSize +
                (displayedAvatars.length - 1) * (avatarSize - overlap)
            : 0;
    final remainingUsersSpacing = 6.0 * scaleFactor;
    final estimatedTextWidth = 24.0 * scaleFactor;

    final totalWidth =
        displayedAvatars.isNotEmpty
            ? avatarsWidth +
                (remainingUsers > 0
                    ? remainingUsersSpacing + estimatedTextWidth
                    : 0)
            : 0;

    return SizedBox(
      height: avatarSize,
      child:
          displayedAvatars.isNotEmpty
              ? SizedBox(
                width: totalWidth.toDouble(),
                height: avatarSize,
                child: Stack(
                  children: [
                    ...displayedAvatars.asMap().entries.toList().map((entry) {
                      final index = entry.key;
                      final avatar = entry.value;
                      return Positioned(
                        left: index * (avatarSize - overlap),
                        child: Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: CircleAvatar(
                            radius: (avatarSize - 2) / 2,
                            backgroundImage:
                                avatar.startsWith('http')
                                    ? NetworkImage(avatar)
                                    : AssetImage(avatar) as ImageProvider,
                          ),
                        ),
                      );
                    }),
                    if (remainingUsers > 0)
                      Positioned(
                        left: avatarsWidth + remainingUsersSpacing,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '+$remainingUsers',
                            style: AppTextStyles.baseBold(context).copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10 * fontSizeMultiplier,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
              : const SizedBox(),
    );
  }

  Widget _buildResponsiveProgressSection(
    BuildContext context,
    double scaleFactor,
    double fontSizeMultiplier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (progressLabel != null) ...[
          Text(
            progressLabel!,
            style: AppTextStyles.xsRegular(context).copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11 * fontSizeMultiplier,
            ),
          ),
          SizedBox(height: 4 * scaleFactor),
        ],
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 0.35,
          lineHeight: 6.0 * scaleFactor,
          percent: progressValue.clamp(0.0, 1.0),
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          progressColor: Colors.white,
          barRadius: Radius.circular(3 * scaleFactor),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
