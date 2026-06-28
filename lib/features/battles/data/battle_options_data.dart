import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:learnwayv2/features/battles/models/battle_option_model.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/router/app_router.dart';

class BattleOptionsData {
  static List<BattleOptionModel> getOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      BattleOptionModel(
        iconPath: Assets.icons.battles.playWithAFriend,

        title: l10n.playWithAFriend,
        onTap: () => context.router.push(PlayWithFriendEntryRoute()),
      ),
      // BattleOptionModel(
      //   iconPath: 'assets/icons/battles/play_in_group.svg',
      //   title: 'Play in Group',
      //   onTap: () => context.router.push(PlayInGroupRoute()),
      // ),
      BattleOptionModel(
        iconPath: 'assets/icons/battles/play_with_bots.svg',
        title: l10n.challengeAI,
        onTap: () => context.router.push(PlayWithBotRoute()),
      ),
      // BattleOptionModel(
      //   iconPath: 'assets/icons/battles/online_opponent.svg',
      //   title: 'Online Opponent',
      //   onTap: () => context.router.push(OnlineOpponentRoute()),
      // ),
    ];
  }
}
