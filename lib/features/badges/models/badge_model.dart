class BadgeModel {
  final String? id;
  final String name;
  final String description;
  final bool isEarned;
  final String iconPath;
  final bool hasProgress;
  final int currentProgress;
  final int targetProgress;
  final String? badgeType;
  final String? category;
  final String? tier;
  final int? rarityLevel;
  final int? gemReward;
  final DateTime? earnedAt;
  final bool? isActive;

  const BadgeModel({
    this.id,
    required this.name,
    required this.description,
    required this.isEarned,
    required this.iconPath,
    this.hasProgress = false,
    this.currentProgress = 0,
    this.targetProgress = 0,
    this.badgeType,
    this.category,
    this.tier,
    this.rarityLevel,
    this.gemReward,
    this.earnedAt,
    this.isActive,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isEarned: json['earnedAt'] != null,
      iconPath: json['imageUrl'] as String? ?? '',
      hasProgress: json['requiredProgress'] != null,
      currentProgress: json['currentProgress'] as int? ?? 0,
      targetProgress: json['requiredProgress'] as int? ?? 0,
      badgeType: json['badgeType'] as String?,
      category: json['category'] as String?,
      tier: json['tier'] as String?,
      rarityLevel: json['rarityLevel'] as int?,
      gemReward: json['gemReward'] as int?,
      earnedAt: json['earnedAt'] != null
          ? DateTime.tryParse(json['earnedAt'])
          : null,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'earnedAt': earnedAt?.toIso8601String(),
      'imageUrl': iconPath,
      'currentProgress': currentProgress,
      'requiredProgress': targetProgress,
      'badgeType': badgeType,
      'category': category,
      'tier': tier,
      'rarityLevel': rarityLevel,
      'gemReward': gemReward,
      'isActive': isActive,
    };
  }
}

class BadgeCategory {
  final String title;
  final List<BadgeModel> badges;

  const BadgeCategory({
    required this.title,
    required this.badges,
  });
}
