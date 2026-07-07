import 'package:ai_mentor/ai_mentor.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/features/play/cubit/roadmap_cubit.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  )..addListener(() => setState(() {}));

  @override
  void initState() {
    super.initState();
    locator<DashboardCubit>().fetchDashboard();
    locator<RoadmapCubit>().fetchMyRoadmap();
    locator<MainActivityCubit>().pendingPlayTab.addListener(
      _handlePendingPlayTab,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _handlePendingPlayTab());
  }

  void _handlePendingPlayTab() {
    final pending = locator<MainActivityCubit>().pendingPlayTab;
    final tab = pending.value;
    if (tab == null || !mounted) return;
    _tabController.animateTo(tab);
    pending.value = null;
  }

  @override
  void dispose() {
    locator<MainActivityCubit>().pendingPlayTab.removeListener(
      _handlePendingPlayTab,
    );
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.learnTitle,
                    style: AppTextStyles.xlBold(context),
                  ),
                ],
              ),
            ),
            const VSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTabSwitcher(context),
            ),
            const VSpace(16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDiscoverTab(context),
                  _buildMyLearningTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: TabBar(
        controller: _tabController,
        padding: EdgeInsets.zero,
        splashBorderRadius: BorderRadius.circular(14),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.gray950,
          borderRadius: BorderRadius.circular(60),
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.gray600,
        labelStyle: AppTextStyles.smBold(context),
        unselectedLabelStyle: AppTextStyles.smBold(context),
        tabs: [
          Tab(text: AppLocalizations.of(context)!.discover),
          Tab(text: AppLocalizations.of(context)!.myLearning),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardFactory.lessonCard(
            title: AppLocalizations.of(context)!.learningPaths,
            subtitle: AppLocalizations.of(context)!.discoverLearningPaths,
            buttonText: AppLocalizations.of(context)!.startExploring,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            onButtonPressed: () {
              context.router.push(const ExplorePathsRoute());
            },
          ),
          CardFactory.lessonCard(
            cardType: CardType.others,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: AppLocalizations.of(context)!.contest,
            subtitle: AppLocalizations.of(context)!.contestSubtitle,
            gradient: AppColors.contestGradient,
            characterImageAsset: Assets.images.contestTroph.path,
            buttonText: AppLocalizations.of(context)!.startContest,
            onButtonPressed: () {
              context.router.push(const ContestRoute());
            },
          ),
          CardFactory.lessonCard(
            cardType: CardType.battles,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            gradient: AppColors.playNowGradient,
            title: AppLocalizations.of(context)!.quizBattle,
            subtitle: AppLocalizations.of(context)!.quizBattleSubtitle,
            buttonText: AppLocalizations.of(context)!.startBattle,
            onButtonPressed: () {
              context.router.push(const BattlesMainEntryRoute());
            },
          ),
          CardFactory.lessonCard(
            cardType: CardType.challenge,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            gradient: AppColors.quizeChallengeGradient,
            title: AppLocalizations.of(context)!.certifiedCourses,
            subtitle: AppLocalizations.of(context)!.certifiedCoursesSubtitle,
            buttonText: AppLocalizations.of(context)!.comingSoon,
          ),
        ],
      ),
    );
  }

  Widget _buildMyLearningTab(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      bloc: locator<DashboardCubit>(),
      builder: (context, state) {
        final dashboard = state.dashboard;
        final isLoading = dashboard == null &&
            (state.status == DashboardStatus.initial ||
                state.status == DashboardStatus.loading);

        if (isLoading) {
          return const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          );
        }

        final hasGoal =
            dashboard != null && dashboard.profile.careerGoal.isNotEmpty;
        if (!hasGoal) {
          return _SetGoalEmptyState(
            onSetGoal: () =>
                context.router.push(DiscoveryFlowRoute(allowBack: true)),
            onExplore: () => _tabController.animateTo(0),
          );
        }

        return _buildMyLearningContent(context, state);
      },
    );
  }

  Widget _buildMyLearningContent(BuildContext context, DashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final dashboard = state.dashboard;
              final insights = dashboard?.recentInsights ?? const [];
              final goalInsight = insights.isEmpty
                  ? null
                  : insights.firstWhere(
                      (i) => i.title == 'Build Consistency',
                      orElse: () => insights.firstWhere(
                        (i) => i.type == 'recommendation',
                        orElse: () => insights.first,
                      ),
                    );
              return _CareerGoalCard(
                goalTitle: dashboard == null || dashboard.profile.careerGoal.isEmpty
                    ? '...'
                    : dashboard.profile.careerGoal,
                goalSubtitle: goalInsight?.description ??
                    "Keep learning and stay consistent, you're building your future",
                overallProgressPercent:
                    dashboard?.profile.employabilityScore ?? 0,
                completedCourses:
                    dashboard?.learnerStats.completedCourses ?? 0,
                totalCourses: dashboard?.learnerStats.totalCourses ?? 0,
                onChangeGoal: () {
                  context.router.push(DiscoveryFlowRoute(allowBack: true));
                },
              );
            },
          ),
          const VSpace(28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.myLearningPathsTitle,
                style: AppTextStyles.smSemiBold(context),
              ),
              GestureDetector(
                onTap: () => context.router.push(const MyPathsRoute()),
                child: Text(
                  AppLocalizations.of(context)!.seeAll,
                  style: AppTextStyles.smMedium(
                    context,
                  ).copyWith(color: AppColors.primary700),
                ),
              ),
            ],
          ),
          const VSpace(16),
          BlocBuilder<RoadmapCubit, RoadmapState>(
            bloc: locator<RoadmapCubit>(),
            builder: (context, state) {
              final paths = state.roadmap?.paths ?? const [];

              if (paths.isEmpty &&
                  (state.status == RoadmapStatus.initial ||
                      state.status == RoadmapStatus.loading)) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                );
              }

              if (paths.isEmpty) {
                return _RoadmapErrorCard(
                  onRetry: () => locator<RoadmapCubit>().fetchMyRoadmap(),
                );
              }

              return Column(
                children: List.generate(paths.length, (index) {
                  final path = paths[index];
                  final locked =
                      path.type == 'specialization' && !state.roadmap!.userHasAccess;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == paths.length - 1 ? 0 : 12,
                    ),
                    child: _MyLearningPathCard(
                      path: path,
                      locked: locked,
                      onTap: () {
                        if (locked) {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black54,
                            builder: (_) => _MyLearningPaywallDialog(
                              path: path,
                              onSubscribe: () {
                                Navigator.of(context).pop();
                                context.router.push(const PayWallRoute());
                              },
                            ),
                          );
                        } else {
                          context.router.push(
                            PathCoursesRoute(
                              learningPathId: path.id,
                              pathTitle: path.title,
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),
              );
            },
          ),
          const VSpace(16),
        ],
      ),
    );
  }
}

