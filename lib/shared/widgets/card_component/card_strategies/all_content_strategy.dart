import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class AllCoursesContentStrategy implements CardContentStrategy {
  const AllCoursesContentStrategy({
    required this.title,
    required this.description,
    required this.courseOwner,
    required this.userAvatars,
    required this.totalEnrolledUsers,
    this.imageUrl,
    required this.progressValue,
    required this.isEnrolled,
    required this.isCompleted,
    required this.responsiveInfo,
    this.isGrid = true,
  });

  final List<LearnWayUser> userAvatars;
  final int totalEnrolledUsers;
  final String title;
  final String description;
  final String courseOwner;
  final String? imageUrl;
  final int progressValue;
  final bool isEnrolled;
  final bool isCompleted;
  final ResponsiveInfo responsiveInfo;
  final bool isGrid;

  @override
  Widget buildContent(BuildContext context, double screenWidth) {
    final maxAvatars = 3;
    final displayedAvatars = userAvatars
        .take(maxAvatars)
        .map((e) => e.profileThumbnailUrl)
        .whereType<String>()
        .toList();
    final remainingUsers = totalEnrolledUsers > displayedAvatars.length
        ? totalEnrolledUsers - displayedAvatars.length
        : 0;

    log('iscompleted() $isCompleted');

    return Stack(
      children: [
        Container(
          padding: isGrid
              ? responsiveInfo.responsivePadding.copyWith(
                  top: (responsiveInfo.responsivePadding.top) + 6,
                  bottom: (responsiveInfo.responsivePadding.bottom) + 6,
                )
              : responsiveInfo.responsivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.mdBold(context).copyWith(
                  color: Colors.white,
                  fontSize: 14 * responsiveInfo.fontSizeMultiplier,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4 * responsiveInfo.scaleFactor),
              if (isGrid)
                Expanded(
                  child: Text(
                    description,
                    style: AppTextStyles.xsRegular(context).copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12 * responsiveInfo.fontSizeMultiplier,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                Text(
                  description,
                  style: AppTextStyles.xsRegular(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12 * responsiveInfo.fontSizeMultiplier,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (displayedAvatars.isNotEmpty) ...[
                SizedBox(height: 12 * responsiveInfo.scaleFactor),
                _buildAvatarsRow(context, displayedAvatars, remainingUsers),
                SizedBox(height: 4 * responsiveInfo.scaleFactor),
              ],
              Text(
                getCourseStatus(isEnrolled, isCompleted),
                style: AppTextStyles.sm(context).copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 11 * responsiveInfo.fontSizeMultiplier,
                ),
              ),
            ],
          ),
        ),
        ...BackgroundBubbles.build(responsiveInfo),
      ],
    );
  }

  Widget _buildAvatarsRow(
    BuildContext context,
    List<String> displayedAvatars,
    int remainingUsers,
  ) {
    final avatarSize = 24.0 * responsiveInfo.scaleFactor;
    final overlap = 8.0 * responsiveInfo.scaleFactor;
    final avatarsWidth = displayedAvatars.isNotEmpty
        ? avatarSize + (displayedAvatars.length - 1) * (avatarSize - overlap)
        : 0;
    final remainingUsersSpacing = 6.0 * responsiveInfo.scaleFactor;
    final estimatedTextWidth = 24.0 * responsiveInfo.scaleFactor;

    final totalWidth = displayedAvatars.isNotEmpty
        ? avatarsWidth +
              (remainingUsers > 0
                  ? remainingUsersSpacing + estimatedTextWidth
                  : 0)
        : 0;

    return SizedBox(
      height: avatarSize,
      child: displayedAvatars.isNotEmpty
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
                          backgroundImage: avatar.startsWith('http')
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
                            fontSize: 10 * responsiveInfo.fontSizeMultiplier,
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
}

String getCourseStatus(bool isEnrolled, bool isCompleted) {
  if (isEnrolled == false) {
    return 'Not Enrolled';
  } else if (isCompleted) {
    return 'Completed';
  } else {
    return 'In Progress';
  }
}

class BackgroundBubbles {
  static List<Widget> build(ResponsiveInfo responsiveInfo) {
    final scaleFactor = responsiveInfo.scaleFactor;
    return [
      Positioned(
        bottom: 60 * scaleFactor,
        right: 70 * scaleFactor,
        child: _bubble(50 * scaleFactor, 0.1, 40 * scaleFactor),
      ),
      Positioned(
        top: 30 * scaleFactor,
        right: -30 * scaleFactor,
        child: _bubble(40 * scaleFactor, 0.08, 25 * scaleFactor),
      ),
      Positioned(
        bottom: 8 * scaleFactor,
        left: 0,
        child: _bubble(45 * scaleFactor, 0.06, 35 * scaleFactor),
      ),
      Positioned(
        bottom: 8 * scaleFactor,
        right: 50 * scaleFactor,
        child: _bubble(35 * scaleFactor, 0.06, 25 * scaleFactor),
      ),
    ];
  }

  static Widget _bubble(double size, double opacity, double borderRadius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
