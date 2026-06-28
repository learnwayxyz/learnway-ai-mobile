// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDecision _$SessionDecisionFromJson(Map<String, dynamic> json) =>
    SessionDecision(
      sessionId: json['session_id'] as String,
      status: const _DiditSessionStatusConverter().fromJson(
        json['status'] as String?,
      ),
    );

Map<String, dynamic> _$SessionDecisionToJson(SessionDecision instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'status': const _DiditSessionStatusConverter().toJson(instance.status),
    };
