import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/home/enums/card_type.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _MyLearningPathData {
  const _MyLearningPathData({
    required this.title,
    required this.icon,
    required this.iconBackground,
    required this.isPremium,
    required this.completedCourses,
    required this.totalCourses,
  });

  final String title;
  final IconData icon;
  final Color iconBackground;
  final bool isPremium;
  final int completedCourses;
  final int totalCourses;

  double get progress =>
      totalCourses == 0 ? 0 : completedCourses / totalCourses;
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  )..addListener(() => setState(() {}));

  static final _myLearningPaths = [
    _MyLearningPathData(
      title: 'Digital Literacy',
      icon: Icons.phone_android_rounded,
      iconBackground: const Color(0xFFE8EAF6),
      isPremium: false,
      completedCourses: 5,
      totalCourses: 25,
    ),
    _MyLearningPathData(
      title: 'Financial Literacy',
      icon: Icons.savings_rounded,
      iconBackground: const Color(0xFFFFF9E6),
      isPremium: true,
      completedCourses: 5,
      totalCourses: 25,
    ),
    _MyLearningPathData(
      title: 'AI Literacy',
      icon: Icons.memory_rounded,
      iconBackground: const Color(0xFFE8EAF6),
      isPremium: false,
      completedCourses: 5,
      totalCourses: 25,
    ),
    _MyLearningPathData(
      title: 'Software Development',
      icon: Icons.laptop_mac_rounded,
      iconBackground: const Color(0xFFE8EAF6),
      isPremium: false,
      completedCourses: 5,
      totalCourses: 25,
    ),
  ];

  @override
  void dispose() {
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
                    AppLocalizations.of(context)!.myLearning,
                    style: AppTextStyles.xlBold(context),
                  ),
                  const VSpace(4),
                  Text(
                    AppLocalizations.of(context)!.myLearningSubtitle,
                    style: AppTextStyles.smRegular(
                      context,
                    ).copyWith(color: AppColors.gray500),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CareerGoalCard(
            goalTitle: 'Become a Software Engineer',
            goalSubtitle:
                "Keep learning and stay consistent, you're building your future",
            overallProgressPercent: 25,
            completedCourses: 12,
            totalCourses: 48,
            onChangeGoal: () {
              context.router.push(const CareerGoalRoute());
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
              Text(
                AppLocalizations.of(context)!.seeAll,
                style: AppTextStyles.smMedium(
                  context,
                ).copyWith(color: AppColors.primary700),
              ),
            ],
          ),
          const VSpace(16),
          ...List.generate(_myLearningPaths.length, (index) {
            final path = _myLearningPaths[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _myLearningPaths.length - 1 ? 0 : 12,
              ),
              child: _MyLearningPathCard(path: path, onTap: () {}),
            );
          }),
          const VSpace(16),
        ],
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
  const _MyLearningPathCard({required this.path, required this.onTap});

  final _MyLearningPathData path;
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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: path.iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(path.icon, color: AppColors.gray950, size: 24),
            ),
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
                          style: AppTextStyles.smBold(
                            context,
                          ).copyWith(color: AppColors.gray950),
                        ),
                      ),
                      _Badge(
                        label: path.isPremium ? 'Premium' : 'Free',
                        color: path.isPremium
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
                          Icons.chevron_right_rounded,
                          color: AppColors.gray500,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const VSpace(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${path.completedCourses} of ${path.totalCourses} ${AppLocalizations.of(context)!.coursesCompletedSuffix}',
                        style: AppTextStyles.xsRegular(
                          context,
                        ).copyWith(color: AppColors.gray500),
                      ),
                      Text(
                        '${(path.progress * 100).round()}%',
                        style: AppTextStyles.xsSemiBold(
                          context,
                        ).copyWith(color: AppColors.primary700),
                      ),
                    ],
                  ),
                  const VSpace(6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: path.progress,
                      minHeight: 6,
                      backgroundColor: AppColors.gray200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary800,
                      ),
                    ),
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
