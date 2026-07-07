import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/svg.dart';

import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class OnboardingInitialScreen extends StatefulWidget {
  const OnboardingInitialScreen({super.key});

  @override
  State<OnboardingInitialScreen> createState() =>
      _OnboardingInitialScreenState();
}

class _OnboardingInitialScreenState extends State<OnboardingInitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [Color(0xFF060B3F), Color(0xFF000000)],
            stops: [0.0, 1.0],
          ),
          image: DecorationImage(
            image: Image.asset('assets/images/grid.png').image,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/learn_way_logo.svg',
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 11.42),
                Text(
                  'LearnWay',
                  style: AppTextStyles.xxlBold(
                    context,
                  ).copyWith(color: Colors.white, fontSize: 34.25),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.masterWeb3,
              style: AppTextStyles.xxl(context).copyWith(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                height: 1.20,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.learnAndEarnTagline,
              style: AppTextStyles.xxl(context).copyWith(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w300,
                height: 1.20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.onboardingDescription,
              style: AppTextStyles.base(context).copyWith(color: Colors.white),
            ),
            const VSpace(100),
            ButtonFactory.outlinedButton(
              text: AppLocalizations.of(context)!.joinJourney,
              useAutoSpace: true,
              textColor: Colors.white,
              textStyle: AppTextStyles.baseBold(context, color: Colors.white)
                  .copyWith(
                    fontSize: 14,
                    height: 1.14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
              onPressed: () {
                context.router.push(const OnBoardingRoute());
              },
              padding: EdgeInsets.only(left: 25),
              borderColor: Colors.white,
              leadingIcon: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/arrow-right.svg',
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            VSpace(20),
          ],
        ),
      ),
    );
  }
}
