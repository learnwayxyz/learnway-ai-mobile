import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

enum CountryWidgetMode { register, updatePhone }

class SelectCountryWidget extends StatelessWidget {
  const SelectCountryWidget({
    super.key,
    required this.countryPicker,
    required this.onCountrySelected,
    this.countryCode,
    this.mode = CountryWidgetMode.register,
  });

  final FlCountryCodePicker countryPicker;
  final CountryCode? countryCode;
  final Function(CountryCode) onCountrySelected;
  final CountryWidgetMode mode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return InkWell(
      onTap: () async {
        final selectedCountry = await countryPicker.showPicker(
          context: context,
          fullScreen: false,
          pickerMinHeight: screenHeight * 0.4,
          pickerMaxHeight: screenHeight - safeAreaTop - safeAreaBottom - 40,
        );
        if (selectedCountry != null) {
          onCountrySelected(selectedCountry);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.gray900 : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD5D6D9)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (mode == CountryWidgetMode.updatePhone || countryCode != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: countryCode?.flagImage(fit: BoxFit.cover),
                ),
              ),

            if (mode == CountryWidgetMode.register) ...[
              const HSpace(10),
              Text(
                countryCode?.name ?? 'Select Country',
                style: AppTextStyles.base(context),
              ),
              const Spacer(),
            ] else
              const Spacer(),

            const HSpace(10),
            SizedBox(
              height: 24,
              width: 24,
              child: SvgPicture.asset('assets/images/arrow-down.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
