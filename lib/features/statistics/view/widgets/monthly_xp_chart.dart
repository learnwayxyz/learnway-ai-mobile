import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/statistics/models/statistics_model.dart';

class MonthlyXPChart extends StatelessWidget {
  final String title;
  final List<MonthlyXPData> monthlyData;
  final double totalXP;
  final double maxXP;

  const MonthlyXPChart({
    super.key,
    required this.title,
    required this.monthlyData,
    required this.totalXP,
    required this.maxXP,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 307,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Stack(
        children: [
          // Icon button
          Positioned(
            left: 305,
            top: 28,
            child: Container(
              width: 33,
              height: 33,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF4F7FE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 5,
                    top: 5,
                    child: SvgPicture.asset(
                      'assets/icons/bar_chart.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bar 1 - Jan
          Positioned(
            left: 18,
            top: 197.37,
            child: Container(
              width: 17.97,
              height: 48.63,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 2 - Feb
          Positioned(
            left: 46.76,
            top: 126.93,
            child: Container(
              width: 17.97,
              height: 119.07,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 3 - Mar
          Positioned(
            left: 75.52,
            top: 163.83,
            child: Container(
              width: 17.97,
              height: 82.17,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 4 - Apr
          Positioned(
            left: 104.27,
            top: 152.09,
            child: Container(
              width: 17.97,
              height: 93.91,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 5 - May
          Positioned(
            left: 133.03,
            top: 170.53,
            child: Container(
              width: 17.97,
              height: 75.47,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 6 - Jun (highest - blue)
          Positioned(
            left: 161.79,
            top: 111,
            child: Container(
              width: 17.97,
              height: 135,
              decoration: ShapeDecoration(
                color: const Color(0xFF205AEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 7 - Jul
          Positioned(
            left: 190.55,
            top: 180.60,
            child: Container(
              width: 17.97,
              height: 65.40,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 8 - Aug
          Positioned(
            left: 219.30,
            top: 126.93,
            child: Container(
              width: 17.97,
              height: 119.07,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 9 - Sep
          Positioned(
            left: 248.06,
            top: 213.30,
            child: Container(
              width: 17.97,
              height: 32.70,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 10 - Oct
          Positioned(
            left: 276.82,
            top: 152.09,
            child: Container(
              width: 17.97,
              height: 93.91,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 11 - Nov
          Positioned(
            left: 305.58,
            top: 193.17,
            child: Container(
              width: 17.97,
              height: 52.83,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Bar 12 - Dec
          Positioned(
            left: 334.34,
            top: 163.83,
            child: Container(
              width: 17.97,
              height: 82.17,
              decoration: ShapeDecoration(
                color: const Color(0xFFE9EDF7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Horizontal dotted line
          Positioned(
            left: 17.98,
            top: 110.67,
            child: Container(
              width: 287.01,
              height: 0.31,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: const Color(0xFF205AEB),
                  ),
                ),
              ),
            ),
          ),
          // XP label
          Positioned(
            left: 310,
            top: 101,
            child: SizedBox(
              width: 42,
              height: 19,
              child: Text(
                '1,179 XP',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color(0xFF205AEB),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.67,
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),
          // Month labels
          Positioned(
            left: 17.47,
            top: 260.73,
            child: SizedBox(
              width: 330.62,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildMonthLabel('Jan', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Feb', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Mar', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Apr', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('May', 24),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Jun', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Jul', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Aug', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Sep', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Oct', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Nov', 22),
                    const SizedBox(width: 6.50),
                    _buildMonthLabel('Dec', 22),
                  ],
                ),
              ),
            ),
          ),
          // Title
          Positioned(
            left: 30.30,
            top: 32,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: const Color(0xFF535861),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: 0.20,
              ),
            ),
          ),
          // Total XP value
          Positioned(
            left: 31,
            top: 53,
            child: SizedBox(
              width: 171,
              child: Text(
                '415',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color(0xFF181D27),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthLabel(String month, double width) {
    return SizedBox(
      width: width,
      height: 19,
      child: Text(
        month,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: const Color(0xFFA3AED0),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.67,
          letterSpacing: -0.24,
        ),
      ),
    );
  }
}
