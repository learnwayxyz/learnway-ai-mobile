import 'package:flutter/material.dart';

class CircularProgressChart extends StatelessWidget {
  final double progress;
  final String totalText;
  final String labelText;
  final Color progressColor;
  final Color backgroundColor;
  final bool isThreeSegment;
  final double middleProgress;
  final Color middleColor;

  const CircularProgressChart({
    super.key,
    required this.progress,
    required this.totalText,
    required this.labelText,
    this.progressColor = const Color(0xFF215AEB),
    this.backgroundColor = const Color(0xFFF4F7FE),
    this.isThreeSegment = false,
    this.middleProgress = 0.0,
    this.middleColor = const Color(0xFF9E77ED),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 137.57,
      height: 137.57,
      child: Stack(
        children: [
          // Pie chart
          SizedBox(
            width: 137.57,
            height: 137.57,
            child: CustomPaint(
              painter: PieChartPainter(
                leftColor: const Color(0xFF215AEB),
                rightColor: const Color(0xFFE8ECF6),
                leftStrokeWidth: 28.68,
                rightStrokeWidth: 24.59,
                isThreeSegment: isThreeSegment,
                middleProgress: middleProgress,
                middleColor: middleColor,
              ),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  totalText,
                  style: TextStyle(
              fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181D27),
                    height: 1.17, // 28/24
                  ),
                ),
                // const SizedBox(height: 4),
                Text(
                  labelText,
                  style: TextStyle(
              fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9EA5D1),
                    letterSpacing: 0.2,
                    height: 1.5, // 18/12
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Color leftColor;
  final Color rightColor;
  final double leftStrokeWidth;
  final double rightStrokeWidth;
  final bool isThreeSegment;
  final double middleProgress;
  final Color middleColor;

  PieChartPainter({
    required this.leftColor,
    required this.rightColor,
    required this.leftStrokeWidth,
    required this.rightStrokeWidth,
    this.isThreeSegment = false,
    this.middleProgress = 0.0,
    this.middleColor = const Color(0xFF9E77ED),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final innerRadius = (size.width - 50) / 2; // Inner radius for alignment

    if (isThreeSegment) {
      // Three segment design for Battle Statistics
      _paintThreeSegment(canvas, center, innerRadius, size);
    } else {
      // Two segment design for Q Answered
      _paintTwoSegment(canvas, center, innerRadius, size);
    }
  }

  void _paintTwoSegment(
    Canvas canvas,
    Offset center,
    double innerRadius,
    Size size,
  ) {
    // Left half (50%) - from top to bottom left with gradient
    final leftGradient = LinearGradient(
      begin: const Alignment(0.50, -0.00),
      end: const Alignment(0.50, 1.00),
      colors: [const Color(0xFF205AEB), const Color(0xFF123385)],
    );

    final leftPaint =
        Paint()
          ..shader = leftGradient.createShader(
            Rect.fromCircle(
              center: center,
              radius: innerRadius + leftStrokeWidth,
            ),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = leftStrokeWidth
          ..strokeCap = StrokeCap.butt;

    // Calculate left arc radius to align inner edge
    final leftRadius = innerRadius + (leftStrokeWidth / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: leftRadius),
      -1.5708, // -90 degrees (top)
      3.14159, // 180 degrees (half circle)
      false,
      leftPaint,
    );

    // Right half (50%) - from top to bottom right
    final rightPaint =
        Paint()
          ..color = rightColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = rightStrokeWidth
          ..strokeCap = StrokeCap.butt;

    // Calculate right arc radius to align inner edge
    final rightRadius = innerRadius + (rightStrokeWidth / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: rightRadius),
      1.5708, // 90 degrees (top)
      3.14159, // 180 degrees (half circle)
      false,
      rightPaint,
    );
  }

  void _paintThreeSegment(
    Canvas canvas,
    Offset center,
    double innerRadius,
    Size size,
  ) {
    // Left half (50%) - from top to bottom left with gradient
    final leftGradient = LinearGradient(
      begin: const Alignment(0.50, -0.00),
      end: const Alignment(0.50, 1.00),
      colors: [const Color(0xFF205AEB), const Color(0xFF123385)],
    );

    final leftPaint =
        Paint()
          ..shader = leftGradient.createShader(
            Rect.fromCircle(
              center: center,
              radius: innerRadius + leftStrokeWidth,
            ),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = leftStrokeWidth
          ..strokeCap = StrokeCap.butt;

    // Calculate left arc radius to align inner edge
    final leftRadius = innerRadius + (leftStrokeWidth / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: leftRadius),
      -1.5708, // -90 degrees (top)
      3.14159, // 180 degrees (half circle)
      false,
      leftPaint,
    );

    // Middle segment (15%) - from bottom center
    final middleStrokeWidth =
        (leftStrokeWidth + rightStrokeWidth) / 2; // Between left and right
    final middlePaint =
        Paint()
          ..color = middleColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = middleStrokeWidth
          ..strokeCap = StrokeCap.butt;

    final middleRadius = innerRadius + (middleStrokeWidth / 2);
    final middleAngle =
        (middleProgress * 2 * 3.14159); // Convert percentage to radians

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: middleRadius),
      1.5708, // Start from bottom center (90 degrees)
      middleAngle, // 15% of circle
      false,
      middlePaint,
    );

    // Right half (remaining) - from middle end to top right
    final rightPaint =
        Paint()
          ..color = rightColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = rightStrokeWidth
          ..strokeCap = StrokeCap.butt;

    final rightRadius = innerRadius + (rightStrokeWidth / 2);
    final rightStartAngle = 1.5708 + middleAngle; // Start after middle segment
    final rightSweepAngle = 3.14159 - middleAngle; // Remaining angle

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: rightRadius),
      rightStartAngle,
      rightSweepAngle,
      false,
      rightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