class _PathCover extends StatelessWidget {
  const _PathCover({required this.coverImageUrl});

  final String? coverImageUrl;

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.route_rounded, color: AppColors.gray950, size: 24),
    );

    final url = coverImageUrl;
    if (url == null || url.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: _size,
        height: _size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}

class _RoadmapErrorCard extends StatelessWidget {
  const _RoadmapErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.roadmapLoadError,
            textAlign: TextAlign.center,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const VSpace(12),
          TextButton(
            onPressed: onRetry,
            child: Text(
              AppLocalizations.of(context)!.retry,
              style: AppTextStyles.smBold(
                context,
              ).copyWith(color: AppColors.primary700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetGoalEmptyState extends StatelessWidget {
  const _SetGoalEmptyState({required this.onSetGoal, required this.onExplore});

  final VoidCallback onSetGoal;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xffF6F8FE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Assets.images.targetIcon.image(width: 48, height: 48),
              ),
            ),
            const VSpace(20),
            Text(
              l10n.setGoalEmptyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.baseBold(
                context,
              ).copyWith(color: AppColors.gray950),
            ),
            const VSpace(8),
            Text(
              l10n.setGoalEmptySubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500, height: 1.5),
            ),
            const VSpace(24),
            GestureDetector(
              onTap: onSetGoal,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray950,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Text(
                  l10n.setGoalCta,
                  style: AppTextStyles.smBold(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
            const VSpace(8),
            TextButton(
              onPressed: onExplore,
              child: Text(
                l10n.exploreFirstCta,
                style: AppTextStyles.smMedium(
                  context,
                ).copyWith(color: AppColors.primary700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareerGoalCard extends StatelessWidget {
  const _CareerGoalCard({
    required this.goalTitle,
    required this.goalSubtitle,
    required this.overallProgressPercent,
    required this.completedCourses,
    required this.totalCourses,
    required this.onChangeGoal,
  });

  final String goalTitle;
  final String goalSubtitle;
  final int overallProgressPercent;
  final int completedCourses;
  final int totalCourses;
  final VoidCallback onChangeGoal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
      decoration: BoxDecoration(
        color: Color(0xffF6F8FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(top: 0, right: 0, child: Assets.images.youngWoman.image()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.images.targetIcon.image(width: 54, height: 54),
                  const HSpace(12),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 110),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.yourCareerGoal,
                                style: AppTextStyles.xsSemiBold(context)
                                    .copyWith(
                                      color: AppColors.primary800,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                            const VSpace(8),
                            Text(
                              goalTitle,
                              style: AppTextStyles.smSemiBold(
                                context,
                              ).copyWith(color: AppColors.gray950),
                            ),
                            const VSpace(4),
                            Text(
                              goalSubtitle,
                              style: AppTextStyles.xsRegular(
                                context,
                              ).copyWith(color: AppColors.gray900),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GoalStat(
                        value: '$overallProgressPercent%',
                        label: AppLocalizations.of(context)!.overallProgress,
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: AppColors.gray200,
                      ),
                      _GoalStat(
                        value: '$completedCourses of $totalCourses',
                        label: AppLocalizations.of(
                          context,
                        )!.completedCoursesLabel,
                      ),
                    ],
                  ),
                ),
              ),
              const VSpace(12),
              Padding(
                padding: const EdgeInsets.only(left: 65),
                child: GestureDetector(
                  onTap: onChangeGoal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray950,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.changeGoal,
                      style: AppTextStyles.smBold(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalStat extends StatelessWidget {
  const _GoalStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.mdMedium(
            context,
          ).copyWith(color: AppColors.primary800),
        ),
        const VSpace(2),
        Text(
          label,
          style: AppTextStyles.xsRegular(
            context,
          ).copyWith(color: AppColors.gray500, fontSize: 10),
        ),
      ],
    );
  }
}

class _MyLearningPathCard extends StatelessWidget {
  const _MyLearningPathCard({
    required this.path,
    required this.locked,
    required this.onTap,
  });

  final RoadmapPath path;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _PathCover(coverImageUrl: path.coverImageUrl),
            const HSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          path.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.smBold(
                            context,
                          ).copyWith(color: AppColors.gray950),
                        ),
                      ),
                      _Badge(
                        label: locked || path.hasPremiumCourse ? 'Premium' : 'Free',
                        color: locked || path.hasPremiumCourse
                            ? const Color(0xFFF97316)
                            : const Color(0xFF16A34A),
                      ),
                      const HSpace(6),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          locked
                              ? Icons.lock_outline_rounded
                              : Icons.chevron_right_rounded,
                          color: AppColors.gray500,
                          size: locked ? 14 : 20,
                        ),
                      ),
                    ],
                  ),
                  const VSpace(4),
                  Text(
                    path.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.xsRegular(
                      context,
                    ).copyWith(color: AppColors.gray500),
                  ),
                  const VSpace(4),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.coursesCount(path.courses.length),
                    style: AppTextStyles.xsSemiBold(
                      context,
                    ).copyWith(color: AppColors.primary700),
                  ),
                ],
              ),
            ),
            const HSpace(8),
          ],
        ),
      ),
    );
  }
}

