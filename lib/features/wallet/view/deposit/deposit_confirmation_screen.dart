import 'package:dotted_line/dotted_line.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/fonbnk_config.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/dto/onramp_order_params.dart';
import 'package:learnwayv2/features/wallet/view/withdraw/offramp_confirmation_screen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class OnrampDepositConfirmationScreen extends StatefulWidget {
  const OnrampDepositConfirmationScreen({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.paymentChannel,
    required this.fiatAmount,
    required this.usdtAmount,
    required this.exchangeRate,
    required this.feeAmount,
    required this.localCurrencyCode,
    required this.localCurrencySymbol,
    required this.countryCode,
    required this.quoteId,
    this.carrierCode = '',
    this.carrierName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
  });

  final String phoneNumber;
  final String fullName;
  final String paymentChannel;
  final double fiatAmount;
  final double usdtAmount;
  final double exchangeRate;
  final double feeAmount;
  final String localCurrencyCode;
  final String localCurrencySymbol;
  final String countryCode;
  final String quoteId;
  final String carrierCode;
  final String carrierName;
  final String bankCode;
  final String bankAccountNumber;

  @override
  State<OnrampDepositConfirmationScreen> createState() =>
      _OnrampDepositConfirmationScreenState();
}

class _OnrampDepositConfirmationScreenState
    extends State<OnrampDepositConfirmationScreen>
    with ResponsiveMixin {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return Scaffold(
          appBar: AppBarFactory.standardAppBar(title: 'Deposit', barHeight: 0),
          backgroundColor: const Color(0xffF8F9FC),

          body: SafeArea(
            child: BlocConsumer<WalletCubit, WalletState>(
              listener: (context, state) {
                // if (_hasNavigated) return;

                // if (state.onRampOrderStatus == OnRampOrderStatus.success &&
                //     state.onRampOrderResponse != null) {
                //   _hasNavigated = true;
                //   NotificationService.showSuccess(
                //     'Deposit order created. Follow the payment instructions.',
                //   );
                // }

                if (state.onRampOrderStatus == OnRampOrderStatus.failed) {
                  NotificationService.showError(
                    state.onRampOrderError ?? 'Failed to initialize deposit',
                  );
                }

                if (state.onRampOrderStatus == OnRampOrderStatus.creating) {
                  context.router.push(
                    DepositLoaderRoute(
                      countryCode: widget.countryCode,
                      exchangeRate: widget.exchangeRate,
                      feeAmount: widget.feeAmount,
                      fiatAmount: widget.fiatAmount,
                      fullName: widget.fullName,
                      localCurrencyCode: widget.localCurrencyCode,
                      localCurrencySymbol: widget.localCurrencySymbol,
                      paymentChannel: widget.paymentChannel,
                      phoneNumber: widget.phoneNumber,
                      quoteId: widget.quoteId,
                      selectedImage: '',
                      usdtAmount: widget.usdtAmount,
                      bankAccountNumber: widget.bankAccountNumber,
                      bankCode: widget.bankCode,
                      carrierCode: widget.carrierCode,
                      carrierName: widget.carrierName,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final loader =
                    state.onRampOrderStatus == OnRampOrderStatus.creating;

                return SingleChildScrollView(
                  child: Padding(
                    padding: responsiveInfo.responsiveMargin * 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(getResponsiveDimension(context, 28)),
                        Text(
                          'Deposit Confirmation',
                          style: AppTextStyles.xxlBold(context).copyWith(
                            fontSize: getResponsiveFontSize(context, 28),
                          ),
                        ),
                        VSpace(getResponsiveDimension(context, 10)),
                        Text(
                          'Check before proceeding with your deposit.',
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
                                'Payment Details',
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
                                title: 'Phone Number',
                                value: widget.phoneNumber,
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: 'Full Name',
                                value: widget.fullName,
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: 'Payment Channel',
                                value: _formatPaymentChannel(
                                  widget.paymentChannel,
                                ),
                              ),
                              if (widget.carrierName.isNotEmpty) ...[
                                VSpace(getResponsiveDimension(context, 16)),
                                BuildRow(
                                  title: 'Carrier',
                                  value: widget.carrierName,
                                ),
                              ],
                              if (widget.bankAccountNumber.isNotEmpty) ...[
                                VSpace(getResponsiveDimension(context, 16)),
                                BuildRow(
                                  title: 'Account Number',
                                  value: widget.bankAccountNumber,
                                ),
                              ],
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: 'Amount to Pay',
                                value:
                                    '${widget.localCurrencySymbol} ${widget.fiatAmount.toStringAsFixed(2)}',
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: 'Exchange Rate',
                                value:
                                    '1 USDT = ${widget.localCurrencySymbol} ${widget.exchangeRate.toStringAsFixed(2)}',
                              ),
                              VSpace(getResponsiveDimension(context, 16)),
                              BuildRow(
                                title: 'Fee',
                                value:
                                    '${widget.localCurrencySymbol} ${widget.feeAmount.toStringAsFixed(2)}',
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
                                title: 'Amount to Receive',
                                value:
                                    '${widget.usdtAmount.toStringAsFixed(2)} USDT',
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
                          text: 'Confirm',
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

  String _formatPaymentChannel(String channel) {
    switch (channel.toLowerCase()) {
      case 'mobile_money':
        return 'Mobile Money';
      case 'airtime':
        return 'Airtime';
      case 'bank':
        return 'Bank Transfer';
      default:
        return channel;
    }
  }

  void _onConfirmPressed() {
    final userEmail = LocalStorageService.getUserSync()?.email ?? '';
    final quoteId =
        context.read<WalletCubit>().state.onRampQuoteResponse?.quoteId ??
        widget.quoteId;

    context.read<WalletCubit>().initializeOnRampOrder(
      params: OnRampOrderParams(
        fiatCurrency: widget.localCurrencyCode,
        fiatAmount: widget.fiatAmount,
        depositChannel: widget.paymentChannel,
        cryptoCurrency: FonbnkConfig.asset,
        cryptoNetwork: FonbnkConfig.network,
        countryCode: widget.countryCode,
        userEmail: userEmail,
        quoteId: quoteId,
        phoneNumber: widget.phoneNumber.isNotEmpty ? widget.phoneNumber : null,
        fullName: widget.fullName.isNotEmpty ? widget.fullName : null,
        carrierCode: widget.carrierCode.isNotEmpty ? widget.carrierCode : null,
        bankCode: widget.bankCode.isNotEmpty ? widget.bankCode : null,
        bankAccountNumber: widget.bankAccountNumber.isNotEmpty
            ? widget.bankAccountNumber
            : null,
      ),
    );
  }
}
