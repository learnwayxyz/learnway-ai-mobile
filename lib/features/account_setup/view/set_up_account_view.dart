import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/account_setup/view/select_avatar_screen.dart';
import 'package:learnwayv2/features/account_setup/view/user_name_screen.dart';
import 'package:learnwayv2/features/auth/auth_enums/auth_provider.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/verify_email_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/apple_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_cubit.dart';
import 'package:learnwayv2/features/auth/social_auth/google_auth_state.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class SetUpAccountViewScreen extends StatefulWidget {
  const SetUpAccountViewScreen({super.key});

  @override
  State<SetUpAccountViewScreen> createState() => _SetUpAccountViewScreenState();
}

class _SetUpAccountViewScreenState extends State<SetUpAccountViewScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  final List<Widget> screens = <Widget>[UserNameScreen(), SelectAvatarScreen()];

  @override
  void initState() {
    super.initState();
    _initializeAuthProvider();
  }

  String _getButtonText() {
    return (currentIndex == screens.length - 1) ? 'Complete Setup' : 'Next';
  }

  void _handleNextPressed(AccountSetupState state) async {
    if (state is! SetAccountDetails) {
      _showIncompleteFormSnackbar(null);
      return;
    }

    if (currentIndex == 0) {
      if (!state.hasUserDetails) {
        _showIncompleteFormSnackbar(state);
        return;
      }
    } else if (currentIndex == 1) {
      if (!state.isComplete) {
        _showIncompleteFormSnackbar(state);
        return;
      }
    }

    if (currentIndex < screens.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeAccountSetup();
    }
  }

  Future<void> _completeAccountSetup() async {
    final userEmail = _getUserEmail();
    if (userEmail != null) {
      context.router.push(AccountSetupLoaderRoute(userEmail: userEmail));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to retrieve user email. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _getUserEmail() {
    try {
      final googleState = context.read<GoogleAuthCubit>().state;
      final appleState = context.read<AppleAuthCubit>().state;
      final emailState = context.read<VerifyEmailCubit>().state;
      final homeState = context.read<HomeBloc>().state;

      if (homeState is FetchHomeDataSuccess &&
          homeState.userProfile!.email != null) {
        log('homeState.userProfile.email: ${homeState.userProfile!.email}');
        return homeState.userProfile!.email;
      }
      if (googleState is GoogleAuthSuccess) {
        return googleState.userCredential.user?.email;
      } else if (appleState is AppleAuthSuccess) {
        return appleState.userCredential.user?.email;
      } else if (emailState is VerifyingNewUserSuccessState ||
          emailState is VerifyingOtpStateSuccessState) {
        return emailState.email;
      }
    } catch (e) {
      log('Error getting email: $e');
    }
    return null;
  }

  void _showIncompleteFormSnackbar(SetAccountDetails? state) {
    String message = '';

    if (currentIndex == 0) {
      if (state == null) {
        message = 'Please fill in your username and select a country';
      } else {
        final hasUsername = state.userName.trim().isNotEmpty;
        final hasCountry = state.country.trim().isNotEmpty;

        if (!hasUsername && !hasCountry) {
          message = 'Please fill in your username and select a country';
        } else if (!hasUsername) {
          message = 'Please fill in your username';
        } else if (!hasCountry) {
          message = 'Please select a country';
        }
      }
    } else {
      message = 'Please select an avatar to continue';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.gray900,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetupCubit, AccountSetupState>(
      builder: (context, state) {
        final isLoading = state is AccountSetupLoading;
        bool canProceed = false;
        if (state is SetAccountDetails) {
          if (currentIndex == 0) {
            canProceed = state.hasUserDetails;
          } else if (currentIndex == 1) {
            canProceed = state.isComplete;
          }
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
          child: OverlayLoader(
            isLoading: isLoading,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: PopScope(
                canPop: false,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: pageController,
                                  count: screens.length,
                                  effect: ExpandingDotsEffect(
                                    dotColor: Colors.grey,
                                    activeDotColor: AppColors.blueLight700,
                                    dotHeight: 5,
                                    dotWidth:
                                        MediaQuery.of(context).size.width *
                                        0.04,
                                    spacing: 5,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${currentIndex + 1} of ${screens.length}',
                              style: AppTextStyles.baseBold(context),
                            ),
                          ],
                        ),
                        VSpace(25),
                        Expanded(
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: screens.length,
                            onPageChanged: (int index) {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) => screens[index],
                          ),
                        ),
                        VSpace(25),
                        ButtonFactory.blackButton(
                          mainAxisAlignment: MainAxisAlignment.center,
                          padding: const EdgeInsets.all(20),
                          text: _getButtonText(),
                          onPressed: canProceed
                              ? () => _handleNextPressed(state)
                              : () => _showIncompleteFormSnackbar(
                                  state is SetAccountDetails ? state : null,
                                ),
                        ),
                        VSpace(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _initializeAuthProvider() async {
    try {
      final googleState = context.read<GoogleAuthCubit>().state;
      final appleState = context.read<AppleAuthCubit>().state;
      final emailState = context.read<VerifyEmailCubit>().state;

      AuthProvider? authProvider;
      if (googleState is GoogleAuthSuccess) {
        authProvider = googleState.provider;
      } else if (appleState is AppleAuthSuccess) {
        authProvider = appleState.provider;
      } else if (emailState is VerifyingNewUserSuccessState) {
        authProvider = AuthProvider.email;
      }

      if (authProvider == null) {
        final usedGoogleAuth = await SharedPreferencesStore.getUsedGoogleAuth(
          usedGoogleAuthKey,
        );
        final usedAppleAuth = await SharedPreferencesStore.getUsedAppleAuth(
          usedAppleAuthKey,
        );

        if (usedGoogleAuth == true) {
          authProvider = AuthProvider.google;
        } else if (usedAppleAuth == true) {
          authProvider = AuthProvider.apple;
        } else {
          authProvider = AuthProvider.email;
        }
      }

      if (mounted) {
        context.read<AccountSetupCubit>().setUserDetails(
          userName: '',
          country: '',
          authProvider: authProvider,
        );
      }

      log('Auth provider successfully initialized: $authProvider');
    } catch (e, stack) {
      log('Error initializing auth provider: $e', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
