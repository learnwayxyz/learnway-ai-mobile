import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/courses_info_details.dart';
import 'package:learnwayv2/features/learn_and_earn/view/widget/expandable_text_widget.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

class CourseInformationEmptyState extends StatelessWidget {
  const CourseInformationEmptyState({super.key, required this.courseTitle});
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

class CourseInformationTab extends StatelessWidget {
  const CourseInformationTab({super.key, required this.courseData});
  final CoursesInfoDetails courseData;

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
