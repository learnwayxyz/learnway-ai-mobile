// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_slide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonSlidesResponse _$LessonSlidesResponseFromJson(
  Map<String, dynamic> json,
) => LessonSlidesResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  data: SlideData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LessonSlidesResponseToJson(
  LessonSlidesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'data': instance.data,
};

SlideData _$SlideDataFromJson(Map<String, dynamic> json) => SlideData(
  content: (json['content'] as List<dynamic>)
      .map((e) => SlideContent.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$SlideDataToJson(SlideData instance) => <String, dynamic>{
  'content': instance.content,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};

SlideContent _$SlideContentFromJson(Map<String, dynamic> json) => SlideContent(
  id: json['id'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  deletedAt: json['deletedAt'] as String?,
  content: json['content'] as String,
  order: (json['order'] as num).toInt(),
  note: json['note'] as String?,
  mediaUrl: json['mediaUrl'] as String?,
  mediaType: json['mediaType'] as String?,
  mediaFileId: json['mediaFileId'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$SlideContentToJson(SlideContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'content': instance.content,
      'order': instance.order,
      'note': instance.note,
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
      'mediaFileId': instance.mediaFileId,
      'thumbnailUrl': instance.thumbnailUrl,
    };
