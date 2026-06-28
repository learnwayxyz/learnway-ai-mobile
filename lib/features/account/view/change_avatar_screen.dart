import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/features/account/widgets/avatar_selection_interface.dart';
import 'package:learnwayv2/features/account/widgets/selected_avatar_display.dart';
import 'package:learnwayv2/features/account/widgets/upload_photo_tab.dart';
import 'package:learnwayv2/features/account_setup/widgets/show_camera_sheet.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/image_helpers.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';

@RoutePage()
class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({super.key});

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  CustomTab _selectedTab = CustomTab.female;
  String? _selectedAvatar;
  bool _isValidatingImage = false;

  @override
  void initState() {
    super.initState();
    _loadExistingAvatar();
  }

  void _loadExistingAvatar() {
    final state = context.read<ProfileCubit>().state;
    if (state.hasUser) {
      setState(() {
        if (state.hasSelectedImage) {
          _selectedAvatar = state.selectedImagePath;
          if (!state.selectedImagePath!.startsWith('assets/')) {
            _selectedTab = CustomTab.uploadPhoto;
          }
        } else if (state.user!.profileImageUrl != null &&
            state.user!.profileImageUrl!.isNotEmpty) {
          _selectedAvatar = state.user!.profileImageUrl;
          if (state.user!.profileImageUrl!.contains('female')) {
            _selectedTab = CustomTab.female;
          } else if (state.user!.profileImageUrl!.contains('male')) {
            _selectedTab = CustomTab.male;
          } else {
            _selectedTab = CustomTab.uploadPhoto;
          }
        }
      });
    }
  }

  void _onAvatarSelected(String avatarPath) {
    setState(() {
      _selectedAvatar = avatarPath;
    });
    context.read<ProfileCubit>().setAvatar(avatarPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, responsiveInfo) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(31),
                        Text(
                          'Choose Avatar for your profile photo.',
                          style: AppTextStyles.mdBold(context).copyWith(
                            fontSize: FigmaConverter.fontSize(context, 18),
                          ),
                        ),
                        VSpace(4),
                        Text(
                          'Select mini me',
                          style: AppTextStyles.smRegular(context).copyWith(
                            fontSize: FigmaConverter.fontSize(context, 14),
                          ),
                        ),
                        VSpace(19),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: CustomTabs<CustomTab>(
                                tabs: [
                                  TabItem<CustomTab>(
                                    value: CustomTab.female,
                                    label: 'Female',
                                    textStyle: AppTextStyles.smRegular(context)
                                        .copyWith(
                                          fontSize: FigmaConverter.fontSize(
                                            context,
                                            14,
                                          ),
                                        ),
                                  ),
                                  TabItem<CustomTab>(
                                    value: CustomTab.male,
                                    label: 'Male',
                                    textStyle: AppTextStyles.smRegular(context)
                                        .copyWith(
                                          fontSize: FigmaConverter.fontSize(
                                            context,
                                            14,
                                          ),
                                        ),
                                  ),
                                  TabItem<CustomTab>(
                                    value: CustomTab.uploadPhoto,
                                    label: 'Upload Photo',
                                    trailingIcon: SvgPicture.asset(
                                      Assets.icons.addCircleIcon,
                                    ),
                                    textStyle: AppTextStyles.smRegular(context)
                                        .copyWith(
                                          fontSize: FigmaConverter.fontSize(
                                            context,
                                            14,
                                          ),
                                        ),
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
                                defaultPadding:
                                    responsiveInfo.responsivePadding,
                                spacing: 10.0,
                              ),
                            ),
                          ],
                        ),
                        VSpace(20),

                        BlocConsumer<ProfileCubit, ProfileState>(
                          listener: (context, state) {
                            if (state.updateStatus == UpdateStatus.updated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Avatar updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }

                            if (state.hasUpdateError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.updateErrorMessage ?? 'Update failed',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }

                            if (state.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    state.errorMessage ?? 'An error occurred',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state.hasUser) {
                              return SelectedAvatarDisplay(
                                state: state,
                                isValidatingImage: _isValidatingImage,
                                hasSelectedAvatar: _hasSelectedAvatar,
                                isCustomImage: _isCustomImage,
                                getAvatarImageProvider: _getAvatarImageProvider,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        if (_selectedTab == CustomTab.female) ...[
                          FemaleAvatarSelectionWidget(
                            selectedAvatar: _selectedAvatar,
                            onAvatarSelected: _onAvatarSelected,
                          ),
                        ],

                        if (_selectedTab == CustomTab.male) ...[
                          MaleAvatarSelectionWidget(
                            selectedAvatar: _selectedAvatar,
                            onAvatarSelected: _onAvatarSelected,
                          ),
                        ],

                        if (_selectedTab == CustomTab.uploadPhoto) ...[
                          UploadPhotoTab(
                            isValidatingImage: _isValidatingImage,
                            onShowCameraOptions: () =>
                                _showCameraOptions(context),
                          ),
                        ],

                        VSpace(100),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state.isUpdating) {
                          return Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.gray200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  HSpace(12),
                                  Text(
                                    'Updating...',
                                    style: AppTextStyles.baseSemiBold(context),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final canUpdate =
                            state.hasUser && state.hasSelectedImage;

                        return ButtonFactory.blackButton(
                          onPressed: canUpdate
                              ? () {
                                  context.read<ProfileCubit>().updateProfile(
                                    profileImagePath: state.selectedImagePath,
                                  );
                                }
                              : () {},
                          text: 'Change',
                          mainAxisAlignment: MainAxisAlignment.center,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60, // Reduced height following Battle Screens pattern
      title: Container(
        padding: const EdgeInsets.only(bottom: 20), // 20px from bottom
        child: Row(
          children: [
            // Back button positioned exactly 20px from left
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.pop()),
            ),
            // Title centered in remaining space
            Expanded(
              child: Center(
                child: Text('Avatar', style: AppTextStyles.mdBold(context)),
              ),
            ),
            // Balancing SizedBox for symmetry
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  void _showCameraOptions(BuildContext context) {
    showCameraDialog(
      context,
      onTapCamera: () async {
        Navigator.of(context).pop(); // Dismiss the dialog first
        final cubit = context.read<ProfileCubit>();
        await cubit.selectProfileImage(
          imageSource: PreferredImageSource.camera,
        );
        final state = cubit.state;
        if (state.hasSelectedImage) {
          await _validateAndShowImage(state.selectedImagePath!);
        }
      },
      onTapGallery: () async {
        Navigator.of(context).pop(); // Dismiss the dialog first
        final cubit = context.read<ProfileCubit>();
        await cubit.selectProfileImage(
          imageSource: PreferredImageSource.gallery,
        );
        final state = cubit.state;
        if (state.hasSelectedImage) {
          await _validateAndShowImage(state.selectedImagePath!);
        }
      },
    );
  }

  bool _hasSelectedAvatar(ProfileState state) {
    return state.hasSelectedImage ||
        (state.user?.profileImageUrl != null &&
            state.user!.profileImageUrl!.isNotEmpty) ||
        (state.user?.profileThumbnailUrl != null &&
            state.user!.profileThumbnailUrl!.isNotEmpty);
  }

  bool _isCustomImage(ProfileState state) {
    return state.hasSelectedImage &&
        !state.selectedImagePath!.startsWith('assets/');
  }

  ImageProvider? _getAvatarImageProvider(ProfileState state) {
    if (state.hasSelectedImage) {
      if (state.selectedImagePath!.startsWith('assets/')) {
        return AssetImage(state.selectedImagePath!);
      } else {
        return FileImage(File(state.selectedImagePath!));
      }
    }

    if (state.user?.profileImageUrl != null &&
        state.user!.profileImageUrl!.isNotEmpty) {
      if (state.user!.profileImageUrl!.startsWith('assets/')) {
        return AssetImage(state.user!.profileImageUrl!);
      } else {
        return NetworkImage(state.user!.profileImageUrl!);
      }
    }

    if (state.user?.profileThumbnailUrl != null &&
        state.user!.profileThumbnailUrl!.isNotEmpty) {
      return NetworkImage(state.user!.profileThumbnailUrl!);
    }

    return null;
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
      const SnackBar(
        content: Text(
          'Invalid image file. Please select a valid JPG, PNG, or WebP image.',
        ),
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
