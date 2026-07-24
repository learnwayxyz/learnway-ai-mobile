import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/certificate_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_info_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_project_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/lesson_certificate_tab.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/lesson_project_tab.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/expandable_text_widget.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart'
    as rb;
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/view/level_screens/screen_helper.dart';
import 'package:learnwayv2/features/learn_and_earn/view/shared/premium_locked_gate.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:learnwayv2/shared/widgets/screen_connectivity_wrapper.dart';

import '../learn_and_earn_data_source/models/lesson_info_details.dart'
    show LessonInfoDetails, RecommendedCourse;

enum LockState { unlocked, sequentialLocked, dailyLimitReached }

enum LessonScreenTab { information, lessons, project, certificate }

@RoutePage()
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.levelType, this.pathTitle});
  final LevelType levelType;
  final String? pathTitle;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with
        AutoRouteAwareStateMixin<LessonScreen>,
        ScreenLoadStateMixin<LessonScreen> {
  @override
  String get routeName => '/lesson/${widget.levelType.name}';

  bool _hasShownInitialSnackbar = false;
  bool _isFirstFetch = true;

  static const _adKey = 'lessonScreen2';
  final AdService _adService = AdService.instance;

  LessonScreenTab _selectedTab = LessonScreenTab.information;

  @override
  void initState() {
    super.initState();

    final courseId = checkCourseLevelType();

    context.read<LearnAndEarnBloc>().add(
      FetchCourseLessons(id: courseId, forceRefresh: false),
    );
    context.read<LearnAndEarnBloc>().add(const FetchDailyLessonsRemaining());

    context.read<CourseInfoCubit>().fetchCourseInfo(courseId);
    context.read<CourseProjectCubit>().fetchCourseProject(courseId);
    context.read<CertificateCubit>().fetchCertificate(courseId);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<LearnAndEarnBloc>().add(
          FetchCourseLessons(id: courseId, forceRefresh: true),
        );
      }
    });
  }

  @override
  void didPopNext() {
    final courseId = checkCourseLevelType();
    context.read<LearnAndEarnBloc>().add(
      FetchCourseLessons(id: courseId, forceRefresh: true),
    );
    context.read<LearnAndEarnBloc>().add(const FetchDailyLessonsRemaining());
    super.didPopNext();
  }

  @override
  void dispose() {
    _cleanupRegisteredInstances();
    super.dispose();
  }

  /// Re-syncs the level screen's enrollment data on the way out. Resolved via
  /// the locator rather than `context` because this also runs after the route
  /// has popped, when the element is no longer safe to look up ancestors from.
  void checkLevelType() {
    final bloc = locator<rb.RegisteredCoursesBloc>();
    if (widget.levelType == LevelType.beginner) {
      bloc.add(const rb.LoadBeginnerRegisteredCourses(forceRefresh: true));
    } else if (widget.levelType == LevelType.intermediate) {
      bloc.add(const rb.LoadIntermediateRegisteredCourses(forceRefresh: true));
    } else if (widget.levelType == LevelType.advanced) {
      bloc.add(const rb.LoadAdvancedRegisteredCourses(forceRefresh: true));
    }
  }

  void _cleanupRegisteredInstances() {
    try {
      if (locator.isRegistered<String>(instanceName: 'lessonId')) {
        locator.unregister<String>(instanceName: 'lessonId');
      }
      if (locator.isRegistered<bool>(instanceName: 'isCompleted')) {
        locator.unregister<bool>(instanceName: 'isCompleted');
      }
    } catch (e) {
      log('Error during cleanup: $e');
    }
  }

  CourseLesson? _getLessons(LearnAndEarnState state) {
    if (state is FetchedCourseLessons) return state.courseLessons;
    if (state is FetchingCourseLessons) return state.courseLessons;
    if (state is FetchCourseLessonsError) return state.courseLessons;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final courseData = locator<CourseDataWrapper>();

    return ScreenConnectivityWrapper(
      routeName: routeName,
      onRetry: () {
        context.read<LearnAndEarnBloc>().add(
          FetchCourseLessons(id: checkCourseLevelType(), forceRefresh: true),
        );
        context.read<CourseInfoCubit>().fetchCourseInfo(checkCourseLevelType());
        context.read<CourseProjectCubit>().fetchCourseProject(
          checkCourseLevelType(),
        );
        context.read<CertificateCubit>().fetchCertificate(
          checkCourseLevelType(),
        );
      },
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) checkLevelType();
        },
        child: Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: widget.pathTitle ?? courseData.courseTitle,
            barHeight: 0,
            // No checkLevelType() here — PopScope above already fires it for
            // every pop, programmatic or gesture.
            onBackPressed: () => Navigator.pop(context),
          ),
          body: OverlayLoader(
            isLoading: _isFirstFetch,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<LearnAndEarnBloc, LearnAndEarnState>(
                  builder: (context, state) {
                    final lessons = _getLessons(state);
                    return CardFactory.activeLessonCard(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      title: lessons?.title ?? courseData.courseTitle,
                      subtitle:
                          lessons?.description ?? courseData.courseDescription,
                      totalLessons: lessons?.lessons.length ?? 0,
                      completedLessons:
                          lessons?.lessons.where((l) => l.isCompleted).length ??
                          0,
                      progressLabel: lessons?.progress.toString() ?? '0',
                      progressValue: (lessons?.progress.toDouble() ?? 0) / 100,
                    );
                  },
                ),

                Visibility(
                  visible: _adService.shouldShowAds,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [const BannerAdSlot(slotKey: _adKey)],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.gray200),
                    ),
                  ),
                  child: CustomTabs<LessonScreenTab>(
                    selectedValue: _selectedTab,
                    onTabSelected: (value) =>
                        setState(() => _selectedTab = value),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    spacing: 10,
                    borderRadius: 24,
                    showCheckmark: false,
                    defaultPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    defaultSelectedColor: AppColors.gray900,
                    defaultUnselectedColor: AppColors.gray100v2,
                    defaultSelectedTextColor: Colors.white,
                    defaultUnselectedTextColor: AppColors.gray600,
                    defaultTextStyle: AppTextStyles.smMedium(context),
                    tabs: const [
                      TabItem(
                        value: LessonScreenTab.information,
                        label: 'Information',
                      ),
                      TabItem(value: LessonScreenTab.lessons, label: 'Lessons'),
                      TabItem(value: LessonScreenTab.project, label: 'Project'),
                      TabItem(
                        value: LessonScreenTab.certificate,
                        label: 'Certificate',
                      ),
                    ],
                  ),
                ),

                const VSpace(8),

                Expanded(
                  child: BlocListener<LearnAndEarnBloc, LearnAndEarnState>(
                    listener: (context, state) {
                      if (state is FetchedCourseLessons &&
                          state.showSuccessSnackbar &&
                          !_hasShownInitialSnackbar) {
                        _hasShownInitialSnackbar = true;
                      }
                      if (state is FetchedCourseLessons) {
                        setState(() => _isFirstFetch = false);
                        markAsLoaded();
                      }
                    },
                    child: BlocBuilder<LearnAndEarnBloc, LearnAndEarnState>(
                      builder: (context, state) {
                        if (state is FetchCourseLessonsError &&
                            state.courseLessons == null) {
                          return _ErrorState(
                            message:
                                state.error.toLowerCase().contains(
                                  'network error',
                                )
                                ? AppLocalizations.of(
                                    context,
                                  )!.noInternetConnection
                                : AppLocalizations.of(context)!.noLessonsYet,
                          );
                        }

                        final lessons = _getLessons(state);

                        return IndexedStack(
                          index: _selectedTab.index,
                          children: [
                            BlocBuilder<CourseInfoCubit, CourseInfoState>(
                              builder: (context, infoState) {
                                if (infoState is CourseInfoLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (infoState is CourseInfoLoaded) {
                                  if (!infoState.data.hasInformation) {
                                    return _InformationEmptyState(
                                      courseTitle: courseData.courseTitle,
                                    );
                                  }
                                  return _InformationTab(
                                    courseData: infoState.data,
                                  );
                                } else if (infoState is CourseInfoError) {
                                  return Center(
                                    child: Text(
                                      infoState.error,
                                      style: AppTextStyles.smRegular(context),
                                    ),
                                  );
                                }
                                return _InformationEmptyState(
                                  courseTitle: courseData.courseTitle,
                                );
                              },
                            ),
                            _LessonsTab(
                              lessons: lessons?.lessons ?? [],
                              levelType: widget.levelType,
                            ),
                            PremiumLockedGate(
                              lockedTitle: 'Project Locked',
                              lockedSubtitle:
                                  'Subscribe to Premium to unlock Project',
                              buttonText: 'Subscribe to unlock Project',
                              child:
                                  BlocBuilder<
                                    LearnAndEarnBloc,
                                    LearnAndEarnState
                                  >(
                                    builder: (context, lessonState) {
                                      final lessons = _getLessons(lessonState);
                                      final remaining =
                                          lessons?.lessons
                                              .where((l) => !l.isCompleted)
                                              .length ??
                                          0;
                                      if (lessons != null &&
                                          lessons.lessons.isNotEmpty &&
                                          remaining > 0) {
                                        return SingleChildScrollView(
                                          child: ProjectNotAvailableCard(
                                            progressValue:
                                                lessons.progress.toDouble() /
                                                100,
                                            lessonsRemaining: remaining,
                                          ),
                                        );
                                      }
                                      return BlocBuilder<
                                        CourseProjectCubit,
                                        CourseProjectState
                                      >(
                                        builder: (context, projectState) {
                                          return switch (projectState) {
                                            CourseProjectLoading() =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            CourseProjectLoaded(
                                              :final project,
                                            ) =>
                                              ProjectTab(project: project),
                                            CourseProjectError(:final error) =>
                                              Center(
                                                child: Text(
                                                  error,
                                                  style:
                                                      AppTextStyles.smRegular(
                                                        context,
                                                      ),
                                                ),
                                              ),
                                            _ => const _ComingSoonState(),
                                          };
                                        },
                                      );
                                    },
                                  ),
                            ),
                            CertificateTab(courseId: checkCourseLevelType()),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.noCompletedCourse.path),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.browseCoursesToGetStarted,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonState extends StatelessWidget {
  const _ComingSoonState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.noCompletedCourse.path),
            const SizedBox(height: 16),
            Text(
              'Coming soon',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationEmptyState extends StatelessWidget {
  const _InformationEmptyState({required this.courseTitle});
  final String courseTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.noCompletedCourse.path),
            const SizedBox(height: 16),
            Text(
              'No information to show for $courseTitle',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationTab extends StatelessWidget {
  const _InformationTab({required this.courseData});
  final LessonInfoDetails courseData;

  @override
  Widget build(BuildContext context) {
    final recommendedNext = courseData.recommendedNextCourse;
    final hasRecommendedNext =
        recommendedNext != null && recommendedNext.id.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (courseData.aboutText.trim().isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About course', style: AppTextStyles.mdBold(context)),
                  const VSpace(8),
                  ExpandableDescription(text: courseData.aboutText),
                ],
              ),
            ),
            const VSpace(24),
          ],

          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  label: 'Difficulty',
                  value: courseData.difficultyLabel,
                ),
              ),
              if (courseData.estimatedTimeLabel != null) ...[
                const HSpace(12),
                Expanded(
                  child: _InfoCard(
                    label: 'Estimated Time',
                    value: courseData.estimatedTimeLabel!,
                  ),
                ),
              ],
            ],
          ),
          const VSpace(24),

          if (courseData.skillsGained.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills you\'ll gain',
                    style: AppTextStyles.mdBold(context),
                  ),
                  const VSpace(12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: courseData.skillsGained
                        .map((tag) => _SkillChip(tag))
                        .toList(),
                  ),
                ],
              ),
            ),
            const VSpace(24),
          ],

          if (courseData.prerequisites.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prerequisite', style: AppTextStyles.mdBold(context)),
                  const VSpace(12),
                  ...courseData.prerequisites.map(
                    (prerequisite) => _PrerequisiteItem(prerequisite),
                  ),
                ],
              ),
            ),
            const VSpace(24),
          ],

          if (courseData.targetAudience?.trim().isNotEmpty ?? false) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Who this course is for',
                    style: AppTextStyles.mdBold(context),
                  ),
                  const VSpace(8),
                  Text(
                    courseData.targetAudience!,
                    style: AppTextStyles.smRegular(
                      context,
                    ).copyWith(color: AppColors.gray600),
                  ),
                ],
              ),
            ),
            const VSpace(24),
          ],

          if (courseData.careerOpportunities.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Career Opportunities',
                    style: AppTextStyles.mdBold(context),
                  ),
                  const VSpace(12),
                  ...courseData.careerOpportunities.map((opp) {
                    return _CareerItem(opp, '');
                  }),
                ],
              ),
            ),
            const VSpace(24),
          ],

          if (hasRecommendedNext) ...[
            Text('Recommended Next', style: AppTextStyles.mdBold(context)),
            const VSpace(12),
            _RecommendedNextCard(course: recommendedNext),
            const VSpace(24),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.xsRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const VSpace(4),
          Text(value, style: AppTextStyles.baseMedium(context)),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE9FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.xsMedium(
          context,
        ).copyWith(color: const Color(0xFF4F46E5)),
      ),
    );
  }
}

