import 'package:another_flushbar/flushbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class DepositSuccessfulScreen extends StatefulWidget {
  const DepositSuccessfulScreen({
    super.key,
    required this.selectedImage,
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

  final String selectedImage;
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
  State<DepositSuccessfulScreen> createState() =>
      _DepositSuccessfulScreenState();
}

class _DepositSuccessfulScreenState extends State<DepositSuccessfulScreen>
    with ResponsiveMixin {
  bool _hasShownConfetti = false;
  bool _hasShownErrorSnackbar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final order = context.read<WalletCubit>().state.onRampOrderResponse;
      if (order != null) {
        context.read<WalletCubit>().confirmOnRampOrder(
          transactionId: order.transactionId,
          fonbnkOrderId: order.fonbnkOrderId,
        );
      }
    });
  }

  void _showErrorSnackbarIfFailed(bool isFailed, String? errorMessage) {
    if (isFailed && !_hasShownErrorSnackbar && mounted) {
      _hasShownErrorSnackbar = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Flushbar(
            message: errorMessage ?? 'Something went wrong. Please try again.',
            backgroundColor: AppColors.error600,
            flushbarPosition: FlushbarPosition.TOP,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(8),
            icon: const Icon(Icons.error_outline, color: Colors.white),
          ).show(context);
        }
      });
    }
  }

  void _showConfettiIfCompleted(bool isCompleted) {
    if (isCompleted && !_hasShownConfetti && mounted) {
      _hasShownConfetti = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Confetti.launch(
            context,
            options: const ConfettiOptions(
              particleCount: 150,
              spread: 90,
              y: 0.6,
              startVelocity: 45,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.red,
                Colors.purple,
                Colors.orange,
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final isConfirming =
                state.onRampConfirmStatus == OnRampConfirmStatus.confirming;

            final transactionCompleted =
                state.onRampConfirmStatus == OnRampConfirmStatus.success;

            final transactionFailed =
                state.onRampConfirmStatus == OnRampConfirmStatus.failed;

            _showConfettiIfCompleted(transactionCompleted);
            _showErrorSnackbarIfFailed(
              transactionFailed,
              state.onRampConfirmError,
            );

            return PopScope(
              canPop: false,
              child: Scaffold(
                appBar: AppBarFactory.centeredTitleAppBar(
                  title: 'Deposit',
                  backgroundColor: const Color(0xffF8F9FC),
                  bottom: isConfirming
                      ? PreferredSize(
                          preferredSize: const Size.fromHeight(4),
                          child: LinearProgressIndicator(
                            backgroundColor: AppColors.gray200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryMain,
                            ),
                          ),
                        )
                      : null,
                ),
                backgroundColor: const Color(0xffF8F9FC),
                body: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableHeight = constraints.maxHeight;
                      final minContentHeight = availableHeight * 0.85;
                      final onRamOrder = state.onRampOrderResponse;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: minContentHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: responsiveInfo.responsiveMargin * 3,
                              child: Column(
                                children: [
                                  VSpace(getTopPadding(responsiveInfo)),
                                  _buildHeaderImage(
                                    responsiveInfo,
                                    transactionCompleted,
                                  ),
                                  if (!transactionCompleted) ...[
                                    VSpace(getResponsiveDimension(context, 24)),
                                    _buildPaymentDetailsCard(
                                      context,
                                      responsiveInfo,
                                      state,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.primary25,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          responsiveInfo.responsiveBorderRadius,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: AppColors.primaryMain,
                                          ),
                                          Text(
                                            onRamOrder
                                                    ?.transferInstructions
                                                    .warningText ??
                                                'Please complete the payment within the next 15 minutes to avoid order cancellation.',
                                            style:
                                                AppTextStyles.smRegular(
                                                  context,
                                                ).copyWith(
                                                  fontSize:
                                                      getResponsiveFontSize(
                                                        context,
                                                        12,
                                                      ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  VSpace(getResponsiveDimension(context, 30)),
                                  _buildButtonSection(
                                    context,
                                    responsiveInfo,
                                    transactionCompleted,
                                    transactionFailed,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderImage(ResponsiveInfo responsiveInfo, bool isCompleted) {
    if (!isCompleted) return const SizedBox.shrink();

    final imageSize = getResponsiveValue<double>(
      context: context,
      small: 280,
      medium: 300,
      large: 320,
      xlarge: 340,
    );

    return Center(
      child: Image.asset(
        Assets.images.lennyHappy.path,
        width: imageSize,
        height: imageSize * 0.8,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPaymentDetailsCard(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    WalletState state,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          responsiveInfo.responsiveBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(getResponsiveDimension(context, 20)),
      child: Column(
        children: [
          Text(
            'Payment Details',
            style: AppTextStyles.mdSemiBold(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 20)),
          ),
          VSpace(getResponsiveDimension(context, 22)),
          _buildPaymentDetailsRows(context, state),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsRows(BuildContext context, WalletState state) {
    final rowSpacing = getResponsiveDimension(context, 16);
    final order = state.onRampOrderResponse;
    final details = order?.transferInstructions.transferDetails ?? [];

    return Column(
      children: [
        for (int i = 0; i < details.length; i++) ...[
          _BuildRow(
            title: details[i].label,
            value: details[i].value,
            titleStyle: AppTextStyles.base(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
            valueStyle: AppTextStyles.baseSemiBold(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
            onCopy: details[i].id == 'bankTransferNarration'
                ? () async {
                    await Clipboard.setData(
                      ClipboardData(text: details[i].value),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Narration code copied'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                : null,
          ),
          if (i < details.length - 1) VSpace(rowSpacing),
        ],
        if (order != null) ...[
          VSpace(rowSpacing),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 4.0,
            dashColor: AppColors.gray70,
          ),
          VSpace(rowSpacing),
          _BuildRow(
            title: 'USDT to Receive',
            value: '${order.cryptoAmount.toStringAsFixed(2)} USDT',
            titleStyle: AppTextStyles.base(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
            valueStyle: AppTextStyles.baseSemiBold(context).copyWith(
              fontSize: getResponsiveFontSize(context, 20),
              color: AppColors.gray900,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    bool transactionCompleted,
    bool transactionFailed,
  ) {
    final buttonHeight = getResponsiveDimension(context, 50);
    final buttonSpacing = getResponsiveDimension(context, 16);

    return Column(
      children: [
        if (transactionFailed) ...[
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () {
                context.read<WalletCubit>().resetAllStates();
                context.router.pop();
              },
              text: 'Try Again',
              textStyle: AppTextStyles.baseSemiBold(context).copyWith(
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 16),
              ),
              isFullWidth: true,
            ),
          ),
          VSpace(buttonSpacing),
        ],
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ButtonFactory.blackButton(
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: () {
              context.read<WalletCubit>().fetchWalletData();
              context.read<WalletCubit>().resetAllStates();
              context.router.popUntil(
                (route) => route.settings.name == MainActivityRoute.name,
              );
            },
            text: 'Go Home',
            textStyle: AppTextStyles.baseSemiBold(context).copyWith(
              color: Colors.white,
              fontSize: getResponsiveFontSize(context, 16),
            ),
            isFullWidth: true,
          ),
        ),
      ],
    );
  }
}

class _BuildRow extends StatelessWidget {
  const _BuildRow({
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.onCopy,
  });

  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final VoidCallback? onCopy;

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
              Flexible(
                child: Text(
                  value,
                  style: valueStyle ?? AppTextStyles.baseSemiBold(context),
                  textAlign: TextAlign.end,
                ),
              ),
              if (onCopy != null) ...[
                const HSpace(4),
                GestureDetector(
                  onTap: onCopy,
                  child: Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: AppColors.primaryMain,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
