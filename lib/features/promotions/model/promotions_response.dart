import 'package:json_annotation/json_annotation.dart';
import 'package:learnwayv2/features/promotions/model/promotion_model.dart';

part 'promotions_response.g.dart';

@JsonSerializable()
class PromotionsResponse {
  PromotionsResponse({this.popup, required this.banners});

  final PromotionModel? popup;
  final List<PromotionModel> banners;

  factory PromotionsResponse.fromJson(Map<String, dynamic> json) =>
      _$PromotionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionsResponseToJson(this);
}
