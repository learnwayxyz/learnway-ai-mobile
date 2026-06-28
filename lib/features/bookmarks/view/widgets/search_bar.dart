import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';

class BookmarkSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const BookmarkSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.blueGray25,
        borderRadius: BorderRadius.circular(60),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray600),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SvgPicture.asset(
              Assets.icons.searchIcon,
              width: 18,
              height: 18,
              color: AppColors.gray600,
            ),
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    onPressed: onClear,
                    icon: Icon(Icons.clear, color: AppColors.gray600, size: 20),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
