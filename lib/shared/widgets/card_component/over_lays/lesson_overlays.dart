import 'package:flutter/material.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class LessonOverlayStrategy implements CardOverlayStrategy {
  final CardType cardType;
  final Map<CardType, List<OverlayConfig>> dynamicOverlays;

  const LessonOverlayStrategy(this.cardType, {this.dynamicOverlays = const {}});

  @override
  List<Widget> buildOverlays(String? characterImageAsset) {
    final List<Widget> overlays = [];
    if (characterImageAsset != null) {
      overlays.add(
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(characterImageAsset, fit: BoxFit.contain),
        ),
      );
    }

    final configs = dynamicOverlays[cardType];
    if (configs != null && configs.isNotEmpty) {
      for (final config in configs) {
        overlays.add(
          Positioned(
            right: config.right,
            top: config.top,
            bottom: config.bottom,
            left: config.left,
            child: Image.asset(
              config.assetPath,
              fit: config.fit ?? BoxFit.contain,
              width: config.width,
              height: config.height,
            ),
          ),
        );
      }
      return overlays;
    }
    switch (cardType) {
      case CardType.lesson:
        overlays.addAll([
          Positioned(
            right: 40,
            top: 11,
            child: Image.asset(
              Assets.images.lessonCardIllustration.path,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 25,
            bottom: 45,
            child: Image.asset(
              Assets.images.smallCoinPile.path,
              fit: BoxFit.contain,
            ),
          ),
        ]);
        break;

      case CardType.battles:
        overlays.add(
          Positioned(
            right: 35,
            bottom: 40,
            child: Image.asset(
              'assets/images/game_pad.png',
              fit: BoxFit.contain,
            ),
          ),
        );
        break;

      case CardType.challenge:
        overlays.add(
          Positioned(
            right: 5,
            bottom: 11,
            child: Image.asset(
              'assets/images/child_chair.png',
              fit: BoxFit.contain,
            ),
          ),
        );
        break;

      case CardType.others:
        overlays.add(
          Positioned(
            right: 5,
            bottom: 11,
            child: Image.asset(
              Assets.images.contestTroph.path,
              fit: BoxFit.contain,
            ),
          ),
        );
        break;
    }

    return overlays;
  }
}

class OverlayConfig {
  const OverlayConfig({
    required this.assetPath,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.fit,
    this.width,
    this.height,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final BoxFit? fit;
}
