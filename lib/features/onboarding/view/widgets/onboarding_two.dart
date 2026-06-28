import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';

class OnboardingTwo extends StatefulWidget {
  const OnboardingTwo({super.key});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50),
        AspectRatio(
          aspectRatio: 1.2,
          child: Image(
            image: AssetImage(Assets.images.onboardingImages.unlockOp.path),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.onboarding2Title,
          style: AppTextStyles.xxlSemiBold(
            context,
          ).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.onboarding2Description,
          style: AppTextStyles.md(context).copyWith(fontFamily: 'Poppins'),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
