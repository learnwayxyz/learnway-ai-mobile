import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/home/bloc/streak_bloc.dart';
import 'package:learnwayv2/features/home/bloc/streak_event.dart';
import 'package:learnwayv2/features/home/bloc/streak_state.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_event.dart';
import 'package:learnwayv2/features/streak/domain/repositories/streak_repository.dart';
import 'package:learnwayv2/features/streak/domain/usecases/claim_daily_reward_usecase.dart';
import 'package:core/src/config/env/api_config_service.dart';
import 'package:learnwayv2/shared/widgets/ad_gate_dialog.dart';
import 'package:learnwayv2/shared/enums/enums.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/daily_gems_loading_dialog.dart';
import 'package:learnwayv2/shared/widgets/daily_gems_success_dialog.dart';
import 'package:learnwayv2/shared/widgets/daily_gems_error_dialog.dart';

class StreakComponent extends StatelessWidget {
  const StreakComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.read<HomeBloc>().state;

    return BlocProvider(
      create: (context) {
        final bloc = StreakBloc(
          streakRepository: locator<StreakRepository>(),
          claimDailyRewardUseCase: locator<ClaimDailyRewardUseCase>(),
        );

        if (homeState is FetchHomeDataSuccess &&
            homeState.userProfile != null) {
          bloc.add(InitializeStreakFromProfile(homeState.userProfile!));
        } else {
          bloc.add(const LoadStreakData());
        }

        return bloc;
      },
      child: const ResponsiveStreakComponentView(),
    );
  }
}

class ResponsiveStreakComponentView extends StatelessWidget
    with ResponsiveMixin {
  const ResponsiveStreakComponentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StreakBloc, StreakState>(
      listener: (context, state) {
        if (state is StreakClaiming) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const DailyGemsLoadingDialog(),
          );
        } else if (state is StreakClaimSuccess) {
          context.read<HomeBloc>().add(RefreshHomeDataEvent());

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (_) =>
                      DailyGemsSuccessDialog(gemsAwarded: state.gemsAwarded),
                );
              }
            });
          });
        } else if (state is StreakClaimFailed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            Future.delayed(const Duration(milliseconds: 100), () {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (_) => const DailyGemsErrorDialog(),
                );
              }
            });
          });
        }
      },
      child: BlocBuilder<StreakBloc, StreakState>(
        buildWhen: (previous, current) {
          if (current is StreakClaiming ||
              current is StreakClaimFailed ||
              current is StreakClaimSuccess) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is StreakInitial || state is StreakLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StreakLoaded) {
            final loadedState = state;

            return ResponsiveBuilder(
              builder: (context, responsiveInfo) {
                return Container(
                  margin: responsiveInfo.responsiveMargin,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      responsiveInfo.responsiveBorderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: _buildContent(context, loadedState, responsiveInfo),
                );
              },
            );
          }

          if (state is StreakError) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${l10n.error}: ${state.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<StreakBloc>().add(const LoadStreakData()),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StreakLoaded state,
    ResponsiveInfo responsiveInfo,
  ) {
    if (responsiveInfo.screenSize == ScreenSize.small &&
        responsiveInfo.screenWidth < 350) {
      return Column(
        children: [
          ResponsiveStreakCounter(
            streakDays: state.streakDays,
            responsiveInfo: responsiveInfo,
          ),
          const SizedBox(height: 16),
          _buildProgressSection(state, responsiveInfo),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: getResponsiveDimension(context, 12)),
          width: getResponsiveValue(
            context: context,
            small: MediaQuery.of(context).size.width * 0.32,
            medium: MediaQuery.of(context).size.width * 0.28,
            large: MediaQuery.of(context).size.width * 0.25,
            xlarge: MediaQuery.of(context).size.width * 0.22,
          ),
          child: ResponsiveStreakCounter(
            streakDays: state.streakDays,
            responsiveInfo: responsiveInfo,
          ),
        ),
        SizedBox(width: getResponsiveDimension(context, 13)),
        Expanded(flex: 4, child: _buildProgressSection(state, responsiveInfo)),
      ],
    );
  }

  Widget _buildProgressSection(
    StreakLoaded state,
    ResponsiveInfo responsiveInfo,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveProgressIndicator(
              current: state.currentDay,
              total: state.totalDays,
              responsiveInfo: responsiveInfo,
            ),
            ResponsivePlayButton(
              isPressed: false,
              responsiveInfo: responsiveInfo,
              nextClaimAt: state.nextClaimAt,
            ),
          ],
        ),
        SizedBox(height: responsiveInfo.scaleFactor * 6),
        Padding(
          padding: EdgeInsets.only(right: responsiveInfo.scaleFactor * 14),
          child: SizedBox(
            height: responsiveInfo.scaleFactor * 8,
            child: ResponsiveProgressBar(
              current: state.currentDay,
              total: state.totalDays,
              responsiveInfo: responsiveInfo,
            ),
          ),
        ),
        SizedBox(height: responsiveInfo.scaleFactor * 10),
        Container(
          margin: EdgeInsets.only(
            bottom: responsiveInfo.scaleFactor * 14,
            right: responsiveInfo.scaleFactor * 14,
          ),
          decoration: BoxDecoration(
            color: AppColors.blueGray50,
            borderRadius: BorderRadius.circular(
              responsiveInfo.scaleFactor * 15,
            ),
          ),
          child: WeeklyCalendar(
            progress: state.weeklyProgress,
            responsiveInfo: responsiveInfo,
          ),
        ),
      ],
    );
  }
}

