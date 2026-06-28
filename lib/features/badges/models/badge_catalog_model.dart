/// Models for the new Badge Catalog API response

class BadgeCatalogResponse {
  final int totalBadges;
  final UserBadgeStats userBadgeStats;
  final Map<String, List<BadgeCatalogItem>> categories;

  const BadgeCatalogResponse({
    required this.totalBadges,
    required this.userBadgeStats,
    required this.categories,
  });

  factory BadgeCatalogResponse.fromJson(Map<String, dynamic> json) {
    final categoriesMap = <String, List<BadgeCatalogItem>>{};

    if (json['categories'] != null) {
      final categoriesJson = json['categories'] as Map<String, dynamic>;
      categoriesJson.forEach((key, value) {
        categoriesMap[key] = (value as List)
            .map((badge) => BadgeCatalogItem.fromJson(badge))
            .toList();
      });
    }

    return BadgeCatalogResponse(
      totalBadges: json['totalBadges'] as int? ?? 0,
      userBadgeStats: UserBadgeStats.fromJson(json['userBadgeStats'] ?? {}),
      categories: categoriesMap,
    );
  }
}

class UserBadgeStats {
  final int totalEarned;
  final int totalGems;
  final int completionPercentage;

  const UserBadgeStats({
    required this.totalEarned,
    required this.totalGems,
    required this.completionPercentage,
  });

  factory UserBadgeStats.fromJson(Map<String, dynamic> json) {
    return UserBadgeStats(
      totalEarned: json['totalEarned'] as int? ?? 0,
      totalGems: json['totalGems'] as int? ?? 0,
      completionPercentage: json['completionPercentage'] as int? ?? 0,
    );
  }
}

class BadgeCatalogItem {
  final String badgeType;
  final String name;
  final String description;
  final String category;
  final int? rarityLevel;
  final int? gemReward;
  final bool isUnique;
  final List<BadgeRequirement> requirements;
  final String initialBadgeImageUrl;
  final List<BadgeTier>? tiers;
  final bool isTiered;
  final BadgeUserData userData;

  const BadgeCatalogItem({
    required this.badgeType,
    required this.name,
    required this.description,
    required this.category,
    this.rarityLevel,
    this.gemReward,
    required this.isUnique,
    required this.requirements,
    required this.initialBadgeImageUrl,
    this.tiers,
    required this.isTiered,
    required this.userData,
  });

  factory BadgeCatalogItem.fromJson(Map<String, dynamic> json) {
    return BadgeCatalogItem(
      badgeType: json['badgeType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rarityLevel: json['rarityLevel'] as int?,
      gemReward: json['gemReward'] as int?,
      isUnique: json['isUnique'] as bool? ?? false,
      requirements: (json['requirements'] as List?)
              ?.map((req) => BadgeRequirement.fromJson(req))
              .toList() ??
          [],
      initialBadgeImageUrl: json['initialBadgeImageUrl'] as String? ?? '',
      tiers: json['tiers'] != null
          ? (json['tiers'] as List)
              .map((tier) => BadgeTier.fromJson(tier))
              .toList()
          : null,
      isTiered: json['isTiered'] as bool? ?? false,
      userData: BadgeUserData.fromJson(json['userData'] ?? {}),
    );
  }

  /// Get the display image URL (earned badge or placeholder)
  String get displayImageUrl {
    if (userData.hasEarned && userData.earnedBadges.isNotEmpty) {
      return userData.earnedBadges.first.badgeImageUrl;
    }
    return initialBadgeImageUrl;
  }

  /// Get the current tier if earned
  String? get currentTier {
    if (userData.hasEarned && userData.earnedBadges.isNotEmpty) {
      return userData.earnedBadges.first.tier;
    }
    return null;
  }
}

class BadgeRequirement {
  final String type;
  final int value;
  final String description;

  const BadgeRequirement({
    required this.type,
    required this.value,
    required this.description,
  });

  factory BadgeRequirement.fromJson(Map<String, dynamic> json) {
    return BadgeRequirement(
      type: json['type'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }
}

class BadgeTier {
  final String tier;
  final String name;
  final int gemReward;
  final int rarityLevel;
  final List<BadgeRequirement> requirements;

  const BadgeTier({
    required this.tier,
    required this.name,
    required this.gemReward,
    required this.rarityLevel,
    required this.requirements,
  });

  factory BadgeTier.fromJson(Map<String, dynamic> json) {
    return BadgeTier(
      tier: json['tier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gemReward: json['gemReward'] as int? ?? 0,
      rarityLevel: json['rarityLevel'] as int? ?? 0,
      requirements: (json['requirements'] as List?)
              ?.map((req) => BadgeRequirement.fromJson(req))
              .toList() ??
          [],
    );
  }
}

class BadgeUserData {
  final List<EarnedBadge> earnedBadges;
  final dynamic currentProgress;
  final bool hasEarned;

  const BadgeUserData({
    required this.earnedBadges,
    this.currentProgress,
    required this.hasEarned,
  });

  factory BadgeUserData.fromJson(Map<String, dynamic> json) {
    return BadgeUserData(
      earnedBadges: (json['earnedBadges'] as List?)
              ?.map((badge) => EarnedBadge.fromJson(badge))
              .toList() ??
          [],
      currentProgress: json['currentProgress'],
      hasEarned: json['hasEarned'] as bool? ?? false,
    );
  }
}

class EarnedBadge {
  final String? tier;
  final String earnedAt;
  final int gemReward;
  final String badgeImageUrl;

  const EarnedBadge({
    this.tier,
    required this.earnedAt,
    required this.gemReward,
    required this.badgeImageUrl,
  });

  factory EarnedBadge.fromJson(Map<String, dynamic> json) {
    return EarnedBadge(
      tier: json['tier'] as String?,
      earnedAt: json['earnedAt'] as String? ?? '',
      gemReward: json['gemReward'] as int? ?? 0,
      badgeImageUrl: json['badgeImageUrl'] as String? ?? '',
    );
  }
}

/// Badge Details Model (for individual badge endpoint)
class BadgeDetailsModel {
  final String badgeType;
  final String name;
  final String description;
  final String? title;
  final String? howToEarn;
  final String category;
  final int? rarityLevel;
  final int? gemReward;
  final bool isUnique;
  final List<BadgeRequirement> requirements;
  final String? imageUrl;
  final List<BadgeTier>? tiers;
  final bool isTiered;

  const BadgeDetailsModel({
    required this.badgeType,
    required this.name,
    required this.description,
    this.title,
    this.howToEarn,
    required this.category,
    this.rarityLevel,
    this.gemReward,
    required this.isUnique,
    required this.requirements,
    this.imageUrl,
    this.tiers,
    required this.isTiered,
  });

  factory BadgeDetailsModel.fromJson(Map<String, dynamic> json) {
    return BadgeDetailsModel(
      badgeType: json['badgeType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      title: json['title'] as String?,
      howToEarn: json['howToEarn'] as String?,
      category: json['category'] as String? ?? '',
      rarityLevel: json['rarityLevel'] as int?,
      gemReward: json['gemReward'] as int?,
      isUnique: json['isUnique'] as bool? ?? false,
      requirements: (json['requirements'] as List?)
              ?.map((req) => BadgeRequirement.fromJson(req))
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String?,
      tiers: json['tiers'] != null
          ? (json['tiers'] as List)
              .map((tier) => BadgeTier.fromJson(tier))
              .toList()
          : null,
      isTiered: json['isTiered'] as bool? ?? false,
    );
  }
}
