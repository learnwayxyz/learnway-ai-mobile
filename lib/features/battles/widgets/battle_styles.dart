import 'package:flutter/material.dart';
import 'package:core/core.dart';

class BattleStyles {
  BattleStyles._();

  // Text Styles
  static TextStyle get appBarTitle => TextStyle(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.12,
        letterSpacing: 0.20,
      );

  // Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get historyCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Divider
  static Widget get divider => Container(
        height: 1,
        color: AppColors.borderColor,
      );
}
