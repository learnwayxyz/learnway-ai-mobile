import 'package:json_annotation/json_annotation.dart';

part 'confirm_order_response.g.dart';

@JsonSerializable()
class ConfirmOrderResponse {
  ConfirmOrderResponse({
    required this.transactionId,
    required this.fonbnkOrderId,
    required this.status,
    this.cryptoTxHash,
  });

  final String transactionId;
  final String fonbnkOrderId;
  final String status;
  final String? cryptoTxHash;

  factory ConfirmOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmOrderResponseToJson(this);
}
