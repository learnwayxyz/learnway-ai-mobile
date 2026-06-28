import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/battles/models/battle_option_model.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';

class BattleOptionTile extends StatelessWidget {
  final BattleOptionModel option;
  final bool isFirst;
  final bool isLast;

  const BattleOptionTile({
    super.key,
    required this.option,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.only(
          top: isFirst ? 0 : 13,
          bottom: isLast ? 0 : 13,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              option.iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColors.gray600,
                BlendMode.srcIn,
              ),
            ),
            const HSpace(16),
            Expanded(
              child: Text(
                option.title,
                style: AppTextStyles.baseMedium(context)
                    .copyWith(color: AppColors.textPrimary),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/battles/chevron.left.svg',
              width: 7,
              height: 12,
              colorFilter: ColorFilter.mode(
                AppColors.textTertiary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
