import 'package:dotted_line/dotted_line.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class OfframpConfirmationScreen extends StatefulWidget {
  const OfframpConfirmationScreen({
    super.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    this.carrierName,
    this.offrampData,
  });

  final String recipientNumber;
  final double amountUsdt;
  final double amountToReceive;
  final double exchangeRate;
  final String paymentChannel;
  final String localCurrency;
  final String? carrierName;
  final StoreOffRampScreenTranscientData? offrampData;

  @override
  State<OfframpConfirmationScreen> createState() =>
      _OfframpConfirmationScreenState();
}

class _OfframpConfirmationScreenState extends State<OfframpConfirmationScreen>
    with ResponsiveMixin {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Scaffold(
          appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.withdraw, barHeight: 0),
          backgroundColor: const Color(0xffF8F9FC),
          body: SafeArea(
            child: BlocConsumer<WalletCubit, WalletState>(
              listener: (context, state) {
                if (_hasNavigated) return;

                if (state.otpVerificationStatus == OtpVerificationStatus.sent) {
                  _hasNavigated = true;
                  context.router.push(
                    OfframpVerificationRoute(
                      recipientNumber: widget.recipientNumber,
                      amountUsdt: widget.amountUsdt,
                      amountToReceive: widget.amountToReceive,
                      exchangeRate: widget.exchangeRate,
                      paymentChannel: widget.paymentChannel,
                      localCurrency: widget.localCurrency,
                      carrierName: widget.carrierName,
                      offrampData: widget.offrampData!,
                    ),
                  );
                }

                if (state.otpVerificationStatus ==
                    OtpVerificationStatus.failed) {
                  NotificationService.showError(
                    state.otpError ?? AppLocalizations.of(context)!.failedToSendVerificationCode,
                  );
                }
              },
              builder: (context, state) {
                final loader =
                    state.otpVerificationStatus ==
                    OtpVerificationStatus.sending;
                return SingleChildScrollView(
                  child: Padding(
                    padding: responsiveInfo.responsiveMargin * 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(getResponsiveDimension(context, 28)),
                        Text(
                          AppLocalizations.of(context)!.transferConfirmation,
                          style: AppTextStyles.xxlBold(context).copyWith(
                            fontSize: getResponsiveFontSize(context, 28),
                          ),
                        ),
                        VSpace(getResponsiveDimension(context, 10)),
                        Text(
                          AppLocalizations.of(context)!.checkBeforeProceeding,
                          style: AppTextStyles.md(context).copyWith(
                            fontSize: getResponsiveFontSize(context, 16),
                          ),
                        ),
                        VSpace(getResponsiveDimension(context, 20)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              responsiveInfo.responsiveBorderRadius,
                            ),
                          ),
                          padding: EdgeInsets.all(
                            getResponsiveDimension(context, 20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.paymentDetails,
                                style: AppTextStyles.mdSemiBold(context)
                                    .copyWith(
                                      fontSize: getResponsiveFontSize(
                                        context,
                                        20,
                                      ),
                                    ),
                              ),
                              VSpace(getResponsiveDimension(context, 22)),
                              BuildRow(
                                title: AppLocalizations.of(context)!.recipientNumber,
                                value: widget.recipientNumber,
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: AppLocalizations.of(context)!.paymentChannel,
                                value: _formatPaymentChannel(
                                  context,
                                  widget.paymentChannel,
                                ),
                              ),
                              if (widget.carrierName != null) ...[
                                VSpace(getResponsiveDimension(context, 16)),
                                BuildRow(
                                  title: AppLocalizations.of(context)!.carrier,
                                  value: widget.carrierName!,
                                ),
                              ],
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: AppLocalizations.of(context)!.amountUsdt,
                                value:
                                    '${widget.amountUsdt.toStringAsFixed(2)} USDT',
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: AppLocalizations.of(context)!.exchangeRate,
                                value:
                                    '1 USDT = ${widget.exchangeRate.toStringAsFixed(2)} ${widget.localCurrency}',
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: AppColors.gray70,
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: AppLocalizations.of(context)!.amountToReceive,
                                value:
                                    '${widget.localCurrency} ${widget.amountToReceive.toStringAsFixed(2)}',
                                titleStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                valueStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VSpace(getResponsiveDimension(context, 40)),
                        ButtonFactory.blackButton(
                          isLoading: loader,
                          onPressed: _onConfirmPressed,
                          text: AppLocalizations.of(context)!.confirm,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _formatPaymentChannel(BuildContext context, String channel) {
    final l10n = AppLocalizations.of(context)!;
    switch (channel.toLowerCase()) {
      case 'mobile_money':
        return l10n.mobileMoney;
      case 'airtime':
        return l10n.airtime;
      case 'bank':
        return l10n.bankTransfer;
      default:
        return channel;
    }
  }

  void _onConfirmPressed() {
    context.read<WalletCubit>().sendTransactionOtp(
      amount: widget.amountUsdt.toString(),
      recipientAddress: widget.recipientNumber,
    );
  }
}

class BuildRow extends StatelessWidget {
  const BuildRow({
    super.key,
    required this.title,
    required this.value,
    this.status,
    this.leadingWidget,
    this.titleStyle,
    this.valueStyle,
  });
  final String title;
  final String value;
  final Widget? status;
  final Widget? leadingWidget;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: titleStyle ?? AppTextStyles.smRegular(context),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (leadingWidget != null) ...[leadingWidget!],
              if (status == null)
                Flexible(
                  child: Text(
                    value,
                    style: valueStyle ?? AppTextStyles.baseSemiBold(context),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                status!,
            ],
          ),
        ),
      ],
    );
  }
}
