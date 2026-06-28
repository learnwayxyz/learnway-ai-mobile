import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/account_setup/view/select_avatar_screen.dart';

abstract class AvatarSelectionWidget extends StatelessWidget {
  final String? selectedAvatar;
  final Function(String) onAvatarSelected;
  final double height;

  const AvatarSelectionWidget({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    this.height = 0.6,
  });

  List<String> get avatarPaths;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 40,
          childAspectRatio: 1,
          mainAxisSpacing: 21.86,
        ),
        itemCount: avatarPaths.length,
        itemBuilder: (context, index) {
          final avatarPath = avatarPaths[index];
          final isSelected = selectedAvatar == avatarPath;

          return GestureDetector(
            onTap: () => onAvatarSelected(avatarPath),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border:
                    isSelected
                        ? Border.all(color: AppColors.primaryColor, width: 3)
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
                        child: const Icon(
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
    );
  }
}

class FemaleAvatarSelectionWidget extends AvatarSelectionWidget {
  const FemaleAvatarSelectionWidget({
    super.key,
    required super.selectedAvatar,
    required super.onAvatarSelected,
    super.height,
  });

  @override
  List<String> get avatarPaths => ImageStrings.femaleAvatars;
}

class MaleAvatarSelectionWidget extends AvatarSelectionWidget {
  const MaleAvatarSelectionWidget({
    super.key,
    required super.selectedAvatar,
    required super.onAvatarSelected,
    super.height,
  });

  @override
  List<String> get avatarPaths => ImageStrings.maleAvatars;
}
