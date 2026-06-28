import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/badges/models/badge_tier_item.dart';
import 'package:learnwayv2/features/badges/widgets/badge_styles.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BadgeCard extends StatelessWidget {
  final BadgeTierItem badge;

  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.router.push(BadgeDetailsRoute(badgeType: badge.badgeType)),
      child: SizedBox(
        width: 160,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBadgeIcon(),
            const VSpace(22),
            Text(
              badge.name,
              style: BadgeStyles.badgeTitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              badge.description,
              style: BadgeStyles.badgeDescription,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon() {
    final imageUrl = badge.imageUrl;

    // If no icon path or empty, show placeholder
    if (imageUrl.isEmpty) {
      return Container(
        width: 101.03,
        height: 101.03,
        decoration: BoxDecoration(
          color: AppColors.gray200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.emoji_events,
          size: 50,
          color: AppColors.gray400,
        ),
      );
    }

    // Handle network images (from API)
    if (imageUrl.startsWith('http')) {
      if (imageUrl.endsWith('.svg')) {
        return SizedBox(
          width: 101.03,
          height: 101.03,
          child: SvgPicture.network(
            imageUrl,
            placeholderBuilder: (context) => Container(
              width: 101.03,
              height: 101.03,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events,
                size: 50,
                color: AppColors.gray400,
              ),
            ),
          ),
        );
      } else {
        return SizedBox(
          width: 101.03,
          height: 101.03,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
              width: 101.03,
              height: 101.03,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events,
                size: 50,
                color: AppColors.gray400,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 101.03,
              height: 101.03,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events,
                size: 50,
                color: AppColors.gray400,
              ),
            ),
          ),
        );
      }
    }

    // Handle local assets (fallback)
    if (imageUrl.endsWith('.svg')) {
      return SizedBox(
        width: 101.03,
        height: 101.03,
        child: SvgPicture.asset(imageUrl),
      );
    } else {
      return SizedBox(
        width: 101.03,
        height: 101.03,
        child: Image.asset(imageUrl, fit: BoxFit.contain),
      );
    }
  }
}
