import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/features/statistics/view/widgets/circular_progress_chart.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String totalText;
  final String labelText;
  final double progress;
  final Color progressColor;
  final List<StatisticItem> items;
  final Widget? icon;
  final bool isThreeSegment;
  final double middleProgress;
  final Color middleColor;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.totalText,
    required this.labelText,
    required this.progress,
    required this.items,
    this.progressColor = const Color(0xFF215AEB),
    this.icon,
    this.isThreeSegment = false,
    this.middleProgress = 0.0,
    this.middleColor = const Color(0xFF9E77ED),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 338,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
              fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF252B37),
                    letterSpacing: 0.2,
                    height: 1.14, // 16/14
                  ),
                ),
                if (icon != null)
                  Container(
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FE),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(child: icon!),
                  ),
              ],
            ),
            const VSpace(23),
            // Circular chart
            Center(
              child: CircularProgressChart(
                progress: progress,
                totalText: totalText,
                labelText: labelText,
                progressColor: progressColor,
                isThreeSegment: isThreeSegment,
                middleProgress: middleProgress,
                middleColor: middleColor,
              ),
            ),
            // const Spacer(),
            const VSpace(27),
            // Statistics items
            ...items.map((item) => _buildStatisticItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(BuildContext context, StatisticItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 9,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 3),
              Text(
                item.label,
                style: TextStyle(
              fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF535862),
                  letterSpacing: 0.2,
                  height: 1.0, // 14/14
                ),
              ),
            ],
          ),
          Text(
            item.value.toString(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF181D27),
              letterSpacing: -0.28,
              height: 1.14, // 16/14
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticItem {
  final String label;
  final int value;
  final Color color;

  const StatisticItem({
    required this.label,
    required this.value,
    required this.color,
  });
}
