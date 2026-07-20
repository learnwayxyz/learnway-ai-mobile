import 'package:json_annotation/json_annotation.dart';

part 'certificate_claim.g.dart';

@JsonSerializable()
class CertificateClaim {
  const CertificateClaim({
    required this.id,
    required this.courseId,
    required this.studentName,
    this.certificateNumber,
    this.imageUri,
    this.metadataUri,
    this.txHash,
    this.mintedAt,
    this.onChainVerified = false,
    this.course,
  });

  factory CertificateClaim.fromJson(Map<String, dynamic> json) =>
      _$CertificateClaimFromJson(json);

  final String id;
  final String courseId;
  final String studentName;
  final String? certificateNumber;
  final String? imageUri;
  final String? metadataUri;
  final String? txHash;
  final DateTime? mintedAt;
  @JsonKey(defaultValue: false)
  final bool onChainVerified;
  final CertificateCourseInfo? course;

  Map<String, dynamic> toJson() => _$CertificateClaimToJson(this);

  String get courseTitle => course?.title ?? '';
}

@JsonSerializable()
class CertificateCourseInfo {
  const CertificateCourseInfo({required this.title});

  factory CertificateCourseInfo.fromJson(Map<String, dynamic> json) =>
      _$CertificateCourseInfoFromJson(json);

  final String title;

  Map<String, dynamic> toJson() => _$CertificateCourseInfoToJson(this);
}
