import 'package:flutter/widgets.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:core/core.dart';

class BuildErrorWidget extends StatelessWidget {
  const BuildErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.images.noCompletedCourse.path),
          const SizedBox(height: 16),
          Text(
            'There was an error, pull to refresh',
            style: AppTextStyles.xxlBold(
              context,
            ).copyWith(color: AppColors.gray600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
