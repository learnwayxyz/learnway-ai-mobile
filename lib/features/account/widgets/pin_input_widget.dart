import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

class PinInputWidget extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final bool hasError;
  final String? errorMessage;

  const PinInputWidget({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.errorMessage,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }

    final pin = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(pin);

    if (pin.length == 4) {
      widget.onCompleted(pin);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(4, (index) {
            final isFocused = _focusNodes[index].hasFocus;
            final hasValue = _controllers[index].text.isNotEmpty;
            
            return Padding(
              padding: EdgeInsets.only(right: index < 3 ? 10 : 0),
              child: Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: widget.hasError
                          ? 2
                          : (isFocused || hasValue)
                              ? 2
                              : 1,
                      color: widget.hasError
                          ? AppColors.error600
                          : (isFocused || hasValue)
                              ? const Color(0xFF535861)
                              : const Color(0xFFD5D6D9),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    obscureText: true,
                    obscuringCharacter: '●',
                    style: AppTextStyles.xlBold(context).copyWith(
                      color: widget.hasError
                          ? AppColors.error600
                          : AppColors.gray900,
                      fontSize: 24,
                    ),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) => _onChanged(index, value),
                    onTap: () {
                      if (_controllers[index].text.isNotEmpty) {
                        _controllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      }
                    },
                    onEditingComplete: () {
                      if (index < 3 && _controllers[index].text.isNotEmpty) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            );
          }),
        ),
        if (widget.hasError && widget.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorMessage!,
            style: AppTextStyles.smRegular(context).copyWith(
              color: AppColors.error600,
            ),
          ),
        ],
      ],
    );
  }
}
