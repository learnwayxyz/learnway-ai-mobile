import 'package:json_annotation/json_annotation.dart';

part 'promotion_model.g.dart';

@JsonSerializable()
class PromotionModel {
  PromotionModel({
    required this.id,
    required this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.actionType,
    this.actionValue,
    this.buttonText,
    this.dismissText,
    required this.displayFrequencyHours,
    required this.priority,
    this.targetCountries = const [],
    this.targetLanguages = const [],
    this.isActive = true,
    this.startDate,
    this.endDate,
    this.impressionCount = 0,
    this.clickCount = 0,
    this.dismissCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String type;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? actionType;
  final String? actionValue;
  final String? buttonText;
  final String? dismissText;
  final int displayFrequencyHours;
  final int priority;
  final List<String> targetCountries;
  final List<String> targetLanguages;
  final bool isActive;
  final String? startDate;
  final String? endDate;
  final int impressionCount;
  final int clickCount;
  final int dismissCount;
  final String? createdAt;
  final String? updatedAt;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  factory PromotionModel.empty() => PromotionModel(
        id: 'promo_preview_001',
        type: 'popup',
        title: '🎉 Special Offer Just for You!',
        description:
            'Upgrade to Premium and unlock unlimited lessons, ad-free learning, and exclusive contests. Limited time offer — 50% off your first month!',
        imageUrl: null,
        actionType: 'internal_screen',
        actionValue: 'subscription',
        buttonText: 'Upgrade Now',
        dismissText: 'Maybe Later',
        displayFrequencyHours: 24,
        priority: 1,
        targetCountries: const ['NG', 'KE', 'GH'],
        targetLanguages: const ['en'],
        isActive: true,
        startDate: '2026-05-01T00:00:00.000Z',
        endDate: '2026-06-30T23:59:59.000Z',
        impressionCount: 0,
        clickCount: 0,
        dismissCount: 0,
        createdAt: '2026-05-01T00:00:00.000Z',
        updatedAt: '2026-05-01T00:00:00.000Z',
      );

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);
}
