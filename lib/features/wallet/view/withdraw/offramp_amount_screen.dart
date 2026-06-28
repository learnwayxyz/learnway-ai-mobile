import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/wallet/balance_notifier.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/dto/offramp_details_param.dart';
import 'package:learnwayv2/features/wallet/widgets/wallet_shimmer.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

@RoutePage()
class OfframpAmountScreen extends StatefulWidget {
  const OfframpAmountScreen({
    super.key,
    required this.paymentChannel,
    required this.offrampDetailsParam,
  });
  final String paymentChannel;
  final OffRampDetailsParam? offrampDetailsParam;

  @override
  State<OfframpAmountScreen> createState() => _OfframpAmountScreenState();
}

class _OfframpAmountScreenState extends State<OfframpAmountScreen> {
  final usdtFormKey = GlobalKey<FormState>();
  final localCurrencyFormKey = GlobalKey<FormState>();

  final TextEditingController usdAmountController = TextEditingController();
  final TextEditingController localCurrencyController = TextEditingController();

  double? baseUsdtToLocalRate;

  @override
  void initState() {
    super.initState();
    _fetchQuote(widget.paymentChannel);
    _fetchOrderLimits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.withdraw,
        barHeight: 0,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.quoteStatus == QuoteStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.quoteError ?? 'Unknown error')),
            );
          }
          if (state.quoteResponse != null) {
            setUsdtToLocalRate =
                state.quoteResponse?.payout.cashout.exchangeRate ?? 0.0;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VSpace(28),
                Text(
                  AppLocalizations.of(context)!.withdrawFunds,
                  style: AppTextStyles.xxlBold(context),
                ),
                const VSpace(8),
                Text(
                  AppLocalizations.of(context)!.enterAmountToWithdrawTo,
                  style: AppTextStyles.base(
                    context,
                  ).copyWith(color: AppColors.gray600, height: 1.5),
                ),
                const VSpace(26),
                Text(
                  AppLocalizations.of(context)!.amountToWithdrawCurrency(
                    widget.offrampDetailsParam?.localCurrency ?? '',
                  ),
                  style: AppTextStyles.baseBold(context),
                ),
                const VSpace(12),
                Form(
                  key: localCurrencyFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: _BuildAmountField(
                    state: state,
                    controller: localCurrencyController,
                    hintText: AppLocalizations.of(context)!.amountInCurrency(
                      widget.offrampDetailsParam?.localCurrency ?? '',
                    ),
                    onChanged: onLocalCurrencyChanged,
                  ),
                ),
                const VSpace(26),
                Text(
                  AppLocalizations.of(context)!.amountToWithdrawUsdt,
                  style: AppTextStyles.baseBold(context),
                ),
                const VSpace(12),
                Form(
                  key: usdtFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: _BuildAmountField(
                    state: state,
                    controller: usdAmountController,
                    hintText: AppLocalizations.of(context)!.amountInUsd,
                    onChanged: onUsdAmountChanged,
                    isUsdField: true,
                  ),
                ),
                const VSpace(26),

                _BuildExchangeRateInfo(
                  state: state,
                  baseUsdtToLocalRate: baseUsdtToLocalRate ?? 0,
                ),
                if (_hasInsufficientBalance(state)) ...[
                  const VSpace(16),
                  _buildInsufficientBalanceWarning(state),
                ],
                const VSpace(32),

                _isFormValid(state)
                    ? ButtonFactory.blackButton(
                        mainAxisAlignment: MainAxisAlignment.center,
                        text: AppLocalizations.of(context)!.confirmWithdrawal,
                        onPressed: () {
                          final enteredAmount =
                              double.tryParse(usdAmountController.text) ?? 0;
                          context.router.push(
                            OfframpConfirmationRoute(
                              recipientNumber: widget
                                  .offrampDetailsParam!
                                  .formattedPhoneNumber,
                              amountUsdt: enteredAmount,
                              amountToReceive:
                                  double.tryParse(
                                    localCurrencyController.text,
                                  ) ??
                                  0,
                              exchangeRate: baseUsdtToLocalRate ?? 0,
                              paymentChannel:
                                  widget.offrampDetailsParam!.paymentChannel,
                              localCurrency:
                                  widget.offrampDetailsParam!.localCurrency,
                              carrierName:
                                  widget.offrampDetailsParam!.carrierName,
                              offrampData: widget
                                  .offrampDetailsParam
                                  ?.offRampData
                                  .copyWith(cryptoAmount: enteredAmount),
                            ),
                          );
                        },
                      )
                    : ButtonFactory.disabledButton(
                        text: AppLocalizations.of(context)!.confirmWithdrawal,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchQuote(String paymentChannel) async {
    log('_fetchQuote() called with channel: $paymentChannel');
    try {
      final userData = LocalStorageService.getUserSync()?.country;
      log('User country: $userData');
      await locator.get<WalletCubit>().getQuote(
        address: '',
        network: 'LISK',
        asset: 'LISK_USDT',
        amount: '10.5',
        currency: CurrencyCheck.getLocalCurrencyCode(userData ?? 'GHS'),
        countryIsoCode: CurrencyCheck.getCountryIsocode(userData ?? 'GHS'),
        paymentChannel: paymentChannel,
      );
    } catch (e) {
      log('Error fetching quote: $e');
    }
  }

  void onUsdAmountChanged(String value) {
    if (value.isEmpty) {
      localCurrencyController.clear();
      setState(() {});
      return;
    }
    final usdAmount = double.tryParse(value) ?? 0;
    if (baseUsdtToLocalRate == null) return;
    final double localAmount = usdAmount * baseUsdtToLocalRate!;
    localCurrencyController.text = localAmount.toStringAsFixed(2);
    setState(() {});
  }

  void onLocalCurrencyChanged(String value) {
    if (value.isEmpty) {
      usdAmountController.clear();
      setState(() {});
      return;
    }
    final localAmount = double.tryParse(value) ?? 0;
    final usdAmount = localAmount / getBaseUsdtToLocalRate;
    usdAmountController.text = usdAmount.toStringAsFixed(2);
    setState(() {});
  }

  set setUsdtToLocalRate(double rate) {
    baseUsdtToLocalRate = rate;
  }

  double get getBaseUsdtToLocalRate {
    return baseUsdtToLocalRate ?? 0;
  }

  double _getUserBalance() {
    final userBalance = context.read<BalanceNotifier>().balance;
    if (userBalance == null) return 0;
    log('Getting user balance: $userBalance');
    return double.tryParse(userBalance) ?? 0;
  }

  bool _hasInsufficientBalance(WalletState state) {
    final usdAmount = double.tryParse(usdAmountController.text) ?? 0;
    if (usdAmount <= 0) return false;
    final userBalance = _getUserBalance();
    return usdAmount > userBalance;
  }

  double _getAmountNeeded(WalletState state) {
    final usdAmount = double.tryParse(usdAmountController.text) ?? 0;
    final userBalance = _getUserBalance();
    return usdAmount - userBalance;
  }

  bool _isFormValid(WalletState state) {
    final usdAmount = double.tryParse(usdAmountController.text) ?? 0;
    final localAmount = double.tryParse(localCurrencyController.text) ?? 0;

    if (usdAmountController.text.isEmpty ||
        localCurrencyController.text.isEmpty) {
      return false;
    }

    if (usdAmount <= 0 || localAmount <= 0) {
      return false;
    }

    if (_hasInsufficientBalance(state)) {
      return false;
    }

    if (state.orderLimit != null) {
      final minUsd = state.orderLimit!.payout.minUsd;
      final maxUsd = state.orderLimit!.payout.maxUsd;
      if (usdAmount < minUsd || usdAmount > maxUsd) {
        return false;
      }
    }

    return true;
  }

  Future<void> _fetchOrderLimits() async {
    final userData = LocalStorageService.getUserSync()?.country;
    final currency = CurrencyCheck.getLocalCurrencyCode(userData ?? 'GHS');
    final countryCode = CurrencyCheck.getCountryIsocode(userData ?? 'GHS');

    context.read<WalletCubit>().getOrderLimits(
      cryptoCurrency: 'LISK_USDT',
      fiatCurrency: currency,
      payoutChannel: widget.paymentChannel,
      countryCode: countryCode,
    );
  }

  Widget _buildInsufficientBalanceWarning(WalletState state) {
    final amountNeeded = _getAmountNeeded(state);
    final userBalance = _getUserBalance();

    return Text(
      AppLocalizations.of(context)!.insufficientBalance(
        userBalance.toStringAsFixed(2),
        amountNeeded.toStringAsFixed(2),
      ),
      style: AppTextStyles.sm(
        context,
      ).copyWith(color: AppColors.primary25, height: 1.4),
    );
  }
}

class _BuildAmountField extends StatelessWidget {
  const _BuildAmountField({
    required this.state,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.isUsdField = false,
  });

  final WalletState state;
  final TextEditingController controller;
  final String hintText;
  final void Function(String) onChanged;
  final bool isUsdField;

  @override
  Widget build(BuildContext context) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpAmountFieldShimmer();
    }

    return TextFieldFactory.amount(
      controller: controller,
      config: TextFieldConfig(
        hintText: hintText,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final l10n = AppLocalizations.of(context)!;
          if (value == null || value.isEmpty) {
            return l10n.pleaseEnterAnAmount;
          }
          if (isUsdField && state.orderLimit != null) {
            final amount = double.tryParse(value) ?? 0;
            final minUsd = state.orderLimit!.payout.minUsd;
            final maxUsd = state.orderLimit!.payout.maxUsd;
            if (amount < minUsd) {
              return l10n.minimumAmount(minUsd.toStringAsFixed(2));
            }
            if (amount > maxUsd) {
              return l10n.maximumAmount(maxUsd.toStringAsFixed(2));
            }
          }
          return null;
        },
      ),
    );
  }
}

class _BuildExchangeRateInfo extends StatelessWidget {
  const _BuildExchangeRateInfo({
    required this.state,
    required this.baseUsdtToLocalRate,
  });

  final WalletState state;
  final double baseUsdtToLocalRate;

  @override
  Widget build(BuildContext context) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpRateShimmer();
    }

    if (state.quoteStatus == QuoteStatus.error) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error500, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                state.quoteError ??
                    AppLocalizations.of(context)!.failedToLoadExchangeRate,
                style: AppTextStyles.sm(
                  context,
                ).copyWith(color: AppColors.error500),
              ),
            ),
          ],
        ),
      );
    }

    if (state.quoteStatus == QuoteStatus.loaded) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.exchangeRate,
              style: AppTextStyles.sm(
                context,
              ).copyWith(color: AppColors.gray600),
            ),
            Text(
              '1 USDT = ${baseUsdtToLocalRate.toStringAsFixed(2)} ${CurrencyCheck.getLocalCurrencyCode(LocalStorageService.getUserSync()?.country ?? 'GHS')}',
              style: AppTextStyles.smBold(
                context,
              ).copyWith(color: AppColors.gray900),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
