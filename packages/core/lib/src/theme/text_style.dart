import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Base font sizes (these will be scaled)
  static const double _xsSize = 12.0;
  static const double _smSize = 14.0;
  static const double _baseSize = 16.0;
  static const double _mdSize = 18.0;
  static const double _lgSize = 20.0;
  static const double _xlSize = 24.0;
  static const double _xxlSize = 30.0;

  // Font weights
  static const FontWeight _light = FontWeight.w300;
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;
  static const FontWeight _extraBold = FontWeight.w800;

  // Line heights
  static const double _tightHeight = 1.25;
  static const double _normalHeight = 1.5;

  // Screen size breakpoints
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;

  // Scale factors for different screen sizes
  static const double _mobileScale = 0.9;
  static const double _tabletScale = 1.0;
  static const double _desktopScale = 1.1;
  static const double _largeDesktopScale = 1.2;

  /// Get the appropriate scale factor based on screen width
  static double _getScaleFactor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < _mobileBreakpoint) {
      return _mobileScale;
    } else if (screenWidth < _tabletBreakpoint) {
      return _tabletScale;
    } else if (screenWidth < _desktopBreakpoint) {
      return _desktopScale;
    } else {
      return _largeDesktopScale;
    }
  }

  /// Scale a font size based on screen size
  static double _scaleFontSize(BuildContext context, double fontSize) {
    final scaleFactor = _getScaleFactor(context);
    return fontSize * scaleFactor;
  }

  /// Alternative method using MediaQuery.textScaleFactorOf for accessibility
  static double _getAccessibleFontSize(BuildContext context, double fontSize) {
    final scaleFactor = _getScaleFactor(context);
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);

    // Combine responsive scaling with accessibility scaling
    // Clamp the total scale to prevent text from becoming too large
    final totalScale = (scaleFactor * textScaleFactor).clamp(0.8, 2.0);
    return fontSize * totalScale;
  }

  // Base text style generator that pulls colors from the theme and applies scaling
  static TextStyle _baseStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
    bool useAccessibleScaling = true,
  }) {
    final theme = Theme.of(context);

    // Apply responsive scaling to font size
    final scaledFontSize = fontSize != null
        ? (useAccessibleScaling
              ? _getAccessibleFontSize(context, fontSize)
              : _scaleFontSize(context, fontSize))
        : null;

    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: scaledFontSize,
      fontWeight: fontWeight ?? _regular,
      color: color ?? theme.colorScheme.onSurface,
      height: height ?? _normalHeight,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  // Extra Small (12px)
  static TextStyle xs(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _xsSize, fontWeight: weight, color: color);

  static TextStyle xsRegular(BuildContext context, {Color? color}) => xs(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xsMedium(BuildContext context, {Color? color}) => xs(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xsSemiBold(BuildContext context, {Color? color}) => xs(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Small (14px)
  static TextStyle sm(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _smSize, fontWeight: weight, color: color);

  static TextStyle smRegular(BuildContext context, {Color? color}) => sm(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle smMedium(BuildContext context, {Color? color}) => sm(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle smSemiBold(BuildContext context, {Color? color}) => sm(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle smBold(BuildContext context, {Color? color}) => sm(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Base (16px)
  static TextStyle base(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) => _baseStyle(
    context,
    fontSize: _baseSize,
    fontWeight: weight,
    color: color,
  );

  static TextStyle baseLight(BuildContext context, {Color? color}) => base(
    context,
    weight: _light,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle baseRegular(BuildContext context, {Color? color}) => base(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle baseMedium(BuildContext context, {Color? color}) => base(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle baseSemiBold(BuildContext context, {Color? color}) => base(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle baseBold(BuildContext context, {Color? color}) => base(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle baseExtraBold(BuildContext context, {Color? color}) => base(
    context,
    weight: _extraBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Medium (18px)
  static TextStyle md(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _mdSize, fontWeight: weight, color: color);

  static TextStyle mdRegular(BuildContext context, {Color? color}) => md(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle mdMedium(BuildContext context, {Color? color}) => md(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle mdSemiBold(BuildContext context, {Color? color}) => md(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle mdBold(BuildContext context, {Color? color}) => md(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Large (20px)
  static TextStyle lg(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _lgSize, fontWeight: weight, color: color);

  static TextStyle lgRegular(BuildContext context, {Color? color}) => lg(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle lgMedium(BuildContext context, {Color? color}) => lg(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle lgSemiBold(BuildContext context, {Color? color}) => lg(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle lgBold(BuildContext context, {Color? color}) => lg(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Extra Large (24px)
  static TextStyle xl(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _xlSize, fontWeight: weight, color: color);

  static TextStyle xlRegular(BuildContext context, {Color? color}) => xl(
    context,
    weight: _regular,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xlMedium(BuildContext context, {Color? color}) => xl(
    context,
    weight: _medium,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xlSemiBold(BuildContext context, {Color? color}) => xl(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xlBold(BuildContext context, {Color? color}) => xl(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // 2XL (30px)
  static TextStyle xxl(
    BuildContext context, {
    FontWeight? weight,
    Color? color,
  }) =>
      _baseStyle(context, fontSize: _xxlSize, fontWeight: weight, color: color);

  static TextStyle xxlBold(BuildContext context, {Color? color}) => xxl(
    context,
    weight: _bold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xxlSemiBold(BuildContext context, {Color? color}) => xxl(
    context,
    weight: _semiBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle xxlExtraBold(BuildContext context, {Color? color}) => xxl(
    context,
    weight: _extraBold,
    color: color ?? Theme.of(context).colorScheme.onSurface,
  );

  // Semantic text styles with responsive scaling

  /// Caption style for small descriptive text
  static TextStyle caption(BuildContext context) => _baseStyle(
    context,
    fontSize: _xsSize,
    fontWeight: _regular,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: _tightHeight,
  );

  /// Hyperlink style
  static TextStyle link(BuildContext context) => _baseStyle(
    context,
    fontSize: _baseSize,
    fontWeight: _semiBold,
    color: Theme.of(context).colorScheme.primary,
    decoration: TextDecoration.underline,
  );

  /// Primary button text style
  static TextStyle buttonText(BuildContext context) => _baseStyle(
    context,
    fontSize: _baseSize,
    fontWeight: _semiBold,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  /// Text style for section headers
  static TextStyle sectionHeader(BuildContext context) => _baseStyle(
    context,
    fontSize: _mdSize,
    fontWeight: _bold,
    color: Theme.of(context).colorScheme.onSurface,
    letterSpacing: 0.5,
  );

  /// Style for secondary/muted text
  static TextStyle secondary(BuildContext context) => _baseStyle(
    context,
    fontSize: _baseSize,
    fontWeight: _regular,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  /// Error text style
  static TextStyle error(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.error,
  );

  /// Success text style
  static TextStyle success(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.tertiary,
  );

  /// Warning text style
  static TextStyle warning(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Color(0xFFF59E0B),
  );

  /// Info text style
  static TextStyle info(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.secondary,
  );

  /// Headline style for page titles
  static TextStyle headline(BuildContext context) => _baseStyle(
    context,
    fontSize: _xxlSize,
    fontWeight: _bold,
    color: Theme.of(context).colorScheme.onSurface,
    height: _tightHeight,
    letterSpacing: -0.5,
  );

  /// Subheadline style for subtitles
  static TextStyle subheadline(BuildContext context) => _baseStyle(
    context,
    fontSize: _lgSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    height: _tightHeight,
  );

  /// Style for card titles
  static TextStyle cardTitle(BuildContext context) => _baseStyle(
    context,
    fontSize: _mdSize,
    fontWeight: _semiBold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  /// Style for card subtitles
  static TextStyle cardSubtitle(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  /// Style for form labels
  static TextStyle formLabel(BuildContext context) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: _medium,
    color: Theme.of(context).colorScheme.onSurface,
    letterSpacing: 0.25,
  );

  /// Style for form hints
  static TextStyle formHint(BuildContext context) => _baseStyle(
    context,
    fontSize: _xsSize,
    fontWeight: _regular,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );

  /// Style for badges or tags
  static TextStyle badge(BuildContext context) => _baseStyle(
    context,
    fontSize: _xsSize,
    fontWeight: _semiBold,
    color: Theme.of(context).colorScheme.onPrimaryContainer,
    height: _tightHeight,
  );

  /// Style for navigation items
  static TextStyle navigationItem(
    BuildContext context, {
    bool isSelected = false,
  }) => _baseStyle(
    context,
    fontSize: _smSize,
    fontWeight: isSelected ? _semiBold : _medium,
    color: isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant,
  );

  // Utility methods for responsive design

  /// Check if the current screen is mobile sized
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  /// Check if the current screen is tablet sized
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _desktopBreakpoint;
  }

  /// Check if the current screen is desktop sized
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _desktopBreakpoint;
  }

  /// Get the current screen size category as a string
  static String getScreenSizeCategory(BuildContext context) {
    if (isMobile(context)) return 'mobile';
    if (isTablet(context)) return 'tablet';
    return 'desktop';
  }

  // Extension of Material Theme Text Styles (these will also be responsive)

  /// Maps to the theme's titleLarge style with responsive scaling
  static TextStyle titleLarge(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.titleLarge!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 22.0),
    );
  }

  /// Maps to the theme's titleMedium style with responsive scaling
  static TextStyle titleMedium(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.titleMedium!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 16.0),
    );
  }

  /// Maps to the theme's titleSmall style with responsive scaling
  static TextStyle titleSmall(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.titleSmall!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 14.0),
    );
  }

  /// Maps to the theme's bodyLarge style with responsive scaling
  static TextStyle bodyLarge(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.bodyLarge!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 16.0),
    );
  }

  /// Maps to the theme's bodyMedium style with responsive scaling
  static TextStyle bodyMedium(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.bodyMedium!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 14.0),
    );
  }

  /// Maps to the theme's bodySmall style with responsive scaling
  static TextStyle bodySmall(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.bodySmall!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 12.0),
    );
  }

  /// Maps to the theme's labelLarge style with responsive scaling
  static TextStyle labelLarge(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.labelLarge!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 14.0),
    );
  }

  /// Maps to the theme's labelMedium style with responsive scaling
  static TextStyle labelMedium(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.labelMedium!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 12.0),
    );
  }

  /// Maps to the theme's labelSmall style with responsive scaling
  static TextStyle labelSmall(BuildContext context) {
    final originalStyle = Theme.of(context).textTheme.labelSmall!;
    return originalStyle.copyWith(
      fontSize: _scaleFontSize(context, originalStyle.fontSize ?? 11.0),
    );
  }
}
