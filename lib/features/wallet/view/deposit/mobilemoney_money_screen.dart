import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class MobileMoneyScreen extends StatefulWidget {
  const MobileMoneyScreen({
    super.key,
    required this.phoneNumber,
    required this.accountName,
    required this.selectedNetwork,
    required this.selectedImage,
  });
  final String phoneNumber;
  final String accountName;
  final String selectedNetwork;
  final String selectedImage;

  @override
  State<MobileMoneyScreen> createState() => _MobileMoneyScreenState();
}

class _MobileMoneyScreenState extends State<MobileMoneyScreen>
    with ResponsiveMixin {
  final TextEditingController ghsController = TextEditingController();
  final TextEditingController usdtController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isFormValid = false;
  bool isUpdatingGhs = false;
  bool isUpdatingUsdt = false;
  final double minGhsAmount = 100.0;
  final double maxGhsAmount = 50000.0;
  final double minUsdtAmount = 0.0;
  final double maxUsdtAmount = 10000.0;

  final double defaultFiatAmount = 100.0;

  @override
  void initState() {
    super.initState();
    ghsController.addListener(_validateForm);
    usdtController.addListener(_validateForm);
  }

  void _validateForm() {
    final valid =
        ghsController.text.isNotEmpty || usdtController.text.isNotEmpty;

    if (valid != isFormValid) {
      setState(() => isFormValid = valid);
    }
  }

  double _getExchangeRate(WalletState state) {
    if (state.onRampRate?.data.value != null) {
      return double.tryParse(state.onRampRate!.data.value) ?? 0.0;
    }
    return 0.0;
  }

  String? ghsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  String? usdtValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  void _handleNext(WalletState state) {
    if (formKey.currentState!.validate()) {
      final ghsAmount = double.tryParse(ghsController.text);
      final rate = _getExchangeRate(state);

      if (ghsAmount != null && ghsAmount > 0) {
        final usdtAmount = ghsAmount / rate;
        final fee = state.onRampRate?.data.fee ?? 0.0;
        final totalAmount = ghsAmount + fee;

        // context.router.push(
        //   DepositConfirmationRoute(
        //     accountNumber: widget.phoneNumber,
        //     accountName: widget.accountName,
        //     amount: totalAmount,
        //     amountUsdt: '${usdtAmount.toStringAsFixed(2)} USDT',
        //     referenceId: state.onRampRate?.data.id ?? '',
        //     selectedImage: widget.selectedImage,
        //     selectedNetwork: widget.selectedNetwork,
        //   ),
        // );
      }
    }
  }

  void _onGhsChanged(String value, double exchangeRate) {
    if (isUpdatingGhs) return;

    if (value.isEmpty) {
      isUpdatingUsdt = true;
      usdtController.clear();
      isUpdatingUsdt = false;
      return;
    }

    final ghsAmount = double.tryParse(value);
    if (ghsAmount != null && ghsAmount > 0) {
      isUpdatingUsdt = true;
      final usdtAmount = ghsAmount / exchangeRate;
      usdtController.text = usdtAmount.toStringAsFixed(2);
      isUpdatingUsdt = false;
    }
  }

  void _onUsdtChanged(String value, double exchangeRate) {
    if (isUpdatingUsdt) return;

    if (value.isEmpty) {
      isUpdatingGhs = true;
      ghsController.clear();
      isUpdatingGhs = false;
      return;
    }

    final usdtAmount = double.tryParse(value);
    if (usdtAmount != null && usdtAmount > 0) {
      isUpdatingGhs = true;
      final ghsAmount = usdtAmount * exchangeRate;
      ghsController.text = ghsAmount.toStringAsFixed(2);
      isUpdatingGhs = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listenWhen: (previous, current) {
        return previous.depositStatus != current.depositStatus ||
            previous.depositError != current.depositError ||
            previous.ratesError != current.ratesError ||
            previous.depositResponse != current.depositResponse;
      },
      listener: (context, state) {
        if (state.isDepositSuccessful && state.depositResponse != null) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.depositResponse!.message),
              backgroundColor: Colors.green,
            ),
          );

          if (state.depositResponse!.data?.redirectUrl != null) {}
        }

        if (state.hasDepositError) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(state.depositError ?? 'Deposit failed'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              )
              .closed
              .then((_) {
                context.read<WalletCubit>().resetDepositState();
              });
        }

        if (state.hasRatesError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text(state.ratesError ?? 'Failed to fetch rates'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              )
              .closed
              .then((_) {
                context.read<WalletCubit>().clearRateError();
              });
        }
      },
      builder: (context, state) {
        final exchangeRate = _getExchangeRate(state);
        final isLoadingRates = state.ratesLoading;

        return Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: 'Deposit Hell',
            showBackButton: true,
            barHeight: 0,
          ),
          body: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VSpace(28),
                    Text(
                      'Deposit Funds',
                      style: AppTextStyles.xxlBold(context),
                    ),
                    const VSpace(8),
                    Text(
                      'Please enter the amount to deposit funds.',
                      style: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.gray600, height: 1.5),
                    ),
                    const VSpace(24),
                    Text(
                      'Amount (GHS)',
                      style: AppTextStyles.baseSemiBold(context),
                    ),
                    const VSpace(10),
                    TextFieldFactory.amount(
                      controller: ghsController,
                      config: TextFieldConfig(
                        borderRadius: BorderRadius.circular(12),
                        enabledBorderColor: AppColors.gray300,
                        focusedBorderColor: AppColors.gray900,
                        validator: ghsValidator,
                        hintText: 'Enter GHS amount',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        onChanged: (value) =>
                            _onGhsChanged(value, exchangeRate),
                      ),
                    ),
                    const VSpace(22),

                    Text(
                      'Amount (USDT)',
                      style: AppTextStyles.baseSemiBold(context),
                    ),
                    const VSpace(10),
                    TextFieldFactory.amount(
                      controller: usdtController,
                      config: TextFieldConfig(
                        borderRadius: BorderRadius.circular(12),
                        enabledBorderColor: AppColors.gray300,
                        focusedBorderColor: AppColors.gray900,
                        validator: usdtValidator,
                        hintText: 'Enter USDT amount',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        onChanged: (value) =>
                            _onUsdtChanged(value, exchangeRate),
                      ),
                    ),
                    const VSpace(20),
                    Center(
                      child: Text(
                        'Rate: 1 USDT = GHS ${exchangeRate.toStringAsFixed(2)}',
                        style: AppTextStyles.smMedium(context),
                      ),
                    ),
                    const VSpace(50),
                    ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: AppTextStyles.mdSemiBold(context).copyWith(
                              color: Colors.white,
                              fontSize: getResponsiveFontSize(context, 16),
                            ),
                          ),
                          if (isLoadingRates) ...[
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      onPressed:
                          (isFormValid &&
                              !isLoadingRates &&
                              state.onRampRate != null)
                          ? () => _handleNext(state)
                          : () {},
                      backgroundColor:
                          (isFormValid &&
                              !isLoadingRates &&
                              state.onRampRate != null)
                          ? AppColors.gray900
                          : AppColors.gray400,
                    ),
                    const VSpace(16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    ghsController.dispose();
    usdtController.dispose();
    super.dispose();
  }
}