class _PrerequisiteItem extends StatelessWidget {
  const _PrerequisiteItem(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: AppColors.success200, size: 18),
          const HSpace(8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray700),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerItem extends StatelessWidget {
  const _CareerItem(this.title, this.badge);
  final String title;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray700),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: AppTextStyles.xsMedium(
                context,
              ).copyWith(color: AppColors.gray600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedNextCard extends StatelessWidget {
  const _RecommendedNextCard({required this.course});
  final RecommendedCourse course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: AppColors.gray400),
          ),
          const HSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Course',
                  style: AppTextStyles.xsRegular(
                    context,
                  ).copyWith(color: AppColors.gray500),
                ),
                const VSpace(2),
                Text(course.title, style: AppTextStyles.smMedium(context)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.gray400),
        ],
      ),
    );
  }
}

class _LessonsTab extends StatelessWidget {
  const _LessonsTab({required this.lessons, required this.levelType});
  final List<Lesson> lessons;
  final LevelType levelType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VSpace(12),
          Expanded(
            child: LessonBuilder(lessons: lessons, levelType: levelType),
          ),
        ],
      ),
    );
  }
}

class LessonBuilder extends StatefulWidget {
  const LessonBuilder({
    super.key,
    required this.lessons,
    required this.levelType,
  });
  final List<Lesson> lessons;
  final LevelType levelType;

