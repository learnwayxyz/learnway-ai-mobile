import 'package:json_annotation/json_annotation.dart';
part 'enrollment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EnrollmentResponse {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double progress;

  const EnrollmentResponse({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.enrolledAt,
    this.completedAt,
    required this.progress,
  });

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollmentResponseToJson(this);
}
