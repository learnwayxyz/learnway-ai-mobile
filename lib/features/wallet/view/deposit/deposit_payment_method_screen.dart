import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/models/onramp_quote_response.dart';
import 'package:learnwayv2/features/wallet/models/quote_response.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';
import 'package:learnwayv2/features/wallet/widgets/network_provider_sheet.dart';
import 'package:learnwayv2/features/wallet/widgets/wallet_shimmer.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class DepositPaymentMethodScreen extends StatefulWidget {
  const DepositPaymentMethodScreen({super.key});

  @override
  State<DepositPaymentMethodScreen> createState() =>
      _DepositPaymentMethodScreenState();
}

class _DepositPaymentMethodScreenState
    extends State<DepositPaymentMethodScreen> {
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  final accountNumberController = TextEditingController();

  PaymentChannel? selectedPaymentChannel;
  Carrier? selectedCarrier;
  FieldOption? selectedBank;

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().getSupportedCurrencies();
    _fetchOrderLimits();
  }

  void _fetchOrderLimits() {
    final currency = CurrencyCheck.getLocalCurrencyCode(_userCountry);
    final countryCode = CurrencyCheck.getCountryIsocode(_userCountry);
    context.read<WalletCubit>().getOnRampOrderLimits(
      cryptoCurrency: 'LISK_USDT',
      fiatCurrency: currency,
      depositChannel: 'bank',
      countryCode: countryCode,
    );
  }

  String get _userCountry =>
      LocalStorageService.getUserSync()?.country ?? 'Ghana';

  String get _userWalletAddress =>
      LocalStorageService.getUserSync()?.walletAddress ?? '';

  bool get _isChannelPreselected =>
      _userCountry == 'Nigeria' || _userCountry == 'Ghana';

  void _fetchQuoteForBank(WalletState state) {
    final currency = CurrencyCheck.getLocalCurrencyCode(_userCountry);
    final countryCode = CurrencyCheck.getCountryIsocode(_userCountry);
    final minAmount = state.onRampOrderLimit?.deposit.min ?? 1.0;
    context.read<WalletCubit>().getOnRampQuote(
      fiatCurrency: currency,
      depositChannel: 'bank',
      countryCode: countryCode,
      cryptoCurrency: 'LISK_USDT',
      fiatAmount: minAmount,
    );
  }

  void _showPaymentChannelSheet(List<PaymentChannel> channels) {
    const allowedTypes = {'mobile_money', 'bank'};
    final filtered = channels
        .where((c) => c.isDepositAllowed && allowedTypes.contains(c.type))
        .toList();

    if (filtered.isEmpty) return;

    final networks = filtered
        .map((c) => MobileMoneyNetwork(name: _channelDisplayName(c.type)))
        .toSet()
        .toList();

    log('Available networks: $networks');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NetworkProviderBottomSheet(
        networks: networks,
        selectedNetwork: selectedPaymentChannel != null
            ? _channelDisplayName(selectedPaymentChannel!.type)
            : null,
        onNetworkSelected: (displayName) {
          final newChannel = filtered.firstWhere(
            (c) => _channelDisplayName(c.type) == displayName,
          );
          final currentState = context.read<WalletCubit>().state;
          setState(() {
            selectedPaymentChannel = newChannel;
            selectedCarrier = null;
            selectedBank = null;
          });
          if (newChannel.type == 'bank') _fetchQuoteForBank(currentState);
        },
      ),
    );
  }

  void _showCarrierSheet() {
    final allCarriers = selectedPaymentChannel?.carriers ?? [];
    final carriers = allCarriers
        .where((c) => c.name.toLowerCase().contains('mtn'))
        .toList();
    if (carriers.isEmpty) return;

    if (selectedCarrier == null) {
      setState(() => selectedCarrier = carriers.first);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CarrierBottomSheet(
        carriers: carriers,
        selectedCarrier: selectedCarrier?.name ?? carriers.first.name,
        onCarrierSelected: (carrier) {
          setState(() => selectedCarrier = carrier);
        },
      ),
    );
  }

  void _showBankSheet(WalletState state) {
    final banks = _getBankOptions(state);
    if (banks.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BankBottomSheet(
        banks: banks,
        selectedBank: selectedBank?.label,
        onBankSelected: (bank) {
          setState(() => selectedBank = bank);
        },
      ),
    );
  }

  List<FieldOption> _getBankOptions(WalletState state) {
    final fields = state.onRampQuoteResponse?.deposit.fieldsToCreateOrder ?? [];
    final bankField = fields.firstWhere(
      (f) => f.key == 'bankCode',
      orElse: () => const OnRampQuoteFieldToCreateOrder(
        key: '',
        label: '',
        required: false,
        type: '',
      ),
    );
    return bankField.options ?? [];
  }

  bool _shouldShowCarrierSelector() {
    if (selectedPaymentChannel == null) return false;
    final carriers = selectedPaymentChannel!.carriers;
    return carriers != null && carriers.isNotEmpty;
  }

  bool _shouldShowBankSelector(WalletState state) {
    if (selectedPaymentChannel == null) return false;
    if (selectedPaymentChannel!.type != 'bank') return false;
    return _getBankOptions(state).isNotEmpty;
  }

  bool _shouldShowFullNameField() => selectedPaymentChannel != null;

  bool _shouldShowBankAccountFields() => selectedPaymentChannel?.type == 'bank';

  bool _isFormValid(WalletState state) {
    if (selectedPaymentChannel == null) return false;

    final phoneValidation = PhoneNumberUtils.validatePhoneNumber(
      phoneNumberController.text,
      _userCountry,
    );
    if (phoneValidation != null) return false;

    if (_shouldShowCarrierSelector() && selectedCarrier == null) return false;
    if (_shouldShowBankSelector(state) && selectedBank == null) return false;

    if (fullNameController.text.trim().length < 3) return false;

    if (_shouldShowBankAccountFields()) {
      if (accountNumberController.text.trim().isEmpty) return false;
    }

    return true;
  }

  void _onNext(WalletState state) {
    if (!_isFormValid(state)) return;

    final formattedPhone = PhoneNumberUtils.formatWithCountryCode(
      phoneNumberController.text,
      _userCountry,
    );

    context.router.push(
      DepositConverterRoute(
        walletAddress: _userWalletAddress,
        phoneNumber: formattedPhone,
        selectedCountry: _userCountry,
        selectedCountryCode: CurrencyCheck.getCountryIsocode(_userCountry),
        selectedPaymentChannel: selectedPaymentChannel!.type,
        selectedNetwork: selectedCarrier?.name ?? '',
        selectedCarrierCode: selectedCarrier?.code ?? '',
        fullName: fullNameController.text.trim(),
        bankCode: selectedBank?.value ?? '',
        bankAccountNumber: accountNumberController.text.trim(),
        minDepositAmount: state.onRampOrderLimit?.deposit.min ?? 0.0,
        maxDepositAmount: state.onRampOrderLimit?.deposit.max ?? 0.0,
      ),
    );
  }

  String _channelDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
        return 'Bank Transfer';
      case 'mobile_money':
        return 'Mobile Money';
      case 'airtime':
        return 'Airtime';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: 'Select Payment Method',
        showBackButton: true,
        barHeight: 0,
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          // Auto-preselect channel when supported currencies load
          if (state.supportedCurrencyStatus == SupportedCurrencyStatus.loaded &&
              state.supportedCurrencies != null &&
              selectedPaymentChannel == null) {
            final currencyCode = CurrencyCheck.getLocalCurrencyCode(
              _userCountry,
            );
            final userCurrencies = state.supportedCurrencies!
                .where((c) => c.currencyCode == currencyCode)
                .toList();

            if (_userCountry == 'Nigeria') {
              final bankChannel = userCurrencies
                  .expand((c) => c.paymentChannels)
                  .where((c) => c.isDepositAllowed && c.type == 'bank')
                  .firstOrNull;
              if (bankChannel != null) {
                setState(() => selectedPaymentChannel = bankChannel);
                // Only fetch quote if limits are already loaded
                if (state.onRampOrderLimitStatus ==
                    OnRampOrderLimitStatus.loaded) {
                  _fetchQuoteForBank(state);
                }
              }
            } else if (_userCountry == 'Ghana') {
              final mobileChannel = userCurrencies
                  .expand((c) => c.paymentChannels)
                  .where((c) => c.isDepositAllowed && c.type == 'mobile_money')
                  .firstOrNull;
              if (mobileChannel != null) {
                setState(() => selectedPaymentChannel = mobileChannel);
              }
            }
          }

          // Fetch quote when limits load and bank is already preselected
          if (state.onRampOrderLimitStatus == OnRampOrderLimitStatus.loaded &&
              state.onRampOrderLimit != null &&
              selectedPaymentChannel?.type == 'bank' &&
              state.onRampQuoteStatus == OnRampQuoteStatus.initial) {
            _fetchQuoteForBank(state);
          }
        },
        builder: (context, state) {
          final currencyCode = CurrencyCheck.getLocalCurrencyCode(_userCountry);
          final userCurrencies = (state.supportedCurrencies ?? [])
              .where((c) => c.currencyCode == currencyCode)
              .toList();
          final paymentChannels = userCurrencies
              .expand((c) => c.paymentChannels)
              .where((c) => c.isDepositAllowed)
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VSpace(28),
                  Text('Deposit Funds', style: AppTextStyles.xxlBold(context)),
                  const VSpace(8),
                  Text(
                    'Enter your payment details',
                    style: AppTextStyles.base(
                      context,
                    ).copyWith(color: AppColors.gray600, height: 1.5),
                  ),
                  const VSpace(24),
                  Text(
                    'Payment Method',
                    style: AppTextStyles.baseSemiBold(
                      context,
                    ).copyWith(color: AppColors.gray900),
                  ),
                  const VSpace(12),
                  _buildPaymentChannelSelector(state, paymentChannels),
                  if (_shouldShowCarrierSelector()) ...[
                    const VSpace(24),
                    Text(
                      'Network Provider',
                      style: AppTextStyles.baseSemiBold(
                        context,
                      ).copyWith(color: AppColors.gray900),
                    ),
                    const VSpace(12),
                    _buildCarrierSelector(),
                  ],
                  if (_shouldShowBankSelector(state)) ...[
                    const VSpace(24),
                    Text(
                      'Select Bank',
                      style: AppTextStyles.baseSemiBold(
                        context,
                      ).copyWith(color: AppColors.gray900),
                    ),
                    const VSpace(12),
                    _buildBankSelector(state),
                  ],
                  if (selectedPaymentChannel != null) ...[
                    const VSpace(24),
                    Text(
                      'Phone Number',
                      style: AppTextStyles.baseSemiBold(
                        context,
                      ).copyWith(color: AppColors.gray900),
                    ),
                    const VSpace(12),
                    _buildPhoneField(),
                    if (_shouldShowFullNameField()) ...[
                      const VSpace(24),
                      Text(
                        'Full Name',
                        style: AppTextStyles.baseSemiBold(
                          context,
                        ).copyWith(color: AppColors.gray900),
                      ),
                      const VSpace(12),
                      _buildFullNameField(),
                    ],
                    if (_shouldShowBankAccountFields()) ...[
                      const VSpace(24),
                      Text(
                        'Account Number',
                        style: AppTextStyles.baseSemiBold(
                          context,
                        ).copyWith(color: AppColors.gray900),
                      ),
                      const VSpace(12),
                      _buildAccountNumberField(),
                    ],
                  ],
                  const VSpace(40),
                  _isFormValid(state)
                      ? ButtonFactory.blackButton(
                          mainAxisAlignment: MainAxisAlignment.center,
                          text: 'Next',
                          textStyle: AppTextStyles.baseSemiBold(
                            context,
                            color: Colors.white,
                          ),
                          onPressed: () => _onNext(state),
                          backgroundColor: AppColors.gray900,
                        )
                      : ButtonFactory.disabledButton(text: 'Next'),
                  const VSpace(24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentChannelSelector(
    WalletState state,
    List<PaymentChannel> paymentChannels,
  ) {
    if (state.supportedCurrencyStatus == SupportedCurrencyStatus.loading) {
      return const OfframpSelectorShimmer();
    }

    if (state.supportedCurrencyStatus == SupportedCurrencyStatus.error) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.error500),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          state.supportedCurrencyMessage ?? 'Failed to load payment channels',
          style: AppTextStyles.sm(context).copyWith(color: AppColors.error500),
        ),
      );
    }

    if (_isChannelPreselected && selectedPaymentChannel != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Text(
          _channelDisplayName(selectedPaymentChannel!.type),
          style: AppTextStyles.base(context).copyWith(color: AppColors.gray900),
        ),
      );
    }

    return InkWell(
      onTap: paymentChannels.isNotEmpty
          ? () => _showPaymentChannelSheet(paymentChannels)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedPaymentChannel != null
                    ? _channelDisplayName(selectedPaymentChannel!.type)
                    : 'Select Payment Method',
                style: AppTextStyles.base(context).copyWith(
                  color: selectedPaymentChannel != null
                      ? AppColors.gray900
                      : AppColors.gray400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildCarrierSelector() {
    final carrierIcon = selectedCarrier != null
        ? getCarrierIcon(selectedCarrier!.name)
        : null;

    return InkWell(
      onTap: _showCarrierSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            if (carrierIcon != null) ...[
              Image.asset(carrierIcon, width: 24, height: 24),
              const HSpace(12),
            ],
            Expanded(
              child: Text(
                selectedCarrier?.name ?? 'Select Network Provider',
                style: AppTextStyles.base(context).copyWith(
                  color: selectedCarrier != null
                      ? AppColors.gray900
                      : AppColors.gray400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildBankSelector(WalletState state) {
    if (state.onRampQuoteStatus == OnRampQuoteStatus.loading) {
      return const OfframpSelectorShimmer();
    }

    return InkWell(
      onTap: () => _showBankSheet(state),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedBank?.label ?? 'Select Bank',
                style: AppTextStyles.base(context).copyWith(
                  color: selectedBank != null
                      ? AppColors.gray900
                      : AppColors.gray400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFieldFactory.standard(
      controller: phoneNumberController,
      config: TextFieldConfig(
        hintText: 'Enter your phone number',
        hintTextStyle: AppTextStyles.base(
          context,
        ).copyWith(color: AppColors.gray400),
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\+]'))],
        focusedBorderColor: AppColors.gray900,
        enabledBorderColor: AppColors.gray300,
        fillColor: AppColors.gray50,
        onChanged: (_) => setState(() {}),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            PhoneNumberUtils.validatePhoneNumber(value, _userCountry),
      ),
    );
  }

  Widget _buildFullNameField() {
    return TextFieldFactory.standard(
      controller: fullNameController,
      config: TextFieldConfig(
        hintText: 'Enter your full name',
        hintTextStyle: AppTextStyles.base(
          context,
        ).copyWith(color: AppColors.gray400),
        keyboardType: TextInputType.name,
        focusedBorderColor: AppColors.gray900,
        enabledBorderColor: AppColors.gray300,
        fillColor: AppColors.gray50,
        onChanged: (_) => setState(() {}),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your full name';
          }
          if (value.trim().length < 3) {
            return 'Full name must be at least 3 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAccountNumberField() {
    return TextFieldFactory.standard(
      controller: accountNumberController,
      config: TextFieldConfig(
        hintText: 'Enter account number',
        hintTextStyle: AppTextStyles.base(
          context,
        ).copyWith(color: AppColors.gray400),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        focusedBorderColor: AppColors.gray900,
        enabledBorderColor: AppColors.gray300,
        fillColor: AppColors.gray50,
        onChanged: (_) => setState(() {}),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your account number';
          }
          if (!RegExp(r'^\d{8,20}$').hasMatch(value)) {
            return 'Please enter a valid account number';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    fullNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }
}
