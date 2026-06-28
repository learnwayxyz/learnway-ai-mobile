import 'package:json_annotation/json_annotation.dart';

part 'lesson_slide.g.dart';

@JsonSerializable()
class LessonSlidesResponse {
  final bool success;
  final String timestamp;
  final SlideData data;

  LessonSlidesResponse({
    required this.success,
    required this.timestamp,
    required this.data,
  });

  factory LessonSlidesResponse.fromJson(Map<String, dynamic> json) =>
      _$LessonSlidesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LessonSlidesResponseToJson(this);
}

@JsonSerializable()
class SlideData {
  final List<SlideContent> content;
  final int page;
  final int limit;
  final int totalPages;

  SlideData({
    required this.content,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory SlideData.fromJson(Map<String, dynamic> json) =>
      _$SlideDataFromJson(json);

  Map<String, dynamic> toJson() => _$SlideDataToJson(this);
}

@JsonSerializable()
class SlideContent {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String content;
  final int order;
  final String? note;
  final String? mediaUrl;
  final String? mediaType;
  final String? mediaFileId;
  final String? thumbnailUrl;

  SlideContent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.content,
    required this.order,
    this.note,
    this.mediaUrl,
    this.mediaType,
    this.mediaFileId,
    this.thumbnailUrl,
  });

  factory SlideContent.fromJson(Map<String, dynamic> json) =>
      _$SlideContentFromJson(json);

  Map<String, dynamic> toJson() => _$SlideContentToJson(this);
}
