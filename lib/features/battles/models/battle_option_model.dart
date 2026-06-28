import 'package:flutter/material.dart';

class BattleOptionModel {
  const BattleOptionModel({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final VoidCallback onTap;
}
