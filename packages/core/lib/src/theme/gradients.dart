import 'dart:math';

import 'package:flutter/material.dart';

class RandomGradients {
  static const List<Gradient> courseGradients = [
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE36693), Color(0xFFE02969)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7E9BE7), Color(0xFF245DEC)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFF73C6AD), Color(0xFF1AB284)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFF414651), Color(0xFF130F26)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFF9F7AEA), Color(0xFF6B46C1)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF6AD55), Color(0xFFED8936)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF56565), Color(0xFFE53E3E)],
    ),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4FD1C7), Color(0xFF319795)],
    ),
  ];

  static Gradient getRandomGradient() {
    final random = Random();
    return courseGradients[random.nextInt(courseGradients.length)];
  }

  static Gradient getDailyGradient({String? seed}) {
    final now = DateTime.now();
    final daysSinceEpoch = now.difference(DateTime(1970, 1, 1)).inDays;

    final combinedSeed =
        seed != null ? '$daysSinceEpoch-$seed'.hashCode : daysSinceEpoch;
    final index = combinedSeed.abs() % courseGradients.length;
    return courseGradients[index];
  }
}
