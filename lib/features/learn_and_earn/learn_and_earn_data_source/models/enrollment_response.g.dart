// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollmentResponse _$EnrollmentResponseFromJson(Map<String, dynamic> json) =>
    EnrollmentResponse(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      progress: (json['progress'] as num).toDouble(),
    );

Map<String, dynamic> _$EnrollmentResponseToJson(EnrollmentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'enrolledAt': instance.enrolledAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'progress': instance.progress,
    };
