import 'dart:async';

import 'package:shimmer/shimmer.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/features/wallet/fonbnk_config.dart';

@RoutePage()
class DepositConverterScreen extends StatefulWidget {
  const DepositConverterScreen({
    super.key,
    required this.walletAddress,
    required this.selectedCountry,
    required this.selectedCountryCode,
    required this.selectedPaymentChannel,
    required this.selectedNetwork,
    required this.selectedCarrierCode,
    required this.phoneNumber,
    this.fullName = '',
    this.bankCode = '',
    this.bankAccountNumber = '',
    this.minDepositAmount = 0.0,
    this.maxDepositAmount = 0.0,
  });

  final String walletAddress;
  final String selectedCountry;
  final String selectedCountryCode;
  final String selectedPaymentChannel;
  final String selectedNetwork;
  final String selectedCarrierCode;
  final String phoneNumber;
  final String fullName;
  final String bankCode;
  final String bankAccountNumber;
  final double minDepositAmount;
  final double maxDepositAmount;

  @override
  State<DepositConverterScreen> createState() => _DepositConverterScreenState();
}

class _DepositConverterScreenState extends State<DepositConverterScreen>
    with ResponsiveMixin {
  final TextEditingController localCurrencyController = TextEditingController();
  final TextEditingController usdtController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isFormValid = false;
  bool isUpdatingLocal = false;
  bool isUpdatingUsdt = false;

  late String localCurrencyCode;
  late String localCurrencySymbol;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    localCurrencyController.addListener(_validateForm);
    usdtController.addListener(_validateForm);
    localCurrencyCode = CurrencyCheck.getLocalCurrencyCode(
      widget.selectedCountry,
    );
    localCurrencySymbol = CurrencyCheck.getLocalCurrencyDisplayName(
      widget.selectedCountry,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<WalletCubit>().state;
      if (state.onRampQuoteResponse != null) {
        if (widget.minDepositAmount > 0) {
          isUpdatingLocal = true;
          localCurrencyController.text = widget.minDepositAmount
              .toStringAsFixed(2);
          isUpdatingLocal = false;
        }
        isUpdatingUsdt = true;
        usdtController.text = state
            .onRampQuoteResponse!
            .deposit
            .cashout
            .amountAfterFees
            .toStringAsFixed(2);
        isUpdatingUsdt = false;
      } else if (widget.minDepositAmount > 0) {
        isUpdatingLocal = true;
        localCurrencyController.text = widget.minDepositAmount.toStringAsFixed(
          2,
        );
        isUpdatingLocal = false;
        context.read<WalletCubit>().getOnRampQuote(
          fiatCurrency: localCurrencyCode,
          depositChannel: widget.selectedPaymentChannel,
          countryCode: widget.selectedCountryCode,
          cryptoCurrency: FonbnkConfig.asset,
          fiatAmount: widget.minDepositAmount,
        );
      }
    });
  }

  void _validateForm() {
    final valid =
        localCurrencyController.text.isNotEmpty ||
        usdtController.text.isNotEmpty;

    if (valid != isFormValid) {
      setState(() => isFormValid = valid);
    }
  }

  double _getExchangeRate(WalletState state) {
    return state.onRampQuoteResponse?.deposit.cashout.exchangeRate ?? 0.0;
  }

  String? localCurrencyValidator(String? value) {
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

    if (widget.minDepositAmount > 0 && amount < widget.minDepositAmount) {
      return 'Minimum deposit is $localCurrencySymbol ${widget.minDepositAmount.toStringAsFixed(2)}';
    }

    if (widget.maxDepositAmount > 0 && amount > widget.maxDepositAmount) {
      return 'Maximum deposit is $localCurrencySymbol ${widget.maxDepositAmount.toStringAsFixed(2)}';
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
      final localAmount = double.tryParse(localCurrencyController.text);
      final usdtAmount = double.tryParse(usdtController.text);
      final quoteResponse = state.onRampQuoteResponse;

      if (localAmount != null &&
          usdtAmount != null &&
          localAmount > 0 &&
          quoteResponse != null) {
        context.router.push(
          OnrampDepositConfirmationRoute(
            phoneNumber: widget.phoneNumber,
            fullName: widget.fullName,
            paymentChannel: widget.selectedPaymentChannel,
            fiatAmount: localAmount,
            usdtAmount: usdtAmount,
            exchangeRate: quoteResponse.deposit.cashout.exchangeRate,
            feeAmount: quoteResponse.deposit.cashout.totalChargedFees,
            localCurrencyCode: localCurrencyCode,
            localCurrencySymbol: localCurrencySymbol,
            countryCode: widget.selectedCountryCode,
            quoteId: quoteResponse.quoteId,
            carrierCode: widget.selectedCarrierCode,
            carrierName: widget.selectedNetwork,
            bankCode: widget.bankCode,
            bankAccountNumber: widget.bankAccountNumber,
          ),
        );
      }
    }
  }

  void _onLocalCurrencyChanged(String value) {
    if (isUpdatingLocal) return;

    if (value.isEmpty) {
      isUpdatingUsdt = true;
      usdtController.clear();
      isUpdatingUsdt = false;
      _debounceTimer?.cancel();
      return;
    }

    final localAmount = double.tryParse(value);
    final minAmount = widget.minDepositAmount > 0 ? widget.minDepositAmount : 1;
    if (localAmount != null && localAmount >= minAmount) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 800), () {
        context.read<WalletCubit>().getOnRampQuote(
          fiatCurrency: localCurrencyCode,
          depositChannel: widget.selectedPaymentChannel,
          countryCode: widget.selectedCountryCode,
          cryptoCurrency: FonbnkConfig.asset,
          fiatAmount: localAmount,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listenWhen: (previous, current) {
        return previous.depositStatus != current.depositStatus ||
            previous.depositError != current.depositError ||
            previous.ratesError != current.ratesError ||
            previous.onRampQuoteResponse != current.onRampQuoteResponse ||
            previous.onRampQuoteStatus != current.onRampQuoteStatus;
      },
      listener: (context, state) {
        if (state.onRampQuoteStatus == OnRampQuoteStatus.loaded &&
            state.onRampQuoteResponse != null &&
            !isUpdatingLocal) {
          isUpdatingUsdt = true;
          final cashout = state.onRampQuoteResponse!.deposit.cashout;
          final fiatAfterFees = cashout.amountAfterFees;
          final rate = cashout.exchangeRate;
          final usdtAmount = rate > 0 ? fiatAfterFees / rate : 0.0;
          usdtController.text = usdtAmount.toStringAsFixed(2);
          isUpdatingUsdt = false;
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
                  content:
                      state.ratesError!.toLowerCase().contains(
                        'no offers found',
                      )
                      ? Text('No offers found, try increasing the price.')
                      : Text(state.ratesError ?? 'Rates error'),
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
        final isLoadingRates =
            state.onRampQuoteStatus == OnRampQuoteStatus.loading;

        String feeInfo = '';
        if (state.onRampQuoteResponse != null) {
          final totalFee =
              state.onRampQuoteResponse!.deposit.cashout.totalChargedFees;
          feeInfo = 'Fee: $localCurrencySymbol ${totalFee.toStringAsFixed(2)}';
        }

        final canProceed =
            isFormValid && !isLoadingRates && state.onRampQuoteResponse != null;

        return Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: 'Deposit',
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
                      'Enter amount in $localCurrencySymbol or USDT',
                      style: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.gray600, height: 1.5),
                    ),
                    const VSpace(24),
                    Text(
                      'Amount to Pay ($localCurrencySymbol)',
                      style: AppTextStyles.baseSemiBold(context),
                    ),
                    const VSpace(10),
                    TextFieldFactory.amount(
                      controller: localCurrencyController,
                      config: TextFieldConfig(
                        borderRadius: BorderRadius.circular(12),
                        enabledBorderColor: AppColors.gray300,
                        focusedBorderColor: AppColors.gray900,
                        validator: localCurrencyValidator,
                        hintText: 'Enter $localCurrencySymbol amount',
                        readOnly: isLoadingRates,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        onChanged: _onLocalCurrencyChanged,
                      ),
                    ),
                    const VSpace(22),
                    Text(
                      'Amount to Receive (USDT)',
                      style: AppTextStyles.baseSemiBold(context),
                    ),
                    const VSpace(10),
                    if (isLoadingRates)
                      Shimmer.fromColors(
                        baseColor: AppColors.gray200,
                        highlightColor: AppColors.gray100,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.gray200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    else
                      TextFieldFactory.amount(
                        controller: usdtController,
                        config: TextFieldConfig(
                          borderRadius: BorderRadius.circular(12),
                          enabledBorderColor: AppColors.gray300,
                          focusedBorderColor: AppColors.gray900,
                          validator: usdtValidator,
                          hintText: 'Enter USDT amount',
                          readOnly: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    const VSpace(12),
                    Center(
                      child: Text(
                        'Rate: 1 USDT = $localCurrencySymbol ${exchangeRate.toStringAsFixed(2)}',
                        style: AppTextStyles.smMedium(context),
                      ),
                    ),
                    if (feeInfo.isNotEmpty) ...[
                      const VSpace(8),
                      Center(
                        child: Text(
                          feeInfo,
                          style: AppTextStyles.smMedium(
                            context,
                          ).copyWith(color: AppColors.gray600),
                        ),
                      ),
                    ],
                    const VSpace(24),
                    ButtonFactory.blackButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Proceed to Payment',
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
                      onPressed: canProceed ? () => _handleNext(state) : () {},
                      backgroundColor: canProceed
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
    _debounceTimer?.cancel();
    localCurrencyController.dispose();
    usdtController.dispose();
    super.dispose();
  }
}
