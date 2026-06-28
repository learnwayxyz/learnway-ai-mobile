import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

class CourseOverlayStrategy implements CardOverlayStrategy {
  @override
  List<Widget> buildOverlays(String? characterImageAsset) {
    return [
      Positioned(
        top: -30,
        right: -40,
        child: Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: -20,
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      Positioned(
        bottom: -20,
        left: -30,
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      Positioned(
        top: 60,
        left: -40,
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    ];
  }
}

class GridOverlayStrategy implements CardOverlayStrategy {
  @override
  List<Widget> buildOverlays(String? characterImageAsset) {
    return [
      Positioned(
        top: -30,
        right: -40,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      ),
      Positioned(
        top: 20,
        right: -20,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      Positioned(
        bottom: -20,
        left: -30,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      Positioned(
        top: 60,
        left: -40,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    ];
  }
}
