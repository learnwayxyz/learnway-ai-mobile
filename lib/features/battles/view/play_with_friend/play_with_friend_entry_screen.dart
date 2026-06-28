import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/create_battle_modal.dart';
import 'package:learnwayv2/features/battles/view/play_with_friend/play_with_friend_join_room_modal.dart';
import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

@RoutePage()
class PlayWithFriendEntryScreen extends StatelessWidget {
  const PlayWithFriendEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<BattlesBloc>(),
      child: _PlayWithFriendView(),
    );
  }
}

class _PlayWithFriendView extends StatelessWidget {
  void _showCreateBattleModal(BuildContext context) {
    final bloc = context.read<BattlesBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          BlocProvider.value(value: bloc, child: const CreateBattleModal()),
    );
  }

  void _showJoinRoomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: locator<BattlesBloc>(),
        child: const PlayWithFriendJoinRoomModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBarFactory.standardAppBar(title: l10n.playWithFriends),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const VSpace(50),
                      ResponsiveBuilder(
                        builder: (context, responsiveInfo) {
                          double imageSize;
                          switch (responsiveInfo.screenSize) {
                            case ScreenSize.small:
                              imageSize = 250;
                              break;
                            case ScreenSize.medium:
                              imageSize = 300;
                              break;
                            case ScreenSize.large:
                              imageSize = 350;
                              break;
                            case ScreenSize.xlarge:
                              imageSize = 400;
                              break;
                          }
                          return Center(
                            child: Image.asset(
                              'assets/images/battles/smiling_man.png',
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                      const VSpace(35),
                      ResponsiveBuilder(
                        builder: (context, responsiveInfo) {
                          double titleFontSize;
                          double subtitleFontSize;
                          double spacing;
                          switch (responsiveInfo.screenSize) {
                            case ScreenSize.small:
                              titleFontSize = 24;
                              subtitleFontSize = 16;
                              spacing = 3;
                              break;
                            case ScreenSize.medium:
                              titleFontSize = 30;
                              subtitleFontSize = 18;
                              spacing = 5;
                              break;
                            case ScreenSize.large:
                              titleFontSize = 36;
                              subtitleFontSize = 20;
                              spacing = 7;
                              break;
                            case ScreenSize.xlarge:
                              titleFontSize = 42;
                              subtitleFontSize = 22;
                              spacing = 10;
                              break;
                          }
                          return Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  l10n.getReadyToParticipate,
                                  style: AppTextStyles.headline(context)
                                      .copyWith(
                                        color: AppColors.textDark,
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.w600,
                                        height: 1.13,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              VSpace(spacing),
                              Text(
                                l10n.battleEntryDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const VSpace(60),
                      ResponsiveBuilder(
                        builder: (context, responsiveInfo) {
                          double buttonHeight;
                          double buttonFontSize;
                          double dividerFontSize;
                          double spacing;
                          double dividerSpacing;
                          switch (responsiveInfo.screenSize) {
                            case ScreenSize.small:
                              buttonHeight = 50;
                              buttonFontSize = 14;
                              dividerFontSize = 14;
                              spacing = 15;
                              dividerSpacing = 15;
                              break;
                            case ScreenSize.medium:
                              buttonHeight = 55;
                              buttonFontSize = 16;
                              dividerFontSize = 16;
                              spacing = 20;
                              dividerSpacing = 20;
                              break;
                            case ScreenSize.large:
                              buttonHeight = 60;
                              buttonFontSize = 18;
                              dividerFontSize = 18;
                              spacing = 25;
                              dividerSpacing = 25;
                              break;
                            case ScreenSize.xlarge:
                              buttonHeight = 65;
                              buttonFontSize = 20;
                              dividerFontSize = 20;
                              spacing = 30;
                              dividerSpacing = 30;
                              break;
                          }
                          return Column(
                            children: [
                              ButtonFactory.blackButton(
                                text: l10n.createARoom,
                                onPressed: () =>
                                    _showCreateBattleModal(context),
                                isFullWidth: true,
                                height: buttonHeight,
                                backgroundColor: Colors.black,
                                textStyle: TextStyle(
                                  color: AppColors.gray100,
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  height: 1.12,
                                  letterSpacing: 0.20,
                                ),
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              VSpace(spacing),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  HSpace(dividerSpacing),
                                  Text(
                                    l10n.or,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: dividerFontSize,
                                      fontWeight: FontWeight.w600,
                                      height: 1.12,
                                      letterSpacing: 0.20,
                                    ),
                                  ),
                                  HSpace(dividerSpacing),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                ],
                              ),
                              VSpace(spacing),
                              ButtonFactory.blackButton(
                                text: l10n.joinARoom,
                                onPressed: () => _showJoinRoomModal(context),
                                isFullWidth: true,
                                height: buttonHeight,
                                backgroundColor: Colors.black,
                                textStyle: TextStyle(
                                  color: AppColors.gray100,
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  height: 1.12,
                                  letterSpacing: 0.20,
                                ),
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const BannerAdSlot(slotKey: 'playWithFriendEntry'),
          ],
        ),
      ),
    );
  }
}
