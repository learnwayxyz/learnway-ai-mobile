import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/auth/authenticate_email/cubit/timer_cubit.dart';
import 'package:learnwayv2/features/verify_phone/widgets/otp_input_widget.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:learnwayv2/shared/widgets/send_button_widget.dart';

@RoutePage()
class OfframpVerificationScreen extends StatefulWidget {
  const OfframpVerificationScreen({
    super.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.offrampData,
    this.carrierName,
  });

  final String recipientNumber;
  final double amountUsdt;
  final double amountToReceive;
  final double exchangeRate;
  final String paymentChannel;
  final String localCurrency;
  final String? carrierName;
  final StoreOffRampScreenTranscientData offrampData;

  @override
  State<OfframpVerificationScreen> createState() =>
      _OfframpVerificationScreenState();
}

class _OfframpVerificationScreenState extends State<OfframpVerificationScreen> {
  final _otpKey = GlobalKey<FormState>();
  String enteredOTP = '';
  bool isCompleted = false;
  bool disableButton = true;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    context.read<TimerCubit>().startTimer();
  }

  void _onResendPressed() {
    context.read<WalletCubit>().sendTransactionOtp(
      amount: widget.amountUsdt.toString(),
      recipientAddress: widget.recipientNumber,
    );
    context.read<TimerCubit>().restartTimer();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<WalletCubit, bool>(
      (cubit) => cubit.state.isSendingOtp || cubit.state.isVerifyingOtp,
    );

    final isOrderCreating = context.select<WalletCubit, bool>(
      (cubit) => cubit.state.createOrderStatus == CreateOrderStatus.creating,
    );

    final showLoader = isLoading || isOrderCreating;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletCubit, WalletState>(
            listenWhen: (previous, current) {
              return !_hasNavigated &&
                  (previous.otpVerificationStatus !=
                          current.otpVerificationStatus ||
                      previous.createOrderStatus != current.createOrderStatus);
            },
            listener: (context, state) {
              if (_hasNavigated) return;

              if (state.otpVerificationStatus ==
                      OtpVerificationStatus.verified &&
                  state.createOrderStatus != CreateOrderStatus.creating &&
                  state.createOrderStatus != CreateOrderStatus.success) {
                NotificationService.showSuccess(
                  AppLocalizations.of(context)!.emailVerifiedSuccessfully,
                );
                context.read<WalletCubit>().createOffRampOrder(
                  request: widget.offrampData,
                );
              }

              if (state.createOrderStatus == CreateOrderStatus.creating) {
                _hasNavigated = true;
                context.router.push(
                  OfframpLoaderRoute(
                    recipientNumber: widget.recipientNumber,
                    amountUsdt: widget.amountUsdt,
                    amountToReceive: widget.amountToReceive,
                    exchangeRate: widget.exchangeRate,
                    paymentChannel: widget.paymentChannel,
                    localCurrency: widget.localCurrency,
                    carrierName: widget.carrierName,
                    offrampData: widget.offrampData,
                  ),
                );
              }

              if (state.hasOtpError) {
                NotificationService.showError(
                  state.otpError ??
                      AppLocalizations.of(context)!.failedVerifyOtp,
                );
              }

              if (state.isOtpSent &&
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
          loadingIndicator: _buildProcessingIndicator(context),
          child: Scaffold(
            appBar: AppBarFactory.standardAppBar(
              title: AppLocalizations.of(context)!.verifyTransaction,
              showBackButton: !isOrderCreating,
              barHeight: 0,
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
                          text:
                              ' ${AppLocalizations.of(context)!.toConfirmThisTransaction}',
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
                    text: AppLocalizations.of(context)!.verifyAndContinue,
                    onPressed: disableButton || isOrderCreating
                        ? () {}
                        : () {
                            if (_otpKey.currentState?.validate() ?? false) {
                              context.read<WalletCubit>().verifyTransactionOtp(
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

  Widget _buildProcessingIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.verifyingCode,
          style: AppTextStyles.smSemiBold(context),
        ),
      ],
    );
  }
}
