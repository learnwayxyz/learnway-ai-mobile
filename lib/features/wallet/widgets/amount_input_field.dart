import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatefulWidget {
  const AmountInputField({super.key, this.onChanged});
  final void Function(double)? onChanged;

  @override
  State<AmountInputField> createState() => _AmountInputFieldState();
}

class _AmountInputFieldState extends State<AmountInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    if (_controller.text.isNotEmpty) {
      final text = _controller.text.replaceAll(',', '.');
      try {
        final value = double.parse(text);

        // Notify parent of change
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      } catch (e) {
        print('Error parsing value: $e');
      }
    } else if (widget.onChanged != null) {
      // If text is empty, consider it as 0
      widget.onChanged!(0);
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _controller.text.isNotEmpty) {
      // Lost focus - format the value
      try {
        final value = double.parse(_controller.text.replaceAll(',', '.'));
        _formatDisplayValue(value);
      } catch (e) {
        print('Error formatting value on focus lost: $e');
      }
    }
  }

  void _formatDisplayValue(double value) {
    String formattedText;
    if (value < 1) {
      formattedText = value.toStringAsFixed(2);
    } else {
      formattedText =
          value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
    }

    _controller
      ..removeListener(_onTextChanged)
      ..text = formattedText
      ..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xff707070);

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }

          final text = newValue.text.replaceAll(',', '.');

          if (RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
            final parts = text.split('.');
            if (parts.length > 1 && parts[1].length > 2) {
              return oldValue;
            }
            return newValue.copyWith(text: text);
          }
          return oldValue;
        }),
      ],
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 16, color: textColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
        hintText: '0.0',
        hintStyle: TextStyle(fontSize: 16, color: textColor.withOpacity(0.5)),
      ),
    );
  }
}
