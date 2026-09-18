import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/leader_board/models/leaderboard_user.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';

class PodiumSection extends StatelessWidget {
  const PodiumSection({
    super.key,
    required this.users,
    required this.responsiveInfo,
  });

  final List<LeaderboardUser> users;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Container(
        padding: FigmaConverter.padding(
          context,
          left: 40,
          right: 40,
          top: 40,
          bottom: 40,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.startLessonGradient,
          borderRadius: BorderRadius.circular(
            FigmaConverter.width(context, 30),
          ),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noLeaderboardData,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    double firstPlaceSize = responsiveInfo.isTablet
        ? FigmaConverter.width(context, 120, max: 130)
        : FigmaConverter.width(context, 117, max: 125);
    double otherPlacesSize = responsiveInfo.isTablet
        ? FigmaConverter.width(context, 120, max: 130)
        : FigmaConverter.width(context, 80, max: 90);

    return Container(
      padding: FigmaConverter.padding(context, left: 0, right: 0, top: 20),
      decoration: BoxDecoration(
        gradient: AppColors.startLessonGradient,
        borderRadius: BorderRadius.circular(FigmaConverter.width(context, 30)),
      ),
      child: Stack(
        children: [
          _buildPodiumDecorations(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (users.length > 1)
                    PodiumUser(
                      user: users[1],
                      size: otherPlacesSize,
                      medalColor: const Color(0xFFC0C0C0),
                      position: "2",
                      responsiveInfo: responsiveInfo,
                    ),
                  if (users.length > 1)
                    SizedBox(width: FigmaConverter.width(context, 25)),
                  if (users.isNotEmpty)
                    PodiumUser(
                      user: users[0],
                      size: firstPlaceSize,
                      medalColor: const Color(0xFFFFD700),
                      position: "1",
                      responsiveInfo: responsiveInfo,
                    ),
                  if (users.length > 2)
                    SizedBox(width: FigmaConverter.width(context, 25)),
                  if (users.length > 2)
                    PodiumUser(
                      user: users[2],
                      size: otherPlacesSize,
                      medalColor: const Color(0xFFCD7F32),
                      position: "3",
                      responsiveInfo: responsiveInfo,
                    ),
                ],
              ),
              SizedBox(height: FigmaConverter.height(context, 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumDecorations(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          _buildStar(177, 0, 114),
          _buildStar(67, 14, 59),
          _buildStar(201, 191, 59),
          _buildStar(21, 154, 90),
          _buildStar(292, 104, 90),
          _buildBalloon(31, 92, 22),
          _buildBalloon(319, -8, 22),
          _buildBalloon(148, 154, 37),
        ],
      ),
    );
  }

  Widget _buildStar(double left, double top, double size) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset('assets/icons/Star 5.svg', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildBalloon(double left, double top, double size) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(
          'assets/icons/fluent-mdl2_balloons.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PodiumUser extends StatelessWidget {
  const PodiumUser({
    super.key,
    required this.medalColor,
    required this.position,
    required this.user,
    required this.size,
    required this.responsiveInfo,
  });

  final LeaderboardUser user;
  final double size;
  final Color medalColor;
  final String position;
  final ResponsiveInfo responsiveInfo;

  String _truncateName(String name, {int maxLength = 8}) {
    if (name.length <= maxLength) return name;
    return '${name.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirstPlace = position == "1";
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundImage: user.avatar.startsWith('http')
                  ? NetworkImage(user.avatar)
                  : AssetImage(user.avatar) as ImageProvider,
            ),
            Positioned(
              bottom: -5,
              child: Container(
                width: responsiveInfo.isTablet
                    ? FigmaConverter.width(context, 35, max: 40)
                    : FigmaConverter.width(context, 20, max: 24),
                height: responsiveInfo.isTablet
                    ? FigmaConverter.width(context, 35, max: 40)
                    : FigmaConverter.width(context, 20, max: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    position,
                    style: TextStyle(
                      color: AppColors.gray800,
                      fontWeight: FontWeight.w600,
                      fontSize: FigmaConverter.fontSize(
                        context,
                        11,
                        min: 12,
                        max: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isFirstPlace) ...[
              Positioned(
                bottom: -15,
                child: Image.asset(Assets.images.firstPlaceBadge.path),
              ),
            ],
          ],
        ),
        SizedBox(height: FigmaConverter.height(context, 30)),
        Text(
          _truncateName(user.name),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: FigmaConverter.fontSize(context, 14, min: 12, max: 16),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: FigmaConverter.height(context, 10)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              FigmaConverter.width(context, 30),
            ),
          ),
          padding: FigmaConverter.padding(
            context,
            left: 12,
            right: 12,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.images.smallXp.path),
              SizedBox(width: FigmaConverter.width(context, 2)),
              Flexible(
                child: Text(
                  formatScore(user.xp),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: FigmaConverter.fontSize(
                      context,
                      14,
                      min: 12,
                      max: 16,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
