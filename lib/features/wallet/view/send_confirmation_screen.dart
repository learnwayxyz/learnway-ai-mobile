import 'package:auto_route/auto_route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class SendConfirmationScreen extends StatefulWidget {
  const SendConfirmationScreen({
    super.key,
    required this.recipientAddress,
    required this.amount,
  });

  final String recipientAddress;
  final String amount;

  @override
  State<SendConfirmationScreen> createState() => _SendConfirmationScreenState();
}

class _SendConfirmationScreenState extends State<SendConfirmationScreen>
    with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: AppLocalizations.of(context)!.sendConfirmation,
            barHeight: 0,
          ),
          backgroundColor: const Color(0xffF8F9FC),
          body: BlocConsumer<WalletCubit, WalletState>(
            listener: (context, state) {
              if (state.otpVerificationStatus == OtpVerificationStatus.sent) {
                context.router.replace(
                  TransactionVerifyOtpRoute(
                    recipientAddress: widget.recipientAddress,
                    amount: widget.amount,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: responsiveInfo.responsiveMargin * 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(getResponsiveDimension(context, 28)),
                    Text(
                      AppLocalizations.of(context)!.transferConfirmation,
                      style: AppTextStyles.xxlBold(
                        context,
                      ).copyWith(fontSize: getResponsiveFontSize(context, 28)),
                    ),
                    VSpace(getResponsiveDimension(context, 10)),
                    Text(
                      AppLocalizations.of(context)!.checkBeforeProceeding,
                      style: AppTextStyles.md(
                        context,
                      ).copyWith(fontSize: getResponsiveFontSize(context, 16)),
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
                            style: AppTextStyles.mdSemiBold(context).copyWith(
                              fontSize: getResponsiveFontSize(context, 20),
                            ),
                          ),
                          VSpace(getResponsiveDimension(context, 22)),
                          BuildRow(
                            title: AppLocalizations.of(context)!.paymentAddress,
                            value: shortenAddress(widget.recipientAddress),
                          ),
                          VSpace(getResponsiveDimension(context, 16)),
                          BuildRow(
                            title: AppLocalizations.of(context)!.network,
                            value: 'Lisk',
                            leadingWidget: SizedBox(
                              height: 15,
                              width: 15,
                              child: Image.asset(Assets.images.lskImg.path),
                            ),
                          ),
                          VSpace(getResponsiveDimension(context, 16)),
                          BuildRow(title: AppLocalizations.of(context)!.fee, value: '0.00 USDT'),
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
                            title: AppLocalizations.of(context)!.tokenAmount,
                            value:
                                '${double.tryParse(widget.amount)?.toStringAsFixed(2)} USDT',
                          ),
                        ],
                      ),
                    ),
                    VSpace(getResponsiveDimension(context, 62)),
                    ButtonFactory.blackButton(
                      onPressed: state.isSendingOtp
                          ? () {}
                          : () {
                              context.read<WalletCubit>().sendTransactionOtp(
                                amount: widget.amount,
                                recipientAddress: widget.recipientAddress,
                              );
                            },
                      text: state.isSendingOtp ? AppLocalizations.of(context)!.sendingOtp : AppLocalizations.of(context)!.continueButton,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
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
