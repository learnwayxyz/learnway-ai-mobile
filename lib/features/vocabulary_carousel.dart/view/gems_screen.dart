import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class GemsScreen extends StatelessWidget {
  const GemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            width: double.infinity,
            child: Assets.images.gemsEarned.image(),
          ),
          VSpace(16),
          Text(
            AppLocalizations.of(context)!.walkThrough_title1,
            textAlign: TextAlign.center,
            style: AppTextStyles.xxl(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          VSpace(10),
          Text(
            AppLocalizations.of(context)!.walkThrough_description1,
            style: AppTextStyles.mdRegular(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
