import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/bloc/course_tabs_bloc.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/all_course_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/completed_tab.dart';
import 'package:learnwayv2/shared/widgets/course_layout_widget/tabs/current_course_tab.dart';

class CourseTabsWithLayout extends StatelessWidget {
  final Function(BaseRegisteredCourses<BaseCourseModel> course)?
  onCoursePressed;
  final Function(LearnWayCourses onEnroll)? onEnrollCoursePressed;
  final EdgeInsets? padding;
  final LevelType levelType;
  final double? spacing;
  final CourseStatus selectedTab;
  final LayoutType layoutType;

  const CourseTabsWithLayout({
    super.key,
    this.onCoursePressed,
    this.onEnrollCoursePressed,
    this.padding,
    this.spacing = 16.0,
    required this.levelType,
    required this.selectedTab,
    required this.layoutType,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTabContent(context);
  }

  Widget _buildTabContent(BuildContext context) {
    switch (selectedTab) {
      case CourseStatus.all:
        return AllCoursesTab(
          layoutType: layoutType,
          padding: padding,
          spacing: spacing,
          levelType: levelType,
        );
      case CourseStatus.current:
        return CurrentCoursesTab(
          onCoursePressed: onCoursePressed,
          layoutType: layoutType,
          padding: padding,
          levelType: levelType,
          spacing: spacing,
        );
      case CourseStatus.completed:
        return CompletedCoursesTab(
          onCoursePressed: onCoursePressed,
          layoutType: layoutType,
          padding: padding,
          levelType: levelType,
          spacing: spacing,
        );
    }
  }
}

class CourseListButton extends StatelessWidget {
  const CourseListButton({super.key, this.onButtonPressed});
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onButtonPressed?.call();
      },
      child: Container(
        height: 39,
        width: 41,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: SvgPicture.asset(Assets.icons.arrowRight),
        ),
      ),
    );
  }
}
