// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    PromotionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      actionType: json['actionType'] as String?,
      actionValue: json['actionValue'] as String?,
      buttonText: json['buttonText'] as String?,
      dismissText: json['dismissText'] as String?,
      displayFrequencyHours: (json['displayFrequencyHours'] as num).toInt(),
      priority: (json['priority'] as num).toInt(),
      targetCountries:
          (json['targetCountries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetLanguages:
          (json['targetLanguages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      impressionCount: (json['impressionCount'] as num?)?.toInt() ?? 0,
      clickCount: (json['clickCount'] as num?)?.toInt() ?? 0,
      dismissCount: (json['dismissCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'actionType': instance.actionType,
      'actionValue': instance.actionValue,
      'buttonText': instance.buttonText,
      'dismissText': instance.dismissText,
      'displayFrequencyHours': instance.displayFrequencyHours,
      'priority': instance.priority,
      'targetCountries': instance.targetCountries,
      'targetLanguages': instance.targetLanguages,
      'isActive': instance.isActive,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'impressionCount': instance.impressionCount,
      'clickCount': instance.clickCount,
      'dismissCount': instance.dismissCount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
