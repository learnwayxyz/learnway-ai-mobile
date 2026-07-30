import 'package:ai_mentor/ai_mentor.dart';
import 'package:collection/collection.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_info_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart'
    as learn_and_earn;
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/expandable_text_widget.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/overlay_loader.dart';

@RoutePage()
class CoursesPathInfoScreen extends StatefulWidget {
  const CoursesPathInfoScreen({
    super.key,
    required this.course,
    required this.pathTitle,
  });

  final PathCourseModel course;
  final String pathTitle;

  @override
  State<CoursesPathInfoScreen> createState() => _CoursesPathInfoScreenState();
}

class _CoursesPathInfoScreenState extends State<CoursesPathInfoScreen> {
  bool _isEnrolling = false;

  LevelType get _levelType {
    return switch (widget.course.skillLevel.toUpperCase()) {
      'INTERMEDIATE' => LevelType.intermediate,
      'ADVANCED' => LevelType.advanced,
      _ => LevelType.beginner,
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseInfoCubit>().fetchCourseInfo(widget.course.id);
      context.read<learn_and_earn.LearnAndEarnBloc>().add(
        learn_and_earn.FetchCourseLessons(
          id: widget.course.id,
          forceRefresh: false,
        ),
      );
    });
  }

  CourseLesson? _getLessons(learn_and_earn.LearnAndEarnState state) {
    final lessons = switch (state) {
      learn_and_earn.FetchedCourseLessons() => state.courseLessons,
      learn_and_earn.FetchingCourseLessons() => state.courseLessons,
      learn_and_earn.FetchCourseLessonsError() => state.courseLessons,
      _ => null,
    };
    return lessons?.id == widget.course.id ? lessons : null;
  }

  void _enroll() {
    setState(() => _isEnrolling = true);
    final bloc = context.read<learn_and_earn.LearnAndEarnBloc>();
    switch (_levelType) {
      case LevelType.beginner:
        bloc.add(learn_and_earn.EnrollBeginnerCourse(widget.course.id));
      case LevelType.intermediate:
        bloc.add(learn_and_earn.EnrollIntermediateCourse(widget.course.id));
      case LevelType.advanced:
        bloc.add(learn_and_earn.EnrollAdvancedCourse(widget.course.id));
    }
  }

  void _handleEnrolled(learn_and_earn.LearnAndEarnState state) {
    switch (state) {
      case learn_and_earn.EnrolledBeginnerCourse(:final myRegisteredCourses):
        final registered = myRegisteredCourses.firstWhereOrNull(
          (c) => c.course.id == widget.course.id,
        );
        if (registered != null) {
          registerCourseData(registered, LevelType.beginner);
          context.router.replace(
            LessonRoute(
              levelType: LevelType.beginner,
              pathTitle: widget.pathTitle,
            ),
          );
        }
      case learn_and_earn.EnrolledIntermediateCourse(
        :final myRegisteredCourses,
      ):
        final registered = myRegisteredCourses.firstWhereOrNull(
          (c) => c.course.id == widget.course.id,
        );
        if (registered != null) {
          registerCourseData(registered, LevelType.intermediate);
          context.router.replace(
            LessonRoute(
              levelType: LevelType.intermediate,
              pathTitle: widget.pathTitle,
            ),
          );
        }
      case learn_and_earn.EnrolledAdvancedCourse(:final myRegisteredCourses):
        final registered = myRegisteredCourses.firstWhereOrNull(
          (c) => c.course.id == widget.course.id,
        );
        if (registered != null) {
          registerCourseData(registered, LevelType.advanced);
          context.router.replace(
            LessonRoute(
              levelType: LevelType.advanced,
              pathTitle: widget.pathTitle,
            ),
          );
        }
      case learn_and_earn.EnrollBeginnerCourseError(:final message) ||
          learn_and_earn.EnrollIntermediateCourseError(:final message) ||
          learn_and_earn.EnrollAdvancedCourseError(:final message):
        setState(() => _isEnrolling = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      learn_and_earn.LearnAndEarnBloc,
      learn_and_earn.LearnAndEarnState
    >(
      listener: (context, state) => _handleEnrolled(state),
      child: Scaffold(
        appBar: AppBarFactory.standardAppBar(
          title: widget.course.title,
          barHeight: 10,
        ),
        body: OverlayLoader(
          isLoading: _isEnrolling,
          loadingText: Text(
            'Enrolling in ${widget.course.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.smMedium(context),
          ),
          child: SafeArea(
            child: Column(
              children: [
                BlocBuilder<
                  learn_and_earn.LearnAndEarnBloc,
                  learn_and_earn.LearnAndEarnState
                >(
                  builder: (context, state) {
                    final lessons = _getLessons(state);
                    return CardFactory.activeLessonCard(
                      title: widget.course.title,
                      subtitle: widget.course.description,
                      totalLessons: lessons?.lessons.length ?? 0,
                      completedLessons: lessons?.lessons
                              .where((l) => l.isCompleted)
                              .length ??
                          0,
                      progressLabel: lessons?.progress.toString() ?? '0',
                      progressValue: (lessons?.progress.toDouble() ?? 0) / 100,
                      borderRadius: BorderRadius.circular(0),
                      showCompletedCount: false,
                    );
                  },
                ),
                const VSpace(8),
                Expanded(
                  child: BlocBuilder<CourseInfoCubit, CourseInfoState>(
                    builder: (context, state) {
                      if (state is CourseInfoLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CourseInfoError) {
                        return Center(
                          child: Text(
                            state.error,
                            style: AppTextStyles.smRegular(context),
                          ),
                        );
                      }
                      final data = state is CourseInfoLoaded
                          ? state.data
                          : null;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data != null &&
                                data.aboutText.trim().isNotEmpty) ...[
                              _AboutCourseCard(text: data.aboutText),
                              const VSpace(24),
                            ],
                            if (data != null) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: _InfoCard(
                                      label: 'Difficulty',
                                      value: data.difficultyLabel,
                                    ),
                                  ),
                                  if (data.estimatedTimeLabel != null) ...[
                                    const HSpace(12),
                                    Expanded(
                                      child: _InfoCard(
                                        label: 'Estimated Time',
                                        value: data.estimatedTimeLabel!,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const VSpace(24),
                            ],
                            if (data != null &&
                                data.skillsGained.isNotEmpty) ...[
                              _SkillsGainedCard(items: data.skillsGained),
                              const VSpace(24),
                            ],
                            const _CertificateCard(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _EnrollButtonBar(onEnroll: _isEnrolling ? null : _enroll),
              ],
            ),
          ),
        ),
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

class _AboutCourseCard extends StatelessWidget {
  const _AboutCourseCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          ExpandableDescription(text: text),
        ],
      ),
    );
  }
}

class _SkillsGainedCard extends StatelessWidget {
  const _SkillsGainedCard({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skills you\'ll gain', style: AppTextStyles.mdBold(context)),
          const VSpace(12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: AppColors.success200, size: 18),
                  const HSpace(8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.smRegular(
                        context,
                      ).copyWith(color: AppColors.gray700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Earn a Certificate', style: AppTextStyles.mdBold(context)),
        const VSpace(8),
        Text(
          'Complete the courses and project assessments to earn a Certificate '
          'of Completion you can showcase on your CV or LinkedIn profile.',
          style: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray600),
        ),
        const VSpace(12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Assets.images.premimuCert.image(),
          ),
        ),
      ],
    );
  }
}

class _EnrollButtonBar extends StatelessWidget {
  const _EnrollButtonBar({required this.onEnroll});
  final VoidCallback? onEnroll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.viewPaddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ButtonFactory.blackButton(
        mainAxisAlignment: MainAxisAlignment.center,
        text: 'Enroll in Course',
        backgroundColor: Colors.black,
        textStyle: AppTextStyles.smSemiBold(
          context,
        ).copyWith(color: Colors.white),
        onPressed: onEnroll ?? () {},
      ),
    );
  }
}
