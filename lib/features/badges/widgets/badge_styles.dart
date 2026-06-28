import 'package:flutter/material.dart';
import 'package:core/core.dart';

class BadgeStyles {
  BadgeStyles._();

  // Text Styles
  static const TextStyle badgeTitle = TextStyle(
    color: Color(0xFF181D27),
    fontSize: 14,
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle badgeDescription = TextStyle(
    color: Color(0xFF414651),
    fontSize: 12,
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle categoryTitle = TextStyle(
    color: Color(0xFF181D27),
    fontSize: 14,
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle headerTitle = TextStyle(
    color: Color(0xFF181D27),
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle headerCountHighlight = TextStyle(
    color: Color(0xFF205AEB),
    fontSize: 14,
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: 0.20,
  );

  static const TextStyle headerCountNormal = TextStyle(
    color: Color(0xFF414651),
    fontSize: 14,
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w400,
    height: 1,
    letterSpacing: 0.20,
  );

  static const TextStyle appBarTitle = TextStyle(
    color: Color(0xFF181D27),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.12,
    letterSpacing: 0.20,
  );

  static TextStyle tabButtonText({required bool isSelected}) {
    return TextStyle(
      color: isSelected ? const Color(0xFFFDFDFD) : AppColors.gray700,
      fontSize: 14,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );
  }

  // Colors
  static const Color dividerColor = Color(0xFFEAEBF5);
  static const Color tabButtonInactive = Color(0xFFEAEBF5);
  static Color get tabButtonActive => Colors.black;
  static Color get cardBackground => Colors.white;
}
