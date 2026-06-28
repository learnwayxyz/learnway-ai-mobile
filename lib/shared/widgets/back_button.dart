import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:core/core.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPress});
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.white,
        side: BorderSide(color: Color(0xFFD8DADC)),
        padding: const EdgeInsets.all(0),
      ),
      icon: SizedBox(
        child: SvgPicture.asset(
          'assets/images/backward_arrow.svg',
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
      onPressed: () {
        if (onPress == null) {
          Navigator.pop(context);
        } else {
          onPress!();
        }
      },
    );
  }
}
