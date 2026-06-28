// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_intermediate_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampIntermediateActionResponse _$OnRampIntermediateActionResponseFromJson(
  Map<String, dynamic> json,
) => OnRampIntermediateActionResponse(
  transactionId: json['transactionId'] as String,
  fonbnkOrderId: json['fonbnkOrderId'] as String,
  status: json['status'] as String,
  transferInstructions: OnRampIntermediateInstructions.fromJson(
    json['transferInstructions'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OnRampIntermediateActionResponseToJson(
  OnRampIntermediateActionResponse instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'status': instance.status,
  'transferInstructions': instance.transferInstructions.toJson(),
};

OnRampIntermediateInstructions _$OnRampIntermediateInstructionsFromJson(
  Map<String, dynamic> json,
) => OnRampIntermediateInstructions(
  type: json['type'] as String,
  intermediateActionRequired: json['intermediateActionRequired'] as bool?,
  intermediateActionExecuted: json['intermediateActionExecuted'] as bool?,
  intermediateActionAttempts: (json['intermediateActionAttempts'] as num?)
      ?.toInt(),
  intermediateActionMaxAttempts: (json['intermediateActionMaxAttempts'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$OnRampIntermediateInstructionsToJson(
  OnRampIntermediateInstructions instance,
) => <String, dynamic>{
  'type': instance.type,
  'intermediateActionRequired': instance.intermediateActionRequired,
  'intermediateActionExecuted': instance.intermediateActionExecuted,
  'intermediateActionAttempts': instance.intermediateActionAttempts,
  'intermediateActionMaxAttempts': instance.intermediateActionMaxAttempts,
};
