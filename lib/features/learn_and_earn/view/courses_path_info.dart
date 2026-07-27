import 'package:ai_mentor/ai_mentor.dart';
import 'package:collection/collection.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/course_bloc/cubit/course_info_cubit.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart'
    as learn_and_earn;
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/courses_info_details.dart';
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
    });
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
            child: BlocBuilder<CourseInfoCubit, CourseInfoState>(
              builder: (context, state) {
                final data = state is CourseInfoLoaded ? state.data : null;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroCard(course: widget.course),
                            const VSpace(70),
                            if (state is CourseInfoLoading)
                              const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            else ...[
                              if (data != null &&
                                  data.skillsGained.isNotEmpty) ...[
                                _WhatYouWillLearnCard(items: data.skillsGained),
                                const VSpace(40),
                              ],
                              _CertificateCard(),
                              const VSpace(60),
                              _WhyTakeCourseCard(
                                course: widget.course,
                                data: data,
                              ),
                              const VSpace(40),
                              if (data != null &&
                                  data.prerequisites.isNotEmpty) ...[
                                _PrerequisitesCard(items: data.prerequisites),
                                const VSpace(24),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                    _EnrollButtonBar(onEnroll: _isEnrolling ? null : _enroll),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.course});
  final PathCourseModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: RandomGradients.getDailyGradient(seed: course.id),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 36),
          ),
          const HSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course.title, style: AppTextStyles.lgBold(context)),
                const VSpace(6),
                Text(
                  course.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smRegular(
                    context,
                  ).copyWith(color: AppColors.gray600),
                ),
                const VSpace(8),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: AppColors.gray500,
                    ),
                    const HSpace(4),
                    Text(
                      '${course.enrolledUsersCount} Enrolled',
                      style: AppTextStyles.xsRegular(
                        context,
                      ).copyWith(color: AppColors.gray500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatYouWillLearnCard extends StatelessWidget {
  const _WhatYouWillLearnCard({required this.items});
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
          Text('What you will learn', style: AppTextStyles.mdBold(context)),
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

class _PrerequisitesCard extends StatelessWidget {
  const _PrerequisitesCard({required this.items});
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
          Text('Prerequisite', style: AppTextStyles.mdBold(context)),
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
          'Complete all courses and assessments to receive a LearnWay AI '
          'Certificate of Completion that you can showcase on your CV, '
          'LinkedIn profile, or professional portfolio.',
          style: AppTextStyles.smRegular(
            context,
          ).copyWith(color: AppColors.gray600),
        ),
        const VSpace(12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              Assets.images.learnwayCert.path,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _WhyTakeCourseCard extends StatelessWidget {
  const _WhyTakeCourseCard({required this.course, required this.data});
  final PathCourseModel course;
  final CoursesInfoDetails? data;

  @override
  Widget build(BuildContext context) {
    final body = (data?.targetAudience?.trim().isNotEmpty ?? false)
        ? data!.targetAudience!
        : (data?.aboutText.trim().isNotEmpty ?? false)
        ? data!.aboutText
        : 'Whether you\'re a student, professional, entrepreneur, or '
              'lifelong learner, this learning path will equip you with the '
              'skills needed to thrive in today\'s technology-driven world.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why take this course?', style: AppTextStyles.mdBold(context)),
        const VSpace(8),
        ExpandableDescription(text: body),
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
        backgroundColor: AppColors.orange500,
        textStyle: AppTextStyles.smSemiBold(
          context,
        ).copyWith(color: Colors.black),
        onPressed: onEnroll ?? () {},
      ),
    );
  }
}
