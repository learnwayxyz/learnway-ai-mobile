import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

class DismissableAppBarContentStrategy implements AppBarContentStrategy {
  final String title;
  final VoidCallback? onDismiss;

  const DismissableAppBarContentStrategy({required this.title, this.onDismiss});

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: onDismiss ?? () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.baseSemiBold(
                context,
              ).copyWith(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
