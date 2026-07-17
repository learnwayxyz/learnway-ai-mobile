import 'package:flutter/material.dart';

extension CardStyleExtension on Widget {
  Widget cardStyle({
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry? margin,
    Color color = Colors.white,
    double borderRadius = 20,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow,
      ),
      child: this,
    );
  }
}