class _MyLearningPaywallDialog extends StatelessWidget {
  const _MyLearningPaywallDialog({
    required this.path,
    required this.onSubscribe,
  });

  final RoadmapPath path;
  final VoidCallback onSubscribe;

  static const _includes = ['AI Mentor', 'Hands on Projects', 'Certificate'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: path.coverImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            path.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.route_rounded, size: 32),
                          ),
                        )
                      : const Icon(Icons.route_rounded, size: 32),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Badge(label: 'Premium', color: const Color(0xFFF97316)),
                          const Spacer(),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.gray950,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        path.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseBold(context).copyWith(color: AppColors.gray950),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        path.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.xsRegular(context).copyWith(color: AppColors.gray500, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Includes', style: AppTextStyles.baseBold(context).copyWith(color: AppColors.gray950)),
            const SizedBox(height: 12),
            ...List.generate(_includes.length, (index) {
              return Padding(
                padding: EdgeInsets.only(left: 12, bottom: index == _includes.length - 1 ? 0 : 10),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18, color: AppColors.primary700),
                    const SizedBox(width: 8),
                    Text(
                      _includes[index],
                      style: AppTextStyles.smMedium(context).copyWith(color: AppColors.primary700),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: onSubscribe,
                text: 'Unlock Premium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.xsSemiBold(context).copyWith(color: Colors.white),
      ),
    );
  }
}
