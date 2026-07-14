import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/notification_service.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/filters.dart';
import 'package:learnwayv2/shared/utilities/responsive.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/current_tab_strategy.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/course_layout_tab.dart';

class CompletedCoursesTab extends StatefulWidget {
  final Function(BaseRegisteredCourses<BaseCourseModel> course)?
  onCoursePressed;
  final LayoutType layoutType;
  final EdgeInsets? padding;
  final double? spacing;
  final LevelType levelType;

  const CompletedCoursesTab({
    super.key,
    this.onCoursePressed,
    required this.layoutType,
    this.padding,
    this.spacing,
    required this.levelType,
  });

  @override
  State<CompletedCoursesTab> createState() => _CompletedCoursesTabState();
}

class _CompletedCoursesTabState extends State<CompletedCoursesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    final state = context.read<RegisteredCoursesBloc>().state;
    if (state is LoadedBeginnerRegisteredCourses) {
      return;
    } else {
      context.read<RegisteredCoursesBloc>().add(
        const LoadBeginnerRegisteredCourses(forceRefresh: true),
      );
    }
  }

  void _smartRefreshIntermediate() {
    final state = context.read<RegisteredCoursesBloc>().state;
    if (state is LoadedIntermediateRegisteredCourses) {
      return;
    } else {
      context.read<RegisteredCoursesBloc>().add(
        const LoadIntermediateRegisteredCourses(forceRefresh: true),
      );
    }
  }

  void _smartRefreshAdvanced() {
    final state = context.read<RegisteredCoursesBloc>().state;
    if (state is LoadedAdvancedRegisteredCourses) {
      return;
    } else {
      context.read<RegisteredCoursesBloc>().add(
        const LoadAdvancedRegisteredCourses(forceRefresh: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<RegisteredCoursesBloc, RegisteredCoursesState>(
      listener: (context, state) {
        if (state is LoadedBeginnerRegisteredCourses ||
            state is LoadedIntermediateRegisteredCourses ||
            state is LoadedAdvancedRegisteredCourses) {
          NotificationService.showSuccess('Successfully fetched courses');
        }
        if (state is LoadedBeginnerRegisteredCoursesError ||
            state is LoadedIntermediateRegisteredCoursesError ||
            state is LoadedAdvancedRegisteredCoursesError) {
          final error = state is LoadedBeginnerRegisteredCoursesError
              ? state.error
              : state is LoadedIntermediateRegisteredCoursesError
              ? state.error
              : (state as LoadedAdvancedRegisteredCoursesError).error;
          NotificationService.showError(error);
        }
      },
      child: BlocBuilder<RegisteredCoursesBloc, RegisteredCoursesState>(
        builder: (context, state) {
          if (state is LoadingBeginnerRegisteredCourses ||
              state is LoadingIntermediateRegisteredCourses ||
              state is LoadingAdvancedRegisteredCourses) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          if (state is LoadedBeginnerRegisteredCoursesError ||
              state is LoadedIntermediateRegisteredCoursesError ||
              state is LoadedAdvancedRegisteredCoursesError) {
            return _buildEmptyState(context, 'completed courses');
          }

          List<BaseRegisteredCourses<BaseCourseModel>> courses = [];

          final registeredCoursesBloc = context.read<RegisteredCoursesBloc>();

          switch (widget.levelType) {
            case LevelType.beginner:
              if (state is LoadedBeginnerRegisteredCourses) {
                final filtered =
                    filterCompletedCourses<BeginnerRegisteredCourses>(
                      state.registeredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              } else if (registeredCoursesBloc
                  .cachedBeginnerRegisteredCourses
                  .isNotEmpty) {
                final filtered =
                    filterCompletedCourses<BeginnerRegisteredCourses>(
                      registeredCoursesBloc.cachedBeginnerRegisteredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              }
              break;
            case LevelType.intermediate:
              if (state is LoadedIntermediateRegisteredCourses) {
                final filtered =
                    filterCompletedCourses<IntermediateRegisteredCourse>(
                      state.registeredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              } else if (registeredCoursesBloc
                  .cachedIntermediateRegisteredCourses
                  .isNotEmpty) {
                final filtered =
                    filterCompletedCourses<IntermediateRegisteredCourse>(
                      registeredCoursesBloc.cachedIntermediateRegisteredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              }
              break;
            case LevelType.advanced:
              if (state is LoadedAdvancedRegisteredCourses) {
                final filtered =
                    filterCompletedCourses<AdvancedRegisteredCourses>(
                      state.registeredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              } else if (registeredCoursesBloc
                  .cachedAdvancedRegisteredCourses
                  .isNotEmpty) {
                final filtered =
                    filterCompletedCourses<AdvancedRegisteredCourses>(
                      registeredCoursesBloc.cachedAdvancedRegisteredCourses,
                      (c) => c.completedAt,
                      (c) => c.course.isActive,
                    );
                courses = filtered
                    .cast<BaseRegisteredCourses<BaseCourseModel>>();
              }
              break;
          }

          if (courses.isEmpty) {
            return _buildEmptyState(context, 'completed courses');
          }

          return ResponsiveBuilder(
            builder: (context, responsiveInfo) {
              return widget.layoutType == LayoutType.grid
                  ? _buildGridLayout(context, courses, responsiveInfo)
                  : _buildListLayout(context, courses, responsiveInfo);
            },
          );
        },
      ),
    );
  }

  Widget _buildGridLayout(
    BuildContext context,
    List<BaseRegisteredCourses<BaseCourseModel>> courses,
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
          return _buildRegisteredCourseCard(
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
    List<BaseRegisteredCourses<BaseCourseModel>> courses,
    ResponsiveInfo responsiveInfo,
  ) {
    return ResponsiveBuilder(
      builder: (context, responsiveInfo) {
        final topPadding = getTopPadding(responsiveInfo);

        return ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: topPadding),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: widget.spacing!),
          itemBuilder: (context, index) {
            return _buildRegisteredCourseCard(
              context,
              courses[index],
              false,
              responsiveInfo,
            );
          },
        );
      },
    );
  }

  Widget _buildRegisteredCourseCard(
    BuildContext context,
    BaseRegisteredCourses<BaseCourseModel> registeredCourse,
    bool isGrid,
    ResponsiveInfo responsiveInfo,
  ) {
    if (isGrid) {
      return SizedBox(
        height: getGridItemHeight(responsiveInfo),
        child: CardFactory.customCard(
          contentStrategy: CurrentTabStrategy(
            title: registeredCourse.course.title,
            description: registeredCourse.course.description,
            buttonText: "Continue",
            userAvatars: registeredCourse.course.latestEnrolledUsers
              ..sort((a, b) => a.enrolledAt!.compareTo(b.enrolledAt!)),
            totalUsers: registeredCourse.course.enrolledUsersCount,
            progressValue: registeredCourse.progress.toDouble() / 100,
            progressLabel: "${registeredCourse.progress}% Complete",
            onButtonPressed: () => _startCourse(context, registeredCourse),
            responsiveInfo: responsiveInfo,
            isGrid: true,
          ),
          overlayStrategy: EmptyOverlayStrategy(),
          gradient: RandomGradients.getDailyGradient(seed: registeredCourse.id),
          margin: EdgeInsets.zero,
        ),
      );
    } else {
      return Stack(
        children: [
          CardFactory.progressCard(
            title: registeredCourse.course.title,
            description: registeredCourse.course.description,
            isList: !isGrid,
            buttonText: "Continue",
            userAvatars: registeredCourse.course.latestEnrolledUsers
              ..sort((a, b) => a.enrolledAt!.compareTo(b.enrolledAt!)),
            totalUsers: registeredCourse.course.enrolledUsersCount,
            progressValue: registeredCourse.progress.toDouble() / 100,
            progressLabel: "${registeredCourse.progress}% Complete",
            onButtonPressed: () => _startCourse(context, registeredCourse),
            gradient: RandomGradients.getDailyGradient(
              seed: registeredCourse.id,
            ),
            margin: responsiveInfo.responsiveMargin.copyWith(
              top: responsiveInfo.responsiveMargin.top * 0.5,
              bottom: responsiveInfo.responsiveMargin.bottom * 0.5,
            ),
          ),
          Positioned(
            top: 18,
            right: 30 * responsiveInfo.scaleFactor,
            child: CourseListButton(
              onButtonPressed: () => _startCourse(context, registeredCourse),
            ),
          ),
        ],
      );
    }
  }

  void _startCourse(
    BuildContext context,
    BaseRegisteredCourses<BaseCourseModel> courseData,
  ) {
    widget.onCoursePressed?.call(courseData);
  }

  Widget _buildEmptyState(BuildContext context, String statusText) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            VSpace(111),
            Image.asset(Assets.images.noCompletedCourse.path),
            const SizedBox(height: 16),
            Text(
              'No $statusText yet',
              style: AppTextStyles.xxlBold(
                context,
              ).copyWith(color: AppColors.gray600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
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
