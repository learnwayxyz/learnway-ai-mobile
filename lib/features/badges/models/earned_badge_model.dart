/// Model for earned badges from /api/v2/badges/user/{userId} endpoint

class EarnedBadgeModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String description;
  final String imageUrl;
  final int tokenId;
  final String contractAddress;
  final String mintTransactionHash;
  final dynamic onChainMetadata;
  final String userId;
  final String? achievementId;
  final String badgeType;
  final bool isActive;
  final dynamic requirements;
  final String category;
  final String? tier;
  final bool isUnique;
  final int currentProgress;
  final int? requiredProgress;
  final DateTime earnedAt;
  final int rarityLevel;
  final int gemReward;

  const EarnedBadgeModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tokenId,
    required this.contractAddress,
    required this.mintTransactionHash,
    this.onChainMetadata,
    required this.userId,
    this.achievementId,
    required this.badgeType,
    required this.isActive,
    this.requirements,
    required this.category,
    this.tier,
    required this.isUnique,
    required this.currentProgress,
    this.requiredProgress,
    required this.earnedAt,
    required this.rarityLevel,
    required this.gemReward,
  });

  factory EarnedBadgeModel.fromJson(Map<String, dynamic> json) {
    return EarnedBadgeModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      tokenId: json['tokenId'] as int,
      contractAddress: json['contractAddress'] as String? ?? '',
      mintTransactionHash: json['mintTransactionHash'] as String? ?? '',
      onChainMetadata: json['onChainMetadata'],
      userId: json['userId'] as String,
      achievementId: json['achievementId'] as String?,
      badgeType: json['badgeType'] as String,
      isActive: json['isActive'] as bool,
      requirements: json['requirements'],
      category: json['category'] as String,
      tier: json['tier'] as String?,
      isUnique: json['isUnique'] as bool,
      currentProgress: json['currentProgress'] as int? ?? 0,
      requiredProgress: json['requiredProgress'] as int?,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      rarityLevel: json['rarityLevel'] as int,
      gemReward: json['gemReward'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'tokenId': tokenId,
      'contractAddress': contractAddress,
      'mintTransactionHash': mintTransactionHash,
      'onChainMetadata': onChainMetadata,
      'userId': userId,
      'achievementId': achievementId,
      'badgeType': badgeType,
      'isActive': isActive,
      'requirements': requirements,
      'category': category,
      'tier': tier,
      'isUnique': isUnique,
      'currentProgress': currentProgress,
      'requiredProgress': requiredProgress,
      'earnedAt': earnedAt.toIso8601String(),
      'rarityLevel': rarityLevel,
      'gemReward': gemReward,
    };
  }
}
