import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/account_setup/cubit/account_setup_cubit.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/validators/base_validators.dart';
import 'package:learnwayv2/shared/widgets/select_country_widget.dart';
import 'package:rename/platform_file_editors/abs_platform_file_editor.dart';

@RoutePage()
class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  CountryCode? countryCode;
  late final FlCountryCodePicker countryPicker;
  CountryCode? selectedCountryCode;
  late final FlCountryCodePicker selectCountryPicker;
  String userEmail = '';
  Timer? _debounceTimer;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

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

    _loadUserEmail();
    _fetchRemoteDataIfRegistered();
    _initializeFromState();
  }

  void _initializeFromState() {
    final state = context.read<AccountSetupCubit>().state;
    if (state is SetAccountDetails && !_isInitialized) {
      _syncControllersWithState(state);
      _isInitialized = true;
    }
  }

  void _syncControllersWithState(SetAccountDetails state) {
    if (state.userName.isNotEmpty && _userNameController.text.isEmpty) {
      _userNameController.text = state.userName;
    }

    if (state.referralCode != null &&
        state.referralCode!.isNotEmpty &&
        referralCodeController.text.isEmpty) {
      referralCodeController.text = state.referralCode!;
    }
    if (state.country.isNotEmpty && selectedCountryCode == null) {
      try {
        selectedCountryCode = CountryCode.fromName(state.country);
        setState(() {});
      } catch (e) {
        log('Error setting country from name: $e');
        try {
          selectedCountryCode = CountryCode.fromCode(state.country);
          setState(() {});
        } catch (e2) {
          log('Error setting country by code: $e2');
        }
      }
    }
  }

  void _fetchRemoteDataIfRegistered() async {
    final cubit = context.read<AccountSetupCubit>();
    await cubit.fetchUserProfile();
  }

  void _loadUserEmail() async {
    final email = await SharedPreferencesStore.getUserEmail(userEmailKey);
    if (mounted) {
      setState(() {
        userEmail = email ?? '';
      });
    }
  }

  void checkUserNameExists() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final cubit = context.read<AccountSetupCubit>();
      cubit.checkUserName(_userNameController.text.trim());
      log('Debouncing username check...');
    });
  }

  Widget showLoaderOrIcon(SetAccountDetails state) {
    if (state.isCheckingUsername) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state.isUsernameAvailable != null) {
      return state.isUsernameAvailable!
          ? const Icon(Icons.done_rounded, color: Colors.green)
          : const Icon(Icons.cancel_rounded, color: Colors.red);
    }

    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _userNameController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<AccountSetupCubit, AccountSetupState>(
      listener: (context, state) {
        if (state is SetAccountDetails && !_isInitialized) {
          _syncControllersWithState(state);
          _isInitialized = true;
        }
      },
      buildWhen: (previous, current) {
        if (previous is SetAccountDetails && current is SetAccountDetails) {
          return previous.userName != current.userName ||
              previous.country != current.country ||
              previous.referralCode != current.referralCode ||
              previous.isUsernameAvailable != current.isUsernameAvailable ||
              previous.isCheckingUsername != current.isCheckingUsername;
        }
        return true;
      },
      builder: (context, state) {
        logger.d('State: ${state is SetAccountDetails && state.isComplete}');
        return ListView(
          children: [
            Text(AppLocalizations.of(context)!.setUpYourAccount, style: AppTextStyles.xxlBold(context)),
            VSpace(10),
            RichText(
              text: TextSpan(
                style: AppTextStyles.md(context),
                children: [
                  if (userEmail.isNotEmpty) ...[
                    TextSpan(
                      text: userEmail,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' successfully signed in'),
                  ] else ...[
                    TextSpan(text: AppLocalizations.of(context)!.loadingUserEmail),
                  ],
                ],
              ),
            ),
            VSpace(43),
            Text(AppLocalizations.of(context)!.username, style: AppTextStyles.baseBold(context)),
            VSpace(8),
            if (state is SetAccountDetails)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      TextFieldFactory.name(
                        controller: _userNameController,
                        config: TextFieldConfig(
                          hintText: AppLocalizations.of(context)!.enterPreferredUsername,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              BaseValidators.validateUsername(value ?? ''),
                          hintTextStyle: AppTextStyles.base(
                            context,
                          ).copyWith(color: AppColors.hintTextColor),
                          onChanged: (String? value) {
                            if (value == null || value.isEmpty) {
                              context.read<AccountSetupCubit>().updateUserName(
                                '',
                              );
                              return;
                            }
                            context.read<AccountSetupCubit>().updateUserName(
                              value.trim(),
                            );
                            checkUserNameExists();
                          },
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 20,
                        child: Center(child: showLoaderOrIcon(state)),
                      ),
                    ],
                  ),
                  if (state.isUsernameAvailable == false) ...[
                    VSpace(2),
                    Text(
                      AppLocalizations.of(context)!.usernameAlreadyExists,
                      style: AppTextStyles.sm(
                        context,
                      ).copyWith(color: Colors.red),
                    ),
                  ] else if (state.isUsernameAvailable == true) ...[
                    VSpace(2),
                    Text(
                      AppLocalizations.of(context)!.usernameAvailable,
                      style: AppTextStyles.sm(
                        context,
                      ).copyWith(color: Colors.green),
                    ),
                  ] else ...[
                    const SizedBox.shrink(),
                  ],
                ],
              )
            else
              TextFieldFactory.name(
                controller: _userNameController,
                config: TextFieldConfig(
                  hintText: 'Enter preferred username',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      BaseValidators.validateUsername(value ?? ''),
                  hintTextStyle: AppTextStyles.base(
                    context,
                  ).copyWith(color: AppColors.hintTextColor),
                  onChanged: (String? value) {
                    if (value == null || value.isEmpty) {
                      return;
                    }
                    context.read<AccountSetupCubit>().updateUserName(
                      value.trim(),
                    );
                  },
                ),
              ),
            VSpace(23),
            Text(AppLocalizations.of(context)!.country, style: AppTextStyles.sm(context)),
            VSpace(8),
            SelectCountryWidget(
              mode: CountryWidgetMode.register,
              countryPicker: selectCountryPicker,
              countryCode: selectedCountryCode,
              onCountrySelected: (countryCode) {
                log('Selected country: ${countryCode.name}');
                setState(() {
                  selectedCountryCode = countryCode;
                });
                context.read<AccountSetupCubit>().updateCountry(
                  countryCode.name,
                );
              },
            ),
            VSpace(23),
            Text(
              AppLocalizations.of(context)!.referralCodeOptional,
              style: AppTextStyles.baseBold(context),
            ),
            VSpace(8),
            TextFieldFactory.name(
              controller: referralCodeController,
              config: TextFieldConfig(
                hintText: AppLocalizations.of(context)!.referralCodeHint,
                hintTextStyle: AppTextStyles.base(
                  context,
                ).copyWith(color: AppColors.hintTextColor),
                onChanged: (value) {
                  context.read<AccountSetupCubit>().updateReferralCode(
                    value.trim().isEmpty ? null : value.trim(),
                  );
                },
              ),
            ),
            VSpace(20),
          ],
        );
      },
    );
  }
}
