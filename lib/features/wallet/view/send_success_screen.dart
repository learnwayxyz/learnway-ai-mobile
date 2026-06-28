import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:core/src/config/env/env.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/view/send_confirmation_screen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/ethereum_utils.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SendSuccessScreen extends StatefulWidget {
  const SendSuccessScreen({
    super.key,
    required this.recipientAddress,
    required this.amount,
    required this.transactionHash,
  });

  final String recipientAddress;
  final String amount;
  final String transactionHash;

  @override
  State<SendSuccessScreen> createState() => _SendSuccessScreenState();
}

class _SendSuccessScreenState extends State<SendSuccessScreen>
    with ResponsiveMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionHash = context.select<WalletCubit, String?>(
      (value) => value.state.transactionHash,
    );

    final transactionStatus = context.select<WalletCubit, TransactionStatus?>(
      (value) => value.state.transactionStatus,
    );

    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBarFactory.standardAppBar(
              title: AppLocalizations.of(context)!.send,
              showBackButton: false,
              barHeight: 0,
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
                      constraints: BoxConstraints(minHeight: minContentHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: responsiveInfo.responsiveMargin * 3,
                          child: Column(
                            children: [
                              VSpace(getTopPadding(responsiveInfo)),

                              _buildHeaderImage(responsiveInfo),

                              VSpace(getResponsiveDimension(context, 24)),
                              _buildPaymentDetailsCard(
                                context,
                                responsiveInfo,
                                transactionStatus,
                              ),
                              const Spacer(flex: 2),
                              _buildButtonSection(
                                context,
                                responsiveInfo,
                                transactionHash,
                                transactionStatus,
                              ),

                              VSpace(getResponsiveDimension(context, 24)),
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
  }

  Widget _buildHeaderImage(ResponsiveInfo responsiveInfo) {
    final imageSize = getResponsiveValue<double>(
      context: context,
      small: 250,
      medium: 260,
      large: 280,
      xlarge: 290,
    );

    return Center(
      child: Image.asset(
        Assets.images.tetherImage.path,
        width: imageSize,
        height: imageSize * 0.8,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPaymentDetailsCard(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    TransactionStatus? transactionStatus,
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(getResponsiveDimension(context, 20)),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.paymentDetails,
            style: AppTextStyles.mdSemiBold(
              context,
            ).copyWith(fontSize: getResponsiveFontSize(context, 20)),
          ),

          VSpace(getResponsiveDimension(context, 22)),

          _buildPaymentDetailsRows(context, responsiveInfo, transactionStatus),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsRows(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    TransactionStatus? transactionStatus,
  ) {
    final rowSpacing = getResponsiveDimension(context, 16);

    final l10n = AppLocalizations.of(context)!;
    Map<String, dynamic> getStatusInfo(TransactionStatus? status) {
      switch (status) {
        case TransactionStatus.success:
          return {
            'text': l10n.success,
            'backgroundColor': AppColors.success100,
            'textColor': AppColors.success500,
          };
        case TransactionStatus.pending:
          return {
            'text': l10n.pending,
            'backgroundColor': AppColors.warning100,
            'textColor': AppColors.warning500,
          };
        case TransactionStatus.failed:
          return {
            'text': l10n.failed,
            'backgroundColor': AppColors.error100,
            'textColor': AppColors.error500,
          };
        case TransactionStatus.sending:
          return {
            'text': l10n.sending,
            'backgroundColor': AppColors.primary100,
            'textColor': AppColors.primary500,
          };
        default:
          return {
            'text': l10n.unknown,
            'backgroundColor': AppColors.gray100,
            'textColor': AppColors.gray500,
          };
      }
    }

    final statusInfo = getStatusInfo(transactionStatus);

    return Column(
      children: [
        BuildRow(
          title: l10n.network,
          value: 'LSK',
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),

        VSpace(rowSpacing),

        BuildRow(
          title: l10n.paymentAddress,
          value: EthereumAddressUtils.shortenAddress(widget.recipientAddress),
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),

        VSpace(rowSpacing),

        BuildRow(
          title: l10n.fee,
          value: '0.00 USDT',
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

        BuildRow(
          title: l10n.tokenAmount,
          value: '${double.tryParse(widget.amount)?.toStringAsFixed(2)} USDT',
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
          valueStyle: AppTextStyles.baseSemiBold(context).copyWith(
            fontSize: getResponsiveFontSize(context, 16),
            color: AppColors.gray900,
          ),
        ),

        VSpace(rowSpacing),

        BuildRow(
          title: l10n.paymentStatus,
          value: statusInfo['text'],
          status: Container(
            decoration: BoxDecoration(
              color: statusInfo['backgroundColor'],
              borderRadius: BorderRadius.circular(
                getResponsiveDimension(context, 60),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveDimension(context, 12),
              vertical: getResponsiveDimension(context, 6),
            ),
            child: Text(
              statusInfo['text'],
              style: AppTextStyles.smSemiBold(context).copyWith(
                color: statusInfo['textColor'],
                fontSize: getResponsiveFontSize(context, 12),
              ),
            ),
          ),
          titleStyle: AppTextStyles.base(
            context,
          ).copyWith(fontSize: getResponsiveFontSize(context, 14)),
        ),
      ],
    );
  }

  Widget _buildButtonSection(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
    String? transactionHash,
    TransactionStatus? transactionStatus,
  ) {
    final buttonHeight = getResponsiveDimension(context, 50);
    final buttonSpacing = getResponsiveDimension(context, 16);

    final canViewTransaction =
        transactionStatus == TransactionStatus.success ||
        transactionStatus == TransactionStatus.pending;

    return Column(
      children: [
        VSpace(40),
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ButtonFactory.blackButton(
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: canViewTransaction && transactionHash != null
                ? () async {
                    await _openTransactionInExplorer(transactionHash);
                  }
                : () {},
            text: AppLocalizations.of(context)!.viewOnchain,
            textStyle: AppTextStyles.baseSemiBold(context).copyWith(
              color: canViewTransaction ? Colors.white : AppColors.gray400,
              fontSize: getResponsiveFontSize(context, 16),
            ),
            isFullWidth: true,
          ),
        ),

        VSpace(buttonSpacing),
        SizedBox(
          width: double.infinity,
          height: buttonHeight,
          child: ButtonFactory.blackButton(
            mainAxisAlignment: MainAxisAlignment.center,
            onPressed: () {
              context.read<WalletCubit>().fetchWalletData();
              context.router.popUntil(
                (route) => route.settings.name == MainActivityRoute.name,
              );
            },
            text: AppLocalizations.of(context)!.goHome,
            textStyle: AppTextStyles.baseSemiBold(context).copyWith(
              color: AppColors.gray900,
              fontSize: getResponsiveFontSize(context, 16),
            ),
            backgroundColor: Colors.white,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }

  Future<void> _openTransactionInExplorer(String? transactionHash) async {
    String blockExplorerBaseUrl = '${Env.explorerUrl}/tx/';
    final url = '$blockExplorerBaseUrl$transactionHash';
    log('Opening transaction in explorer: $url');

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (!mounted) return;
      final errorMsg = AppLocalizations.of(
        context,
      )!.couldNotOpenTransaction(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }
}
