import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';

class OnboardingFour extends StatefulWidget {
  const OnboardingFour({super.key});

  @override
  State<OnboardingFour> createState() => _OnboardingFourState();
}

class _OnboardingFourState extends State<OnboardingFour> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50),
        AspectRatio(
          aspectRatio: 1.2,
          child: Image(
            image: AssetImage(Assets.images.onboardingImages.joinMovement.path),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.onboarding4Title,
          style: AppTextStyles.xxlSemiBold(context),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.onboarding4Description,
          style: AppTextStyles.md(context).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
