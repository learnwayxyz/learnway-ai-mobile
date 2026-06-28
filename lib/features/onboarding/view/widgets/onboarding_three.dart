import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({super.key});

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50),
        AspectRatio(
          aspectRatio: 1.2,
          child: Image(
            image: AssetImage(Assets.images.onboardingImages.globalWallet.path),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.onboarding3Title,
          style: AppTextStyles.xxlSemiBold(
            context,
          ).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.onboarding3Description,
          style: AppTextStyles.md(context).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
