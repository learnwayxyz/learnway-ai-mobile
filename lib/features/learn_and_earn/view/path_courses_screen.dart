import 'package:ai_mentor/ai_mentor.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart'
    as learn_and_earn;
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/shared/utilities/convert_learnway_to_base.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/all_content_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:learnwayv2/shared/widgets/custom_tabs.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';

@RoutePage()
class PathCoursesScreen extends StatefulWidget {
  const PathCoursesScreen({
    super.key,
    required this.learningPathId,
    required this.pathTitle,
  });

  final String learningPathId;
  final String pathTitle;

  @override
  State<PathCoursesScreen> createState() => _PathCoursesScreenState();
}

class _PathCoursesScreenState extends State<PathCoursesScreen>
    with AutoRouteAwareStateMixin<PathCoursesScreen> {
  final ScrollController _scrollController = ScrollController();

  String? _enrollingCourseId;
  String? _enrollingCourseTitle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locator<LearningPathCubit>().fetchPathCourses(widget.learningPathId);
    });
  }

  @override
  void didPopNext() {
    // Enrollment (triggered from this screen) navigates to LessonRoute
    // directly and never notifies LearningPathCubit, so its cached
    // `isEnrolled` flags go stale the moment a course is enrolled. Refetch on
    // return so a re-tap of the same card routes to the lesson instead of
    // showing the enroll dialog again.
    locator<LearningPathCubit>().fetchPathCourses(widget.learningPathId);
    super.didPopNext();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<learn_and_earn.LearnAndEarnBloc, learn_and_earn.LearnAndEarnState>(
      listener: (context, state) {
        switch (state) {
          case learn_and_earn.EnrolledBeginnerCourse() ||
              learn_and_earn.EnrolledIntermediateCourse() ||
              learn_and_earn.EnrolledAdvancedCourse():
            setState(() {
              _enrollingCourseId = null;
              _enrollingCourseTitle = null;
            });
          case learn_and_earn.EnrollBeginnerCourseError(:final message) ||
              learn_and_earn.EnrollIntermediateCourseError(:final message) ||
              learn_and_earn.EnrollAdvancedCourseError(:final message):
            setState(() {
              _enrollingCourseId = null;
              _enrollingCourseTitle = null;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.pathTitle,
          barHeight: 10,
        ),
        body: OverlayLoader(
          isLoading: _enrollingCourseId != null,
          loadingText: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.6,
            ),
            child: Text(
              'Enrolling ${_enrollingCourseTitle ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.smMedium(context),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose a Course',
                        style: AppTextStyles.lgBold(context),
                      ),
                      Text(
                        'Learn future-ready skills at your own pace',
                        style: AppTextStyles.md(
                          context,
                        ).copyWith(color: AppColors.gray700),
                      ),
                    ],
                  ),
                ),
                _buildTabBar(context),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: BlocBuilder<CourseTabsBloc, CourseTabsState>(
        builder: (context, tabState) {
          return Row(
            children: [
              Expanded(
                child: CustomTabs<CourseStatus>(
                  tabs: [
                    TabItem(
                      value: CourseStatus.all,
                      label: 'All',
                      selectedColor: AppColors.gray900,
                      unselectedColor: AppColors.blueGray100,
                      selectedTextColor: Colors.white,
                      unselectedTextColor: AppColors.gray700,
                    ),
                    TabItem(
                      value: CourseStatus.current,
                      label: 'Current',
                      selectedColor: AppColors.gray900,
                      unselectedColor: AppColors.blueGray100,
                      selectedTextColor: Colors.white,
                      unselectedTextColor: AppColors.gray700,
                    ),
                    TabItem(
                      value: CourseStatus.completed,
                      label: 'Completed',
                      selectedColor: AppColors.gray900,
                      unselectedColor: AppColors.blueGray100,
                      selectedTextColor: Colors.white,
                      unselectedTextColor: AppColors.gray700,
                    ),
                  ],
                  selectedValue: tabState.selectedTab,
                  onTabSelected: (value) {
                    context.read<CourseTabsBloc>().changeTab(value);
                  },
                  padding: EdgeInsets.zero,
                  spacing: 8.0,
                  borderRadius: 20.0,
                  defaultPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  defaultTextStyle: AppTextStyles.smBold(context),
                ),
              ),
              const HSpace(12),
              _buildLayoutToggle(context, tabState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLayoutToggle(BuildContext context, CourseTabsState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _toggleButton(
          icon: Assets.icons.gridLayoutIcon,
          isSelected: state.layoutType == LayoutType.grid,
          onTap: () =>
              context.read<CourseTabsBloc>().changeLayout(LayoutType.grid),
        ),
        const HSpace(10),
        _toggleButton(
          icon: Assets.icons.listLayoutIcon,
          isSelected: state.layoutType == LayoutType.list,
          onTap: () =>
              context.read<CourseTabsBloc>().changeLayout(LayoutType.list),
        ),
      ],
    );
  }

  Widget _toggleButton({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.blueGray100,
          borderRadius: BorderRadius.circular(60),
        ),
        child: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.gray700 : AppColors.gray400,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<CourseTabsBloc, CourseTabsState>(
      builder: (context, tabState) {
        return BlocBuilder<LearningPathCubit, LearningPathState>(
          bloc: locator<LearningPathCubit>(),
          builder: (context, pathState) {
            final hasCachedCourses = pathState.pathCourses.isNotEmpty;

            // Only block on the spinner for the very first load. Once we have
            // data, a status flip back to loading/initial is a background
            // refresh (e.g. didPopNext after enrolling) — keep the current
            // list on screen and let this rebuild in place once it resolves.
            if (!hasCachedCourses &&
                (pathState.pathCoursesStatus == LearningPathStatus.loading ||
                    pathState.pathCoursesStatus ==
                        LearningPathStatus.initial)) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (!hasCachedCourses &&
                pathState.pathCoursesStatus == LearningPathStatus.failure) {
              return _buildEmptyState(
                context,
                pathState.pathCoursesError ?? 'Failed to load courses',
              );
            }

            final all = pathState.pathCourses;
            final courses = switch (tabState.selectedTab) {
              CourseStatus.current =>
                all.where((c) => c.isEnrolled && !c.isCompleted).toList(),
              CourseStatus.completed =>
                all.where((c) => c.isCompleted).toList(),
              _ => all,
            };

            if (courses.isEmpty) {
              return _buildEmptyState(context, 'courses');
            }

            return SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: ResponsiveBuilder(
                builder: (context, responsiveInfo) {
                  return tabState.layoutType == LayoutType.grid
                      ? _buildGrid(context, courses, responsiveInfo)
                      : _buildList(context, courses, responsiveInfo);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<PathCourseModel> courses,
    ResponsiveInfo responsiveInfo,
  ) {
    final crossAxisCount = getCrossAxisCount(responsiveInfo);
    final crossAxisSpacing = getCrossAxisSpacing(responsiveInfo);
    final mainAxisSpacing = getMainAxisSpacing(responsiveInfo);
    final childAspectRatio = getChildAspectRatio(responsiveInfo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) =>
            _courseCard(context, courses[index], true, responsiveInfo),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<PathCourseModel> courses,
    ResponsiveInfo responsiveInfo,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      separatorBuilder: (context, index) => const VSpace(16),
      itemBuilder: (context, index) =>
          _courseCard(context, courses[index], false, responsiveInfo),
    );
  }

  Widget _courseCard(
    BuildContext context,
    PathCourseModel course,
    bool isGrid,
    ResponsiveInfo responsiveInfo,
  ) {
    final userAvatars = course.latestEnrolledUsers
        .map(
          (u) => LearnWayUser(
            id: u.id,
            username: u.username,
            email: u.email,
            profileImageUrl: u.profileImageUrl,
            profileImageFileId: u.profileImageFileId,
            profileThumbnailUrl: u.profileThumbnailUrl,
            enrolledAt: u.enrolledAt,
          ),
        )
        .toList();

    return GestureDetector(
      onTap: () => _handleCourseTap(context, course),
      child: SizedBox(
        height: isGrid
            ? getGridItemHeight(responsiveInfo)
            : getGridItemHeight(responsiveInfo) * 0.7,
        child: CardFactory.customCard(
          contentStrategy: AllCoursesContentStrategy(
            title: course.title,
            description: course.description,
            courseOwner: '',
            userAvatars: userAvatars,
            totalEnrolledUsers: course.enrolledUsersCount,
            progressValue: course.progress,
            isEnrolled: course.isEnrolled,
            isCompleted: course.isCompleted,
            responsiveInfo: responsiveInfo,
            isGrid: isGrid,
          ),
          overlayStrategy: EmptyOverlayStrategy(),
          gradient: RandomGradients.getDailyGradient(seed: course.id),
          margin: isGrid
              ? EdgeInsets.zero
              : responsiveInfo.responsiveMargin.copyWith(
                  top: responsiveInfo.responsiveMargin.top * 0.5,
                  bottom: responsiveInfo.responsiveMargin.bottom * 0.5,
                ),
        ),
      ),
    );
  }

  void _handleCourseTap(BuildContext context, PathCourseModel course) {
    if (course.isEnrolled) {
      final levelType = _levelTypeFrom(course.skillLevel);
      final registered = CourseConverter.toBaseRegisteredCourse(
        LearnWayCourses(
          id: course.id,
          createdAt: course.createdAt,
          updatedAt: course.updatedAt,
          deletedAt: course.deletedAt,
          title: course.title,
          description: course.description,
          skillLevel: course.skillLevel,
          isActive: course.isActive,
          isPremium: course.isPremium,
          order: course.order,
          enrolledUsersCount: course.enrolledUsersCount,
          latestEnrolledUsers: [],
          isEnrolled: course.isEnrolled,
          enrolledAt: course.enrolledAt,
          isCompleted: course.isCompleted,
          completedAt: course.completedAt,
          progress: course.progress,
        ),
        levelType,
      );
      registerCourseData(registered, levelType);
      context.router.push(
        LessonRoute(levelType: levelType, pathTitle: widget.pathTitle),
      );
      return;
    }

    _showEnrollDialog(context, course);
  }

  void _showEnrollDialog(BuildContext context, PathCourseModel course) {
    final levelType = _levelTypeFrom(course.skillLevel);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Stack(
          children: [
            AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(60),
                  Center(
                    child: Text(
                      'Enroll in Course',
                      style: AppTextStyles.mdBold(
                        context,
                      ).copyWith(fontFamily: 'Poppins', color: Colors.black),
                    ),
                  ),
                  Text('Do you want to enroll in "${course.title}"?'),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ButtonFactory.blackButton(
                        mainAxisAlignment: MainAxisAlignment.center,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        text: 'Cancel',
                        backgroundColor: AppColors.gray300,
                        textStyle: AppTextStyles.smSemiBold(
                          context,
                        ).copyWith(color: AppColors.gray600),
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                    const HSpace(10),
                    Expanded(
                      child: ButtonFactory.blackButton(
                        isFullWidth: false,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textStyle: AppTextStyles.smSemiBold(
                          context,
                        ).copyWith(color: AppColors.white),
                        text: 'Enroll',
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          _enrollCourse(context, course, levelType);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: const Offset(0, 130),
                  child: Image.asset(
                    Assets.images.lennyStarePose.path,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _enrollCourse(
    BuildContext context,
    PathCourseModel course,
    LevelType levelType,
  ) {
    setState(() {
      _enrollingCourseId = course.id;
      _enrollingCourseTitle = course.title;
    });

    final bloc = context.read<learn_and_earn.LearnAndEarnBloc>();
    switch (levelType) {
      case LevelType.beginner:
        bloc.add(learn_and_earn.EnrollBeginnerCourse(course.id));
      case LevelType.intermediate:
        bloc.add(learn_and_earn.EnrollIntermediateCourse(course.id));
      case LevelType.advanced:
        bloc.add(learn_and_earn.EnrollAdvancedCourse(course.id));
    }
  }

  LevelType _levelTypeFrom(String skillLevel) {
    return switch (skillLevel.toUpperCase()) {
      'INTERMEDIATE' => LevelType.intermediate,
      'ADVANCED' => LevelType.advanced,
      _ => LevelType.beginner,
    };
  }

  Widget _buildEmptyState(BuildContext context, String label) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.noCompletedCourse.path),
            const VSpace(16),
            Text(
              'No $label yet',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            const VSpace(8),
            Text(
              'Courses for this path will appear here',
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
