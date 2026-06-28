import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/ethereum_utils.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class OfframpSuccessScreen extends StatefulWidget {
  const OfframpSuccessScreen({
    super.key,
    required this.recipientNumber,
    required this.amountUsdt,
    required this.amountToReceive,
    required this.exchangeRate,
    required this.paymentChannel,
    required this.localCurrency,
    required this.orderId,
    required this.depositAddress,
    this.carrierName,
  });

  final String recipientNumber;
  final double amountUsdt;
  final double amountToReceive;
  final double exchangeRate;
  final String paymentChannel;
  final String localCurrency;
  final String? carrierName;
  final String orderId;
  final String depositAddress;

  @override
  State<OfframpSuccessScreen> createState() => _OfframpSuccessScreenState();
}

class _OfframpSuccessScreenState extends State<OfframpSuccessScreen>
    with ResponsiveMixin {
  bool _hasShownConfetti = false;

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
            final isPollingBlockConfirmation =
                state.pollingStatus == PoolStatus.loading ||
                state.transactionStatus == TransactionStatus.sending ||
                state.transactionStatus == TransactionStatus.pending;

            final isPollingTransactionStatus =
                state.offRampStatusState == OffRampStatus.processing;

            final isPolling =
                isPollingBlockConfirmation || isPollingTransactionStatus;

            final blockConfirmationComplete =
                state.pollingStatus == PoolStatus.loaded;

            final transactionCompleted =
                state.offRampStatusState == OffRampStatus.success;

            final transactionFailed =
                state.offRampStatusState == OffRampStatus.failed ||
                state.pollingStatus == PoolStatus.error;

            _showConfettiIfCompleted(transactionCompleted);

            return PopScope(
              canPop: false,
              child: Scaffold(
                appBar: AppBarFactory.centeredTitleAppBar(
                  title: AppLocalizations.of(context)!.withdraw,
                  backgroundColor: const Color(0xffF8F9FC),
                  bottom: isPolling
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
                                    transactionFailed,
                                  ),
                                  VSpace(getResponsiveDimension(context, 24)),
                                  _buildStatusText(
                                    context,
                                    state,
                                    transactionCompleted,
                                    transactionFailed,
                                  ),
                                  if (!transactionCompleted) ...[
                                    VSpace(getResponsiveDimension(context, 24)),
                                    _buildPaymentDetailsCard(
                                      context,
                                      responsiveInfo,
                                      state,
                                    ),
                                  ],
                                  VSpace(getResponsiveDimension(context, 30)),
                                  _buildButtonSection(
                                    context,
                                    responsiveInfo,
                                    state,
                                    blockConfirmationComplete,
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

  Widget _buildStatusText(
    BuildContext context,
    WalletState state,
    bool transactionCompleted,
    bool transactionFailed,
  ) {
    String title;
    String subtitle;

    final l10n = AppLocalizations.of(context)!;
    if (transactionFailed) {
      title = l10n.transactionFailed;
      subtitle = state.transactionError ?? l10n.somethingWentWrong;
    } else if (transactionCompleted) {
      title = l10n.withdrawalSuccessfulTitle;
      subtitle = l10n.withdrawalSuccessful(
        state.createOrderResponse?.fiatAmount?.toString() ?? '',
        widget.localCurrency,
      );
    } else if (state.pollingStatus == PoolStatus.loaded) {
      title = l10n.transferConfirmed;
      subtitle = l10n.onchainTransferComplete;
    } else if (state.transactionStatus == TransactionStatus.sending ||
        state.transactionStatus == TransactionStatus.pending) {
      title = l10n.processingTransfer;
      subtitle = l10n.sendingFundsToWithdrawal;
    } else {
      title = l10n.withdrawalOrderCreated;
      subtitle = l10n.withdrawalWillBeProcessed;
    }

    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.xlBold(
            context,
          ).copyWith(color: transactionFailed ? AppColors.error600 : null),
          textAlign: TextAlign.center,
        ),
        VSpace(getResponsiveDimension(context, 8)),
        Text(
          subtitle,
          style: AppTextStyles.base(context).copyWith(
            color: transactionFailed ? AppColors.error600 : AppColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHeaderImage(
    ResponsiveInfo responsiveInfo,
    bool isCompleted,
    bool isFailed,
  ) {
    final imageSize = isCompleted
        ? getResponsiveValue<double>(
            context: context,
            small: 280,
            medium: 300,
            large: 320,
            xlarge: 340,
          )
        : getResponsiveValue<double>(
            context: context,
            small: 200,
            medium: 220,
            large: 240,
            xlarge: 260,
          );

    if (!isFailed && !isCompleted) return const SizedBox.shrink();

    final imagePath = isFailed
        ? Assets.images.lennySad.path
        : Assets.images.lennyHappy.path;

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: Image.asset(
          imagePath,
          key: ValueKey(imagePath),
          width: imageSize,
          height: imageSize * 0.8,
          fit: BoxFit.contain,
        ),
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
          _buildPaymentDetailsRows(context, responsiveInfo, state),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsRows(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    WalletState state,
  ) {
    final rowSpacing = getResponsiveDimension(context, 16);

    return Column(
      children: [
        _BuildRow(
          title: 'Recipient Number',
          value: widget.recipientNumber,
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),
        VSpace(rowSpacing),
        _BuildRow(
          title: 'Payment Channel',
          value: _formatPaymentChannel(widget.paymentChannel),
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),
        if (widget.carrierName != null) ...[
          VSpace(rowSpacing),
          _BuildRow(
            title: 'Carrier',
            value: widget.carrierName!,
            titleStyle: AppTextStyles.base(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
            valueStyle: AppTextStyles.baseSemiBold(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          ),
        ],
        VSpace(rowSpacing),
        _BuildRow(
          title: 'Order ID',
          value: _shortenOrderId(widget.orderId),
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),
        VSpace(rowSpacing),
        _BuildRow(
          title: 'Amount (USDT)',
          value: '${widget.amountUsdt.toStringAsFixed(2)} USDT',
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(context).copyWith(
            fontSize: getResponsiveFontSize(context, 16),
            color: AppColors.gray900,
          ),
        ),
        VSpace(rowSpacing),
        _BuildRow(
          title: 'Exchange Rate',
          value:
              '1 USDT = ${widget.exchangeRate.toStringAsFixed(2)} ${widget.localCurrency}',
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),
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
          title: 'Amount to Receive',
          value:
              '${widget.localCurrency} ${widget.amountToReceive.toStringAsFixed(2)}',
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(context).copyWith(
            fontSize: getResponsiveFontSize(context, 20),
            color: AppColors.gray900,
          ),
        ),
        if (state.transactionHash != null) ...[
          VSpace(rowSpacing),
          _BuildRow(
            title: 'Transaction Hash',
            value: EthereumAddressUtils.shortenAddress(state.transactionHash!),
            titleStyle: AppTextStyles.base(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
            valueStyle: AppTextStyles.baseSemiBold(context).copyWith(
              fontSize: getResponsiveFontSize(context, 14),
              color: AppColors.primaryMain,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    WalletState state,
    bool blockConfirmationComplete,
    bool transactionCompleted,
    bool transactionFailed,
  ) {
    final buttonHeight = getResponsiveDimension(context, 50);
    final buttonSpacing = getResponsiveDimension(context, 16);

    return Column(
      children: [
        if (blockConfirmationComplete &&
            state.transactionHash != null &&
            !transactionCompleted) ...[
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () =>
                  _openTransactionInExplorer(state.transactionHash),
              text: 'View Onchain',
              textStyle: AppTextStyles.baseSemiBold(context).copyWith(
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, 16),
              ),
              isFullWidth: true,
            ),
          ),
          VSpace(buttonSpacing),
        ],
        if (transactionFailed) ...[
          SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ButtonFactory.blackButton(
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () {
                context.read<WalletCubit>().resetTransactionStatus();
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
              color: transactionFailed ? AppColors.gray900 : Colors.white,
              fontSize: getResponsiveFontSize(context, 16),
            ),
            backgroundColor: transactionFailed
                ? Colors.white
                : AppColors.gray900,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }

  Future<void> _openTransactionInExplorer(String? transactionHash) async {
    final blockExplorerBaseUrl = '${Env.explorerUrl}/tx/';
    final url = '$blockExplorerBaseUrl$transactionHash';
    log('Opening transaction in explorer: $url');

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open transaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  String _shortenOrderId(String orderId) {
    if (orderId.length <= 12) return orderId;
    return '${orderId.substring(0, 6)}...${orderId.substring(orderId.length - 4)}';
  }
}

class _BuildRow extends StatelessWidget {
  const _BuildRow({
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
  });

  final String title;
  final String value;
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
          child: Text(
            value,
            style: valueStyle ?? AppTextStyles.baseSemiBold(context),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
