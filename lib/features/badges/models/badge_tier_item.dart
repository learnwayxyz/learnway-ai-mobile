import 'package:learnwayv2/features/badges/models/badge_catalog_model.dart';

/// Represents a single tier of a badge as a displayable item
class BadgeTierItem {
  final String badgeType;
  final String name; // e.g., "Silver Keyholder"
  final String description;
  final String category;
  final String? tier; // e.g., "Silver", "Gold"
  final int gemReward;
  final int rarityLevel;
  final bool isEarned;
  final String imageUrl;
  final List<BadgeRequirement> requirements;

  const BadgeTierItem({
    required this.badgeType,
    required this.name,
    required this.description,
    required this.category,
    this.tier,
    required this.gemReward,
    required this.rarityLevel,
    required this.isEarned,
    required this.imageUrl,
    required this.requirements,
  });

  /// Create a BadgeTierItem from a non-tiered badge
  factory BadgeTierItem.fromNonTieredBadge(BadgeCatalogItem badge) {
    return BadgeTierItem(
      badgeType: badge.badgeType,
      name: badge.name,
      description: badge.requirements.isNotEmpty
          ? badge.requirements.first.description
          : badge.description,
      category: badge.category,
      tier: null,
      gemReward: badge.gemReward ?? 0,
      rarityLevel: badge.rarityLevel ?? 1,
      isEarned: badge.userData.hasEarned,
      imageUrl: badge.displayImageUrl,
      requirements: badge.requirements,
    );
  }

  /// Create a BadgeTierItem from a tiered badge + specific tier
  factory BadgeTierItem.fromTieredBadge(
    BadgeCatalogItem badge,
    BadgeTier tier,
  ) {
    // Check if this specific tier is earned
    final earnedTier = badge.userData.earnedBadges.firstWhere(
      (earned) => earned.tier == tier.tier,
      orElse: () => EarnedBadge(
        tier: null,
        earnedAt: '',
        gemReward: 0,
        badgeImageUrl: badge.initialBadgeImageUrl,
      ),
    );

    final isEarned = earnedTier.tier == tier.tier;
    final imageUrl = isEarned
        ? earnedTier.badgeImageUrl
        : badge.initialBadgeImageUrl;

    return BadgeTierItem(
      badgeType: badge.badgeType,
      name: '${tier.tier} ${badge.name}', // e.g., "Silver Keyholder"
      description: tier.requirements.isNotEmpty
          ? tier.requirements.first.description
          : badge.description,
      category: badge.category,
      tier: tier.tier,
      gemReward: tier.gemReward,
      rarityLevel: tier.rarityLevel,
      isEarned: isEarned,
      imageUrl: imageUrl,
      requirements: tier.requirements,
    );
  }

  /// Expand a BadgeCatalogItem into one or more BadgeTierItems
  static List<BadgeTierItem> expandBadge(BadgeCatalogItem badge) {
    if (!badge.isTiered || badge.tiers == null || badge.tiers!.isEmpty) {
      // Non-tiered badge - return as single item
      return [BadgeTierItem.fromNonTieredBadge(badge)];
    }

    // Special case: KEYHOLDER badge should be split into separate tier cards
    if (badge.badgeType == 'KEYHOLDER') {
      // Create one item per tier
      return badge.tiers!
          .map((tier) => BadgeTierItem.fromTieredBadge(badge, tier))
          .toList();
    }

    // All other tiered badges - return as single item
    // (They will show their tiers in the details screen)
    return [BadgeTierItem.fromNonTieredBadge(badge)];
  }

  /// Expand all badges in a category
  static List<BadgeTierItem> expandBadges(List<BadgeCatalogItem> badges) {
    final List<BadgeTierItem> expanded = [];
    for (final badge in badges) {
      expanded.addAll(expandBadge(badge));
    }
    return expanded;
  }
}
