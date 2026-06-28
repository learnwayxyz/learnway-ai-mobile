import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

class SliverIntroText extends StatelessWidget {
  const SliverIntroText({super.key, this.title = 'Beginner'});
  final String title;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(title, style: AppTextStyles.mdBold(context))),
              VSpace(16),
              Text(
                AppLocalizations.of(context)!.chooseACourse,
                style: AppTextStyles.mdBold(context),
              ),
              VSpace(4),
              Text(
                AppLocalizations.of(context)!.letsBringYouOnWeb3Journey,
                style: AppTextStyles.md(
                  context,
                ).copyWith(color: AppColors.gray700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
