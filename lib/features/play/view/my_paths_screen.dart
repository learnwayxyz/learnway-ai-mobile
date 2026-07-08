import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/explore_paths/widgets/explore_paths_shimmer.dart';
import 'package:learnwayv2/features/play/cubit/roadmap_cubit.dart';
import 'package:learnwayv2/features/play/models/career_path_model.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';

@RoutePage()
class MyPathsScreen extends StatefulWidget {
  const MyPathsScreen({super.key});

  @override
  State<MyPathsScreen> createState() => _MyPathsScreenState();
}

class _MyPathsScreenState extends State<MyPathsScreen> {
  @override
  void initState() {
    super.initState();
    final userId = LocalStorageService.getUserSync()?.id ?? '';
    locator<RoadmapCubit>().fetchCareerPaths(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(child: _buildPathList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 12),
      child: Row(
        children: [
          CustomBackButton(onPress: () => context.router.maybePop()),
          const SizedBox(width: 8),
          Text(
            'My Learning Paths',
            style: AppTextStyles.xlBold(
              context,
            ).copyWith(color: AppColors.gray950),
          ),
        ],
      ),
    );
  }

  Widget _buildPathList() {
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      bloc: locator<RoadmapCubit>(),
      builder: (context, state) {
        if (state.careerPaths.isEmpty &&
            (state.careerPathsStatus == RoadmapStatus.loading ||
                state.careerPathsStatus == RoadmapStatus.initial)) {
          return const ExplorePathsShimmer();
        }

        if (state.careerPathsStatus == RoadmapStatus.failure &&
            state.careerPaths.isEmpty) {
          return Center(
            child: Text(
              state.careerPathsError ?? 'Failed to load paths',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
          );
        }

        final paths = state.careerPaths;

        if (paths.isEmpty) {
          return Center(
            child: Text(
              'No paths available',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          itemCount: paths.length,
          separatorBuilder: (context, i) => const SizedBox(height: 16),
          itemBuilder: (_, i) => _CareerPathCard(path: paths[i]),
        );
      },
    );
  }
}

class _CareerPathCard extends StatelessWidget {
  const _CareerPathCard({required this.path});

  final CareerPathModel path;

  @override
  Widget build(BuildContext context) {
    final progress = (path.completionPercentage / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                Assets.images.botToMoonPng.path,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.careerGoal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.smBold(
                    context,
                  ).copyWith(color: AppColors.gray950),
                ),
                const SizedBox(height: 6),
                Text(
                  '${path.totalEstimatedWeeks} weeks estimated',
                  style: AppTextStyles.xsRegular(
                    context,
                  ).copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: AppColors.gray200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${path.completionPercentage}%',
                      style: AppTextStyles.xsSemiBold(
                        context,
                      ).copyWith(color: const Color(0xFF2563EB)),
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
