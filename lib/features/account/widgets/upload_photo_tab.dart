import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/account/cubit/profile_cubit.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';

class UploadPhotoTab extends StatelessWidget {
  const UploadPhotoTab({
    super.key,
    required this.onShowCameraOptions,
    required this.isValidatingImage,
  });

  final VoidCallback onShowCameraOptions;
  final bool isValidatingImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Center(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.hasSelectedImage &&
                !state.selectedImagePath!.startsWith('assets/')) {
              return _buildSelectedImageView(context, state.selectedImagePath!);
            }

            if (state.hasUser &&
                state.user!.profileImageUrl != null &&
                state.user!.profileImageUrl!.isNotEmpty) {
              return _buildNetworkImageView(
                context,
                state.user!.profileImageUrl!,
              );
            }

            // Default empty state
            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  Widget _buildSelectedImageView(BuildContext context, String imagePath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onShowCameraOptions(),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(File(imagePath)),
              ),
              if (isValidatingImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        VSpace(20),
        Text(
          'Tap on the image to change photo',
          style: AppTextStyles.base(context).copyWith(
            color: AppColors.primaryColor,
            fontSize: FigmaConverter.fontSize(context, 16),
          ),
        ),
        VSpace(8),
        FutureBuilder<double>(
          future: ImageHelper.getFileSizeInMB(File(imagePath)),
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
    );
  }

  Widget _buildNetworkImageView(BuildContext context, String imageUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onShowCameraOptions(),
          child: Stack(
            children: [
              CircleAvatar(radius: 60, backgroundImage: NetworkImage(imageUrl)),
              if (isValidatingImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        VSpace(20),
        Text(
          'Tap on the image to change photo',
          style: AppTextStyles.base(context).copyWith(
            color: AppColors.primaryColor,
            fontSize: FigmaConverter.fontSize(context, 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: () => onShowCameraOptions(),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 10],
          strokeWidth: 2,
          radius: Radius.circular(15),
          color: AppColors.primary25,
          padding: EdgeInsets.all(16),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.images.folderCloud,
                width: 70,
                height: 70,
              ),
              VSpace(16),
              Text(
                'Please upload your profile picture',
                style: AppTextStyles.baseBold(
                  context,
                ).copyWith(color: AppColors.primary25),
                textAlign: TextAlign.center,
              ),
              VSpace(8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'File size: ',
                      style: AppTextStyles.sm(context).copyWith(
                        color: AppColors.gray600,
                        fontSize: FigmaConverter.fontSize(context, 14),
                      ),
                    ),
                    TextSpan(
                      text: 'Max 5MB',
                      style: AppTextStyles.sm(context).copyWith(
                        color: AppColors.primary25,
                        fontSize: FigmaConverter.fontSize(context, 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
