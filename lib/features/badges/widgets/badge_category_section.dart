import 'package:flutter/material.dart';
import 'package:learnwayv2/features/badges/models/badge_tier_item.dart';
import 'package:learnwayv2/features/badges/widgets/badge_card.dart';
import 'package:learnwayv2/features/badges/widgets/badge_styles.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BadgeCategorySection extends StatelessWidget {
  final String categoryTitle;
  final List<BadgeTierItem> badges;
  final bool showEarnedOnly;

  const BadgeCategorySection({
    super.key,
    required this.categoryTitle,
    required this.badges,
    required this.showEarnedOnly,
  });

  @override
  Widget build(BuildContext context) {
    final filteredBadges = showEarnedOnly
        ? badges.where((badge) => badge.isEarned).toList()
        : badges;

    if (filteredBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: BadgeStyles.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(categoryTitle, style: BadgeStyles.categoryTitle),
          const VSpace(20),
          Container(height: 1, color: BadgeStyles.dividerColor),
          const VSpace(44),
          _buildBadgeGrid(filteredBadges),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid(List<BadgeTierItem> badges) {
    return Column(
      children: List.generate((badges.length / 2).ceil(), (index) {
        final firstBadgeIndex = index * 2;
        final secondBadgeIndex = firstBadgeIndex + 1;

        return Padding(
          padding: EdgeInsets.only(
            bottom: secondBadgeIndex < badges.length ? 20 : 0,
          ),
          child: Row(
            children: [
              Expanded(child: BadgeCard(badge: badges[firstBadgeIndex])),
              if (secondBadgeIndex < badges.length)
                Expanded(child: BadgeCard(badge: badges[secondBadgeIndex]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
      }),
    );
  }
}
