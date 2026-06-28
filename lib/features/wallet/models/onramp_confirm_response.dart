import 'package:json_annotation/json_annotation.dart';

part 'onramp_confirm_response.g.dart';

@JsonSerializable()
class OnRampConfirmResponse {
  OnRampConfirmResponse({
    required this.transactionId,
    required this.fonbnkOrderId,
    required this.status,
  });

  factory OnRampConfirmResponse.fromJson(Map<String, dynamic> json) =>
      _$OnRampConfirmResponseFromJson(json);

  final String transactionId;
  final String fonbnkOrderId;
  final String status;

  Map<String, dynamic> toJson() => _$OnRampConfirmResponseToJson(this);
}
