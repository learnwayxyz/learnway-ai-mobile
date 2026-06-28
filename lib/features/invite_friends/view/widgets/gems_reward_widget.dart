import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';

class GemsRewardWidget extends StatelessWidget {
  final int gemsAmount;

  const GemsRewardWidget({super.key, required this.gemsAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Decorative diamond graphics - exact Figma measurements
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            children: [
              // Main diamond - exact Figma positioning (x: 1, y: 0, width: 140, height: 140)
              Positioned(
                left: 1,
                top: 0,
                child: Image.asset(
                  Assets.images.blueGem.path,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              // Overlay diamond - exact Figma positioning (x: 90.25, y: 74.31, width: 65.48, height: 65.48)
              Positioned(
                left: 90.25,
                top: 74.31,
                child: Image.asset(
                  Assets.images.blueGem.path,
                  width: 65.48,
                  height: 65.48,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Gems amount text
        Text(
          '$gemsAmount Gems',
          style: AppTextStyles.xxlBold(
            context,
          ).copyWith(fontSize: 30, color: AppColors.gray900),
        ),
      ],
    );
  }
}
