import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

/// Helper class for launching enhanced confetti celebrations throughout the app
class ConfettiHelper {
  ConfettiHelper._();

  /// Launch a dramatic confetti celebration with multiple bursts
  /// covering the entire screen for a more festive effect
  static void launchCelebration(BuildContext context) {
    // Main center burst with wide spread
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 150,
        spread: 120,
        y: 0.5,
        startVelocity: 45,
      ),
    );

    // Left side burst for fuller coverage
    Future.delayed(const Duration(milliseconds: 100), () {
      Confetti.launch(
        context,
        options: const ConfettiOptions(
          particleCount: 80,
          spread: 90,
          x: 0.2,
          y: 0.4,
          angle: 60,
        ),
      );
    });

    // Right side burst for fuller coverage
    Future.delayed(const Duration(milliseconds: 200), () {
      Confetti.launch(
        context,
        options: const ConfettiOptions(
          particleCount: 80,
          spread: 90,
          x: 0.8,
          y: 0.4,
          angle: 120,
        ),
      );
    });
  }

  /// Launch a simple confetti celebration (for less dramatic moments)
  static void launchSimple(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 100,
        spread: 70,
        y: 0.6,
      ),
    );
  }
}