  @override
  State<LessonBuilder> createState() => _LessonBuilderState();
}

class _LessonBuilderState extends State<LessonBuilder> {
  @override
  void initState() {
    super.initState();
    LocalStorageService.dailyLessonsNotifier.addListener(_onLimitChanged);
  }

  void _onLimitChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    LocalStorageService.dailyLessonsNotifier.removeListener(_onLimitChanged);
    super.dispose();
  }

  void _registerLessonId(String id) {
    if (locator.isRegistered<String>(instanceName: 'lessonId')) {
      locator.unregister<String>(instanceName: 'lessonId');
    }
    locator.registerFactory<String>(() => id, instanceName: 'lessonId');
  }

  void _registerCompletionStatus(bool isCompleted) {
    if (locator.isRegistered<bool>(instanceName: 'isCompleted')) {
      locator.unregister<bool>(instanceName: 'isCompleted');
    }
    locator.registerFactory<bool>(
      () => isCompleted,
      instanceName: 'isCompleted',
    );
    log('Registered completion status: $isCompleted');
  }

  LockState _getLockState(Lesson lesson) {
    if (lesson.isCompleted) return LockState.unlocked;

    if (lesson.order != 1) {
      final prevLessons = widget.lessons
          .where((l) => l.order == lesson.order - 1)
          .toList();
      if (prevLessons.isEmpty || prevLessons.first.completedAt == null) {
        return LockState.sequentialLocked;
      }
    }

    final isPremium = !AdService.instance.shouldShowAds;
    if (!isPremium) {
      final remaining = LocalStorageService.dailyLessonsNotifier.value;
      log('dailyLimit $remaining');
      if (remaining == null || remaining <= 0) {
        return LockState.dailyLimitReached;
      }
    }

    return LockState.unlocked;
  }

  void _onLockedTap(BuildContext context, LockState lockState) {
    if (lockState == LockState.sequentialLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the previous lesson to unlock this one.'),
        ),
      );
      return;
    }

    if (lockState == LockState.dailyLimitReached) {
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.viewPaddingOf(context).bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_clock,
                  color: Color(0xFFF57C00),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Daily lesson limit reached",
                style: AppTextStyles.lgBold(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "You've used all free lessons for today. Come back tomorrow or upgrade to Premium for unlimited access.",
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: AppColors.gray500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                text: 'Upgrade to premium',
                onPressed: () {
                  Navigator.pop(context);
                  context.router.push(const PayWallRoute());
                },
              ),
              const SizedBox(height: 8),
              ButtonFactory.outlinedButton(
                mainAxisAlignment: MainAxisAlignment.center,
                text: 'Come back tomorrow',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lessons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.images.noCompletedCourse.path),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noLessonsAvailable,
                style: AppTextStyles.xxlBold(
                  context,
                ).copyWith(color: AppColors.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.lessonsWillAppearHere,
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: AppColors.gray500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (_, __) =>
          const Divider(indent: 25, endIndent: 25, height: 2),
      itemCount: widget.lessons.length,
      itemBuilder: (context, index) {
        final lesson = widget.lessons[index];
        final lockState = _getLockState(lesson);
        return LessonBuilderCard(
          lesson: lesson,
          lockState: lockState,
          onTap: lockState == LockState.unlocked
              ? () {
                  _registerLessonId(lesson.id);
                  _registerCompletionStatus(lesson.isCompleted);
                  context.router.push(
                    RouteLoaderRoute(
                      levelType: widget.levelType,
                      title: lesson.title,
                      lessonId: lesson.id,
                      lessonImage: lesson.imageUrl,
                    ),
                  );
                }
              : () => _onLockedTap(context, lockState),
        );
      },
    );
  }
}

