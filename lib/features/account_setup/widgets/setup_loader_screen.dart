import 'dart:developer';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/loader/circular_progress_painter.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class AccountSetupLoaderScreen extends StatefulWidget {
  const AccountSetupLoaderScreen({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<AccountSetupLoaderScreen> createState() =>
      _AccountSetupLoaderScreenState();
}

class _AccountSetupLoaderScreenState extends State<AccountSetupLoaderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountSetupCubit>().completeAccountSetup(
        userEmail: widget.userEmail,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getDynamicStatusText(BuildContext context, SetupStep step) {
    final l10n = AppLocalizations.of(context)!;
    switch (step) {
      case SetupStep.collectingInfo:
        return l10n.preparingInformation;
      case SetupStep.uploadingImage:
        return l10n.uploadingImage;
      case SetupStep.creatingAccount:
        return l10n.creatingAccount;
      case SetupStep.generatingWallet:
        return l10n.generatingWallet;
      case SetupStep.generatingReferralCode:
        return l10n.generatingReferralCode;
      case SetupStep.settingUpSecurity:
        return l10n.settingUpSecurity;
      case SetupStep.finalizing:
        return l10n.finalizingSetup;
      case SetupStep.completed:
        return l10n.accountIsReady;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarFactory.standardAppBar(
          title: AppLocalizations.of(context)!.settingUpAccount,
          showBackButton: false,
        ),
        body: BlocConsumer<AccountSetupCubit, AccountSetupState>(
          listener: (context, state) {
            if (state is AccountSetupSucess) {
              log('Account setup successful: ${state.userName}');
              context.router.replace(const SetUpSuccessRoute());
            } else if (state is AccountSetupError) {
              if (context.mounted) {
                context.router.replace(const RegisterRoute());
              }

              Future.delayed(Duration(seconds: 3), () {
                if (context.mounted) {
                  context.router.pop();
                }
              });
            }
          },
          builder: (context, state) {
            if (state is AccountSetupProgress) {
              final progress = state.progress;

              if (progress.isError) {
                _controller.stop();
              } else {
                _controller.repeat();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!progress.isError) ...[
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: CustomPaint(
                              size: const Size(40, 40),
                              painter: CircularProgressPainter(progress: 0.25),
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 32,
                        ),
                      ),
                    ],

                    VSpace(32),

                    Text(
                      progress.isError
                          ? AppLocalizations.of(context)!.setupFailed
                          : AppLocalizations.of(context)!.settingUpYourAccount,
                      style: AppTextStyles.xl(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: progress.isError
                            ? Colors.red
                            : AppColors.gray900,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    VSpace(16),

                    SizedBox(
                      height: 48,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          progress.isError
                              ? (progress.errorMessage ??
                                    AppLocalizations.of(context)!.somethingWentWrong)
                              : _getDynamicStatusText(context, progress.currentStep),
                          key: ValueKey(
                            progress.isError ? 'error' : progress.currentStep,
                          ),
                          style: AppTextStyles.base(context).copyWith(
                            color: progress.isError
                                ? Colors.red.shade600
                                : AppColors.gray600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    VSpace(40),

                    if (progress.isError) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ButtonFactory.blackButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                              text: AppLocalizations.of(context)!.goBack,
                              onPressed: () {
                                context
                                    .read<AccountSetupCubit>()
                                    .restoreDetailsAfterFailure();
                                context.router.pop();
                              },
                            ),
                          ),
                          HSpace(12),
                          Expanded(
                            child: ButtonFactory.blackButton(
                              mainAxisAlignment: MainAxisAlignment.center,
                              text: AppLocalizations.of(context)!.retry,
                              onPressed: () {
                                context.read<AccountSetupCubit>().retrySetup(
                                  userEmail: widget.userEmail,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      if (progress.currentStep ==
                          SetupStep.generatingWallet) ...[
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              HSpace(12),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.walletGenerationNote,
                                  style: AppTextStyles.sm(
                                    context,
                                  ).copyWith(color: AppColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: CustomPaint(
                          size: const Size(40, 40),
                          painter: CircularProgressPainter(progress: 0.25),
                        ),
                      );
                    },
                  ),
                  VSpace(32),
                  Text(
                    AppLocalizations.of(context)!.settingUpYourAccount,
                    style: AppTextStyles.lg(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  VSpace(16),
                  Text(
                    AppLocalizations.of(context)!.preparingAccountSetup,
                    style: AppTextStyles.base(
                      context,
                    ).copyWith(color: AppColors.gray600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
