import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPInputWidget extends StatefulWidget {
  const OTPInputWidget({
    super.key,
    this.numberOfFields = 6,
    this.onCompleted,
    this.onChanged,
    this.textStyle,
    this.decoration,
    this.fieldWidth = 50.0,
    this.fieldHeight = 60.0,
    this.fieldPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.autoFocus = true,
    this.enabled = true,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.borderRadius = 8.0,
    this.keyboardType = TextInputType.number,
    this.formKey,
    this.validator,
    this.controller,
    this.showDefaultError = true,
  });

  final int numberOfFields;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final double fieldWidth;
  final double fieldHeight;
  final EdgeInsets fieldPadding;
  final bool autoFocus;
  final bool enabled;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final double borderRadius;
  final TextInputType keyboardType;
  final GlobalKey<FormState>? formKey;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool showDefaultError;
  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNodes = FocusNode();
  String otpValue = '';

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   if (widget.controller == null) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: PinCodeTextField(
        appContext: context,
        length: widget.numberOfFields,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: AppColors.gray900,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        obscureText: false,
        animationType: AnimationType.fade,
        showCursor: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableActiveFill: true,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          fieldHeight: widget.fieldHeight,
          fieldWidth: widget.fieldWidth,
          activeFillColor: widget.fillColor ?? Colors.white,
          inactiveFillColor: widget.fillColor ?? Colors.white,
          selectedFillColor: widget.fillColor ?? Colors.white,
          activeColor: widget.focusedBorderColor ?? AppColors.primaryColor,
          inactiveColor: widget.borderColor ?? Colors.grey,
          selectedColor: widget.focusedBorderColor ?? AppColors.primaryColor,
          errorBorderColor: AppColors.warning700,
          errorBorderWidth: 1.5,
        ),

        textStyle: widget.textStyle,
        controller: widget.controller ?? controller,
        validator: widget.showDefaultError
            ? widget.validator
            : (value) {
                widget.validator?.call(value);
                return null;
              },

        focusNode: focusNodes,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          otpValue = value;
          if (widget.onChanged != null) {
            widget.onChanged!(otpValue);
          }
          if (otpValue.length == widget.numberOfFields &&
              widget.onCompleted != null) {
            widget.onCompleted!(otpValue);
          }
        },
      ),
    );
  }
}
