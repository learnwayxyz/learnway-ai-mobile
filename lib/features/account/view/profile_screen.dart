import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/data/user_account_model.dart';
import 'package:learnwayv2/features/account/widgets/account_sections.dart';
import 'package:learnwayv2/features/account/widgets/country_edit_bottom_sheet.dart';
import 'package:learnwayv2/features/account/widgets/email_edit_bottom_sheet.dart';
import 'package:learnwayv2/features/account/widgets/name_edit_bottom_sheet.dart';
import 'package:learnwayv2/features/account/widgets/phone_number_edit_bottom_sheet.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/screen_connectivity_wrapper.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with ScreenLoadStateMixin<ProfileScreen> {
  @override
  String get routeName => '/profile';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _populateControllers(UserAccountModel user) {
    _nameController.text = user.username ?? '';
    _phoneController.text = '';
    _emailController.text = user.email ?? '';
    _countryController.text = user.country ?? '';
  }

  Widget? _getCountryFlag(String? countryName) {
    if (countryName == null || countryName.isEmpty) return null;

    try {
      final countryCode = CountryCode.fromName(countryName);
      if (countryCode != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            width: 24,
            height: 16,
            child: countryCode.flagImage(fit: BoxFit.cover),
          ),
        );
      }
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenConnectivityWrapper(
      routeName: routeName,
      onRetry: () => context.read<ProfileCubit>().fetchUserData(),
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(title: AppLocalizations.of(context)!.profile, barHeight: 10),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.hasUser && !state.isLoading) {
              markAsLoaded();
            }

            if (state.hasUser) {
              _populateControllers(state.user!);
            }
            if (state.isUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.profileUpdatedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );

              Future.delayed(Duration(milliseconds: 500), () {
                if (!context.mounted) return;
                context.read<ProfileCubit>().clearUpdateError();
              });
            } else if (state.hasUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.updateErrorMessage ?? AppLocalizations.of(context)!.updateFailed),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? AppLocalizations.of(context)!.anErrorOccurred),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.isDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.accountDeletedSuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state.hasDeleteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.deleteErrorMessage ?? AppLocalizations.of(context)!.deleteFailed),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading && !state.hasUser) {
              return Center(child: CircularProgressIndicator());
            }

            if (state.hasError && !state.hasUser) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.errorWithMessage(state.errorMessage ?? '')),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().fetchUserData(),
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            }
            if (state.hasUser) {
              _populateControllers(state.user!);
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(40),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage: _getProfileImage(state),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 120,
                              child: InkWell(
                                onTap: () => context.router.push(
                                  const ChangeAvatarRoute(),
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(60),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.edit,
                                    style: AppTextStyles.smSemiBold(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        VSpace(40),
                        _buildEditableField(
                          AppLocalizations.of(context)!.username,
                          _nameController,
                          state.user!.username ?? AppLocalizations.of(context)!.addUsername,
                          onSave: (value) => _updateProfile(username: value),
                          isLoading: state.isCheckingUsername,
                          backgroundColor: AppColors.white,

                          isEditable: true,
                        ),
                        VSpace(24),
                        _buildEditableField(
                          AppLocalizations.of(context)!.email,
                          _emailController,
                          state.user!.email ?? AppLocalizations.of(context)!.addEmail,
                          onSave: (value) => _updateProfile(email: value),
                          isEditable: false,
                          backgroundColor: AppColors.white,
                        ),
                        VSpace(24),
                        _buildEditableField(
                          AppLocalizations.of(context)!.country,
                          _countryController,
                          state.user!.country ?? AppLocalizations.of(context)!.addCountry,
                          onSave: (value) => _updateProfile(country: value),
                          countryFlag: _getCountryFlag(state.user!.country),
                          backgroundColor: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  if (state.isUpdating || state.isDeleting)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            VSpace(16),
                            Text(
                              state.isUpdating
                                  ? AppLocalizations.of(context)!.updatingProfile
                                  : AppLocalizations.of(context)!.deletingAccount,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }

            return Center(child: Text(AppLocalizations.of(context)!.noDataAvailable));
          },
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    String placeholder, {
    required Function(String) onSave,
    bool isLoading = false,
    bool isEditable = true,
    Color? backgroundColor,
    Widget? countryFlag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(label, style: AppTextStyles.sm(context))]),
        VSpace(10),
        IndependentTile(
          icon: '',

          styles: AppTextStyles.smSemiBold(context),
          title: controller.text.isEmpty ? placeholder : controller.text,
          onTap: isLoading || !isEditable
              ? null
              : () {
                  final l10n = AppLocalizations.of(context)!;
                  if (label == l10n.username) {
                    _showNameEditBottomSheet(context, controller.text);
                  } else if (label == l10n.phoneNumber) {
                    _showPhoneEditBottomSheet(context, controller.text);
                  } else if (label == l10n.email) {
                    _showEmailEditBottomSheet(context, controller.text);
                  } else if (label == l10n.country) {
                    _showCountryEditBottomSheet(context, controller.text);
                  }
                },
          showArrow: isEditable,
          backgroundColor: backgroundColor,
          countryFlag: countryFlag,
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage(ProfileState state) {
    // Handle selected image (only for assets, not local files)
    if (state.hasSelectedImage &&
        state.selectedImagePath!.startsWith('assets/')) {
      return AssetImage(state.selectedImagePath!);
    }

    // Handle local file selected image (only if user profile URL is not available)
    if (state.hasSelectedImage &&
        !state.selectedImagePath!.startsWith('assets/') &&
        (state.user?.profileImageUrl == null ||
            state.user!.profileImageUrl!.isEmpty)) {
      return FileImage(File(state.selectedImagePath!));
    }

    // Handle network images
    if (state.user?.profileImageUrl != null &&
        state.user!.profileImageUrl!.isNotEmpty) {
      return NetworkImage(state.user!.profileImageUrl!);
    }

    if (state.user?.profileThumbnailUrl != null &&
        state.user!.profileThumbnailUrl!.isNotEmpty) {
      return NetworkImage(state.user!.profileThumbnailUrl!);
    }

    return null;
  }

  void _updateProfile({
    String? username,
    String? email,
    String? phoneNumber,
    String? country,
    String? profileImagePath,
  }) {
    context.read<ProfileCubit>().updateProfile(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      country: country,
      profileImagePath: profileImagePath,
    );
  }

  void _showNameEditBottomSheet(BuildContext context, String currentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: NameEditBottomSheet(
            currentName: currentName,
            onSave: (newName) => _updateProfile(username: newName),
          ),
        ),
      ),
    );
  }

  void _showPhoneEditBottomSheet(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: PhoneNumberEditBottomSheet(
          currentPhoneNumber: phoneNumber,
          onSave: (newPhone) => _updateProfile(email: newPhone),
        ),
      ),
    );
  }

  void _showEmailEditBottomSheet(BuildContext context, String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: EmailEditBottomSheet(
          currentEmail: email,
          onSave: (newEmail) => _updateProfile(email: newEmail),
        ),
      ),
    );
  }

  void _showCountryEditBottomSheet(BuildContext context, String country) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: CountryEditBottomSheet(
          currentCountry: country,
          onSave: (newCountry) => _updateProfile(country: newCountry),
        ),
      ),
    );
  }
}