class LessonBuilderCard extends StatelessWidget {
  const LessonBuilderCard({
    super.key,
    required this.lesson,
    required this.lockState,
    this.onTap,
  });
  final Lesson lesson;
  final LockState lockState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconBg;
    final IconData icon;
    final Color iconColor;

    if (lesson.isCompleted) {
      iconBg = AppColors.success25;
      icon = Icons.check;
      iconColor = Colors.white;
    } else if (lockState == LockState.sequentialLocked) {
      iconBg = AppColors.gray300;
      icon = Icons.lock_outline;
      iconColor = Colors.white;
    } else if (lockState == LockState.dailyLimitReached) {
      iconBg = const Color(0xFFFFF3E0);
      icon = Icons.lock_clock;
      iconColor = const Color(0xFFF57C00);
    } else {
      iconBg = AppColors.gray900;
      icon = Icons.play_arrow;
      iconColor = Colors.white;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const HSpace(16),
              Expanded(
                child: Text(
                  lesson.title,
                  style: AppTextStyles.baseMedium(context).copyWith(
                    color:
                        lockState != LockState.unlocked && !lesson.isCompleted
                        ? AppColors.gray400
                        : null,
                  ),
                ),
              ),
              if (lockState == LockState.dailyLimitReached)
                const Icon(Icons.chevron_right, color: Color(0xFFF57C00)),
            ],
          ),
        ),
      ),
    );
  }
}
