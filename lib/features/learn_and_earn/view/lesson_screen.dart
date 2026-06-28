import 'dart:developer';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/bloc/registered_course_bloc.dart'
    as rb;
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/view/level_screens/screen_helper.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/ad_service.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/banner_ad_slot.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';
import 'package:learnwayv2/shared/widgets/screen_connectivity_wrapper.dart';

enum LockState { unlocked, sequentialLocked, dailyLimitReached }

@RoutePage()
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.levelType});
  final LevelType levelType;

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

  @override
  void initState() {
    super.initState();
    final courseId = checkCourseLevelType();

    context.read<LearnAndEarnBloc>().add(
      FetchCourseLessons(id: courseId, forceRefresh: false),
    );
    context.read<LearnAndEarnBloc>().add(const FetchDailyLessonsRemaining());

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

  void checkLevelType() {
    if (widget.levelType == LevelType.beginner) {
      context.read<rb.RegisteredCoursesBloc>().add(
        rb.LoadBeginnerRegisteredCourses(),
      );
    } else if (widget.levelType == LevelType.intermediate) {
      context.read<rb.RegisteredCoursesBloc>().add(
        rb.LoadIntermediateRegisteredCourses(),
      );
    } else if (widget.levelType == LevelType.advanced) {
      context.read<rb.RegisteredCoursesBloc>().add(
        rb.LoadAdvancedRegisteredCourses(),
      );
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
      },
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) checkLevelType();
        },
        child: Scaffold(
          appBar: AppBarFactory.standardAppBar(
            title: courseData.courseTitle,
            barHeight: 0,
            onBackPressed: () {
              checkLevelType();
              Navigator.pop(context);
            },
          ),
          body: OverlayLoader(
            isLoading: _isFirstFetch,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VSpace(20),
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

                if (_adService.shouldShowAds) ...[
                  const VSpace(10),
                  const BannerAdSlot(slotKey: _adKey),
                ],
                VSpace(20),
                Expanded(
                  child: BlocConsumer<LearnAndEarnBloc, LearnAndEarnState>(
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.lessons,
                              style: AppTextStyles.mdBold(context),
                            ),
                            VSpace(4),
                            Text(
                              AppLocalizations.of(context)!.takeALessonAndEarn,
                              style: AppTextStyles.xsRegular(context),
                            ),
                            VSpace(20),
                            Expanded(
                              child: LessonBuilder(
                                lessons: lessons?.lessons ?? [],
                                levelType: widget.levelType,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

    // Sequential check first — lessons that aren't next in line stay
    // sequentialLocked regardless of the daily limit, so only one tile
    // (the next available lesson) ever shows dailyLimitReached.
    if (lesson.order != 1) {
      final prevLessons = widget.lessons
          .where((l) => l.order == lesson.order - 1)
          .toList();
      if (prevLessons.isEmpty || prevLessons.first.completedAt == null) {
        return LockState.sequentialLocked;
      }
    }

    // This lesson is next in line (order == 1, or previous lesson is done).
    // Now apply the global daily cap — covers all courses, not just the current one.
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
      iconBg = Color(0xFFFFF3E0);
      icon = Icons.lock_clock;
      iconColor = Color(0xFFF57C00);
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
