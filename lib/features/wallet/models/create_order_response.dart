import 'package:json_annotation/json_annotation.dart';

part 'create_order_response.g.dart';

@JsonSerializable()
class CreateOrderResponse {
  CreateOrderResponse({
    required this.transactionId,
    required this.fonbnkOrderId,
    required this.cryptoWalletAddress,
    required this.cryptoAmount,
    required this.fiatAmount,
    required this.status,
    required this.expiresAt,
  });

  final String transactionId;
  final String fonbnkOrderId;
  final String cryptoWalletAddress;
  @JsonKey(fromJson: _stringFromJson)
  final String cryptoAmount;
  @JsonKey(fromJson: _stringFromJson)
  final String fiatAmount;
  final String status;
  final DateTime expiresAt;

  static String _stringFromJson(dynamic value) => value.toString();

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}
