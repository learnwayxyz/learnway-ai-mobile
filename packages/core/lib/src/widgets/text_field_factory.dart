import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

/// Configuration class for AppTextField styling and behavior
class TextFieldConfig {
  const TextFieldConfig({
    this.suffixIcon,
    this.onChanged,
    this.hintText,
    this.validator,
    this.autovalidateMode,
    this.errorText,
    this.maxLines,
    this.textAlign,
    this.textAlignVertical,
    this.contentPadding,
    this.hintTextStyle,
    this.fontStyle,
    this.prefixIcon,
    this.focusNode,
    this.keyboardType,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.inputFormatters,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.borderRadius,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.isDense = false,
    this.enabled = true,
    this.maxLength,
  });

  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? hintText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final String? errorText;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintTextStyle;
  final TextStyle? fontStyle;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Color? errorBorderColor;
  final Color? focusedErrorBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool readOnly;
  final bool isDense;
  final void Function()? onTap;
  final bool enabled;
  final int? maxLength;

  TextFieldConfig copyWith({
    Widget? suffixIcon,
    void Function(String)? onChanged,
    String? hintText,
    String? Function(String?)? validator,
    AutovalidateMode? autovalidateMode,
    String? errorText,
    int? maxLines,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    Widget? prefixIcon,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? errorBorderColor,
    Color? focusedErrorBorderColor,
    List<TextInputFormatter>? inputFormatters,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
    Color? fillColor,
    BorderRadius? borderRadius,
    BorderRadius? enabledBorderRadius,
    BorderRadius? focusedBorderRadius,
    bool? obscureText,
    bool? readOnly,
    void Function()? onTap,
    TextCapitalization? textCapitalization,
    bool? isDense,
    bool? enabled,
    int? maxLength,
  }) {
    return TextFieldConfig(
      suffixIcon: suffixIcon ?? this.suffixIcon,
      onChanged: onChanged ?? this.onChanged,
      hintText: hintText ?? this.hintText,
      validator: validator ?? this.validator,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      errorText: errorText ?? this.errorText,
      maxLines: maxLines ?? this.maxLines,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      contentPadding: contentPadding ?? this.contentPadding,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      fontStyle: fontStyle ?? this.fontStyle,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      focusNode: focusNode ?? this.focusNode,
      keyboardType: keyboardType ?? this.keyboardType,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      focusedErrorBorderColor:
          focusedErrorBorderColor ?? this.focusedErrorBorderColor,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      enabledBorderColor: enabledBorderColor ?? this.enabledBorderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      fillColor: fillColor ?? this.fillColor,
      borderRadius: borderRadius ?? this.borderRadius,
      enabledBorderRadius: enabledBorderRadius ?? this.enabledBorderRadius,
      focusedBorderRadius: focusedBorderRadius ?? this.focusedBorderRadius,
      obscureText: obscureText ?? this.obscureText,
      readOnly: readOnly ?? this.readOnly,
      onTap: onTap ?? this.onTap,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      isDense: isDense ?? this.isDense,
      enabled: enabled ?? this.enabled,
      maxLength: maxLength ?? this.maxLength,
    );
  }
}

/// Factory class for creating pre-configured text fields
abstract class TextFieldFactory {
  const TextFieldFactory._();

  /// Creates an amount input field with decimal formatting
  static AppTextField amount({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
    int maxDecimalPlaces = 2,
  }) {
    final amountFormatters = [
      FilteringTextInputFormatter.allow(
        RegExp(r'^\d*\.?\d{0,' + maxDecimalPlaces.toString() + r'}'),
      ),
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        if (text.split('.').length > 2) {
          return oldValue;
        }
        return newValue;
      }),
    ];

    return AppTextField(
      controller: controller,
      config: config.copyWith(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: amountFormatters,
        textAlign: config.textAlign ?? TextAlign.start,
      ),
    );
  }

  static AppTextField phone({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
  }) {
    return AppTextField(
      controller: controller,
      config: config.copyWith(
        keyboardType: config.keyboardType ?? TextInputType.phone,
        inputFormatters:
            config.inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  static AppTextField name({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
  }) {
    return AppTextField(
      controller: controller,
      config: config.copyWith(
        keyboardType: config.keyboardType ?? TextInputType.name,
        textCapitalization: config.textCapitalization == TextCapitalization.none
            ? TextCapitalization.words
            : config.textCapitalization,
      ),
    );
  }

  static AppTextField email({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
  }) {
    return AppTextField(
      controller: controller,
      config: config.copyWith(
        keyboardType: config.keyboardType ?? TextInputType.emailAddress,
      ),
    );
  }

  static AppTextField password({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
  }) {
    return AppTextField(
      controller: controller,
      config: config.copyWith(
        obscureText: true,
        keyboardType: config.keyboardType ?? TextInputType.visiblePassword,
      ),
    );
  }

  static AppTextField standard({
    required TextEditingController controller,
    TextFieldConfig config = const TextFieldConfig(),
  }) {
    return AppTextField(controller: controller, config: config);
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.config = const TextFieldConfig(),
  });

  final TextEditingController controller;
  final TextFieldConfig config;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: config.focusNode,
      inputFormatters: config.inputFormatters,
      textCapitalization: config.textCapitalization,
      controller: controller,
      readOnly: config.readOnly,
      enabled: config.enabled,
      onTap: config.onTap,
      keyboardType: config.keyboardType ?? TextInputType.text,
      textAlign: config.textAlign ?? TextAlign.start,
      textAlignVertical: config.textAlignVertical,
      validator: config.validator,
      autovalidateMode: config.autovalidateMode,
      maxLines: config.maxLines ?? 1,
      maxLength: config.maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      cursorColor: Colors.black,
      onChanged: config.onChanged,
      obscureText: config.obscureText,
      style: config.fontStyle ?? AppTextStyles.sm(context),
      decoration: InputDecoration(
        fillColor: config.fillColor ?? AppColors.overlayLight,
        filled: true,
        isDense: config.isDense,
        labelText: config.hintText,
        suffixIcon: config.suffixIcon,
        labelStyle: config.hintTextStyle ?? AppTextStyles.sm(context),
        prefixIcon: config.prefixIcon,
        errorText: config.errorText,
        errorStyle: AppTextStyles.sm(
          context,
        ).copyWith(color: config.errorBorderColor ?? AppColors.error500),
        helperStyle: const TextStyle(height: 0),
        contentPadding: config.contentPadding ?? const EdgeInsets.all(20),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: config.errorBorderColor ?? Colors.purple,
          ),
          borderRadius:
              config.borderRadius ??
              const BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: config.focusedErrorBorderColor ?? AppColors.overlayDark,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              config.enabledBorderRadius ??
              const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(
            color: config.enabledBorderColor ?? const Color(0xFFD5D6D9),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: config.focusedBorderColor ?? const Color(0xFFD5D6D9),
          ),
          borderRadius:
              config.focusedBorderRadius ??
              const BorderRadius.all(Radius.circular(12)),
        ),
        counterText: '',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
      ),
    );
  }
}
