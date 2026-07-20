import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/app/app.dart';

class ButtonFactory {
  ButtonFactory._();

  static const double _defaultBorderRadius = 60.0;
  static const double _defaultPadding = 16.0;
  static const double _emojiCircleSize = 55.0;

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF111827)
        : Colors.white;
  }

  static Widget whiteButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    TextStyle? style,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
    bool? isLocked,
    bool? hasBorder,
    Color? borderColor,
  }) {
    return _baseButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      height: height,
      textStyle: style,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      hasBorder: hasBorder ?? false,
      borderColor: borderColor ?? Colors.transparent,
    );
  }

  /// New method with Widget support
  static Widget whiteButtonWidget({
    required Widget child,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
    bool? isLocked,
  }) {
    return _baseButton(
      text: '', // Not used when child is provided
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      height: height,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      child: child,
    );
  }

  // OPTION 2: SMART FACTORY APPROACH
  // Single method that handles both String and Widget

  /// Smart factory method - handles both String and Widget
  static Widget whiteButtonSmart({
    String? text,
    Widget? child,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    TextStyle? style,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
    bool? isLocked,
  }) {
    assert(
      (text != null && child == null) || (text == null && child != null),
      'Provide either text or child, not both',
    );

    return _baseButton(
      text: text ?? '',
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      height: height,
      textStyle: style,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      child: child,
    );
  }

  /// @deprecated Use [whiteButtonV2] instead for better flexibility
  @Deprecated('Use whiteButtonV2 for Widget support. Will be removed in v2.0.0')
  static Widget whiteButtonLegacy({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    TextStyle? style,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
    bool? isLocked,
  }) {
    return whiteButtonV2(
      child: Text(
        text,
        style:
            style ??
            AppTextStyles.base(
              appRouter.navigatorKey.currentContext!,
              color: Colors.black,
            ),
      ),
      onPressed: onPressed,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      height: height,
      mainAxisAlignment: mainAxisAlignment,
      padding: padding,
      isLocked: isLocked,
    );
  }

  /// New flexible version with Widget support
  static Widget whiteButtonV2({
    required Widget child,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
    bool? isLocked,
  }) {
    return _baseButton(
      text: '', // Not used when child is provided
      onPressed: onPressed,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      height: height,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      child: child,
    );
  }

  // Update other button methods to support Widget as well
  static Widget primaryButton({
    String? text,
    Widget? child,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    MainAxisAlignment? mainAxisAlignment,
    EdgeInsets? padding,
  }) {
    assert(
      (text != null && child == null) || (text == null && child != null),
      'Provide either text or child, not both',
    );

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return _baseButton(
          text: text ?? '',
          mainAxisAlignment: mainAxisAlignment,
          onPressed: onPressed,
          backgroundColor: theme.brightness == Brightness.dark
              ? theme.colorScheme.primary
              : AppColors.activeButtonColor,
          textColor: Colors.white,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
          child: child,
        );
      },
    );
  }

  static Widget blackButton({
    String? text,
    Widget? child,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    EdgeInsets? padding,
    Color? backgroundColor,
    MainAxisAlignment? mainAxisAlignment,
    TextStyle? textStyle,
    Color? borderColor,
    bool? hasBorder,
  }) {
    assert(
      (text != null && child == null) || (text == null && child != null),
      'Provide either text or child, not both',
    );

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        final buttonColor =
            backgroundColor ??
            (isDarkMode
                ? const Color(0xFFE5E7EB)
                : AppColors.activeButtonColor);

        final textColor = isDarkMode ? Colors.black : Colors.white;

        return _baseButton(
          text: text ?? '',
          onPressed: onPressed,
          backgroundColor: buttonColor,
          textColor: textColor,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
          borderColor: borderColor ?? Colors.transparent,
          hasBorder: hasBorder ?? false,
          padding: padding,
          mainAxisAlignment: mainAxisAlignment,
          textStyle: textStyle,
          child: child,
        );
      },
    );
  }

  // Keep existing methods unchanged for backward compatibility
  static Widget grayButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    MainAxisAlignment? mainAxisAlignment,
    double? height,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final buttonColor = isDarkMode
            ? const Color(0xFF374151)
            : AppColors.inactiveButtonColor;

        final textColor = isDarkMode ? Colors.white : Colors.black87;

        return _baseButton(
          text: text,
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          onPressed: onPressed,
          backgroundColor: buttonColor,
          textColor: textColor,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
        );
      },
    );
  }

  static Widget dangerButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final buttonColor = theme.brightness == Brightness.dark
            ? theme.colorScheme.error
            : AppColors.errorColor;

        return _baseButton(
          text: text,
          onPressed: onPressed,
          backgroundColor: buttonColor,
          textColor: Colors.white,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
        );
      },
    );
  }

  static Widget disabledButton({
    required String text,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final buttonColor = isDarkMode
            ? const Color(0xFF374151)
            : AppColors.inactiveButtonColor;

        final textColor = isDarkMode
            ? Colors.white.withOpacity(0.5)
            : Colors.black38;

        return _baseButton(
          mainAxisAlignment: MainAxisAlignment.center,
          text: text,
          onPressed: null,
          backgroundColor: buttonColor,
          textColor: textColor,
          isLoading: false,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
        );
      },
    );
  }

  static Widget outlinedButton({
    required String text,
    required VoidCallback onPressed,
    Color borderColor = Colors.black,
    Color textColor = Colors.black,
    bool isLoading = false,
    bool isFullWidth = true,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    EdgeInsets? padding,
    double? trailingSpace,
    double? leadingSpace,
    bool useAutoSpace = false,
    TextStyle? textStyle,
    MainAxisAlignment? mainAxisAlignment,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final buttonBorderColor = isDarkMode ? Colors.white : borderColor;
        final buttonTextColor = isDarkMode ? Colors.white : textColor;

        return _baseButton(
          text: text,
          onPressed: onPressed,
          backgroundColor: Colors.transparent,
          textColor: buttonTextColor,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          height: height,
          hasBorder: true,
          borderColor: buttonBorderColor,
          padding: padding,
          trailingSpace: trailingSpace,
          leadingSpace: leadingSpace,
          useAutoSpace: useAutoSpace,
          mainAxisAlignment: mainAxisAlignment,
          textStyle:
              textStyle ??
              AppTextStyles.base(
                appRouter.navigatorKey.currentContext!,
                color: buttonTextColor,
              ),
        );
      },
    );
  }

  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    Color textColor = Colors.black,
    bool isLoading = false,
    Widget? leadingIcon,
    Widget? trailingIcon,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final buttonTextColor = isDarkMode ? Colors.white : textColor;

        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: buttonTextColor,
            padding: const EdgeInsets.symmetric(
              horizontal: _defaultPadding,
              vertical: _defaultPadding / 2,
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : _buildButtonContent(
                  text: text,
                  textColor: buttonTextColor,
                  leadingIcon: leadingIcon,
                  trailingIcon: trailingIcon,
                ),
        );
      },
    );
  }

  static Widget outlinedEmojiButton({
    required String emoji,
    required String text,
    required VoidCallback onPressed,
    Color borderColor = Colors.black,
    Color textColor = Colors.black,
    bool isLoading = false,
    bool isFullWidth = true,
    double? height,
    double? padding,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final buttonBackgroundColor = isDarkMode
            ? const Color(0xFF1F2937)
            : Colors.white;
        final buttonBorderColor = isDarkMode ? Colors.white : borderColor;
        final buttonTextColor = isDarkMode ? Colors.white : textColor;
        final circleColor = isDarkMode
            ? Theme.of(context).colorScheme.primary
            : Colors.black;

        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
            foregroundColor: buttonTextColor,
            disabledForegroundColor: Colors.grey.withAlpha(97),
            disabledBackgroundColor: Colors.grey.withAlpha(31),
            padding: const EdgeInsets.only(
              left: 25,
              top: 5,
              right: 5,
              bottom: 5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_defaultBorderRadius),
              side: BorderSide(color: buttonBorderColor),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  children: [
                    Text(
                      text,
                      style: AppTextStyles.base(
                        appRouter.navigatorKey.currentContext!,
                        color: buttonTextColor,
                      ),
                    ),
                    Container(
                      width: _emojiCircleSize,
                      height: _emojiCircleSize,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: AppTextStyles.md(
                            appRouter.navigatorKey.currentContext!,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  static Widget iconCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.black,
    Color iconColor = Colors.white,
    double size = 48.0,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final buttonBackgroundColor = isDarkMode
            ? Theme.of(context).colorScheme.primary
            : backgroundColor;

        return InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: buttonBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: size / 2),
          ),
        );
      },
    );
  }

  static Widget _baseButton({
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    required bool isLoading,
    required bool isFullWidth,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? height,
    bool hasBorder = false,
    Color borderColor = Colors.transparent,
    EdgeInsets? padding,
    double? trailingSpace,
    double? leadingSpace,
    bool useAutoSpace = false,
    TextStyle? textStyle,
    MainAxisAlignment? mainAxisAlignment,
    Widget? child,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        disabledForegroundColor: Colors.grey.withValues(alpha: 0.38),
        disabledBackgroundColor: Colors.grey.withValues(alpha: 0.12),
        padding: padding ?? const EdgeInsets.all(_defaultPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_defaultBorderRadius),
          side: hasBorder ? BorderSide(color: borderColor) : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: isLoading
          ? Center(
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : _buildButtonContent(
              text: text,
              textColor: textColor,
              leadingIcon: leadingIcon,
              trailingIcon: trailingIcon,
              trialingSpacing: trailingSpace,
              leadingSpacing: leadingSpace,
              useAutoSpace: useAutoSpace,
              textStyle: textStyle,
              mainAxisAlignment: mainAxisAlignment,
              child: child,
            ),
    );
  }

  static Widget _buildButtonContent({
    required String text,
    required Color textColor,
    Widget? leadingIcon,
    Widget? trailingIcon,
    double? trialingSpacing,
    double? leadingSpacing,
    bool useAutoSpace = false,
    TextStyle? textStyle,
    MainAxisAlignment? mainAxisAlignment,
    Widget? child,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        if (trailingIcon != null) ...[trailingIcon],
        HSpace(trailingIcon != null ? trialingSpacing ?? 8 : 0),
        child ??
            Text(
              text,
              style:
                  textStyle ??
                  AppTextStyles.base(
                    appRouter.navigatorKey.currentContext!,
                    color: textColor,
                  ),
            ),
        useAutoSpace ? const Spacer() : const SizedBox(width: 0),
        HSpace(leadingIcon != null ? leadingSpacing ?? 8 : 0),
        if (leadingIcon != null) ...[leadingIcon],
      ],
    );
  }
}
