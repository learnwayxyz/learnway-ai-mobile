import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

class SendCodeButton extends StatefulWidget {
  const SendCodeButton({
    super.key,
    required this.onPressed,
    this.text = 'Send Code',
    this.textColor = Colors.blue,
    this.timerDuration = 60,
  });
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final int timerDuration;

  @override
  State<SendCodeButton> createState() => _SendCodeButtonState();
}

class _SendCodeButtonState extends State<SendCodeButton> {
  Timer? _timer;
  int _remainingTime = 0;
  bool _isTimerActive = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _remainingTime = widget.timerDuration;
      _isTimerActive = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isTimerActive = false;
          timer.cancel();
        }
      });
    });
  }

  void _handlePress() {
    if (!_isTimerActive) {
      widget.onPressed();
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isTimerActive ? null : _handlePress,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: widget.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Center(
        child: Text(
          _isTimerActive
              ? '${widget.text} ${_formatTime(_remainingTime)}'
              : widget.text,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: _isTimerActive ? widget.textColor : widget.textColor,
            fontSize: AppTextStyles.md(context).fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
