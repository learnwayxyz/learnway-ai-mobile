import 'package:json_annotation/json_annotation.dart';

part 'course_project.g.dart';

@JsonSerializable()
class CourseProject {
  const CourseProject({
    required this.id,
    required this.courseId,
    required this.title,
    required this.instructions,
    this.allowedSubmissionTypes = const [],
    required this.passingScore,
    required this.maxScore,
    required this.isActive,
  });

  factory CourseProject.fromJson(Map<String, dynamic> json) =>
      _$CourseProjectFromJson(json);

  final String id;
  final String courseId;
  final String title;
  final String instructions;
  final List<String> allowedSubmissionTypes;
  final int passingScore;
  final int maxScore;
  final bool isActive;

  Map<String, dynamic> toJson() => _$CourseProjectToJson(this);

  /// Submission types the backend accepts for this project, normalized.
  /// Falls back to TEXT so submission is never impossible.
  List<String> get submissionTypes {
    final types = allowedSubmissionTypes
        .map((t) => t.trim().toUpperCase())
        .where((t) => t.isNotEmpty)
        .toList();
    return types.isEmpty ? const ['TEXT'] : types;
  }

  static String submissionTypeLabel(String type) {
    return switch (type) {
      'TEXT' => 'Text',
      'CODE' => 'Code',
      'IMAGE' => 'Image',
      'DOCUMENT' => 'Document',
      'PDF' => 'PDF',
      'GITHUB_URL' => 'GitHub link',
      'WEBSITE_URL' => 'Website link',
      'GOOGLE_DRIVE_URL' => 'Google Drive link',
      'VIDEO_URL' => 'Video link',
      _ => type,
    };
  }

  /// Types whose content is written directly in the app (multiline input).
  static bool isTypedContent(String type) => type == 'TEXT' || type == 'CODE';

  /// Types submitted as an uploaded file; the file is uploaded to the
  /// media endpoint and its URL is sent as the submission content.
  static bool isFileContent(String type) =>
      type == 'PDF' || type == 'DOCUMENT' || type == 'IMAGE';
}