class ResponsiveStreakCounter extends StatelessWidget {
  const ResponsiveStreakCounter({
    super.key,
    required this.streakDays,
    required this.responsiveInfo,
  });

  final int streakDays;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: responsiveInfo.scaleFactor * 14),
      padding: EdgeInsets.only(bottom: responsiveInfo.scaleFactor * 10),
      decoration: BoxDecoration(
        color: AppColors.blueGray25,
        borderRadius: BorderRadius.circular(responsiveInfo.scaleFactor * 20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: responsiveInfo.scaleFactor * 70,
            child: Image(
              image: AssetImage('assets/images/flames.png'),
              fit: BoxFit.contain,
            ),
          ),
          Column(
            children: [
              Text(
                '$streakDays ${streakDays == 1 ? AppLocalizations.of(context)!.day : AppLocalizations.of(context)!.days}',
                style: AppTextStyles.baseSemiBold(
                  context,
                ).copyWith(fontSize: 14 * responsiveInfo.fontSizeMultiplier),
              ),
              Text(
                AppLocalizations.of(context)!.dailyStreak,
                style: AppTextStyles.baseBold(
                  context,
                  color: Colors.grey.shade600,
                ).copyWith(fontSize: 10 * responsiveInfo.fontSizeMultiplier),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResponsiveProgressIndicator extends StatelessWidget {
  const ResponsiveProgressIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.responsiveInfo,
  });

  final int current;
  final int total;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: responsiveInfo.scaleFactor * 14),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: current.toString().padLeft(2, '0'),
              style: AppTextStyles.xlSemiBold(
                context,
                color: Colors.black87,
              ).copyWith(fontSize: 24 * responsiveInfo.fontSizeMultiplier),
            ),
            TextSpan(
              text: "/$total",
              style: AppTextStyles.baseBold(
                context,
                color: Colors.grey.shade600,
              ).copyWith(fontSize: 14 * responsiveInfo.fontSizeMultiplier),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsivePlayButton extends StatefulWidget {
  final bool isPressed;
  final ResponsiveInfo responsiveInfo;
  final DateTime? nextClaimAt;

  const ResponsivePlayButton({
    super.key,
    required this.isPressed,
    required this.responsiveInfo,
    this.nextClaimAt,
  });

  @override
  State<ResponsivePlayButton> createState() => _ResponsivePlayButtonState();
}

class _ResponsivePlayButtonState extends State<ResponsivePlayButton> {
  Timer? _countdownTimer;
  Duration? _timeRemaining;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(ResponsivePlayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.nextClaimAt != widget.nextClaimAt) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    if (widget.nextClaimAt == null) {
      setState(() => _timeRemaining = null);
      return;
    }

    _updateTimeRemaining();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final now = DateTime.now().toUtc();

    if (widget.nextClaimAt == null || now.isAfter(widget.nextClaimAt!)) {
      setState(() => _timeRemaining = null);
      _countdownTimer?.cancel();
      return;
    }

    final difference = widget.nextClaimAt!.difference(now);

    if (difference.isNegative || difference.inSeconds <= 0) {
      setState(() => _timeRemaining = null);
      _countdownTimer?.cancel();
      return;
    }

    setState(() {
      _timeRemaining = difference;
    });
  }

  String _formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}h:${minutes.toString().padLeft(2, '0')}m:${seconds.toString().padLeft(2, '0')}s';
  }

  bool get _canClaim => _timeRemaining == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _canClaim
          ? () async {
              final adsEnabled =
                  !locator.isRegistered<RevenueConfigResponse>() ||
                  locator.get<RevenueConfigResponse>().enableAds;
              if (!adsEnabled) {
                context.read<StreakBloc>().add(const PlayButtonPressed());
                return;
              }
              final l10n = AppLocalizations.of(context)!;
              final granted = await AdGateDialog.show(
                context,
                title: l10n.earnGemsTitle,
                description: l10n.watchAdDescription,
                watchAdButtonText: l10n.watchAndClaim,
              );
              log('Is it granted: $granted');
              if (granted && context.mounted) {
                context.read<StreakBloc>().add(const PlayButtonPressed());
              }
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: BoxConstraints(
          minWidth: widget.responsiveInfo.scaleFactor * 100,
          maxWidth: widget.responsiveInfo.scaleFactor * 140,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.responsiveInfo.scaleFactor * 20,
          vertical: widget.responsiveInfo.scaleFactor * 10,
        ),
        decoration: BoxDecoration(
          color: _canClaim
              ? (widget.isPressed
                    ? AppColors.primary700
                    : AppColors.primaryMain)
              : Colors.black,
          borderRadius: BorderRadius.circular(
            widget.responsiveInfo.scaleFactor * 25,
          ),
        ),
        margin: EdgeInsets.only(
          top: widget.responsiveInfo.scaleFactor * 12,
          right: widget.responsiveInfo.scaleFactor * 14,
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: AutoSizeText(
            _canClaim
                ? AppLocalizations.of(context)!.claimNow
                : _formatCountdown(_timeRemaining!),
            style: AppTextStyles.smSemiBold(
              context,
              color: Colors.white,
            ).copyWith(fontSize: 14 * widget.responsiveInfo.fontSizeMultiplier),
            minFontSize: 5,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ResponsiveProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final ResponsiveInfo responsiveInfo;

  const ResponsiveProgressBar({
    super.key,
    required this.current,
    required this.total,
    required this.responsiveInfo,
  });

  @override
  Widget build(BuildContext context) {
    double progress = total > 0 ? current / total : 0;

    return Container(
      height: responsiveInfo.scaleFactor * 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveInfo.scaleFactor * 4),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.blueGray25,
              borderRadius: BorderRadius.circular(
                responsiveInfo.scaleFactor * 4,
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: responsiveInfo.scaleFactor * 8,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(
                  responsiveInfo.scaleFactor * 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({
    super.key,
    required this.progress,
    required this.responsiveInfo,
  });

  final List<bool> progress;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> dayLabels = [
      l10n.sundayShort,
      l10n.mondayShort,
      l10n.tuesdayShort,
      l10n.wednesdayShort,
      l10n.thursdayShort,
      l10n.fridayShort,
      l10n.saturdayShort,
    ];

    return Container(
      padding: EdgeInsets.all(responsiveInfo.scaleFactor * 8),
      child: Row(
        children: List.generate(7, (index) {
          return Expanded(
            child: WeekDay(
              day: dayLabels[index],
              isCompleted: progress.length > index ? progress[index] : false,
              responsiveInfo: responsiveInfo,
            ),
          );
        }),
      ),
    );
  }
}

class WeekDay extends StatelessWidget {
  const WeekDay({
    super.key,
    required this.day,
    required this.isCompleted,
    required this.responsiveInfo,
  });

  final String day;
  final bool isCompleted;
  final ResponsiveInfo responsiveInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: responsiveInfo.scaleFactor * 18,
          height: responsiveInfo.scaleFactor * 18,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primaryMain : AppColors.blueGray10,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: responsiveInfo.iconSize,
                  )
                : SizedBox(
                    height: responsiveInfo.scaleFactor * 10,
                    width: responsiveInfo.scaleFactor * 10,
                  ),
          ),
        ),
        SizedBox(height: responsiveInfo.scaleFactor * 4),
        Text(
          day,
          style: AppTextStyles.xsSemiBold(
            context,
            color: isCompleted ? Colors.black : Colors.grey.shade600,
          ).copyWith(fontSize: 10 * responsiveInfo.fontSizeMultiplier),
        ),
      ],
    );
  }
}
