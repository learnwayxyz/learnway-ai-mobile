import 'package:core/core.dart';
import 'package:flutter/material.dart';

class GoalOptionCard extends StatelessWidget {
  const GoalOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = AppColors.primaryColor;
    final borderColor = isSelected
        ? selectedColor
        : (isDark ? AppColors.gray700 : AppColors.gray300);
    final bgColor = isSelected
        ? AppColors.primaryColor.withValues(alpha: 0.08)
        : Colors.transparent;
    final textColor = isSelected
        ? selectedColor
        : (isDark ? Colors.white : AppColors.gray950);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: selectedColor, size: 22),
          ],
        ),
      ),
    );
  }
}
