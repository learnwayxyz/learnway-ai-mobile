import 'dart:developer';
import 'dart:math' as math;
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:core/core.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController _textAnimationController;
  late Animation<Offset> _textAnimation;

  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  bool _animationCompleted = false;
  bool _textVisible = false;
  bool showDecorationImage = false;
  bool _allAnimationsComplete = false;

  UserProfileModel? _pendingUserProfile;
  String? _pendingError;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: -(math.pi / 8)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _textAnimation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_animationCompleted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          _animationCompleted = true;
          _rotationAnimation = Tween<double>(
            begin: -(math.pi / 8),
            end: (math.pi / 7),
          ).animate(_animationController);
          _animationController.reset();
          _animationController.forward();

          _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );
        });
      }

      if (_animationCompleted && status == AnimationStatus.completed) {
        _fadeAnimationController.forward();
        if (mounted) {
          setState(() {
            _textVisible = true;
            showDecorationImage = true;
          });
        }

        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _textAnimationController.forward();
          }
        });
      }
    });

    _textAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          _allAnimationsComplete = true;
          if (_pendingUserProfile != null) {
            _handleUserNavigation(_pendingUserProfile!);
          } else if (_pendingError != null) {
            _handleFetchError(_pendingError!);
          }
        });
      }
    });

    context.read<HomeBloc>().add(const FetchHomeDataEvent());
  }

  Future<void> _handleUserNavigation(UserProfileModel userProfile) async {
    if (!_allAnimationsComplete) {
      _pendingUserProfile = userProfile;
      return;
    }

    try {
      final hasRegistered = await SharedPreferencesStore.getHasRegistered(
        hasRegisteredKey,
      );

      log('has registered: $hasRegistered');

      if (userProfile.id != null && userProfile.id!.isNotEmpty) {
        await SharedPreferencesStore.setUserId(userIdKey, userProfile.id!);
      }

      if (userProfile.halfPrivateKey != null) {
        final config = locator.get<ApiConfigResponse>();
        final payload = {
          'remoteShares': userProfile.halfPrivateKey,
          'userName': userProfile.username,
          'userEmail': userProfile.email,
          'walletAddress': userProfile.walletAddress,
          'userId': userProfile.id,
          'pepAddress': config.pepAddress,
        };
        if (mounted) {
          context.read<HomeBloc>().add(AttemptWalletRecoveryEvent(payload));
        }
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          locator.get<MainActivityCubit>().resetState();
          context.router.replace(const MainActivityRoute());
        }
      } else if (userProfile.halfPrivateKey == null) {
        if (mounted) {
          context.router.replace(const WelcomeToSetupRoute());
        }
      } else {
        if (mounted) {
          context.router.replace(const RegisterRoute());
        }
      }
    } catch (e) {
      log('Error handling user navigation: $e');
    }
  }

  Future<void> _handleFetchError(String errorMessage) async {
    if (!_allAnimationsComplete) {
      _pendingError = errorMessage;
      return;
    }

    log('Fetch error occurred: $errorMessage');

    final hasSeenIntroSlides =
        await SharedPreferencesStore.getHasSeenIntroSlides(
          hasSeenIntroSlidesKey,
        );

    if (mounted) {
      if (hasSeenIntroSlides == true &&
          (errorMessage.contains('User token is null') ||
              errorMessage.contains('Unauthorized') ||
              errorMessage.contains('401') ||
              errorMessage.contains('403'))) {
        log('Authentication error - redirecting to registration');
        context.router.replace(const RegisterRoute());
      } else if (errorMessage.contains('Network') ||
          errorMessage.contains('timeout') ||
          errorMessage.contains('connection')) {
        log('Network error - retrying after delay');

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            context.read<HomeBloc>().add(const FetchHomeDataEvent());
          }
        });
      } else {
        log('Unknown error - falling back to registration');
        context.router.replace(const RegisterRoute());
      }
    }
  }

  Gradient _getInterpolatedGradient(double t) {
    return RadialGradient(
      center: Alignment.topLeft,
      radius: 1.5,
      colors: [
        Color.lerp(Colors.white, const Color(0xFF060B3F), t)!,
        Color.lerp(Colors.white, const Color(0xFF000000), t)!,
      ],
      stops: const [0.0, 1.0],
    );
  }

  Widget buildAnimatedContent(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: _getInterpolatedGradient(_fadeAnimation.value),
            image: showDecorationImage
                ? DecorationImage(
                    image: Image.asset('assets/images/grid.png').image,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          alignment: Alignment.center,
                          angle: _rotationAnimation.value,
                          child: Image.asset(
                            'assets/images/learn_way_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (_textVisible)
                        SlideTransition(
                          position: _textAnimation,
                          child: Text(
                            'LearnWay',
                            style: AppTextStyles.xxlBold(
                              context,
                            ).copyWith(color: Colors.white, fontSize: 34.25),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        final hasSeenIntroSlides =
            await SharedPreferencesStore.getHasSeenIntroSlides(
              hasSeenIntroSlidesKey,
            );

        if (hasSeenIntroSlides != true) {
          log('User has not seen intro slides - navigating to onboarding');
          if (context.mounted) {
            context.router.replace(const OnboardingInitialRoute());
          }
          return;
        }

        if (state is FetchHomeDataSuccess) {
          log('Home data fetch successful');
          await _handleUserNavigation(state.userProfile!);
        }

        if (state is FetchingHomeDataError) {
          await _handleFetchError(state.message);
        }
      },
      child: Scaffold(body: Center(child: buildAnimatedContent(context))),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }
}
