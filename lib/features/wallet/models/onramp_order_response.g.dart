// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onramp_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnRampOrderResponse _$OnRampOrderResponseFromJson(Map<String, dynamic> json) =>
    OnRampOrderResponse(
      transactionId: json['transactionId'] as String,
      fonbnkOrderId: json['fonbnkOrderId'] as String,
      status: json['status'] as String,
      cryptoAmount: (json['cryptoAmount'] as num).toDouble(),
      fiatAmount: (json['fiatAmount'] as num).toDouble(),
      transferInstructions: OnRampTransferInstructions.fromJson(
        json['transferInstructions'] as Map<String, dynamic>,
      ),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$OnRampOrderResponseToJson(
  OnRampOrderResponse instance,
) => <String, dynamic>{
  'transactionId': instance.transactionId,
  'fonbnkOrderId': instance.fonbnkOrderId,
  'status': instance.status,
  'cryptoAmount': instance.cryptoAmount,
  'fiatAmount': instance.fiatAmount,
  'transferInstructions': instance.transferInstructions.toJson(),
  'expiresAt': instance.expiresAt.toIso8601String(),
};

OnRampTransferInstructions _$OnRampTransferInstructionsFromJson(
  Map<String, dynamic> json,
) => OnRampTransferInstructions(
  type: json['type'] as String,
  instructionsText: json['instructionsText'] as String?,
  warningText: json['warningText'] as String?,
  transferDetails:
      (json['transferDetails'] as List<dynamic>?)
          ?.map((e) => OnRampTransferDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OnRampTransferInstructionsToJson(
  OnRampTransferInstructions instance,
) => <String, dynamic>{
  'type': instance.type,
  'instructionsText': instance.instructionsText,
  'warningText': instance.warningText,
  'transferDetails': instance.transferDetails.map((e) => e.toJson()).toList(),
};

OnRampTransferDetail _$OnRampTransferDetailFromJson(
  Map<String, dynamic> json,
) => OnRampTransferDetail(
  id: json['id'] as String,
  label: json['label'] as String,
  value: json['value'] as String,
);

Map<String, dynamic> _$OnRampTransferDetailToJson(
  OnRampTransferDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'value': instance.value,
};
