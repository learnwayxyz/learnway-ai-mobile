import 'package:auto_route/auto_route.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart'
    as registered_course_bloc;
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/convert_learnway_to_base.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/all_content_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';

class AllCoursesTab extends StatefulWidget {
  final LayoutType layoutType;
  final EdgeInsets? padding;
  final LevelType levelType;
  final double? spacing;

  const AllCoursesTab({
    super.key,
    required this.layoutType,
    this.padding,
    this.spacing,
    required this.levelType,
  });

  @override
  State<AllCoursesTab> createState() => _AllCoursesTabState();
}

class _AllCoursesTabState extends State<AllCoursesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _refetchCoursesAfterEnrollment() {
    switch (widget.levelType) {
      case LevelType.beginner:
        context.read<CoursesBloc>().add(
          const FetchBeginnerCourses(forceRefresh: true),
        );
        context.read<registered_course_bloc.RegisteredCoursesBloc>().add(
          const registered_course_bloc.LoadBeginnerRegisteredCourses(
            forceRefresh: true,
          ),
        );
        break;
      case LevelType.intermediate:
        context.read<CoursesBloc>().add(
          const FetchIntermediateCourses(forceRefresh: true),
        );
        context.read<registered_course_bloc.RegisteredCoursesBloc>().add(
          const registered_course_bloc.LoadIntermediateRegisteredCourses(
            forceRefresh: true,
          ),
        );
        break;
      case LevelType.advanced:
        context.read<CoursesBloc>().add(
          const FetchAdvancedCourses(forceRefresh: true),
        );
        context.read<registered_course_bloc.RegisteredCoursesBloc>().add(
          const registered_course_bloc.LoadAdvancedRegisteredCourses(
            forceRefresh: true,
          ),
        );
        break;
    }
  }

  void checkLevelType() {
    if (widget.levelType == LevelType.beginner) {
      _smartRefreshBeginner();
    }
    if (widget.levelType == LevelType.intermediate) {
      _smartRefreshIntermediate();
    }
    if (widget.levelType == LevelType.advanced) {
      _smartRefreshAdvanced();
    }
  }

  void _smartRefreshBeginner() {
    final state = context.read<CoursesBloc>().state;
    if (state is FetchedBeginnerCourses) {
      return;
    } else {
      context.read<CoursesBloc>().add(
        const FetchBeginnerCourses(forceRefresh: true),
      );
    }
  }

  void _smartRefreshIntermediate() {
    final state = context.read<CoursesBloc>().state;
    if (state is FetchedIntermediateCourses) {
      return;
    } else {
      context.read<CoursesBloc>().add(
        const FetchIntermediateCourses(forceRefresh: true),
      );
    }
  }

  void _smartRefreshAdvanced() {
    final state = context.read<CoursesBloc>().state;
    if (state is FetchedAdvancedCourses) {
      return;
    } else {
      context.read<CoursesBloc>().add(
        const FetchAdvancedCourses(forceRefresh: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<LearnAndEarnBloc, LearnAndEarnState>(
          listener: (context, state) {
            if (state is EnrolledBeginnerCourse ||
                state is EnrolledIntermediateCourse ||
                state is EnrolledAdvancedCourse) {
              NotificationService.showSuccess('Successfully enrolled');

              _refetchCoursesAfterEnrollment();
            }
          },
        ),

        BlocListener<CoursesBloc, CoursesState>(listener: (context, state) {}),
      ],
      child: BlocBuilder<LearnAndEarnBloc, LearnAndEarnState>(
        builder: (context, learnAndEarnState) {
          final isEnrolling =
              learnAndEarnState is EnrollingBeginnerCourse ||
              learnAndEarnState is EnrollingIntermediateCourse ||
              learnAndEarnState is EnrollingAdvancedCourse;

          return BlocBuilder<CoursesBloc, CoursesState>(
            builder: (context, coursesState) {
              if (coursesState is FetchingBeginnerCourses ||
                  coursesState is FetchingIntermediateCourses ||
                  coursesState is FetchingAdvancedCourses) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              if (isEnrolling) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              if (coursesState is FetchBeginnerCoursesError ||
                  coursesState is FetchIntermediateCoursesError ||
                  coursesState is FetchAdvancedCoursesError) {
                return _buildEmptyState(context, 'courses');
              }

              List<LearnWayCourses> courses = [];

              final coursesBloc = context.read<CoursesBloc>();

              switch (widget.levelType) {
                case LevelType.beginner:
                  if (coursesState is FetchedBeginnerCourses) {
                    courses = coursesState.courses;
                  } else if (coursesBloc.cachedBeginnerCourses.isNotEmpty) {
                    courses = coursesBloc.cachedBeginnerCourses;
                  }
                  break;
                case LevelType.intermediate:
                  if (coursesState is FetchedIntermediateCourses) {
                    courses = coursesState.courses;
                  } else if (coursesBloc.cachedIntermediateCourses.isNotEmpty) {
                    courses = coursesBloc.cachedIntermediateCourses;
                  }
                  break;
                case LevelType.advanced:
                  if (coursesState is FetchedAdvancedCourses) {
                    courses = coursesState.courses;
                  } else if (coursesBloc.cachedAdvancedCourses.isNotEmpty) {
                    courses = coursesBloc.cachedAdvancedCourses;
                  }
                  break;
              }

              if (courses.isEmpty) {
                return Center(child: _buildEmptyState(context, 'courses'));
              }

              return BlocBuilder<
                registered_course_bloc.RegisteredCoursesBloc,
                registered_course_bloc.RegisteredCoursesState
              >(
                builder: (context, registeredState) {
                  Set<String> enrolledCourseIds = {};
                  if (registeredState
                      is registered_course_bloc.LoadedBeginnerRegisteredCourses) {
                    enrolledCourseIds.addAll(
                      registeredState.registeredCourses.map((c) => c.course.id),
                    );
                  } else if (registeredState
                      is registered_course_bloc.LoadedIntermediateRegisteredCourses) {
                    enrolledCourseIds.addAll(
                      registeredState.registeredCourses.map((c) => c.course.id),
                    );
                  } else if (registeredState
                      is registered_course_bloc.LoadedAdvancedRegisteredCourses) {
                    enrolledCourseIds.addAll(
                      registeredState.registeredCourses.map((c) => c.course.id),
                    );
                  }

                  final updatedCourses = courses.map((course) {
                    // The course list endpoint already tells us whether the user
                    // is enrolled. Treat that as the source of truth and use the
                    // registered-courses list only to add newly enrolled courses
                    // the list endpoint hasn't caught up with yet.
                    final isEnrolled =
                        course.isEnrolled ||
                        enrolledCourseIds.contains(course.id);
                    return LearnWayCourses(
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
                      latestEnrolledUsers: course.latestEnrolledUsers,
                      isEnrolled: isEnrolled,
                      enrolledAt:
                          course.enrolledAt ??
                          (isEnrolled ? DateTime.now() : null),
                      isCompleted: course.isCompleted,
                      completedAt: course.completedAt,
                      progress: course.progress,
                    );
                  }).toList();

                  return ResponsiveBuilder(
                    builder: (context, responsiveInfo) {
                      return widget.layoutType == LayoutType.grid
                          ? _buildGridLayout(
                              context,
                              updatedCourses,
                              responsiveInfo,
                            )
                          : _buildListLayout(
                              context,
                              updatedCourses,
                              responsiveInfo,
                            );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGridLayout(
    BuildContext context,
    List<LearnWayCourses> courses,
    ResponsiveInfo responsiveInfo,
  ) {
    final crossAxisCount = getCrossAxisCount(responsiveInfo);
    final crossAxisSpacing = getCrossAxisSpacing(responsiveInfo);
    final mainAxisSpacing = getMainAxisSpacing(responsiveInfo);
    final childAspectRatio = getChildAspectRatio(responsiveInfo);
    final topPadding = getTopPadding(responsiveInfo);

    return Padding(
      padding: widget.padding ?? responsiveInfo.responsiveMargin,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        padding: EdgeInsets.only(top: topPadding),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return _buildLearnWayCoursesCard(
            context,
            courses[index],
            true,
            responsiveInfo,
          );
        },
      ),
    );
  }

  Widget _buildListLayout(
    BuildContext context,
    List<LearnWayCourses> courses,
    ResponsiveInfo responsiveInfo,
  ) {
    final spacing = widget.spacing ?? getListSpacing(responsiveInfo);
    final topPadding = getTopPadding(responsiveInfo);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: topPadding),
      itemCount: courses.length,
      separatorBuilder: (context, index) => VSpace(spacing),
      itemBuilder: (context, index) {
        return _buildLearnWayCoursesCard(
          context,
          courses[index],
          false,
          responsiveInfo,
        );
      },
    );
  }

  Widget _buildLearnWayCoursesCard(
    BuildContext context,
    LearnWayCourses learnWayCourse,
    bool isGrid,
    ResponsiveInfo responsiveInfo,
  ) {
    if (isGrid) {
      return GestureDetector(
        onTap: () =>
            _handleCourseEnrollment(context, learnWayCourse, widget.levelType),
        child: SizedBox(
          height: getGridItemHeight(responsiveInfo),
          child: CardFactory.customCard(
            contentStrategy: AllCoursesContentStrategy(
              title: learnWayCourse.title,
              description: learnWayCourse.description,
              totalEnrolledUsers: learnWayCourse.enrolledUsersCount,
              userAvatars: learnWayCourse.latestEnrolledUsers,
              courseOwner: '',
              isCompleted: learnWayCourse.isCompleted,
              isEnrolled: learnWayCourse.isEnrolled,
              progressValue: learnWayCourse.progress,
              responsiveInfo: responsiveInfo,
              isGrid: true,
            ),
            overlayStrategy: EmptyOverlayStrategy(),
            gradient: RandomGradients.getDailyGradient(
              seed: learnWayCourse.id.toString(),
            ),
            margin: EdgeInsets.zero,
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _handleCourseEnrollment(
              context,
              learnWayCourse,
              widget.levelType,
            ),
            child: SizedBox(
              height: getGridItemHeight(responsiveInfo) * 0.7,
              child: CardFactory.customCard(
                contentStrategy: AllCoursesContentStrategy(
                  title: learnWayCourse.title,
                  description: learnWayCourse.description,
                  courseOwner: '',
                  progressValue: learnWayCourse.progress,
                  isCompleted: learnWayCourse.isCompleted,
                  isEnrolled: learnWayCourse.isEnrolled,
                  userAvatars: learnWayCourse.latestEnrolledUsers
                    ..sort((a, b) => a.enrolledAt.compareTo(b.enrolledAt)),
                  totalEnrolledUsers: learnWayCourse.enrolledUsersCount,
                  responsiveInfo: responsiveInfo,
                  isGrid: false,
                ),
                overlayStrategy: EmptyOverlayStrategy(),
                gradient: RandomGradients.getDailyGradient(
                  seed: learnWayCourse.id.toString(),
                ),
                margin: responsiveInfo.responsiveMargin.copyWith(
                  top: responsiveInfo.responsiveMargin.top * 0.5,
                  bottom: responsiveInfo.responsiveMargin.bottom * 0.5,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  bool _isRegisteredDataReady(BuildContext context, LevelType levelType) {
    final state = context
        .read<registered_course_bloc.RegisteredCoursesBloc>()
        .state;
    return switch (levelType) {
      LevelType.beginner =>
        state is registered_course_bloc.LoadedBeginnerRegisteredCourses,
      LevelType.intermediate =>
        state is registered_course_bloc.LoadedIntermediateRegisteredCourses,
      LevelType.advanced =>
        state is registered_course_bloc.LoadedAdvancedRegisteredCourses,
    };
  }

  void _handleCourseEnrollment(
    BuildContext context,
    LearnWayCourses course,
    LevelType levelType,
  ) {
    if (course.isEnrolled) {
      try {
        final registeredCourse = CourseConverter.toBaseRegisteredCourse(
          course,
          levelType,
        );
        registerCourseData(registeredCourse, levelType);
        context.router.push(LessonRoute(levelType: levelType));
      } catch (e) {
        NotificationService.showError('Unable to access course: $e');
      }
      return;
    }

    // Enrollment data may still be loading (or have failed), in which case every
    // course looks un-enrolled. Re-sync instead of offering to enroll again.
    if (!_isRegisteredDataReady(context, levelType)) {
      _refetchCoursesAfterEnrollment();
      NotificationService.showInfo('Checking your enrollments, try again');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        onPressed: () => Navigator.of(context).pop(),
                        text: 'Cancel',
                        backgroundColor: AppColors.gray300,
                        textStyle: AppTextStyles.smSemiBold(
                          context,
                        ).copyWith(color: AppColors.gray600),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                    HSpace(10),
                    Expanded(
                      child: ButtonFactory.blackButton(
                        isFullWidth: false,
                        mainAxisAlignment: MainAxisAlignment.center,
                        textStyle: AppTextStyles.smSemiBold(
                          context,
                        ).copyWith(color: AppColors.white),
                        text: 'Enroll',
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.of(context).pop();

                          if (levelType == LevelType.beginner) {
                            context.read<LearnAndEarnBloc>().add(
                              EnrollBeginnerCourse(course.id),
                            );
                          } else if (levelType == LevelType.intermediate) {
                            context.read<LearnAndEarnBloc>().add(
                              EnrollIntermediateCourse(course.id),
                            );
                          } else if (levelType == LevelType.advanced) {
                            context.read<LearnAndEarnBloc>().add(
                              EnrollAdvancedCourse(course.id),
                            );
                          }
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

  Widget _buildEmptyState(BuildContext context, String statusText) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            VSpace(111),
            Image.asset(Assets.images.noCompletedCourse.path),
            const VSpace(16),
            Text(
              'No $statusText yet',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            const VSpace(8),
            Text(
              'Complete courses to see them here',
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
