import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battle_history_bloc.dart';
import 'package:learnwayv2/features/battles/models/battle_detail_model.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class BattleHistoryDetailsScreen extends StatelessWidget {
  const BattleHistoryDetailsScreen({super.key, required this.battleId});

  final String battleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<BattleHistoryBloc>()
            ..add(LoadBattleDetailEvent(battleId: battleId)),
      child: const _BattleHistoryDetailsView(),
    );
  }
}

class _BattleHistoryDetailsView extends StatelessWidget {
  const _BattleHistoryDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: BlocBuilder<BattleHistoryBloc, BattleHistoryState>(
          builder: (context, state) {
            if (state is BattleDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BattleDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const VSpace(16),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.goBack),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is BattleDetailLoaded) {
              return _buildContent(context, state.battle);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BattleDetailModel battle) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = LocalStorageService.getUserSync()?.id ?? '';
    final myParticipant = battle.participants.firstWhere(
      (p) => p.userId != null && p.userId == currentUserId,
      orElse: () => battle.participants.first,
    );
    final won = myParticipant.position == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const VSpace(20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF627A9B).withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        battle.topic.title,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.14,
                          letterSpacing: 0.20,
                        ),
                      ),
                      const VSpace(10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.entryFee,
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0.20,
                              ),
                            ),
                            const HSpace(4),
                            Image.asset(
                              'assets/images/blue_gem.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            const HSpace(4),
                            Text(
                              '${battle.stakeAmount}',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const VSpace(13),
                  _buildDivider(),
                  const VSpace(13),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.battleStatus,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0.20,
                        ),
                      ),
                      const VSpace(5),
                      Text(
                        won ? l10n.won : l10n.defeat,
                        style: TextStyle(
                          color: won
                              ? AppColors.success500
                              : AppColors.error500,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.14,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ],
                  ),
                  const VSpace(13),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.completedDate,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          letterSpacing: 0.20,
                        ),
                      ),
                      const VSpace(5),
                      Text(
                        _formatDateTime(battle.completedAt),
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.14,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const VSpace(20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < battle.participants.length; i++) ...[
                    if (i > 0) _buildDivider(),
                    _buildParticipantItem(
                      battle.participants[i],
                      currentUserId,
                      l10n,
                    ),
                  ],
                ],
              ),
            ),

            const VSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantItem(
    BattleDetailParticipant participant,
    String currentUserId,
    AppLocalizations l10n,
  ) {
    final isMe =
        participant.userId != null && participant.userId == currentUserId;
    final displayName = isMe ? l10n.meLabel : (participant.username ?? 'Lenny');
    final roleLabel = participant.role.name.toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.backgroundLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: participant.profileImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: participant.profileImageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => Image.asset(
                        'assets/avatars/male0.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/avatars/male0.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const HSpace(8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: 0.20,
                  ),
                ),
                const VSpace(4),
                Text(
                  roleLabel,
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
          ),

          if (participant.xpEarned > 0) ...[
            Image.asset(
              'assets/images/xp_image.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const HSpace(4),
            Text(
              '${participant.xpEarned}',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.14,
                letterSpacing: 0.20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(String? completedAt) {
    if (completedAt == null) return '—';
    try {
      final date = DateTime.parse(completedAt).toLocal();
      return DateFormat('yyyy/MM/dd    h:mma').format(date);
    } catch (_) {
      return completedAt;
    }
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.borderColor);
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 60,
      title: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: CustomBackButton(onPress: () => context.router.maybePop()),
            ),
            Expanded(
              child: Center(
                child: Text(
                  l10n.battleDetails,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.12,
                    letterSpacing: 0.20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}
