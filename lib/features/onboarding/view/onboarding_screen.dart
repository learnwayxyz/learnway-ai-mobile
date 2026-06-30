import 'dart:developer';

import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/onboarding/onboarding.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const OnboardingOne(),
      const OnboardingTwo(),
      const OnboardingThree(),
      const OnboardingFour(),
    ];
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      dotColor: pages.length == currentIndex
                          ? AppColors.blueLight700
                          : Colors.grey,
                      activeDotColor: AppColors.blueLight700,
                      dotHeight: 5,
                      dotWidth: MediaQuery.of(context).size.width * 0.04,
                      spacing: 5,
                    ),
                    onDotClicked: (index) {
                      currentIndex = index;
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.blueLight700,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.skip,
                      style: AppTextStyles.baseSemiBold(
                        context,
                      ).copyWith(fontFamily: 'Poppins', fontSize: 16),
                    ),
                    onPressed: () {
                      SharedPreferencesStore.hasSeenIntroSlide(
                        hasSeenIntroSlidesKey,
                        true,
                      );
                      context.router.replace(RegisterRoute());
                    },
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  scrollBehavior: const MaterialScrollBehavior(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // VSpace(93),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: pages[index],
                        ),
                      ],
                    );
                  },
                  itemCount: pages.length,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: currentIndex == pages.length - 1
                        ? IntrinsicWidth(
                            child: ButtonFactory.blackButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              text: AppLocalizations.of(context)!.back,
                              trailingIcon: SvgPicture.asset(
                                'assets/images/arrow-left.svg',
                              ),
                              backgroundColor: currentIndex == 0
                                  ? Colors.grey
                                  : Colors.black,
                              onPressed: currentIndex == 0
                                  ? () {}
                                  : () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        curve: Curves.ease,
                                      );
                                    },
                            ),
                          )
                        : ButtonFactory.blackButton(
                            text: AppLocalizations.of(context)!.back,
                            trailingIcon: SvgPicture.asset(
                              'assets/images/arrow-left.svg',
                            ),
                            backgroundColor: currentIndex == 0
                                ? Colors.grey
                                : Colors.black,
                            onPressed: currentIndex == 0
                                ? () {}
                                : () {
                                    _pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.ease,
                                    );
                                  },
                          ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: currentIndex == pages.length - 1
                        ? ButtonFactory.outlinedEmojiButton(
                            padding: 10,
                            text: AppLocalizations.of(context)!.getAccount,
                            emoji: '🎉',
                            onPressed: () {
                              SharedPreferencesStore.hasSeenIntroSlide(
                                hasSeenIntroSlidesKey,
                                true,
                              );
                              context.pushRoute(const RegisterRoute());
                            },
                          )
                        : ButtonFactory.blackButton(
                            text: AppLocalizations.of(context)!.next,
                            leadingIcon: SvgPicture.asset(
                              'assets/images/arrow-right.svg',
                            ),
                            onPressed: () {
                              log('Next button pressed');
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                          ),
                  ),
                ],
              ),
              VSpace(83),
            ],
          ),
        ),
      ),
    );
  }
}
