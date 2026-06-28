import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/features/battles/bloc/battles_bloc.dart';
import 'package:learnwayv2/features/battles/models/battle_events.dart';
import 'package:learnwayv2/features/battles/services/battle_event_service.dart';
import 'package:learnwayv2/features/battles/services/bot_battle_event_service.dart';
import 'package:learnwayv2/features/battles/view/play_with_bot/play_with_bot_modal.dart';
import 'package:learnwayv2/features/battles/view/shared/leave_game_dialog.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class PlayWithBotScreen extends StatelessWidget {
  const PlayWithBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<BattlesBloc>(),
      child: const _PlayWithBotView(),
    );
  }
}

class _PlayWithBotView extends StatefulWidget {
  const _PlayWithBotView();

  @override
  State<_PlayWithBotView> createState() => _PlayWithBotViewState();
}

class _PlayWithBotViewState extends State<_PlayWithBotView>
    with TickerProviderStateMixin {
  bool _connecting = false;
  bool _battleStarted = false;
  int _countdown = 3;
  String _botName = 'Lenny';
  String _battleId = '';
  StreamSubscription<BattleCountdownEvent>? _countdownSub;

  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

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
  }

  @override
  void dispose() {
    _countdownSub?.cancel();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onCountdown(BattleCountdownEvent event) {
    if (!mounted) return;
    setState(() {
      _connecting = false;
      _battleStarted = true;
      _countdown = event.count;
    });
    _scaleController.reset();
    _scaleController.forward();
    _rotationController.reset();
    _rotationController.forward();

    if (event.count <= 1) {
      _countdownSub?.cancel();
      locator<BotBattleEventService>().disconnect();
      locator<BattleEventService>().connect(_battleId);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          context.router.replace(BotBattleRoute(battleId: _battleId));
        }
      });
    }
  }

  void _showPlayWithBotModal(BuildContext context) {
    final bloc = context.read<BattlesBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          BlocProvider.value(value: bloc, child: const PlayWithBotModal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BattlesBloc, BattlesState>(
      listener: (context, state) {
        if (state is BotBattleStarted) {
          final userGems = LocalStorageService.getUserSync()?.totalGems ?? 0;
          if (userGems < state.response.stakeAmount) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Insufficient gem balance to start the battle'),
              ),
            );
            return;
          }
          _battleId = state.response.battleId;
          _botName = state.response.botName;
          final svc = locator<BotBattleEventService>();
          svc.connect(_battleId);
          _countdownSub = svc.onCountdown.listen(_onCountdown);
          setState(() => _connecting = true);
        } else if (state is BotBattleStartError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarFactory.standardAppBar(
          title: 'Play with Ai',
          onBackPressed: () => LeaveGameDialog.show(context),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (!_connecting && !_battleStarted) ...[
                    const VSpace(72),
                    Center(
                      child: Container(
                        width: 288,
                        height: 288,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(144),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(144),
                          child: Image.asset(
                            'assets/images/battles/lenny.png',
                            width: 288,
                            height: 288,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const VSpace(35),
                    Text(
                      'Play with $_botName',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VSpace(8),
                    Text(
                      'Have fun with your learning buddy.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VSpace(60),
                    GestureDetector(
                      onTap: () => _showPlayWithBotModal(context),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: [
                          if (_battleStarted) ...[
                            const VSpace(30),
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
                            const VSpace(20),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _countdown == 1
                                    ? 'Good Luck'
                                    : 'Get ready to participate',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  height: 1.13,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                            const VSpace(20),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildPlayerCard(
                                  avatarPath: 'assets/avatars/male0.png',
                                  name: 'Me',
                                  isCurrentUser: true,
                                ),
                                Image.asset(
                                  'assets/images/vs.png',
                                  fit: BoxFit.contain,
                                  width: 89,
                                  height: 89,
                                ),
                                _buildBotPlayerCard(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard({
    required String avatarPath,
    required String name,
    required bool isCurrentUser,
  }) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              avatarPath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const VSpace(8),
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
          isCurrentUser ? 'PLAYER' : 'BOT',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildBotPlayerCard() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF8AA8F4),
            borderRadius: BorderRadius.circular(45),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFF8AA8F4),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/battles/lenny_bot.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        const VSpace(8),
        Text(
          _botName,
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
          'BOT',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
