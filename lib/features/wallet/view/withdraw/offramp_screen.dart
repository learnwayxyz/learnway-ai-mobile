import 'dart:developer';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/shared/utilities/ui_utils.dart';
import 'package:learnwayv2/features/wallet/cubit/wallet_cubit.dart';
import 'package:learnwayv2/features/wallet/dto/offramp_details_param.dart';
import 'package:learnwayv2/features/wallet/models/quote_response.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';
import 'package:learnwayv2/features/wallet/widgets/network_provider_sheet.dart';
import 'package:learnwayv2/features/wallet/widgets/wallet_shimmer.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/wallet/fonbnk_config.dart';

@RoutePage()
class OfframpScreen extends StatefulWidget {
  const OfframpScreen({super.key});

  @override
  State<OfframpScreen> createState() => _OfframpScreenState();
}

class _OfframpScreenState extends State<OfframpScreen> {
  final TextEditingController usdAmountController = TextEditingController();
  final TextEditingController localCurrencyController = TextEditingController();
  final TextEditingController receipientController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  double? baseUsdtToLocalRate;
  PaymentChannel? selectedPaymentChannel;
  Carrier? selectedCarrier;
  FieldOption? selectedBank;
  final usdtFormKey = GlobalKey<FormState>();
  final localCurrencyFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().getSupportedCurrencies();
    _fetchOrderLimits();
  }

  Future<void> _fetchOrderLimits() async {
    final userData = LocalStorageService.getUserSync()?.country;
    final currency = CurrencyCheck.getLocalCurrencyCode(userData ?? 'GHS');
    final countryCode = CurrencyCheck.getCountryIsocode(userData ?? 'GHS');

    context.read<WalletCubit>().getOrderLimits(
      cryptoCurrency: FonbnkConfig.asset,
      fiatCurrency: currency,
      payoutChannel: 'mobile_money',
      countryCode: countryCode,
    );
  }

  set setUsdtToLocalRate(double rate) {
    baseUsdtToLocalRate = rate;
  }

  double get getBaseUsdtToLocalRate {
    return baseUsdtToLocalRate ?? 0;
  }

  void _showPaymentChannelSheet(List<PaymentChannel> paymentChannels) {
    final allowedNetworks = {'mobile_money', 'bank'};

    final filteredChannels = paymentChannels
        .where(
          (channel) =>
              channel.isPayoutAllowed &&
              allowedNetworks.contains(channel.type.toLowerCase()),
        )
        .toList();

    final networks = filteredChannels
        .map(
          (channel) => MobileMoneyNetwork(
            name: _getPaymentChannelDisplayName(context, channel.type),
          ),
        )
        .toSet()
        .toList();

    if (networks.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NetworkProviderBottomSheet(
        networks: networks,
        selectedNetwork: selectedPaymentChannel != null
            ? _getPaymentChannelDisplayName(context, selectedPaymentChannel!.type)
            : null,
        onNetworkSelected: (displayName) {
          final newChannel = filteredChannels.firstWhere(
            (channel) =>
                _getPaymentChannelDisplayName(context, channel.type) == displayName,
          );
          setState(() {
            selectedPaymentChannel = newChannel;
            selectedCarrier = null;
            selectedBank = null;
          });

          if (newChannel.carriers != null && newChannel.carriers!.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _showCarrierSheet();
            });
          }
          if (newChannel.type.toLowerCase() == 'bank') {
            _fetchQuoteForBank();
          }
        },
      ),
    );
  }

  Future<void> _fetchQuoteForBank() async {
    final userData = LocalStorageService.getUserSync()?.country;
    final userCountry = userData ?? 'Ghana';
    await context.read<WalletCubit>().getQuote(
      address: '',
      network: FonbnkConfig.network,
      asset: FonbnkConfig.asset,
      amount: '10.5',
      currency: CurrencyCheck.getLocalCurrencyCode(userCountry),
      countryIsoCode: CurrencyCheck.getCountryIsocode(userCountry),
      paymentChannel: 'bank',
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
          setState(() {
            selectedCarrier = carrier;
          });
        },
      ),
    );
  }

  List<FieldOption> _getBankOptions(WalletState state) {
    final fieldsToCreate =
        state.quoteResponse?.payout.fieldsToCreateOrder ?? [];
    final bankCodeField = fieldsToCreate.firstWhere(
      (field) => field.key == 'bankCode',
      orElse: () =>
          FieldToCreateOrder(key: '', type: '', label: '', required: false),
    );
    return bankCodeField.options ?? [];
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
          setState(() {
            selectedBank = bank;
          });
        },
      ),
    );
  }

  bool _isFormValid(WalletState state) {
    if (receipientController.text.isEmpty) {
      return false;
    }

    if (selectedPaymentChannel == null) {
      return false;
    }

    if (_shouldShowCarrierSelector() && selectedCarrier == null) {
      return false;
    }

    if (_shouldShowBankSelector(state) && selectedBank == null) {
      return false;
    }

    if (_shouldShowPhoneNumberField()) {
      final userCountry = LocalStorageService.getUserSync()?.country ?? 'Ghana';
      final phoneValidation = PhoneNumberUtils.validatePhoneNumber(
        phoneNumberController.text,
        userCountry,
      );
      if (phoneValidation != null) {
        return false;
      }
    }

    if (_shouldShowFullNameField() && fullNameController.text.isEmpty) {
      return false;
    }

    return true;
  }

  void _onContinuePressed(WalletState state) {
    final userData = LocalStorageService.getUserSync()?.country;
    final userCountry = userData ?? 'Ghana';
    final localCurrency = CurrencyCheck.getLocalCurrencyCode(userCountry);
    final phoneNumberToFormat =
        selectedPaymentChannel?.type.toLowerCase() == 'bank'
        ? phoneNumberController.text
        : receipientController.text;

    final formattedPhoneNumber = PhoneNumberUtils.formatWithCountryCode(
      phoneNumberToFormat,
      userCountry,
    );

    final PayoutDetails payoutDetails = switch (selectedPaymentChannel?.type) {
      'bank' => BankPayoutDetails(
        bankCode: selectedBank?.value ?? '',
        accountNumber: receipientController.text,
        phoneNumber: formattedPhoneNumber,
      ),
      'mobile_money' || 'airtime' => MobileMoneyPayoutDetails(
        carrierCode: selectedCarrier?.code ?? 'Unknown Carrier',
        phoneNumber: formattedPhoneNumber,
        fullName: fullNameController.text.trim(),
      ),
      _ => throw Exception('Unsupported payment channel'),
    };

    final offRampData = StoreOffRampScreenTranscientData(
      cryptoCurrency: FonbnkConfig.asset,
      cryptoNetwork: FonbnkConfig.network,
      cryptoAmount: double.tryParse(usdAmountController.text) ?? 0,
      fiatCurrency: localCurrency,
      countryCode: CurrencyCheck.getCountryIsocode(userCountry),
      payOutDetails: payoutDetails,
      quoteId: state.quoteResponse?.quoteId ?? '',
    );

    log(
      'Navigating to OfframpConfirmationScreen with data: ${offRampData.toString()}',
    );

    log(
      'Navigating to OfframpConfirmationScreen with data: ${selectedCarrier?.name}',
    );

    context.router.push(
      OfframpAmountRoute(
        paymentChannel: selectedPaymentChannel!.type,
        offrampDetailsParam: OffRampDetailsParam(
          formattedPhoneNumber: formattedPhoneNumber,
          offRampData: offRampData,
          amountInUsdt: double.tryParse(usdAmountController.text) ?? 0,
          amountToReceieve: double.tryParse(localCurrencyController.text) ?? 0,
          exchangeRate: baseUsdtToLocalRate ?? 0,
          localCurrency: localCurrency,
          carrierName: selectedCarrier?.name ?? '',
          paymentChannel: selectedPaymentChannel!.type,
        ),
      ),
    );
  }

  String _payOutChannelLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (selectedPaymentChannel == null) return '';
    final type = selectedPaymentChannel!.type.toLowerCase();
    if (type == 'mobile_money') return l10n.momoNumber;
    if (type == 'airtime') return l10n.airtimeNumber;
    if (type == 'bank') return l10n.accountNumber;
    return selectedPaymentChannel!.type;
  }

  String _getPaymentChannelDisplayName(BuildContext context, String channelType) {
    final l10n = AppLocalizations.of(context)!;
    switch (channelType.toLowerCase()) {
      case 'airtime':
        return l10n.airtime;
      case 'bank':
        return l10n.bankTransfer;
      case 'mobile_money':
        return l10n.mobileMoney;
      default:
        return channelType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.standardAppBar(
        title: AppLocalizations.of(context)!.withdraw,
        showBackButton: true,
        barHeight: 10,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.offRampStatusState == OffRampStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.walletError ?? 'Unknown error')),
            );
          }

          if (state.supportedCurrencyStatus == SupportedCurrencyStatus.loaded &&
              state.supportedCurrencies != null &&
              selectedPaymentChannel == null) {
            final userCountry =
                LocalStorageService.getUserSync()?.country ?? 'Ghana';
            final userCurrencyCode = CurrencyCheck.getLocalCurrencyCode(
              userCountry,
            );

            final userCurrencies = state.supportedCurrencies!
                .where((c) => c.currencyCode == userCurrencyCode)
                .toList();

            if (userCountry == 'Ghana') {
              final mobileMoneyChannel = userCurrencies
                  .expand((c) => c.paymentChannels)
                  .where(
                    (channel) =>
                        channel.isPayoutAllowed &&
                        channel.type.toLowerCase() == 'mobile_money',
                  )
                  .firstOrNull;

              if (mobileMoneyChannel != null) {
                setState(() {
                  selectedPaymentChannel = mobileMoneyChannel;
                });
              }
            }
          }
        },
        builder: (context, state) {
          final userCountry =
              LocalStorageService.getUserSync()?.country ?? 'Ghana';
          final userCurrencyCode = CurrencyCheck.getLocalCurrencyCode(
            userCountry,
          );
          final supportedCurrencies = state.supportedCurrencies ?? [];
          final userCurrency = supportedCurrencies
              .where((currency) => currency.currencyCode == userCurrencyCode)
              .toList();

          final paymentChannels = userCurrency
              .expand((currency) => currency.paymentChannels)
              .where((channel) => channel.isPayoutAllowed)
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VSpace(28),
                  Text(AppLocalizations.of(context)!.withdrawFunds, style: AppTextStyles.xxlBold(context)),
                  const VSpace(26),
                  Text(
                    AppLocalizations.of(context)!.selectPaymentMethod,
                    style: AppTextStyles.baseBold(context),
                  ),
                  const VSpace(12),
                  _buildPaymentChannelSelector(state, paymentChannels),
                  if (_shouldShowCarrierSelector()) ...[
                    const VSpace(26),
                    Text(
                      AppLocalizations.of(context)!.selectNetworkProvider,
                      style: AppTextStyles.baseBold(context),
                    ),
                    const VSpace(12),
                    _buildCarrierSelector(state),
                  ],
                  if (_shouldShowBankSelector(state)) ...[
                    const VSpace(26),
                    Text(AppLocalizations.of(context)!.selectBank, style: AppTextStyles.baseBold(context)),
                    const VSpace(12),
                    _buildBankSelector(state),
                  ],
                  if (selectedPaymentChannel != null) ...[
                    const VSpace(26),
                    Text(
                      _payOutChannelLabel(context),
                      style: AppTextStyles.baseBold(context),
                    ),
                    const VSpace(12),
                    _buildReceipientField(
                      state: state,
                      controller: receipientController,
                      hintText: _payOutChannelLabel(context),
                      onChanged: (value) {},
                      paymentChannel: selectedPaymentChannel!,
                    ),
                    if (_shouldShowFullNameField()) ...[
                      const VSpace(26),
                      Text(AppLocalizations.of(context)!.fullName, style: AppTextStyles.baseBold(context)),
                      const VSpace(12),
                      _buildFullNameField(
                        state: state,
                        controller: fullNameController,
                        hintText: AppLocalizations.of(context)!.enterFullName,
                        onChanged: (value) {},
                      ),
                    ],
                    if (_shouldShowPhoneNumberField()) ...[
                      const VSpace(26),
                      Text(
                        AppLocalizations.of(context)!.phoneNumber,
                        style: AppTextStyles.baseBold(context),
                      ),
                      const VSpace(12),
                      _buildPhoneNumberField(
                        state: state,
                        controller: phoneNumberController,
                        hintText: AppLocalizations.of(context)!.enterPhoneNumber,
                        onChanged: (value) {},
                      ),
                    ],
                  ],
                  const VSpace(32),
                  SizedBox(
                    width: double.infinity,
                    child: _isFormValid(state)
                        ? ButtonFactory.blackButton(
                            mainAxisAlignment: MainAxisAlignment.center,
                            text: AppLocalizations.of(context)!.next,
                            onPressed: () => _onContinuePressed(state),
                          )
                        : ButtonFactory.disabledButton(text: AppLocalizations.of(context)!.next),
                  ),
                  const VSpace(24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowCarrierSelector() {
    if (selectedPaymentChannel == null) return false;
    final carriers = selectedPaymentChannel!.carriers;
    return carriers != null && carriers.isNotEmpty;
  }

  bool _shouldShowBankSelector(WalletState state) {
    if (selectedPaymentChannel == null) return false;
    if (selectedPaymentChannel!.type.toLowerCase() != 'bank') return false;
    final bankOptions = _getBankOptions(state);
    return bankOptions.isNotEmpty;
  }

  bool _shouldShowPhoneNumberField() {
    if (selectedPaymentChannel == null) return false;
    return selectedPaymentChannel!.type.toLowerCase() == 'bank';
  }

  bool _shouldShowFullNameField() {
    if (selectedPaymentChannel == null) return false;
    final type = selectedPaymentChannel!.type.toLowerCase();
    return type == 'mobile_money' || type == 'airtime';
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
          state.supportedCurrencyMessage ?? AppLocalizations.of(context)!.failedToLoadPaymentChannels,
          style: AppTextStyles.sm(context).copyWith(color: AppColors.error500),
        ),
      );
    }

    final flagObject = getCurrentUserFlag();
    final countryCode = CountryCode(
      name: 'Ghana',
      code: 'GH',
      dialCode: '+233',
    );

    return InkWell(
      onTap: paymentChannels.isNotEmpty
          ? () => _showPaymentChannelSheet(paymentChannels)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (selectedPaymentChannel != null && flagObject != null) ...[
              Image.asset(
                flagObject.$1,
                package: countryCode.flagImagePackage,
                width: 24,
                height: 24,
              ),
              const HSpace(12),
            ],
            Expanded(
              child: Text(
                selectedPaymentChannel != null
                    ? _getPaymentChannelDisplayName(
                        context,
                        selectedPaymentChannel!.type,
                      )
                    : AppLocalizations.of(context)!.selectPaymentChannel,
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

  Widget _buildBankSelector(WalletState state) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpSelectorShimmer();
    }

    return InkWell(
      onTap: () => _showBankSheet(state),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedBank?.label ?? AppLocalizations.of(context)!.selectBank,
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

  Widget _buildCarrierSelector(WalletState state) {
    final carriers = selectedPaymentChannel?.carriers ?? [];
    if (carriers.isEmpty) return const SizedBox.shrink();

    final carrierIcon = selectedCarrier != null
        ? getCarrierIcon(selectedCarrier!.name)
        : null;

    return InkWell(
      onTap: () => _showCarrierSheet(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (carrierIcon != null) ...[
              Image.asset(carrierIcon, width: 24, height: 24),
              const HSpace(12),
            ],
            Expanded(
              child: Text(
                selectedCarrier?.name ?? AppLocalizations.of(context)!.selectNetworkProvider,
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

  Widget _buildReceipientField({
    required WalletState state,
    required TextEditingController controller,
    required String hintText,
    required void Function(String) onChanged,
    required PaymentChannel paymentChannel,
  }) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpAmountFieldShimmer();
    }

    return TextFieldFactory.standard(
      controller: controller,
      config: TextFieldConfig(
        hintText: hintText,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final l10n = AppLocalizations.of(context)!;
          if (value == null || value.isEmpty) {
            return paymentChannel.type == 'bank'
                ? l10n.pleaseEnterBankAccountNumber
                : l10n.pleaseEnterMobileNumber;
          }

          if (paymentChannel.type == 'mobile_money') {
            final regex = RegExp(r'^\d{9,15}$');
            if (!regex.hasMatch(value)) {
              return l10n.pleaseEnterValidMobileMoneyNumber;
            }
          }
          if (paymentChannel.type == 'airtime') {
            final regex = RegExp(r'^\d{9,15}$');
            if (!regex.hasMatch(value)) {
              return l10n.pleaseEnterValidAirtimeNumber;
            }
          }
          if (paymentChannel.type == 'bank') {
            final regex = RegExp(r'^\d{8,20}$');
            if (!regex.hasMatch(value)) {
              return l10n.pleaseEnterValidBankAccountNumber;
            }
          }

          return null;
        },
      ),
    );
  }

  Widget _buildPhoneNumberField({
    required WalletState state,
    required TextEditingController controller,
    required String hintText,
    required void Function(String) onChanged,
  }) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpAmountFieldShimmer();
    }

    final userCountry = LocalStorageService.getUserSync()?.country ?? 'Ghana';

    return TextFieldFactory.standard(
      controller: controller,
      config: TextFieldConfig(
        hintText: hintText,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\+]'))],
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return PhoneNumberUtils.validatePhoneNumber(value, userCountry);
        },
      ),
    );
  }

  Widget _buildFullNameField({
    required WalletState state,
    required TextEditingController controller,
    required String hintText,
    required void Function(String) onChanged,
  }) {
    if (state.quoteStatus == QuoteStatus.loading) {
      return const OfframpAmountFieldShimmer();
    }

    return TextFieldFactory.standard(
      controller: controller,
      config: TextFieldConfig(
        hintText: hintText,
        keyboardType: TextInputType.name,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          final l10n = AppLocalizations.of(context)!;
          if (value == null || value.isEmpty) {
            return l10n.pleaseEnterYourFullName;
          }
          if (value.trim().length < 3) {
            return l10n.fullNameMinLength;
          }
          return null;
        },
      ),
    );
  }
}
