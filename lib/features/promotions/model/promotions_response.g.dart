// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionsResponse _$PromotionsResponseFromJson(Map<String, dynamic> json) =>
    PromotionsResponse(
      popup: json['popup'] == null
          ? null
          : PromotionModel.fromJson(json['popup'] as Map<String, dynamic>),
      banners: (json['banners'] as List<dynamic>)
          .map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromotionsResponseToJson(PromotionsResponse instance) =>
    <String, dynamic>{'popup': instance.popup, 'banners': instance.banners};
