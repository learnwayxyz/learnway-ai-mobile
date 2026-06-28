import 'package:flutter/material.dart';
import 'package:learnwayv2/features/wallet/models/quote_response.dart';
import 'package:learnwayv2/features/wallet/models/supported_currencies_response.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/currency_check.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

String? getCarrierIcon(String carrierName) {
  final name = carrierName.toLowerCase();
  if (name.contains('mtn')) {
    return Assets.images.momoLogo.path;
  } else if (name.contains('telecel') || name.contains('vodafone')) {
    return Assets.images.telecelLogo.path;
  } else if (name.contains('airtel') || name.contains('tigo')) {
    return Assets.images.airteltigoLogo.path;
  } else if (name.contains('9mobile')) {
    return Assets.icons.a9mobileLogo.path;
  } else if (name.contains('glo')) {
    return Assets.icons.gloLogo.path;
  }
  return null;
}

class DepositNetworkProviderBottomSheet extends StatelessWidget {
  const DepositNetworkProviderBottomSheet({
    super.key,
    required this.selectedNetwork,
    required this.onNetworkSelected,
    required this.country,
    required this.paymentChannel,
  });
  final String? selectedNetwork;
  final Function(CarrierInfo) onNetworkSelected;
  final String country;
  final String paymentChannel;
  @override
  Widget build(BuildContext context) {
    final carriers = CurrencyCheck.getCarriersByCountryAndChannel(
      country,
      paymentChannel,
    );
    final carriersWithApiCodes = carriers.map((carrier) {
      final apiCode = CurrencyCheck.getSpecificCarrierCode(
        country,
        paymentChannel,
        carrier.name,
      );
      final finalCode = apiCode.isNotEmpty
          ? apiCode
          : CurrencyCheck.getCarrierCodeByCountryAndChannel(
              country,
              paymentChannel,
            );
      return CarrierInfo(name: carrier.name, code: finalCode);
    }).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF8F9FC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VSpace(22),
          Text('Network Provider', style: AppTextStyles.baseSemiBold(context)),
          const VSpace(11),
          Divider(color: AppColors.gray200, height: 1),
          const VSpace(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: carriersWithApiCodes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No carriers available for $country - $paymentChannel',
                      style: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.gray600),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: carriersWithApiCodes.map((carrier) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DepositNetworkOption(
                          title: carrier.name,
                          isSelected: selectedNetwork == carrier.name,
                          onTap: () {
                            onNetworkSelected(carrier);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const VSpace(20),
          VSpace(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class DepositNetworkOption extends StatelessWidget {
  const DepositNetworkOption({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gray900 : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.baseSemiBold(
                  context,
                ).copyWith(color: AppColors.gray900),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.gray900, size: 24),
          ],
        ),
      ),
    );
  }
}

class MobileMoneyNetwork {
  MobileMoneyNetwork({required this.name});

  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileMoneyNetwork &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class NetworkProviderBottomSheet extends StatelessWidget {
  final List<MobileMoneyNetwork> networks;
  final String? selectedNetwork;
  final Function(String) onNetworkSelected;

  const NetworkProviderBottomSheet({
    super.key,
    required this.networks,
    required this.selectedNetwork,
    required this.onNetworkSelected,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xffF8F9FC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VSpace(22),
          Text('Network Provider', style: AppTextStyles.baseSemiBold(context)),
          const VSpace(11),
          Divider(color: AppColors.gray200, height: 1),
          const VSpace(30),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: networks.length,
              itemBuilder: (context, index) {
                final network = networks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: NetworkOption(
                    title: network.name,
                    isSelected: selectedNetwork == network.name,
                    onTap: () {
                      onNetworkSelected(network.name);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          const VSpace(20),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class NetworkOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NetworkOption({
    super.key,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gray900 : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.baseSemiBold(
                  context,
                ).copyWith(color: AppColors.gray900),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.gray900, size: 24),
          ],
        ),
      ),
    );
  }
}

class CarrierBottomSheet extends StatefulWidget {
  final List<Carrier> carriers;
  final String? selectedCarrier;
  final Function(Carrier) onCarrierSelected;

  const CarrierBottomSheet({
    super.key,
    required this.carriers,
    required this.selectedCarrier,
    required this.onCarrierSelected,
  });

  @override
  State<CarrierBottomSheet> createState() => _CarrierBottomSheetState();
}

class _CarrierBottomSheetState extends State<CarrierBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Carrier> _filteredCarriers = [];

  @override
  void initState() {
    super.initState();
    _filteredCarriers = widget.carriers;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCarriers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCarriers = widget.carriers;
      } else {
        _filteredCarriers = widget.carriers
            .where(
              (carrier) =>
                  carrier.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  bool get _shouldShowSearch => widget.carriers.length > 5;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: 0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffF8F9FC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const VSpace(22),
              Text('Select Carrier', style: AppTextStyles.baseSemiBold(context)),
              const VSpace(11),
              Divider(color: AppColors.gray200, height: 1),
              if (_shouldShowSearch) ...[
                const VSpace(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCarriers,
                    decoration: InputDecoration(
                      hintText: 'Search carrier',
                      hintStyle: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.gray400),
                      prefixIcon: Icon(Icons.search, color: AppColors.gray400),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray900),
                      ),
                    ),
                  ),
                ),
              ],
              const VSpace(16),
              Flexible(
                fit: FlexFit.loose,
                child: _filteredCarriers.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No carriers found',
                          style: AppTextStyles.base(
                            context,
                          ).copyWith(color: AppColors.gray600),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredCarriers.length,
                          itemBuilder: (context, index) {
                            final carrier = _filteredCarriers[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CarrierOption(
                                title: carrier.name,
                                icon: getCarrierIcon(carrier.name),
                                isSelected: widget.selectedCarrier == carrier.name,
                                onTap: () {
                                  widget.onCarrierSelected(carrier);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const VSpace(20),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class CarrierOption extends StatelessWidget {
  final String title;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CarrierOption({
    super.key,
    required this.title,
    this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.gray900 : AppColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Image.asset(icon!, width: 24, height: 24),
              const HSpace(12),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.baseSemiBold(
                  context,
                ).copyWith(color: AppColors.gray900),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.gray900, size: 24),
          ],
        ),
      ),
    );
  }
}

class BankBottomSheet extends StatefulWidget {
  final List<FieldOption> banks;
  final String? selectedBank;
  final Function(FieldOption) onBankSelected;

  const BankBottomSheet({
    super.key,
    required this.banks,
    required this.selectedBank,
    required this.onBankSelected,
  });

  @override
  State<BankBottomSheet> createState() => _BankBottomSheetState();
}

class _BankBottomSheetState extends State<BankBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<FieldOption> _filteredBanks = [];

  @override
  void initState() {
    super.initState();
    _filteredBanks = widget.banks;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBanks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBanks = widget.banks;
      } else {
        _filteredBanks = widget.banks
            .where(
              (bank) => bank.label.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  bool get _shouldShowSearch => widget.banks.length > 5;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          minHeight: 0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffF8F9FC),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const VSpace(22),
              Text('Select Bank', style: AppTextStyles.baseSemiBold(context)),
              const VSpace(11),
              Divider(color: AppColors.gray200, height: 1),
              if (_shouldShowSearch) ...[
                const VSpace(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterBanks,
                    decoration: InputDecoration(
                      hintText: 'Search bank',
                      hintStyle: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.gray400),
                      prefixIcon: Icon(Icons.search, color: AppColors.gray400),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray900),
                      ),
                    ),
                  ),
                ),
              ],
              const VSpace(16),
              Flexible(
                fit: FlexFit.loose,
                child: _filteredBanks.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No banks found',
                          style: AppTextStyles.base(
                            context,
                          ).copyWith(color: AppColors.gray600),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredBanks.length,
                          itemBuilder: (context, index) {
                            final bank = _filteredBanks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CarrierOption(
                                title: bank.label,
                                isSelected: widget.selectedBank == bank.label,
                                onTap: () {
                                  widget.onBankSelected(bank);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const VSpace(20),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
