import 'package:json_annotation/json_annotation.dart';

part 'learning_path_model.g.dart';

@JsonSerializable()
class LearningPathAccess {
  LearningPathAccess({
    required this.isPremium,
    required this.requiresSubscription,
    required this.userHasAccess,
  });

  factory LearningPathAccess.fromJson(Map<String, dynamic> json) =>
      _$LearningPathAccessFromJson(json);

  @JsonKey(name: 'is_premium')
  final bool isPremium;

  @JsonKey(name: 'requires_subscription')
  final bool requiresSubscription;

  @JsonKey(name: 'user_has_access')
  final bool userHasAccess;

  Map<String, dynamic> toJson() => _$LearningPathAccessToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LearningPathModel {
  LearningPathModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.order,
    required this.isActive,
    required this.isPublished,
    required this.totalCourses,
    required this.access,
    this.coverImageUrl,
    this.coverImageFileId,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) =>
      _$LearningPathModelFromJson(json);

  final String id;
  final String title;
  final String description;
  final String type;
  final int order;
  final bool isActive;
  final bool isPublished;
  final String? coverImageUrl;
  final String? coverImageFileId;
  final int totalCourses;
  final LearningPathAccess access;

  bool get isPremium => access.isPremium;
  bool get isFoundation => type == 'foundation';

  Map<String, dynamic> toJson() => _$LearningPathModelToJson(this);
}
