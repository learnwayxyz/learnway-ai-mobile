import 'package:json_annotation/json_annotation.dart';

part 'onramp_intermediate_action_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OnRampIntermediateActionResponse {
  OnRampIntermediateActionResponse({
    required this.transactionId,
    required this.fonbnkOrderId,
    required this.status,
    required this.transferInstructions,
  });

  factory OnRampIntermediateActionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$OnRampIntermediateActionResponseFromJson(json);

  final String transactionId;
  final String fonbnkOrderId;
  final String status;
  final OnRampIntermediateInstructions transferInstructions;

  Map<String, dynamic> toJson() =>
      _$OnRampIntermediateActionResponseToJson(this);
}

@JsonSerializable()
class OnRampIntermediateInstructions {
  OnRampIntermediateInstructions({
    required this.type,
    this.intermediateActionRequired,
    this.intermediateActionExecuted,
    this.intermediateActionAttempts,
    this.intermediateActionMaxAttempts,
  });

  factory OnRampIntermediateInstructions.fromJson(Map<String, dynamic> json) =>
      _$OnRampIntermediateInstructionsFromJson(json);

  final String type;
  final bool? intermediateActionRequired;
  final bool? intermediateActionExecuted;
  final int? intermediateActionAttempts;
  final int? intermediateActionMaxAttempts;

  Map<String, dynamic> toJson() =>
      _$OnRampIntermediateInstructionsToJson(this);
}
