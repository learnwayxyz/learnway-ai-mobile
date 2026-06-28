import 'dart:math' as math;

import 'package:learnwayv2/app/app_barrel.dart';

class ContentProgressTracker extends StatelessWidget {
  const ContentProgressTracker({
    super.key,
    required this.totalItems,
    required this.currentItem,
    this.onItemTap,
    this.showLabels = true,
    this.prefix,
    this.inactiveHeight = 3.0,
    this.activeHeight = 5.0,
    this.activeColor = const Color(0xFF205AEB),
    this.inactiveColor = const Color(0xff414651),
    this.labelTextStyle,
    this.spacing = 12.0,
    this.isInteractive = true,
  }) : assert(
         currentItem >= 0 && currentItem < totalItems,
         'currentItem must be between 0 and totalItems-1',
       );

  final int totalItems;
  final int currentItem;
  final Function(int)? onItemTap;
  final bool showLabels;
  final String? prefix;
  final double inactiveHeight;
  final double activeHeight;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? labelTextStyle;
  final double spacing;
  final bool isInteractive;

  @override
  Widget build(BuildContext context) {
    final double availableSpace = MediaQuery.of(context).size.width - 32;
    final double textSpace = showLabels ? 80 : 0;
    final double trackerSpace = availableSpace - textSpace;
    if (totalItems == 1) {
      return Row(
        children: [
          if (showLabels) ...[
            Text(
              '1',
              style: labelTextStyle ?? AppTextStyles.mdSemiBold(context),
            ),
            SizedBox(width: spacing),
          ],
          Expanded(
            child: Container(
              height: activeHeight,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          if (showLabels) ...[SizedBox(width: spacing)],
        ],
      );
    }

    final double barWidth = math.min(
      50,
      (trackerSpace - (totalItems - 1) * 8) / totalItems,
    );

    return Row(
      children: [
        if (showLabels) ...[
          Text(
            '${prefix ?? ''}${currentItem + 1}',
            style: labelTextStyle ?? AppTextStyles.mdSemiBold(context),
          ),
          SizedBox(width: spacing),
        ],
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalItems, (index) {
              final bool isActive = currentItem == index;

              Widget progressBar = AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: barWidth,
                height: isActive ? activeHeight : inactiveHeight,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
              if (isInteractive && onItemTap != null) {
                return GestureDetector(
                  onTap: () => onItemTap!(index),
                  child: progressBar,
                );
              }

              return progressBar;
            }),
          ),
        ),
        if (showLabels) ...[
          SizedBox(width: spacing),
          Text(
            '$totalItems',
            style: labelTextStyle ?? AppTextStyles.mdSemiBold(context),
          ),
        ],
      ],
    );
  }
}
