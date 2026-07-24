import 'package:json_annotation/json_annotation.dart';

part 'course_project_submission.g.dart';

@JsonSerializable()
class CourseProjectSubmissionResult {
  const CourseProjectSubmissionResult({
    required this.submission,
    this.assessment,
  });

  factory CourseProjectSubmissionResult.fromJson(Map<String, dynamic> json) =>
      _$CourseProjectSubmissionResultFromJson(json);

  final ProjectSubmission submission;
  final ProjectAssessment? assessment;

  Map<String, dynamic> toJson() => _$CourseProjectSubmissionResultToJson(this);
}

@JsonSerializable()
class ProjectSubmission {
  const ProjectSubmission({
    required this.id,
    required this.userId,
    required this.courseProjectId,
    required this.status,
    required this.submissionType,
    this.textContent,
    this.fileUrl,
    this.fileId,
    this.linkUrl,
    this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProjectSubmission.fromJson(Map<String, dynamic> json) =>
      _$ProjectSubmissionFromJson(json);

  final String id;
  final String userId;
  final String courseProjectId;
  final String status;
  final String submissionType;
  final String? textContent;
  final String? fileUrl;
  final String? fileId;
  final String? linkUrl;
  final DateTime? submittedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() => _$ProjectSubmissionToJson(this);
}

@JsonSerializable()
class ProjectAssessment {
  const ProjectAssessment({
    required this.id,
    required this.submissionId,
    required this.status,
    this.score,
    this.passed,
    this.strengths = const [],
    this.weaknesses = const [],
    this.recommendations = const [],
    this.rawResponse,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ProjectAssessment.fromJson(Map<String, dynamic> json) =>
      _$ProjectAssessmentFromJson(json);

  final String id;
  final String submissionId;
  final String status;
  final int? score;
  final bool? passed;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final Map<String, dynamic>? rawResponse;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() => _$ProjectAssessmentToJson(this);
}
