import 'package:flutter/material.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';

class EmailEditBottomSheet extends StatefulWidget {
  final String currentEmail;
  final Function(String) onSave;

  const EmailEditBottomSheet({
    super.key,
    required this.currentEmail,
    required this.onSave,
  });

  @override
  State<EmailEditBottomSheet> createState() => _EmailEditBottomSheetState();
}

class _EmailEditBottomSheetState extends State<EmailEditBottomSheet> {
  late TextEditingController _emailController;
  bool _isValid = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    final email = _emailController.text.trim();
    final validationResult = BaseValidators.email(email);

    setState(() {
      _isValid = validationResult == null && email.isNotEmpty;
      _errorMessage = validationResult;
    });
  }

  void _handleSave() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _isValid) {
      widget.onSave(email);
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
                    AppLocalizations.of(context)!.email,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldFactory.email(
                  controller: _emailController,
                  config: TextFieldConfig(
                    hintText: AppLocalizations.of(context)!.enterEmailAddress,
                    hintTextStyle: AppTextStyles.base(
                      context,
                    ).copyWith(color: AppColors.hintTextColor),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => BaseValidators.email(value ?? ''),
                    borderRadius: BorderRadius.circular(12),
                    enabledBorderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
