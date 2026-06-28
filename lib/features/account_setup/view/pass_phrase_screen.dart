import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/account_setup/cubit/account_setup_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';

@RoutePage()
class PassphraseScreen extends StatefulWidget {
  const PassphraseScreen({super.key});

  @override
  State<PassphraseScreen> createState() => _PassphraseScreenState();
}

class _PassphraseScreenState extends State<PassphraseScreen> {
  final TextEditingController _passphraseController = TextEditingController();
  final TextEditingController _confirmPassphraseController =
      TextEditingController();

  bool _isPassphraseVisible = false;
  bool _isConfirmPassphraseVisible = false;
  List<PassphraseRequirement> _requirements = [];
  bool _passphrasesMatch = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
    _passphraseController.addListener(_validatePassphrase);
    _confirmPassphraseController.addListener(_validateMatch);
  }

  void _loadExistingData() {
    final state = context.read<AccountSetupCubit>().state;
    if (state is SetAccountDetails && state.passPhrase.isNotEmpty) {
      _passphraseController.text = state.passPhrase;
      _confirmPassphraseController.text = state.passPhrase;
      _validatePassphrase();
      _validateMatch();
    }
  }

  void _validatePassphrase() {
    final passphrase = _passphraseController.text;

    setState(() {
      _requirements = PassphraseValidator.getRequirements(passphrase);
    });

    _validateMatch();
    _savePassphrase();
  }

  void _validateMatch() {
    setState(() {
      _passphrasesMatch =
          _passphraseController.text.isNotEmpty &&
          _passphraseController.text == _confirmPassphraseController.text;
    });
    _savePassphrase();
  }

  void _savePassphrase() {
    if (_isValidPassphrase) {
      final cubit = context.read<AccountSetupCubit>();
      // cubit.setPassphrase(_passphraseController.text);
    }
  }

  bool get _isValidPassphrase {
    return PassphraseValidator.isValidPassphrase(_passphraseController.text) &&
        _passphrasesMatch;
  }

  Widget _buildValidationItem(PassphraseRequirement requirement) {
    return Row(
      children: [
        Icon(
          requirement.isValid ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: requirement.isValid ? Colors.green : AppColors.gray400,
        ),
        HSpace(8),
        Text(
          requirement.text,
          style: AppTextStyles.sm(context).copyWith(
            color: requirement.isValid ? Colors.green : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchValidation() {
    return Row(
      children: [
        Icon(
          _passphrasesMatch ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: _passphrasesMatch ? Colors.green : AppColors.gray400,
        ),
        HSpace(8),
        Text(
          AppLocalizations.of(context)!.passphrasesMatch,
          style: AppTextStyles.sm(context).copyWith(
            color: _passphrasesMatch ? Colors.green : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmPassphraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(AppLocalizations.of(context)!.secureYourWallet, style: AppTextStyles.xxlBold(context)),
        VSpace(10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${AppLocalizations.of(context)!.createStrongPassphraseTo} ',
                style: AppTextStyles.base(context),
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.encryptAndProtect,
                style: AppTextStyles.baseBold(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              TextSpan(
                text: ' ${AppLocalizations.of(context)!.yourWallet}',
                style: AppTextStyles.base(context),
              ),
            ],
          ),
        ),
        VSpace(24),
        Text(AppLocalizations.of(context)!.createPassphrase, style: AppTextStyles.baseBold(context)),
        VSpace(8),
        TextFieldFactory.password(
          controller: _passphraseController,
          config: TextFieldConfig(
            hintText: AppLocalizations.of(context)!.enterYourPassphrase,
            obscureText: !_isPassphraseVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPassphraseVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.gray600,
              ),
              onPressed: () {
                setState(() {
                  _isPassphraseVisible = !_isPassphraseVisible;
                });
              },
            ),
            onChanged: (value) {},
          ),
        ),

        VSpace(20),
        Text(AppLocalizations.of(context)!.confirmPassphrase, style: AppTextStyles.baseBold(context)),
        VSpace(8),
        TextFieldFactory.password(
          controller: _confirmPassphraseController,
          config: TextFieldConfig(
            hintText: AppLocalizations.of(context)!.confirmYourPassphrase,
            obscureText: !_isConfirmPassphraseVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPassphraseVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.gray600,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPassphraseVisible = !_isConfirmPassphraseVisible;
                });
              },
            ),
            onChanged: (value) {},
          ),
        ),
        VSpace(20),
        Text(AppLocalizations.of(context)!.passphraseRequirements, style: AppTextStyles.baseBold(context)),
        VSpace(12),
        Column(
          children: [
            ..._requirements.map(
              (requirement) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _buildValidationItem(requirement),
              ),
            ),
            _buildMatchValidation(),
          ],
        ),
        VSpace(20),
        BlocBuilder<AccountSetupCubit, AccountSetupState>(
          builder: (context, state) {
            if (state is SetAccountDetails && state.hasPassphrase) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    HSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.passphraseCreatedSuccessfully,
                            style: AppTextStyles.baseBold(
                              context,
                            ).copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
        VSpace(16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.blueLight700.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.blueLight700.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, color: AppColors.blueLight700, size: 20),
                  HSpace(8),
                  Text(
                    AppLocalizations.of(context)!.whyWeNeedThis,
                    style: AppTextStyles.baseBold(
                      context,
                    ).copyWith(color: AppColors.blueLight700),
                  ),
                ],
              ),
              VSpace(8),
              Text(
                AppLocalizations.of(context)!.passphraseEncryptsWallet,
                style: AppTextStyles.sm(
                  context,
                ).copyWith(color: AppColors.gray700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> get formData => {
    'passphrase': _passphraseController.text,
    'isValid': _isValidPassphrase,
  };
}
