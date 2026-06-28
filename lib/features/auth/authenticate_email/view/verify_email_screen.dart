import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/verify_email_cubit.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/timer_cubit.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:learnwayv2/shared/widgets/send_button_widget.dart';

@RoutePage()
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _otpKey = GlobalKey<FormState>();
  String enteredOTP = '';
  bool isCompleted = false;
  bool disableButton = true;

  @override
  void initState() {
    super.initState();
    context.read<TimerCubit>().startTimer();
  }

  void _onResendPressed() {
    final email = context.read<VerifyEmailCubit>().state.email;
    context.read<VerifyEmailCubit>().resendOtp(email);
    context.read<TimerCubit>().restartTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRegularLoading = context.select<VerifyEmailCubit, bool>(
      (cubit) =>
          cubit.state is SendingOtpState ||
          cubit.state is VerifyingOtpState ||
          cubit.state is VerifyingNewUser,
    );

    final isWalletGenerating = context.select<VerifyEmailCubit, bool>(
      (cubit) => cubit.state is GeneratingWallet,
    );

    // Combine both loading states
    final showLoader = isRegularLoading || isWalletGenerating;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<VerifyEmailCubit, EmailState>(
            listener: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              if (state is VerifyingOtpStateSuccessState) {
                NotificationService.showSuccess(
                  l10n.emailVerifiedCompleteProfile,
                );
              } else if (state is VerifyingNewUserSuccessState) {
                NotificationService.showNotification(
                  message: l10n.emailVerifiedCompleteProfile,
                );
              } else if (state is VerifyingOtpStateFailureState) {
                NotificationService.showError(
                  state.message.isEmpty ? l10n.failedVerifyOtp : state.message,
                );
              } else if (state is VerifyingNewUserFailureState) {
                NotificationService.showError(
                  state.message.isEmpty ? l10n.failedVerifyEmail : state.message,
                );
              } else if (state is SendingOtpSuccessState) {
                NotificationService.showSuccess(l10n.verificationCodeSent);
              } else if (state is SendingOtpFailureState) {
                NotificationService.showError(l10n.failedSendVerificationCode);
              }
            },
          ),
        ],
        child: OverlayLoader(
          isLoading: showLoader,
          loadingIndicator: isWalletGenerating
              ? _buildWalletGeneratingIndicator(context)
              : null,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(),
                  VSpace(53),
                  Text(
                    AppLocalizations.of(context)!.enterCode,
                    style: AppTextStyles.xxl(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  VSpace(10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${AppLocalizations.of(context)!.activationCodeSentTo} ',
                          style: AppTextStyles.baseRegular(context),
                        ),
                        TextSpan(
                          text: context.select<VerifyEmailCubit, String>(
                            (cubit) => cubit.state.email,
                          ),
                          style: AppTextStyles.baseBold(context),
                        ),
                      ],
                    ),
                  ),
                  VSpace(51),
                  OTPInputWidget(
                    formKey: _otpKey,
                    fieldHeight: MediaQuery.of(context).size.height * 0.06,
                    fieldWidth: MediaQuery.of(context).size.width * 0.12,
                    borderRadius: 12,
                    fillColor: Colors.white,
                    focusedBorderColor: AppColors.gray900,
                    borderColor: AppColors.gray10,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        disableButton = value.length != 6;
                      });
                    },
                    onCompleted: (value) {
                      setState(() {
                        enteredOTP = value;
                        isCompleted = true;
                        disableButton = false;
                      });
                    },
                  ),
                  VSpace(20),
                  BlocBuilder<TimerCubit, TimerState>(
                    builder: (context, timerState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (timerState is TimerRunning) ...[
                            Text(
                              '${AppLocalizations.of(context)!.resendCodeIn} ',
                              style: AppTextStyles.baseRegular(
                                context,
                              ).copyWith(color: AppColors.gray700),
                            ),
                            Text(
                              context.read<TimerCubit>().formatTime(
                                timerState.remainingSeconds,
                              ),
                              style: AppTextStyles.baseBold(
                                context,
                              ).copyWith(color: AppColors.primaryColor),
                            ),
                          ] else if (timerState is TimerCompleted) ...[
                            SendCodeButton(
                              onPressed: _onResendPressed,
                              textColor: AppColors.primaryColor,
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  VSpace(15),
                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    backgroundColor: disableButton
                        ? AppColors.gray10
                        : AppColors.gray900,
                    textStyle: AppTextStyles.baseSemiBold(context).copyWith(
                      color: disableButton
                          ? AppColors.gray900
                          : AppColors.gray50,
                    ),
                    text: AppLocalizations.of(context)!.verify,
                    onPressed: () {
                      if (!disableButton &&
                          (_otpKey.currentState?.validate() ?? false)) {
                        final email = context
                            .read<VerifyEmailCubit>()
                            .state
                            .email;
                        context.read<VerifyEmailCubit>().handleOtpLoginFlow(
                          email: email,
                          otp: enteredOTP,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletGeneratingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
          VSpace(20),
          Text(
            AppLocalizations.of(context)!.stayPut,
            style: AppTextStyles.mdSemiBold(context),
            textAlign: TextAlign.center,
          ),
          VSpace(8),
          Text(
            AppLocalizations.of(context)!.somethingGoodUnderway,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
