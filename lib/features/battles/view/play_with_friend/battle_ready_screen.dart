import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/models/battle_room_participant.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:sentry/sentry.dart';

@RoutePage()
class BattleReadyScreen extends StatefulWidget {
  final String battleId;

  const BattleReadyScreen({super.key, required this.battleId});

  @override
  State<BattleReadyScreen> createState() => _BattleReadyScreenState();
}

class _BattleReadyScreenState extends State<BattleReadyScreen>
    with TickerProviderStateMixin {
  bool _countdownStarted = false;
  int _countdown = 3;
  StreamSubscription<dynamic>? _countdownSub;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  bool get _isCreator {
    final currentUserId = LocalStorageService.getUserSync()?.id;
    final participants = locator<BattleEventService>().participants;
    if (participants.isEmpty || currentUserId == null) return false;
    final me = participants.cast<BattleRoomParticipant?>().firstWhere(
      (p) => p?.userId == currentUserId,
      orElse: () => null,
    );
    return me?.role.toUpperCase() == 'CREATOR';
  }

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _subscribeToCountdown();
  }

  void _subscribeToCountdown() {
    _countdownSub = locator<BattleEventService>().onCountdown.listen((event) {
      log('Count down called() ${event.count}');
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: '[BattleReady] Countdown received: ${event.count}',
          category: 'battle.countdown',
          level: SentryLevel.info,
          data: {
            'battleId': widget.battleId,
            'count': event.count,
            'isCreator': _isCreator,
            'mounted': mounted,
          },
        ),
      );

      if (!mounted) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                '[BattleReady] Countdown received but widget not mounted — count=${event.count}',
            category: 'battle.countdown',
            level: SentryLevel.warning,
            data: {'battleId': widget.battleId, 'count': event.count},
          ),
        );
        return;
      }

      setState(() {
        _countdownStarted = true;
        _countdown = event.count;
      });
      _scaleController.reset();
      _scaleController.forward();
      _rotationController.reset();
      _rotationController.forward();

      if (event.count <= 1) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message:
                '[BattleReady] Countdown at 1 — scheduling navigation to BattleScreen',
            category: 'battle.countdown',
            level: SentryLevel.info,
            data: {'battleId': widget.battleId, 'isCreator': _isCreator},
          ),
        );
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            Sentry.addBreadcrumb(
              Breadcrumb(
                message: '[BattleReady] Navigating to BattleScreen',
                category: 'battle.navigation',
                level: SentryLevel.info,
                data: {'battleId': widget.battleId, 'isCreator': _isCreator},
              ),
            );
            context.router.replace(BattleRoute(battleId: widget.battleId));
          } else {
            Sentry.captureException(
              Exception(
                '[BattleReady] Navigation to BattleScreen failed — widget disposed during delay',
              ),
              hint: Hint.withMap({
                'source': 'BattleReadyScreen._subscribeToCountdown',
                'battleId': widget.battleId,
                'isCreator': _isCreator.toString(),
              }),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownSub?.cancel();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<BattlesBloc>(),
      child: BlocConsumer<BattlesBloc, BattlesState>(
        listener: (context, state) {
          if (state is BattleStartError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isStarting = state is BattleStarting;
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  children: [
                    const VSpace(60),

                    if (_countdownStarted) ...[
                      Center(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _scaleAnimation,
                            _rotationAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Transform.rotate(
                                angle: _rotationAnimation.value,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.50, -0.00),
                                      end: Alignment(0.50, 1.00),
                                      colors: [
                                        Color(0xFF205AEB),
                                        Color(0xFF123385),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF205AEB,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$_countdown',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 60,
                                        fontWeight: FontWeight.w600,
                                        height: 1.83,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const VSpace(40),
                    ],
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _countdownStarted && _countdown == 1
                            ? AppLocalizations.of(context)!.goodLuck
                            : AppLocalizations.of(context)!.getReadyToBattle,
                        style: AppTextStyles.headline(context).copyWith(
                          color: AppColors.textDark,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 1.13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const VSpace(20),
                    _buildPlayerCards(context),
                    const Spacer(),
                    BlocBuilder<BattlesBloc, BattlesState>(
                      builder: (context, state) {
                        if (state is BattleStarted) {
                          return SizedBox.shrink();
                        }
                        return _buildBottomAction(context, isStarting);
                      },
                    ),
                    const VSpace(10),
                    const BannerAdSlot(slotKey: 'battleReady'),
                    const VSpace(20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerCards(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = LocalStorageService.getUserSync();
    final participants = locator<BattleEventService>().participants;
    final opponent = participants.cast<BattleRoomParticipant?>().firstWhere(
      (p) => p?.userId != currentUser?.id,
      orElse: () => null,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerCard(
            name: currentUser?.username ?? 'Me',
            isCurrentUser: true,
            profileImageUrl: currentUser?.profileImageUrl,
            l10n: l10n,
          ),
          Image.asset('assets/images/battles/vs.png', fit: BoxFit.contain),
          _buildPlayerCard(
            name: opponent?.username ?? '...',
            isCurrentUser: false,
            profileImageUrl: opponent?.profileImageUrl,
            l10n: l10n,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, bool isStarting) {
    final l10n = AppLocalizations.of(context)!;
    if (_isCreator) {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: isStarting
              ? null
              : () {
                  context.read<BattlesBloc>().add(
                    StartBattleEvent(battleId: widget.battleId),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            disabledBackgroundColor: AppColors.gray300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          child: isStarting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  l10n.startBattle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blueGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const HSpace(10),
          Text(
            l10n.waitingForCreatorToStart,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required bool isCurrentUser,
    String? profileImageUrl,
    required AppLocalizations l10n,
  }) {
    return Column(
      children: [
        Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            color: isCurrentUser ? AppColors.primaryColor : AppColors.gray300,
            borderRadius: BorderRadius.circular(47.5),
          ),
          child: profileImageUrl != null && profileImageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(47.5),
                  child: CachedNetworkImage(
                    imageUrl: profileImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        const Icon(Icons.person, color: Colors.white, size: 48),
                    errorWidget: (_, _, _) =>
                        const Icon(Icons.person, color: Colors.white, size: 48),
                  ),
                )
              : const Icon(Icons.person, color: Colors.white, size: 48),
        ),
        const VSpace(16),
        Text(
          name,
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
          isCurrentUser ? l10n.creatorRole : l10n.playerRole,
          style: TextStyle(
            color: AppColors.gray500,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
