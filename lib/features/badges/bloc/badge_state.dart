import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/badges/models/badge_model.dart';
import 'package:learnwayv2/features/badges/models/badge_tier_item.dart';

abstract class BadgeState extends Equatable {
  const BadgeState();

  @override
  List<Object?> get props => [];
}

class BadgeInitial extends BadgeState {}

class BadgeLoading extends BadgeState {}

class BadgeLoaded extends BadgeState {
  /// Badges already expanded into display items, organized by category
  final Map<String, List<BadgeTierItem>> badgesByCategory;

  /// Flat list of earned badges (no categorization) from /api/v2/badges/user/{userId}
  final List<BadgeModel> earnedBadges;

  final int totalBadges;
  final int? totalBadgeImages;
  final int totalEarned;
  final int totalGems;
  final int completionPercentage;

  const BadgeLoaded({
    required this.badgesByCategory,
    required this.earnedBadges,
    required this.totalBadges,
    required this.totalEarned,
    required this.totalGems,
    required this.completionPercentage,
    this.totalBadgeImages,
  });

  @override
  List<Object?> get props => [
    badgesByCategory,
    earnedBadges,
    totalBadges,
    totalEarned,
    totalGems,
    completionPercentage,
    totalBadgeImages,
  ];
}

class BadgeError extends BadgeState {
  final String message;

  const BadgeError(this.message);

  @override
  List<Object?> get props => [message];
}
