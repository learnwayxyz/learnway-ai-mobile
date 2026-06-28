import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/learn_and_earn_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';

void handleCourseEnrollment(BuildContext context, LearnWayCourses course) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CourseEnrollmentDialog(
        course: course,
        onConfirm: () async {
          Navigator.of(context).pop();
          final learnAndEarnBloc = locator<LearnAndEarnBloc>();
          learnAndEarnBloc.add(EnrollCourse(courseId: course.id));
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

class CourseEnrollmentDialog extends StatelessWidget {
  final LearnWayCourses course;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CourseEnrollmentDialog({
    super.key,
    required this.course,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(AppLocalizations.of(context)!.enrollInCourse, style: AppTextStyles.lgBold(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.title, style: AppTextStyles.mdBold(context)),
          const SizedBox(height: 8),
          Text(
            course.description,
            style: AppTextStyles.smRegular(context),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.areYouReadyToStartCourse,
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray600),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: AppTextStyles.smMedium(
              context,
            ).copyWith(color: AppColors.gray600),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(AppLocalizations.of(context)!.enrollNow, style: AppTextStyles.smMedium(context)),
        ),
      ],
    );
  }
}
