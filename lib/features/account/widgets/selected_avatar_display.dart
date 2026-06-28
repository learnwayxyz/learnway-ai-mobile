import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/image_helpers.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class SelectedAvatarDisplay extends StatelessWidget {
  final ProfileState state;
  final bool isValidatingImage;
  final bool Function(ProfileState) hasSelectedAvatar;
  final bool Function(ProfileState) isCustomImage;
  final ImageProvider? Function(ProfileState) getAvatarImageProvider;

  const SelectedAvatarDisplay({
    super.key,
    required this.state,
    required this.isValidatingImage,
    required this.hasSelectedAvatar,
    required this.isCustomImage,
    required this.getAvatarImageProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasSelectedAvatar(state)) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: getAvatarImageProvider(state),
                    ),
                  ],
                ),
                HSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avatar Selected',
                        style: AppTextStyles.baseBold(context),
                      ),
                      Text(
                        _getSubtitleText(state),
                        style: AppTextStyles.sm(context),
                      ),
                      if (isCustomImage(state) && state.hasSelectedImage)
                        FutureBuilder<double>(
                          future: ImageHelper.getFileSizeInMB(
                            File(state.selectedImagePath!),
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
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        VSpace(20),
      ],
    );
  }

  String _getSubtitleText(ProfileState state) {
    if (state.isUpdating) {
      return 'Please wait...';
    } else if (state.isUpdated) {
      return 'Avatar updated successfully';
    } else if (state.hasUpdateError) {
      return 'Tap Change to retry';
    } else {
      return 'You can change it below if needed';
    }
  }
}
