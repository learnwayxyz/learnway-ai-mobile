import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/features/battles/data/battle_options_data.dart';
import 'package:learnwayv2/features/battles/widgets/battle_hero_card.dart';
import 'package:learnwayv2/features/battles/widgets/battle_option_tile.dart';
import 'package:learnwayv2/features/battles/widgets/battle_styles.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';

@RoutePage()
class BattlesMainEntryScreen extends StatelessWidget {
  const BattlesMainEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBarFactory.standardAppBar(title: l10n.battles),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VSpace(20),
                      const BattleHeroCard(),
                      const VSpace(20),
                      _buildBattleOptions(context),
                      const VSpace(20),
                      _buildBattleHistory(context),
                      const VSpace(20),
                    ],
                  ),
                ),
              ),
            ),
            const BannerAdSlot(slotKey: 'battlesMainEntry'),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleOptions(BuildContext context) {
    final battleOptions = BattleOptionsData.getOptions(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BattleStyles.cardDecoration,
      child: Column(
        children: battleOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isLast = index == battleOptions.length - 1;
          final isFirst = index == 0;

          return Column(
            children: [
              BattleOptionTile(
                option: option,
                isFirst: isFirst,
                isLast: isLast,
              ),
              if (!isLast) BattleStyles.divider,
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBattleHistory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BattleStyles.historyCardDecoration,
      child: InkWell(
        onTap: () => context.router.push(BattleHistoryRoute()),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/battles/battle_history.svg',
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
                  l10n.battleHistory,
                  style: AppTextStyles.baseMedium(
                    context,
                  ).copyWith(color: AppColors.textPrimary),
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
      ),
    );
  }
}
