import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';

class OnboardingOne extends StatefulWidget {
  const OnboardingOne({super.key});

  @override
  State<OnboardingOne> createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50),
        AspectRatio(
          aspectRatio: 1.2,
          child: Image(
            image: AssetImage(Assets.images.onboardingImages.wavingHand.path),
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.onboarding1Title,
          style: AppTextStyles.xxlSemiBold(
            context,
          ).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.onboarding1Description,
          style: AppTextStyles.md(context).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
