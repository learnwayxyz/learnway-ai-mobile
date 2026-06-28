import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/account_setup/cubit/account_setup_cubit.dart';
import 'package:learnwayv2/features/account_setup/widgets/show_camera_sheet.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/onboarding/onboarding.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/image_helpers.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

@RoutePage()
class SelectAvatarScreen extends StatefulWidget {
  const SelectAvatarScreen({super.key});

  @override
  State<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen>
    with AutomaticKeepAliveClientMixin {
  CustomTab _selectedTab = CustomTab.female;
  String? _selectedAvatar;
  bool _isValidatingImage = false;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadExistingAvatar();
  }

  void _loadExistingAvatar() {
    final state = context.read<AccountSetupCubit>().state;
    if (state is SetAccountDetails && !_isInitialized) {
      _syncWithState(state);
      _isInitialized = true;
    }
  }

  void _syncWithState(SetAccountDetails state) {
    if (state.prefferedImage.isEmpty) return;

    setState(() {
      _selectedAvatar = state.prefferedImage;
      if (state.prefferedImage.contains('female')) {
        _selectedTab = CustomTab.female;
      } else if (state.prefferedImage.contains('male')) {
        _selectedTab = CustomTab.male;
      } else if (state.prefferedImage.isNotEmpty &&
          !state.prefferedImage.startsWith('assets/')) {
        _selectedTab = CustomTab.uploadPhoto;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<AccountSetupCubit, AccountSetupState>(
      listener: (context, state) {
        if (state is SetAccountDetails && !_isInitialized) {
          _syncWithState(state);
          _isInitialized = true;
        }
      },
      buildWhen: (previous, current) {
        if (previous is SetAccountDetails && current is SetAccountDetails) {
          return previous.prefferedImage != current.prefferedImage;
        }
        return true;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.selectAnAvatar, style: AppTextStyles.xxlBold(context)),
            VSpace(10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppLocalizations.of(context)!.selectYour} ',
                    style: AppTextStyles.base(context),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.miniMe,
                    style: AppTextStyles.baseBold(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            VSpace(19),
            CustomTabs<CustomTab>(
              tabs: [
                TabItem<CustomTab>(
                  value: CustomTab.female,
                  label: AppLocalizations.of(context)!.female,
                  textStyle: AppTextStyles.baseBold(context),
                ),
                TabItem<CustomTab>(
                  value: CustomTab.male,
                  label: AppLocalizations.of(context)!.male,
                  textStyle: AppTextStyles.baseBold(context),
                ),
                TabItem<CustomTab>(
                  value: CustomTab.uploadPhoto,
                  label: AppLocalizations.of(context)!.uploadPhoto,
                  trailingIcon: SvgPicture.asset(Assets.icons.addCircleIcon),
                  textStyle: AppTextStyles.baseBold(context),
                ),
              ],
              selectedValue: _selectedTab,
              onTabSelected: (CustomTab selectedTab) {
                setState(() {
                  _selectedTab = selectedTab;
                });
              },
              defaultSelectedColor: AppColors.gray900,
              defaultUnselectedColor: AppColors.gray200,
              defaultSelectedTextColor: Colors.white,
              defaultUnselectedTextColor: AppColors.gray800,
              borderRadius: 60,
              defaultPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              spacing: 12.0,
            ),
            VSpace(20),
            if (state is SetAccountDetails &&
                state.selectAvatar.isSelectAvatarComplete)
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  state.prefferedImage.startsWith('assets/')
                                  ? AssetImage(state.prefferedImage)
                                        as ImageProvider
                                  : FileImage(File(state.prefferedImage)),
                            ),
                            if (_isValidatingImage)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        HSpace(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.avatarSelected,
                                style: AppTextStyles.baseBold(context).copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.canChangeBelow,
                                style: AppTextStyles.sm(context),
                              ),
                              if (!state.prefferedImage.startsWith('assets/'))
                                FutureBuilder<double>(
                                  future: ImageHelper.getFileSizeInMB(
                                    File(state.prefferedImage),
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        'Size: ${snapshot.data!.toStringAsFixed(1)}MB',
                                        style: AppTextStyles.xs(
                                          context,
                                        ).copyWith(color: AppColors.gray600),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  },
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                  VSpace(20),
                ],
              ),

            if (_selectedTab == CustomTab.female) ...[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 40,
                    childAspectRatio: 1,
                    mainAxisSpacing: 21.86,
                  ),
                  itemCount: ImageStrings.femaleAvatars.length,
                  itemBuilder: (context, index) {
                    final avatarPath = ImageStrings.femaleAvatars[index];
                    final isSelected = _isAvatarSelected(avatarPath);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarPath;
                        });
                        context.read<AccountSetupCubit>().setAvatar(avatarPath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryColor,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: AssetImage(avatarPath),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (_selectedTab == CustomTab.male) ...[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 40,
                    childAspectRatio: 1,
                    mainAxisSpacing: 21.86,
                  ),
                  itemCount: ImageStrings.maleAvatars.length,
                  itemBuilder: (context, index) {
                    final avatarPath = ImageStrings.maleAvatars[index];
                    final isSelected = _isAvatarSelected(avatarPath);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarPath;
                        });
                        context.read<AccountSetupCubit>().setAvatar(avatarPath);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primaryColor,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: AssetImage(avatarPath),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            if (_selectedTab == CustomTab.uploadPhoto) ...[
              Expanded(
                child: Center(
                  child:
                      state is SetAccountDetails &&
                          state.prefferedImage.isNotEmpty &&
                          !state.prefferedImage.startsWith('assets/')
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _showCameraOptions(context),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 80,
                                    backgroundImage: FileImage(
                                      File(state.prefferedImage),
                                    ),
                                  ),
                                  if (_isValidatingImage)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            VSpace(20),
                            Text(
                              AppLocalizations.of(context)!.tapToChangePhoto,
                              style: AppTextStyles.base(
                                context,
                              ).copyWith(color: AppColors.primaryColor),
                            ),
                            VSpace(8),
                            FutureBuilder<double>(
                              future: ImageHelper.getFileSizeInMB(
                                File(state.prefferedImage),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    'File size: ${snapshot.data!.toStringAsFixed(1)}MB',
                                    style: AppTextStyles.sm(
                                      context,
                                    ).copyWith(color: AppColors.gray600),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => _showCameraOptions(context),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.gray100,
                              border: Border.all(
                                color: AppColors.gray300,
                                style: BorderStyle.solid,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 50,
                                  color: AppColors.gray600,
                                ),
                                VSpace(16),
                                Text(
                                  AppLocalizations.of(context)!.uploadPhoto,
                                  style: AppTextStyles.baseBold(
                                    context,
                                  ).copyWith(color: AppColors.gray800),
                                ),
                                VSpace(8),
                                Text(
                                  AppLocalizations.of(context)!.tapToSelectPhoto,
                                  style: AppTextStyles.sm(
                                    context,
                                  ).copyWith(color: AppColors.gray600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showCameraOptions(BuildContext context) {
    showCameraDialog(
      context,
      onTapCamera: () async {
        Navigator.of(context).pop();
        final cubit = context.read<AccountSetupCubit>();
        await cubit.selectPrefferedImage(prefferedImage: PreferredImage.camera);
        final state = cubit.state;
        if (state is SetAccountDetails && state.prefferedImage.isNotEmpty) {
          await _validateAndShowImage(state.prefferedImage);
        }
      },
      onTapGallery: () async {
        Navigator.of(context).pop();
        final cubit = context.read<AccountSetupCubit>();
        await cubit.selectPrefferedImage(
          prefferedImage: PreferredImage.gallery,
        );
        final state = cubit.state;
        if (state is SetAccountDetails && state.prefferedImage.isNotEmpty) {
          await _validateAndShowImage(state.prefferedImage);
        }
      },
    );
  }

  bool _isAvatarSelected(String avatarPath) {
    return _selectedAvatar == avatarPath;
  }

  Future<void> _validateAndShowImage(String imagePath) async {
    if (!imagePath.startsWith('assets/')) {
      setState(() {
        _isValidatingImage = true;
      });

      final file = File(imagePath);
      final isValid = await ImageHelper.validateImageFile(file);

      setState(() {
        _isValidatingImage = false;
      });

      if (!isValid) {
        _showImageValidationError();
        return;
      }

      final fileSize = await ImageHelper.getFileSizeInMB(file);
      if (fileSize > 5.0) {
        _showFileSizeError(fileSize);
        return;
      }
    }
  }

  void _showImageValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.invalidImageFile),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFileSizeError(double fileSizeInMB) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Image file is too large (${fileSizeInMB.toStringAsFixed(1)}MB). Please select an image smaller than 5MB.',
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class ImageStrings {
  static List<String> femaleAvatars = [
    'assets/avatars/female0.png',
    'assets/avatars/female1.png',
    'assets/avatars/female2.png',
    'assets/avatars/female3.png',
    'assets/avatars/female4.png',
    'assets/avatars/female5.png',
    'assets/avatars/female6.png',
    'assets/avatars/female7.png',
    'assets/avatars/female8.png',
    'assets/avatars/female9.png',
    'assets/avatars/female10.png',
    'assets/avatars/female11.png',
  ];

  static List<String> maleAvatars = [
    'assets/avatars/male0.png',
    'assets/avatars/male1.png',
    'assets/avatars/male2.png',
    'assets/avatars/male3.png',
    'assets/avatars/male4.png',
    'assets/avatars/male5.png',
    'assets/avatars/male6.png',
    'assets/avatars/male7.png',
    'assets/avatars/male8.png',
    'assets/avatars/male9.png',
    'assets/avatars/male10.png',
    'assets/avatars/male11.png',
  ];
}
