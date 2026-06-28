import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learnwayv2/features/wallet/widgets/custom_context_menu_builder.dart';
import 'package:core/core.dart';

class SendTextField extends StatefulWidget {
  const SendTextField({
    required this.hintText,
    this.hintStyle,
    required this.fieldController,
    required this.fillColor,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    super.key,
  });

  final String hintText;
  final TextStyle? hintStyle;
  final TextEditingController fieldController;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color? fillColor;

  @override
  State<SendTextField> createState() => _SendTextFieldState();
}

class _SendTextFieldState extends State<SendTextField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: errorText != null
                ? Border.all(
                    color: errorText != null
                        ? Colors.red
                        : const Color(0xfff3f4f7),
                  )
                : null,
          ),
          child: TextFormField(
            controller: widget.fieldController,
            contextMenuBuilder: (context, editableTextState) {
              return CustomContextMenuBuilder.buildMenu(
                context: context,
                editableTextState: editableTextState,
                useCustomWidgets: true,
                customItems: [
                  CustomButtonItem(
                    label: 'Paste',
                    textColor: Colors.blue,
                    onPressed: () async {
                      final data = await Clipboard.getData('text/plain');
                      if (data != null) {
                        final text = data.text!;
                        editableTextState.userUpdateTextEditingValue(
                          editableTextState.textEditingValue.replaced(
                            editableTextState.textEditingValue.selection,
                            text,
                          ),
                          SelectionChangedCause.toolbar,
                        );
                      }
                    },
                  ),
                ],
                includeDefaults: false,
                excludeDefaults: ['Paste'],
              );
            },
            keyboardType: widget.keyboardType,
            style: AppTextStyles.md(context, color: AppColors.gray900),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  widget.hintStyle ??
                  AppTextStyles.md(context, color: AppColors.gray400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray400, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray400, width: 1),
              ),
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              focusColor: Colors.red,
              errorStyle: const TextStyle(
                height: 0,
                color: Colors.transparent,
                fontSize: 0,
              ),
              fillColor: widget.fillColor,
              filled: true,
              suffixIcon: widget.suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (widget.validator != null) {
                setState(() {
                  errorText = widget.validator!(value);
                });
              }
              return errorText;
            },
            onChanged: (value) {
              if (errorText != null) {
                setState(() {
                  errorText = widget.validator?.call(value);
                });
              }
            },
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              errorText!,
              style: AppTextStyles.xs(
                context,
              ).copyWith(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
