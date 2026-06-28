import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/select_country_widget.dart';

class CountryEditBottomSheet extends StatefulWidget {
  final String currentCountry;
  final Function(String) onSave;

  const CountryEditBottomSheet({
    super.key,
    required this.currentCountry,
    required this.onSave,
  });

  @override
  State<CountryEditBottomSheet> createState() => _CountryEditBottomSheetState();
}

class _CountryEditBottomSheetState extends State<CountryEditBottomSheet> {
  late TextEditingController _countryController;
  bool _isValid = false;
  late final FlCountryCodePicker countryPicker;
  CountryCode? selectedCountryCode;

  @override
  void initState() {
    super.initState();

    countryPicker = FlCountryCodePicker(
      countryTextStyle: TextStyle(color: AppColors.gray900, fontSize: 16),
      dialCodeTextStyle: TextStyle(color: Colors.black, fontSize: 16),
    );
    if (widget.currentCountry.isNotEmpty) {
      try {
        selectedCountryCode = CountryCode.fromName(widget.currentCountry);
      } catch (e) {
        selectedCountryCode = CountryCode.fromCode('NG');
      }
    } else {
      selectedCountryCode = CountryCode.fromCode('NG');
    }

    _countryController = TextEditingController(text: widget.currentCountry);
    _countryController.addListener(_onCountryChanged);
  }

  @override
  void dispose() {
    _countryController.removeListener(_onCountryChanged);
    _countryController.dispose();
    super.dispose();
  }

  void _onCountryChanged() {
    final country = _countryController.text.trim();
    setState(() {
      _isValid = country.isNotEmpty;
    });
  }

  void _onCountrySelected(CountryCode code) {
    setState(() {
      selectedCountryCode = code;
      _countryController.text = code.name;
    });
  }

  void _handleSave() {
    final country = _countryController.text.trim();
    if (country.isNotEmpty && _isValid) {
      widget.onSave(country);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VSpace(20),
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: AppTextStyles.baseSemiBold(context),
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.country,
                    style: AppTextStyles.baseBold(context),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: _isValid ? _handleSave : null,
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: AppTextStyles.baseSemiBold(context).copyWith(
                      color: _isValid ? AppColors.gray900 : AppColors.gray400,
                    ),
                  ),
                ),
              ],
            ),
            VSpace(20),
            SelectCountryWidget(
              mode: CountryWidgetMode.register,
              countryPicker: countryPicker,
              countryCode: selectedCountryCode,
              onCountrySelected: _onCountrySelected,
            ),
            VSpace(10),
            Text(
              AppLocalizations.of(context)!.selectCountryDescription,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
