import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.supportAndLegal,
                  style: AppTextStyles.baseSemiBold(
                    context,
                    color: const Color(0xFF181D27),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildCustomAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpace(20),
            AccountSections(
              children: [
                // AccountTiles(
                //   icon: 'assets/icons/message-question.svg',
                //   title: 'Help Center / FAQs',
                //   onTap: () {
                //     context.router.push(const HelpCenterRoute());
                //   },
                // ),
                // AccountTiles(
                //   icon: 'assets/icons/report-outline.svg',
                //   title: 'Report a Problem',
                //   onTap: () {
                //     context.router.push(const ReportProblemRoute());
                //   },
                // ),
                AccountTiles(
                  icon: 'assets/icons/book.svg',
                  title: AppLocalizations.of(context)!.termsAndConditions,
                  onTap: () {
                    context.router.push(
                      TermsAndConditionRoute(title: 'About LearnWay'),
                    );
                  },
                ),
                AccountTiles(
                  icon: 'assets/icons/security.svg',
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  onTap: () {
                    context.router.push(const PrivacyPolicyRoute());
                  },
                ),
                // AccountTiles(
                //   icon: 'assets/icons/info-circle.svg',
                //   title: 'About LearnWay',
                //   onTap: () {
                //     context.router.push(
                //       AboutLearnWayRoute(title: 'Terms & Conditions'),
                //     );
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
