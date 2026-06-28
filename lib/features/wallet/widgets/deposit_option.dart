import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class DepositOption extends StatelessWidget {
  const DepositOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showComingSoon = false,
    this.package,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showComingSoon;
  final String? package;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: showComingSoon ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    icon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    package: package,
                  ),
                ),
                const HSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.smSemiBold(context)),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.smRegular(
                          context,
                        ).copyWith(fontSize: 12, color: AppColors.gray500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showComingSoon)
          Positioned(
            top: -10,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Coming Soon',
                style: AppTextStyles.xs(
                  context,
                ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
