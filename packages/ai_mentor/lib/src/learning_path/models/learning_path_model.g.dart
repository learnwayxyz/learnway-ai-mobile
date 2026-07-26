// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningPathAccess _$LearningPathAccessFromJson(Map<String, dynamic> json) =>
    LearningPathAccess(
      isPremium: json['is_premium'] as bool,
      requiresSubscription: json['requires_subscription'] as bool,
      userHasAccess: json['user_has_access'] as bool,
    );

Map<String, dynamic> _$LearningPathAccessToJson(LearningPathAccess instance) =>
    <String, dynamic>{
      'is_premium': instance.isPremium,
      'requires_subscription': instance.requiresSubscription,
      'user_has_access': instance.userHasAccess,
    };

LearningPathModel _$LearningPathModelFromJson(Map<String, dynamic> json) =>
    LearningPathModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      order: (json['order'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isPublished: json['isPublished'] as bool,
      totalCourses: (json['totalCourses'] as num).toInt(),
      access: LearningPathAccess.fromJson(
        json['access'] as Map<String, dynamic>,
      ),
      coverImageUrl: json['coverImageUrl'] as String?,
      coverImageFileId: json['coverImageFileId'] as String?,
    );

Map<String, dynamic> _$LearningPathModelToJson(LearningPathModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'order': instance.order,
      'isActive': instance.isActive,
      'isPublished': instance.isPublished,
      'coverImageUrl': instance.coverImageUrl,
      'coverImageFileId': instance.coverImageFileId,
      'totalCourses': instance.totalCourses,
      'access': instance.access.toJson(),
    };
