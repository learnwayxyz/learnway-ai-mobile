import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/timer_cubit.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:learnwayv2/shared/widgets/send_button_widget.dart';

@RoutePage()
class TransactionVerifyOtpScreen extends StatefulWidget {
  const TransactionVerifyOtpScreen({
    super.key,
    required this.amount,
    required this.recipientAddress,
  });

  final String amount;
  final String recipientAddress;

  @override
  State<TransactionVerifyOtpScreen> createState() =>
      _TransactionVerifyOtpScreenState();
}

class _TransactionVerifyOtpScreenState
    extends State<TransactionVerifyOtpScreen> {
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
    context.read<WalletCubit>().sendTransactionOtp(
      amount: widget.amount,
      recipientAddress: widget.recipientAddress,
    );
    context.read<TimerCubit>().restartTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<WalletCubit, bool>(
      (cubit) => cubit.state.isSendingOtp || cubit.state.isVerifyingOtp,
    );

    final isTransactionInProgress = context.select<WalletCubit, bool>(
      (cubit) => cubit.state.isSendingTransaction,
    );

    final showLoader = isLoading || isTransactionInProgress;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletCubit, WalletState>(
            listener: (context, state) {
              if (state.isOtpVerified && state.isSendingTransaction) {
                context.router.push(
                  SendLoaderRoute(
                    title: AppLocalizations.of(context)!.send,
                    recipientAddress: widget.recipientAddress,
                    amount: widget.amount,
                  ),
                );
              } else if (state.hasOtpError) {
                NotificationService.showError(
                  state.otpError ?? AppLocalizations.of(context)!.failedVerifyOtp,
                );
              } else if (state.isOtpSent &&
                  state.otpVerificationStatus == OtpVerificationStatus.sent) {
                NotificationService.showSuccess(
                  AppLocalizations.of(context)!.verificationCodeSent,
                );
              }
            },
          ),
        ],
        child: OverlayLoader(
          isLoading: showLoader,
          loadingIndicator: isTransactionInProgress
              ? _buildTransactionProcessingIndicator(context)
              : null,
          child: Scaffold(
            appBar: AppBarFactory.standardAppBar(
              title: AppLocalizations.of(context)!.verifyTransaction,
              showBackButton: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(20),
                  Text(
                    AppLocalizations.of(context)!.verifyTransaction,
                    style: AppTextStyles.xxl(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  VSpace(10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${AppLocalizations.of(context)!.verificationCodeSentToEmail} ',
                          style: AppTextStyles.baseRegular(context),
                        ),
                        TextSpan(
                          text: LocalStorageService.getUserSync()?.email ?? '',
                          style: AppTextStyles.baseBold(context),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context)!.toConfirmThisTransaction}',
                          style: AppTextStyles.baseRegular(context),
                        ),
                      ],
                    ),
                  ),
                  VSpace(30),
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
                    text: AppLocalizations.of(context)!.verifyAndSend,
                    onPressed: () {
                      if (!disableButton &&
                          (_otpKey.currentState?.validate() ?? false)) {
                        context.read<WalletCubit>().verifyTransactionOtp(
                          otp: enteredOTP,
                          onVerified: () {
                            context.read<WalletCubit>().transferToken(
                              recipientAddress: widget.recipientAddress,
                              amount: widget.amount,
                            );
                          },
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

  Widget _buildTransactionProcessingIndicator(BuildContext context) {
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
          VSpace(20),
          Text(
            AppLocalizations.of(context)!.processingTransaction,
            style: AppTextStyles.mdSemiBold(context),
            textAlign: TextAlign.center,
          ),
          VSpace(8),
          Text(
            AppLocalizations.of(context)!.pleaseWaitWhileWeProcess,
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
