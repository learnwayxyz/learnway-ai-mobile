import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class KycDoneScreen extends StatelessWidget {
  const KycDoneScreen({super.key});

  void _handleBackToHome(BuildContext context) {
    context.router.popUntil(
      (route) => route.settings.name == MainActivityRoute.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.kycDone, barHeight: 10),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/kyc_done_background.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const VSpace(100),
                  Image.asset(
                    'assets/images/kyc_done.png',
                    width: 280,
                    height: 280,
                  ),
                  const VSpace(40),
                  Text(
                    AppLocalizations.of(context)!.youveDoneYourKyc,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.lgBold(
                      context,
                      color: const Color(0xFF181D27),
                    ),
                  ),
                  const VSpace(10),
                  Text(
                    AppLocalizations.of(context)!.identityVerifiedSuccessfully,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.smRegular(
                      context,
                      color: const Color(0xFF414651),
                    ),
                  ),
                  const Spacer(),
                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    isFullWidth: true,
                    text: AppLocalizations.of(context)!.backToHome,
                    backgroundColor: Colors.black,
                    textStyle: AppTextStyles.baseBold(
                      context,
                    ).copyWith(color: Colors.white, fontFamily: 'Manrope'),
                    onPressed: () => _handleBackToHome(context),
                  ),
                  const VSpace(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
