import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

class LevelOverlayStrategy implements CardOverlayStrategy {
  final LevelType levelType;

  const LevelOverlayStrategy(this.levelType);

  @override
  List<Widget> buildOverlays(String? characterImageAsset) {
    List<Widget> overlays = [];

    if (characterImageAsset != null) {
      overlays.add(
        Positioned(
          right: 0,
          bottom: 0,
          child: Image.asset(characterImageAsset, fit: BoxFit.contain),
        ),
      );
    }

    switch (levelType) {
      case LevelType.beginner:
        overlays.addAll([
          Positioned(
            right: 20,
            top: 20,
            child: Image.asset(
              Assets.images.beginner.path,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ]);
        break;
      case LevelType.intermediate:
        overlays.add(
          Positioned(
            right: 20,
            top: 20,
            child: Image.asset(
              Assets.images.intermediate2.path,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        );
        break;
      case LevelType.advanced:
        overlays.add(
          Positioned(
            right: 20,
            top: 20,
            child: Image.asset(
              Assets.images.intermediate.path,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        );
        break;
    }

    return overlays;
  }
}
