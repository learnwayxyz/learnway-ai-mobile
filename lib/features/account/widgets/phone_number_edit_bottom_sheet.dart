import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';
import 'package:learnwayv2/shared/widgets/select_country_widget.dart';

class PhoneNumberEditBottomSheet extends StatefulWidget {
  final String currentPhoneNumber;
  final Function(String) onSave;

  const PhoneNumberEditBottomSheet({
    super.key,
    required this.currentPhoneNumber,
    required this.onSave,
  });

  @override
  State<PhoneNumberEditBottomSheet> createState() =>
      _PhoneNumberEditBottomSheetState();
}

class _PhoneNumberEditBottomSheetState
    extends State<PhoneNumberEditBottomSheet> {
  late TextEditingController _phoneController;
  bool _isValid = false;
  String? _errorMessage;
  late final FlCountryCodePicker countryPicker;
  late final FlCountryCodePicker selectCountryPicker;
  CountryCode? selectedCountryCode;

  @override
  void initState() {
    super.initState();

    countryPicker = FlCountryCodePicker(
      countryTextStyle: TextStyle(color: AppColors.gray900, fontSize: 16),
      dialCodeTextStyle: TextStyle(color: Colors.black, fontSize: 16),
    );
    selectCountryPicker = FlCountryCodePicker(
      countryTextStyle: TextStyle(color: AppColors.gray900, fontSize: 16),
      dialCodeTextStyle: TextStyle(color: Colors.black, fontSize: 16),
    );

    selectedCountryCode =
        CountryCode.fromCode('NG') ?? CountryCode.fromDialCode('+233');

    String initialPhone = widget.currentPhoneNumber.trim();
    if (selectedCountryCode != null &&
        !initialPhone.startsWith(selectedCountryCode!.dialCode)) {
      initialPhone = '${selectedCountryCode!.dialCode} $initialPhone';
    }

    _phoneController = TextEditingController(text: initialPhone);
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final phone = _phoneController.text.trim();
    final validationResult = BaseValidators.phone(phone);

    setState(() {
      _isValid = validationResult == null && phone.isNotEmpty;
      _errorMessage = validationResult;
    });
  }

  void _onCountrySelected(CountryCode code) {
    setState(() {
      String rawNumber = _phoneController.text.trim();

      if (selectedCountryCode != null &&
          rawNumber.startsWith(selectedCountryCode!.dialCode)) {
        rawNumber = rawNumber
            .replaceFirst(selectedCountryCode!.dialCode, '')
            .trim();
      }
      selectedCountryCode = code;
      _phoneController.text = '${code.dialCode} $rawNumber';
    });
  }

  void _handleSave() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty && _isValid) {
      widget.onSave(phone);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
                    AppLocalizations.of(context)!.phoneNumber,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SelectCountryWidget(
                    mode: CountryWidgetMode.updatePhone,
                    countryPicker: selectCountryPicker,
                    countryCode: selectedCountryCode,
                    onCountrySelected: _onCountrySelected,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _phoneController,
                    cursorColor: AppColors.gray900,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      _errorMessage = BaseValidators.phone(value ?? '');
                      return _errorMessage;
                    },
                    style: AppTextStyles.base(context),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(
                        context,
                      )!.enterPhoneNumberHint,
                      hintStyle: AppTextStyles.base(
                        context,
                      ).copyWith(color: AppColors.hintTextColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      errorText: null,
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.hintTextColor,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.hintTextColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.hintTextColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              ErrorBanner(message: '$_errorMessage'),
            ],
            Text(
              AppLocalizations.of(context)!.phoneNumberDescription,
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

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.showArrow = true,
  });

  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    final bannerColor = backgroundColor ?? AppColors.error600;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bannerColor,
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              child: Text(
                message,
                style: AppTextStyles.smRegular(color: Colors.white, context),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          if (showArrow)
            Positioned(
              top: -6,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.rotate(
                  angle: 45 * 3.14159 / 180,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
