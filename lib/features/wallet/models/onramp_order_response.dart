import 'package:json_annotation/json_annotation.dart';

part 'onramp_order_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OnRampOrderResponse {
  OnRampOrderResponse({
    required this.transactionId,
    required this.fonbnkOrderId,
    required this.status,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.transferInstructions,
    required this.expiresAt,
  });

  factory OnRampOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampOrderResponseFromJson(json);

  final String transactionId;
  final String fonbnkOrderId;
  final String status;
  final double cryptoAmount;
  final double fiatAmount;
  final OnRampTransferInstructions transferInstructions;
  final DateTime expiresAt;

  Map<String, dynamic> toJson() => _$OnRampOrderResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OnRampTransferInstructions {
  OnRampTransferInstructions({
    required this.type,
    this.instructionsText,
    this.warningText,
    this.transferDetails = const [],
  });

  factory OnRampTransferInstructions.fromJson(Map<String, dynamic> json) =>
      _$OnRampTransferInstructionsFromJson(json);

  final String type;
  final String? instructionsText;
  final String? warningText;
  final List<OnRampTransferDetail> transferDetails;

  Map<String, dynamic> toJson() => _$OnRampTransferInstructionsToJson(this);
}

@JsonSerializable()
class OnRampTransferDetail {
  OnRampTransferDetail({
    required this.id,
    required this.label,
    required this.value,
  });

  factory OnRampTransferDetail.fromJson(Map<String, dynamic> json) =>
      _$OnRampTransferDetailFromJson(json);

  final String id;
  final String label;
  final String value;

  Map<String, dynamic> toJson() => _$OnRampTransferDetailToJson(this);
}
