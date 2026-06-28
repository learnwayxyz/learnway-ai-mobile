import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class DepositUssdScreen extends StatefulWidget {
  const DepositUssdScreen({
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

  @override
  State<DepositUssdScreen> createState() => _DepositUssdScreenState();
}

class _DepositUssdScreenState extends State<DepositUssdScreen>
    with ResponsiveMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listenWhen: (previous, current) =>
          previous.onRampIntermediateStatus != current.onRampIntermediateStatus,
      listener: (context, state) {
        if (state.onRampIntermediateStatus ==
            OnRampIntermediateActionStatus.success) {
          context.router.push(
            DepositSuccessfulRoute(
              selectedImage: widget.selectedImage,
              phoneNumber: widget.phoneNumber,
              fullName: widget.fullName,
              paymentChannel: widget.paymentChannel,
              fiatAmount: widget.fiatAmount,
              usdtAmount: widget.usdtAmount,
              exchangeRate: widget.exchangeRate,
              feeAmount: widget.feeAmount,
              localCurrencyCode: widget.localCurrencyCode,
              localCurrencySymbol: widget.localCurrencySymbol,
              countryCode: widget.countryCode,
              quoteId: widget.quoteId,
              carrierCode: widget.carrierCode,
              carrierName: widget.carrierName,
            ),
          );
        }

        if (state.onRampIntermediateStatus ==
            OnRampIntermediateActionStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.onRampIntermediateError ??
                    'Failed to submit OTP. Please try again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isProcessing =
            state.onRampIntermediateStatus ==
            OnRampIntermediateActionStatus.processing;

        return ResponsiveBuilder(
          builder: (context, responsiveInfo) {
            return Scaffold(
              backgroundColor: const Color(0xffF8F9FC),
              appBar: AppBarFactory.centeredTitleAppBar(
                title: 'Approve Payment',
                backgroundColor: const Color(0xffF8F9FC),
                bottom: isProcessing
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
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: responsiveInfo.responsiveMargin * 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      VSpace(getResponsiveDimension(context, 16)),
                      Image(
                        image: AssetImage(Assets.images.lennyStarePose.path),
                        height: getResponsiveDimension(context, 160),
                      ),
                      VSpace(getResponsiveDimension(context, 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.selectedImage.isNotEmpty) ...[
                            Image(
                              image: AssetImage(widget.selectedImage),
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                      VSpace(getResponsiveDimension(context, 16)),
                      Text(
                        'We\'ve sent you a prompt',
                        style: AppTextStyles.xlBold(context).copyWith(
                          fontSize: getResponsiveFontSize(context, 18),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      VSpace(getResponsiveDimension(context, 24)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Not receiving a payment prompt?',
                              style: AppTextStyles.baseSemiBold(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Follow the steps below to authorize payment requests',
                              style: AppTextStyles.smRegular(
                                context,
                              ).copyWith(color: AppColors.gray600),
                            ),
                            VSpace(getResponsiveDimension(context, 16)),
                            _buildInstructionRow(
                              context,
                              'Dial *170# and select Option 6, My Wallet.',
                              '1',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionRow(
                              context,
                              'Select Option 3 for My Approvals.',
                              '2',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionRow(
                              context,
                              'Enter PIN to get your Pending Approval List.',
                              '3',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionRow(
                              context,
                              'Select pending transaction to approve.',
                              '4',
                            ),
                            const SizedBox(height: 8),
                            _buildInstructionRow(context, 'Pay', '5'),
                          ],
                        ),
                      ),
                      VSpace(getResponsiveDimension(context, 32)),
                      SizedBox(
                        width: double.infinity,
                        height: getResponsiveDimension(context, 50),
                        child: ButtonFactory.blackButton(
                          mainAxisAlignment: MainAxisAlignment.center,
                          hasBorder: true,
                          backgroundColor: Colors.white,
                          borderColor: AppColors.gray300,
                          textStyle: AppTextStyles.baseBold(context),
                          onPressed: () {
                            context.read<WalletCubit>().fetchWalletData();
                            context.read<WalletCubit>().resetAllStates();
                            context.router.popUntil(
                              (route) =>
                                  route.settings.name == MainActivityRoute.name,
                            );
                          },
                          text: 'Go Home',
                          isFullWidth: true,
                        ),
                      ),
                      VSpace(getResponsiveDimension(context, 24)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInstructionRow(
    BuildContext context,
    String text, [
    String? step,
  ]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step != null ? '$step. ' : '• ',
          style: AppTextStyles.mdSemiBold(context),
        ),
        Flexible(child: Text(text, style: AppTextStyles.mdSemiBold(context))),
      ],
    );
  }
}
