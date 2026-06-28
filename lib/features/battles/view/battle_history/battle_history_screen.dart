import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battle_history_bloc.dart';
import 'package:learnwayv2/features/battles/models/battle_history_model.dart';
import 'package:learnwayv2/features/battles/view/battle_history/battle_history_details_screen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class BattleHistoryScreen extends StatelessWidget {
  const BattleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          locator<BattleHistoryBloc>()..add(const LoadBattleHistoryEvent()),
      child: const _BattleHistoryView(),
    );
  }
}

class _BattleHistoryView extends StatelessWidget {
  const _BattleHistoryView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildCustomAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: SingleChildScrollView(
            child: Column(
              children: [
                VSpace(20),
                Row(
                  children: [
                    Text(
                      l10n.recent,
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
                const VSpace(4),
                Row(
                  children: [
                    Text(
                      l10n.yourCompletedBattles,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ],
                ),
                const VSpace(20),
                BlocBuilder<BattleHistoryBloc, BattleHistoryState>(
                  builder: (context, state) {
                    if (state is BattleHistoryLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is BattleHistoryError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: Column(
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
                                onPressed: () {
                                  context.read<BattleHistoryBloc>().add(
                                    const LoadBattleHistoryEvent(),
                                  );
                                },
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is BattleHistoryLoaded) {
                      final items = state.response.items;
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Center(
                            child: Text(
                              l10n.noBattleHistoryYet,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      return _buildHistoryList(context, items);
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const VSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<BattleHistoryItem> items,
  ) {
    final currentUserId = LocalStorageService.getUserSync()?.id ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) _buildDivider(),
            _buildHistoryItem(context, items[i], currentUserId),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    BattleHistoryItem item,
    String currentUserId,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final opponent = item.participants.firstWhere(
      (p) => p.userId != currentUserId,
      orElse: () => item.participants.first,
    );

    final isBot = opponent.isBot;
    final isGroup = item.type == 'GROUP';

    final displayType = isBot
        ? 'BOT'
        : isGroup
        ? l10n.groupBattle
        : item.type;

    final resultText = switch (item.outcome) {
      'won' => l10n.won,
      'lost' => l10n.defeat,
      _ => l10n.draw,
    };
    final resultColor = switch (item.outcome) {
      'won' => AppColors.success500,
      'lost' => AppColors.error500,
      _ => AppColors.textTertiary,
    };

    if (isGroup) {
      return _buildGroupItem(context, item, resultText, resultColor);
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BattleHistoryDetailsScreen(battleId: item.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _buildAvatar(
              isBot: isBot,
              profileImageUrl: opponent.profileImageUrl,
            ),
            const HSpace(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBot ? 'BOT' : opponent.username,
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
                    displayType,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  resultText,
                  style: TextStyle(
                    color: resultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: 0.20,
                  ),
                ),
                const VSpace(4),
                Text(
                  _formatDate(item.completedAt, l10n),
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
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(
    BuildContext context,
    BattleHistoryItem item,
    String resultText,
    Color resultColor,
  ) {
    const avatarSize = 40.0;
    const overlap = 24.0;
    final participants = item.participants;
    final stackWidth = overlap * (participants.length - 1) + avatarSize;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BattleHistoryDetailsScreen(battleId: item.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: stackWidth,
              height: avatarSize,
              child: Stack(
                children: participants.asMap().entries.map((entry) {
                  return Positioned(
                    left: entry.key * overlap,
                    child: _buildAvatar(
                      isBot: entry.value.isBot,
                      profileImageUrl: entry.value.profileImageUrl,
                    ),
                  );
                }).toList(),
              ),
            ),
            const HSpace(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.nPlayers(item.participants.length),
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
                    AppLocalizations.of(context)!.groupBattle,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  resultText,
                  style: TextStyle(
                    color: resultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: 0.20,
                  ),
                ),
                const VSpace(4),
                Text(
                  _formatDate(item.completedAt, AppLocalizations.of(context)!),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({bool isBot = false, String? profileImageUrl}) {
    Widget child;
    if (isBot) {
      child = Stack(
        children: [
          Container(width: 40, height: 40, color: const Color(0xFF8AA8F4)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/battles/lenny_bot.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ],
      );
    } else if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      child = CachedNetworkImage(
        imageUrl: profileImageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        placeholder: (_, _) => const Icon(Icons.person, size: 24),
        errorWidget: (_, _, _) => const Icon(Icons.person, size: 24),
      );
    } else {
      child = Image.asset(
        'assets/avatars/male0.png',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isBot ? const Color(0xFF8AA8F4) : AppColors.backgroundLight,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(20), child: child),
    );
  }

  String _formatDate(String? completedAt, AppLocalizations l10n) {
    if (completedAt == null) return '';
    try {
      final date = DateTime.parse(completedAt).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateOnly = DateTime(date.year, date.month, date.day);
      final diff = today.difference(dateOnly).inDays;

      if (diff == 0) return DateFormat('h:mm a').format(date);
      if (diff == 1) return l10n.yesterday;
      if (diff < 7) return DateFormat('EEEE').format(date);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return completedAt;
    }
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.borderColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
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
                  l10n.battleHistory,
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
