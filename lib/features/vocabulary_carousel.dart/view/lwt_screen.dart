import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

class LwtScreen extends StatelessWidget {
  const LwtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.22,
          width: double.infinity,
          child: Image.asset(Assets.images.andinkraSetupBadge.path),
        ),
        VSpace(16),
        Text(
          AppLocalizations.of(context)!.walkThrough_title2,
          textAlign: TextAlign.center,
          style: AppTextStyles.xxl(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        VSpace(10),
        Text(
          AppLocalizations.of(context)!.walkThrough_description2,
          style: AppTextStyles.mdRegular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
