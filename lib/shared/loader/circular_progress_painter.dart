import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularProgressPainter extends CustomPainter {
  final double progress;

  CircularProgressPainter({this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xff215AEB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 1.5, backgroundPaint);

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    const startAngle = -math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.5),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
