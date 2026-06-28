import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class WelcomeToSetupScreen extends StatelessWidget {
  const WelcomeToSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.welcomeShine.path),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 130),
                  child: Assets.images.excitedLenny.image(),
                ),
                const SizedBox(height: 100),
                Text(
                  AppLocalizations.of(context)!.welcomeToLearnWay,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.xxlBold(context).copyWith(fontSize: 25),
                ),
                VSpace(10),
                Text(
                  AppLocalizations.of(context)!.successfullySignedIn,
                  style: AppTextStyles.mdRegular(context),
                ),
                VSpace(42),
                ButtonFactory.blackButton(
                  mainAxisAlignment: MainAxisAlignment.center,
                  text: AppLocalizations.of(context)!.setUpAccount,
                  textStyle: AppTextStyles.mdBold(
                    context,
                  ).copyWith(color: Colors.white),
                  onPressed: () {
                    context.router.replaceAll([const SetUpAccountViewRoute()]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
