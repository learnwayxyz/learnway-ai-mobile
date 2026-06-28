import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/services/kyc_service/model/didit_session_status.dart';

part 'session_decision.g.dart';

class _DiditSessionStatusConverter
    implements JsonConverter<DiditSessionStatus, String?> {
  const _DiditSessionStatusConverter();

  @override
  DiditSessionStatus fromJson(String? json) {
    switch (json?.toLowerCase().trim()) {
      case 'not started':
        return DiditSessionStatus.notStarted;
      case 'in progress':
        return DiditSessionStatus.inProgress;
      case 'approved':
      case 'success':
      case 'completed':
        return DiditSessionStatus.approved;
      case 'declined':
      case 'rejected':
        return DiditSessionStatus.declined;
      case 'in review':
        return DiditSessionStatus.inReview;
      case 'resubmitted':
        return DiditSessionStatus.resubmitted;
      case 'expired':
        return DiditSessionStatus.expired;
      case 'abandoned':
        return DiditSessionStatus.abandoned;
      case 'kyc expired':
        return DiditSessionStatus.kycExpired;
      default:
        return DiditSessionStatus.unknown;
    }
  }

  @override
  String? toJson(DiditSessionStatus status) => switch (status) {
    DiditSessionStatus.notStarted => 'Not Started',
    DiditSessionStatus.inProgress => 'In Progress',
    DiditSessionStatus.approved => 'Approved',
    DiditSessionStatus.declined => 'Declined',
    DiditSessionStatus.inReview => 'In Review',
    DiditSessionStatus.resubmitted => 'Resubmitted',
    DiditSessionStatus.expired => 'Expired',
    DiditSessionStatus.abandoned => 'Abandoned',
    DiditSessionStatus.kycExpired => 'Kyc Expired',
    DiditSessionStatus.unknown => null,
  };
}

@JsonSerializable(explicitToJson: true)
class SessionDecision {
  SessionDecision({
    required this.sessionId,
    required this.status,
    Map<String, dynamic>? rawDecision,
  }) : rawDecision = rawDecision ?? {};

  @JsonKey(name: 'session_id')
  final String sessionId;

  @JsonKey(name: 'status')
  @_DiditSessionStatusConverter()
  final DiditSessionStatus status;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final Map<String, dynamic> rawDecision;

  factory SessionDecision.fromJson(Map<String, dynamic> json) {
    final decision = _$SessionDecisionFromJson(json);
    return SessionDecision(
      sessionId: decision.sessionId,
      status: decision.status,
      rawDecision: json,
    );
  }

  Map<String, dynamic> toJson() => _$SessionDecisionToJson(this);
}
