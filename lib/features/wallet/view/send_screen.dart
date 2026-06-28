import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/view/scanner_screen.dart';
import 'package:learnwayv2/features/wallet/widgets/send_text_field.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/ethereum_utils.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  final amountKey = GlobalKey<FormState>();
  final addressKey = GlobalKey<FormState>();
  final MobileScannerController controller = MobileScannerController();
  bool autoValidate = true;
  String currentBalance = '100';
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    context.read<WalletCubit>().fetchWalletData();

    addressController.addListener(_validateForm);
    amountController.addListener(_validateForm);
  }

  Future<void> _handleScannerResult() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null) {
      addressController.text = result;
    }
  }

  void _validateForm() {
    final valid =
        addressController.text.isNotEmpty && amountController.text.isNotEmpty;

    if (valid != isFormValid) {
      setState(() => isFormValid = valid);
    }
  }

  String? addressFieldValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.pleaseEnterAnAddress;
    }
    if (!EthereumAddressUtils.isValidAddress(value)) {
      return l10n.pleaseEnterValidEthereumAddress;
    }
    return null;
  }

  String? amountFieldValidator(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.pleaseEnterAnAmount;
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return l10n.pleaseEnterValidNumber;
    }

    final balance = double.tryParse(currentBalance) ?? 0;
    if (amount <= 0) {
      return l10n.amountMustBeGreaterThanZero;
    }
    if (amount > balance) {
      return l10n.amountExceedsBalance(balance.toStringAsFixed(2));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.select<BalanceNotifier, String?>((
      BalanceNotifier cubit,
    ) {
      currentBalance = cubit.balance ?? '0';
      return cubit.balance;
    });
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.withdraw,
        showBackButton: true,
        barHeight: 10,
      ),
      body: ResponsiveBuilder(
        builder: (context, responsiveInfo) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VSpace(28),
                  Text(
                    AppLocalizations.of(context)!.transferFunds,
                    style: AppTextStyles.xxlBold(context),
                  ),
                  const VSpace(10),
                  Text(
                    AppLocalizations.of(context)!.easilyTransferTokens,
                    style: AppTextStyles.base(context),
                  ),
                  const VSpace(20),
                  Text(
                    AppLocalizations.of(context)!.recipientAddress,
                    style: AppTextStyles.baseSemiBold(context),
                  ),
                  const VSpace(10),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: addressKey,
                    child: SendTextField(
                      fieldController: addressController,
                      fillColor: AppColors.white,
                      validator: addressFieldValidator,
                      hintText: AppLocalizations.of(context)!.enterAddressOrScan,
                      hintStyle: AppTextStyles.sm(
                        context,
                      ).copyWith(color: AppColors.gray400),
                      suffixIcon: IconButton(
                        onPressed: _handleScannerResult,
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.gray900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            Assets.icons.scanIcon,
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VSpace(30),
                  Text(
                    AppLocalizations.of(context)!.amount,
                    style: AppTextStyles.baseSemiBold(context),
                  ),
                  const VSpace(10),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: amountKey,
                    child: SendTextField(
                      fieldController: amountController,
                      fillColor: AppColors.white,
                      validator: amountFieldValidator,
                      hintText: AppLocalizations.of(context)!.usdtAmount,
                      hintStyle: AppTextStyles.sm(
                        context,
                      ).copyWith(color: AppColors.gray400),
                    ),
                  ),
                  const VSpace(10),
                  Text(
                    '${double.tryParse(balance ?? '0')?.toStringAsFixed(2)} USDT',
                    style: AppTextStyles.md(context),
                  ),
                  const VSpace(50),
                  ButtonFactory.blackButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    backgroundColor: AppColors.gray900,
                    text: AppLocalizations.of(context)!.next,
                    textStyle: AppTextStyles.baseSemiBold(
                      context,
                      color: AppColors.white,
                    ),
                    onPressed: isFormValid
                        ? () {
                            if (amountKey.currentState!.validate() &&
                                addressKey.currentState!.validate()) {
                              context.router.push(
                                SendConfirmationRoute(
                                  recipientAddress: addressController.text,
                                  amount: amountController.text,
                                ),
                              );
                            }
                          }
                        : () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    controller.dispose();
    super.dispose();
  }
}
