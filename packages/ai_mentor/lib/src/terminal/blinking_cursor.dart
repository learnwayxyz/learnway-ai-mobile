import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key, this.color, this.fontSize = 18});

  final Color? color;
  final double fontSize;

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        '|',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: widget.color ?? AppColors.primaryColor,
          height: 1.2,
        ),
      ),
    );
  }
}
