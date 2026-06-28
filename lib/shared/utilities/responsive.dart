import 'package:flutter/material.dart';
import 'package:learnwayv2/shared/enums/enums.dart';

class ResponsiveInfo {
  final ScreenSize screenSize;
  final double screenWidth;
  final double screenHeight;
  final bool isPortrait;
  final bool isTablet;
  final bool isDesktop;
  final double scaleFactor;

  const ResponsiveInfo({
    required this.screenSize,
    required this.screenWidth,
    required this.screenHeight,
    required this.isPortrait,
    required this.isTablet,
    required this.isDesktop,
    required this.scaleFactor,
  });

  EdgeInsets get responsivePadding {
    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ScreenSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ScreenSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
      case ScreenSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
  }

  EdgeInsets get responsiveMargin {
    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.symmetric(horizontal: 8);
      case ScreenSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ScreenSize.large:
        return const EdgeInsets.symmetric(horizontal: 24);
      case ScreenSize.xlarge:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  double get responsiveBorderRadius {
    switch (screenSize) {
      case ScreenSize.small:
        return 20.0;
      case ScreenSize.medium:
        return 25.0;
      case ScreenSize.large:
        return 30.0;
      case ScreenSize.xlarge:
        return 35.0;
    }
  }

  double get fontSizeMultiplier {
    switch (screenSize) {
      case ScreenSize.small:
        return 0.85;
      case ScreenSize.medium:
        return 1.0;
      case ScreenSize.large:
        return 1.15;
      case ScreenSize.xlarge:
        return 1.3;
    }
  }

  double get iconSize {
    switch (screenSize) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 18.0;
      case ScreenSize.large:
        return 20.0;
      case ScreenSize.xlarge:
        return 22.0;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo responsiveInfo)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsiveInfo = _getResponsiveInfo(context, constraints);
        return builder(context, responsiveInfo);
      },
    );
  }

  ResponsiveInfo _getResponsiveInfo(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    ScreenSize screenSize;
    if (screenWidth < 600) {
      screenSize = ScreenSize.small;
    } else if (screenWidth < 900) {
      screenSize = ScreenSize.medium;
    } else if (screenWidth < 1200) {
      screenSize = ScreenSize.large;
    } else {
      screenSize = ScreenSize.xlarge;
    }

    final scaleFactor = (screenWidth / 375).clamp(0.8, 2.0);

    return ResponsiveInfo(
      screenSize: screenSize,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      isPortrait: isPortrait,
      isTablet: screenWidth >= 600,
      isDesktop: screenWidth >= 900,
      scaleFactor: scaleFactor,
    );
  }
}

mixin ResponsiveMixin {
  T getResponsiveValue<T>({
    required BuildContext context,
    required T small,
    T? medium,
    T? large,
    T? xlarge,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200 && xlarge != null) return xlarge;
    if (screenWidth >= 900 && large != null) return large;
    if (screenWidth >= 600 && medium != null) return medium;
    return small;
  }

  double getResponsiveDimension(BuildContext context, double baseValue) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = (screenWidth / 375).clamp(0.8, 2.0);
    return baseValue * scaleFactor;
  }

  double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return baseSize * 0.85;
    } else if (screenWidth < 900) {
      return baseSize;
    } else if (screenWidth < 1200) {
      return baseSize * 1.15;
    } else {
      return baseSize * 1.3;
    }
  }
}

class FigmaConverter {
  static const double baseFigmaWidth = 412.0;
  static const double baseFigmaHeight = 917.0;

  static double width(
    BuildContext context,
    double figmaWidth, {
    double? min,
    double? max,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double converted = (figmaWidth * screenWidth) / baseFigmaWidth;

    if (min != null && converted < min) converted = min;
    if (max != null && converted > max) converted = max;

    return converted;
  }

  static double height(
    BuildContext context,
    double figmaHeight, {
    double? min,
    double? max,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    double converted = (figmaHeight * screenHeight) / baseFigmaHeight;

    if (min != null && converted < min) converted = min;
    if (max != null && converted > max) converted = max;

    return converted;
  }

  static double fontSize(
    BuildContext context,
    double figmaFontSize, {
    double? min,
    double? max,
  }) {
    return width(context, figmaFontSize, min: min, max: max);
  }

  static EdgeInsets padding(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: width(context, left),
      top: height(context, top),
      right: width(context, right),
      bottom: height(context, bottom),
    );
  }

  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(context, horizontal),
      vertical: height(context, vertical),
    );
  }
}

int getCrossAxisCount(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 2;
    case ScreenSize.medium:
      return 2;
    case ScreenSize.large:
      return 3;
    case ScreenSize.xlarge:
      return 4;
  }
}

double getCrossAxisSpacing(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 8.0;
    case ScreenSize.medium:
      return 12.0;
    case ScreenSize.large:
      return 16.0;
    case ScreenSize.xlarge:
      return 20.0;
  }
}

double getMainAxisSpacing(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 8.0;
    case ScreenSize.medium:
      return 12.0;
    case ScreenSize.large:
      return 16.0;
    case ScreenSize.xlarge:
      return 20.0;
  }
}

double getChildAspectRatio(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 6 / 6;
    case ScreenSize.medium:
      return 6 / 6.4;
    case ScreenSize.large:
      return 6 / 6.6;
    case ScreenSize.xlarge:
      return 6 / 6.8;
  }
}

double getGridItemHeight(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 180.0;
    case ScreenSize.medium:
      return 220.0;
    case ScreenSize.large:
      return 240.0;
    case ScreenSize.xlarge:
      return 260.0;
  }
}

double getTopPadding(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 16.0;
    case ScreenSize.medium:
      return 20.0;
    case ScreenSize.large:
      return 24.0;
    case ScreenSize.xlarge:
      return 28.0;
  }
}

double getListSpacing(ResponsiveInfo responsiveInfo) {
  switch (responsiveInfo.screenSize) {
    case ScreenSize.small:
      return 12.0;
    case ScreenSize.medium:
      return 16.0;
    case ScreenSize.large:
      return 20.0;
    case ScreenSize.xlarge:
      return 24.0;
  }
}
