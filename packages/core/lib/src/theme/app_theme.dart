import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Color system from the LearnWay design
  static const Color _primary100 = Color(0xFF2563EB); // Blue 700
  static const Color _primary80 = Color(0xFF3B82F6); // Blue 500
  static const Color _primary60 = Color(0xFF60A5FA); // Blue 400
  static const Color _primary40 = Color(0xFF93C5FD); // Blue 300
  static const Color _primary20 = Color(0xFFBFDBFE); // Blue 200

  // Gray scale
  static const Color _gray100 = Color(0xFF111827); // Gray 900
  static const Color _gray80 = Color(0xFF1F2937); // Gray 800
  static const Color _gray70 = Color(0xFF374151); // Gray 700
  static const Color _gray60 = Color(0xFF4B5563); // Gray 600
  static const Color _gray50 = Color(0xFFF8F9FC); // Gray 500
  static const Color _gray40 = Color(0xFF9CA3AF); // Gray 400
  static const Color _gray30 = Color(0xFFD1D5DB); // Gray 300
  static const Color _gray20 = Color(0xFFE5E7EB); // Gray 200
  static const Color _gray10 = Color(0xFFF3F4F6); // Gray 100
  static const Color _gray5 = Color(0xFFF9FAFB); // Gray 50

  // Success colors (Green)
  static const Color _success100 = Color(0xFF10B981); // From the image (500)
  static const Color _success80 = Color(0xFF34D399); // From the image (400)
  static const Color _success20 = Color(0xFFA7F3D0); // From the image (200)
  static const Color _success25 = Color(0xfff5fef9);

  // Error colors (Red)
  static const Color _error100 = Color(0xFFEF4444); // From the image (500)
  static const Color _error80 = Color(0xFFF87171); // From the image (400)
  static const Color _error60 = Color(0xFFFCA5A5); // From the image (300)
  static const Color _error20 = Color(0xFFFECACA); // From the image (200)

  // Information colors (Light Blue)
  static const Color _info100 = Color(0xFF0EA5E9); // From the image (500)
  static const Color _info80 = Color(0xFF38BDF8); // From the image (400)
  static const Color _info20 = Color(0xFFBAE6FD); // From the image (200)

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _primary100,
      onPrimary: Colors.white,
      primaryContainer: _primary20,
      onPrimaryContainer: _primary100,
      secondary: _info100,
      onSecondary: Colors.white,
      secondaryContainer: _info20,
      onSecondaryContainer: _info100,
      tertiary: _success100,
      onTertiary: Colors.white,
      tertiaryContainer: _success20,
      onTertiaryContainer: _success100,
      error: _error100,
      onError: Colors.white,
      errorContainer: _error20,
      onErrorContainer: _error100,
      surface: _gray5,
      onSurface: _gray100,
      onSurfaceVariant: _gray70,
      outline: _gray30,
      outlineVariant: _gray20,
      shadow: _gray100.withValues(alpha: 0.1),
      scrim: _gray100.withValues(alpha: 0.3),
      inverseSurface: _gray90,
      onInverseSurface: _gray10,
      inversePrimary: _primary40,
      surfaceTint: _primary20.withValues(alpha: 0.3),
    ),
    scaffoldBackgroundColor: _gray50,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: _gray100,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: _gray100.withValues(alpha: 0.1),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary100,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primary100,
        side: BorderSide(color: _primary100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primary100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _gray5,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primary80, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _error100, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _error100, width: 1.5),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: _gray50,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        fontFamily: 'Poppins',
        color: _error100,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _gray900,
      selectedItemColor: _primary100,
      unselectedItemColor: _gray50,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    dividerTheme: DividerThemeData(color: _gray20, thickness: 1, space: 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: _gray100,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: _gray100,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _gray100,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: _gray80,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _gray70,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _gray60,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _primary100,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _gray80,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _gray60,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _gray90,
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: _primary100,
      unselectedLabelColor: _gray50,
      indicatorColor: _primary100,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _gray100,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _gray70,
      ),
    ),
  );

  // Special gray for dark theme
  static const Color _gray90 = Color(0xFF0A0D12);

  static const Color _gray950 = Color(0xFF252B37);
  static const Color _gray900 = Color(0xFF181D27);
  static const Color _gray800 = Color(0xFF252B37);

  // DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _primary80,
      onPrimary: Colors.white,
      primaryContainer: _primary100.withValues(alpha: 0.2),
      onPrimaryContainer: _primary40,
      secondary: _info80,
      onSecondary: Colors.white,
      secondaryContainer: _info100.withValues(alpha: 0.2),
      onSecondaryContainer: _info80,
      tertiary: _success80,
      onTertiary: Colors.white,
      tertiaryContainer: _success100.withValues(alpha: 0.2),
      onTertiaryContainer: _success80,
      error: _error80,
      onError: Colors.white,
      errorContainer: _error100.withValues(alpha: 0.2),
      onErrorContainer: _error60,
      surface: _gray80,
      onSurface: Colors.white,
      onSurfaceVariant: _gray30,
      outline: _gray60,
      outlineVariant: _gray70,
      shadow: Colors.black.withValues(alpha: 0.3),
      scrim: Colors.black.withValues(alpha: 0.7),
      inverseSurface: Colors.white,
      onInverseSurface: _gray90,
      inversePrimary: _primary100,
      surfaceTint: _primary80.withValues(alpha: 0.1),
    ),
    scaffoldBackgroundColor: _gray90,
    appBarTheme: AppBarTheme(
      backgroundColor: _gray950,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
    ),
    cardTheme: CardThemeData(
      color: _gray900,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary80,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primary60,
        side: BorderSide(color: _primary60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primary60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _gray70,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primary60, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _error80, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _error80, width: 1.5),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: _gray40,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: TextStyle(
        fontFamily: 'Poppins',
        color: _error60,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _gray80,
      selectedItemColor: _primary60,
      unselectedItemColor: _gray40,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    dividerTheme: DividerThemeData(color: _gray70, thickness: 1, space: 1),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: _gray30,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _gray40,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _gray40,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _primary60,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _gray30,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _gray40,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _gray70,
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: _primary60,
      unselectedLabelColor: _gray40,
      indicatorColor: _primary60,
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _gray80,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _gray30,
      ),
    ),
  );
}
