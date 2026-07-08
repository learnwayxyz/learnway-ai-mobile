import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/explore_paths/widgets/explore_paths_shimmer.dart';
import 'package:learnwayv2/features/play/cubit/roadmap_cubit.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/gen/assets.gen.dart';
import 'package:learnwayv2/l10n/app_localizations.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/buttons.dart';

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
    locator<RoadmapCubit>().fetchMyRoadmap();
  }

  void _onPathTap(RoadmapPath path, RoadmapModel roadmap) {
    final locked = path.type == 'specialization' && !roadmap.userHasAccess;
    if (!locked) {
      context.router.push(
        PathCoursesRoute(learningPathId: path.id, pathTitle: path.title),
      );
    } else {
      _showPaywall(context, path);
    }
  }

  void _showPaywall(BuildContext context, RoadmapPath path) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _RoadmapPathPaywallDialog(
        path: path,
        onSubscribe: () {
          Navigator.of(context).pop();
          context.router.push(const PayWallRoute());
        },
      ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: CustomBackButton(onPress: () => context.router.maybePop()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Learning Paths',
                style: AppTextStyles.xlBold(
                  context,
                ).copyWith(color: AppColors.gray950),
              ),
              const SizedBox(height: 4),
              Text(
                'All the paths on your personal roadmap toward your career goal',
                style: AppTextStyles.smRegular(
                  context,
                ).copyWith(color: AppColors.gray500),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPathList() {
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      bloc: locator<RoadmapCubit>(),
      builder: (context, state) {
        final roadmap = state.roadmap;

        if (roadmap == null &&
            (state.status == RoadmapStatus.loading ||
                state.status == RoadmapStatus.initial)) {
          return const ExplorePathsShimmer();
        }

        if (roadmap == null) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Failed to load paths',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
          );
        }

        final paths = roadmap.paths;

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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          itemCount: paths.length,
          separatorBuilder: (context, i) => const SizedBox(height: 16),
          itemBuilder: (_, i) => _PathCard(
            path: paths[i],
            locked: paths[i].type == 'specialization' && !roadmap.userHasAccess,
            onTap: () => _onPathTap(paths[i], roadmap),
          ),
        );
      },
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({
    required this.path,
    required this.locked,
    required this.onTap,
  });

  final RoadmapPath path;
  final bool locked;
  final VoidCallback onTap;

  bool get _isFoundation => path.type == 'foundation';

  String get _fallbackAsset {
    if (_isFoundation) return Assets.images.botToMoonPng.path;
    return Assets.images.codeImage.path;
  }

  Color get _bgColor {
    if (_isFoundation) return const Color(0xFFFFF9E6);
    return const Color(0xFFE8EAF6);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox.expand(
                  child: path.coverImageUrl != null
                      ? Image.network(
                          path.coverImageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) =>
                              Image.asset(_fallbackAsset, fit: BoxFit.contain),
                        )
                      : Image.asset(_fallbackAsset, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          path.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.smBold(
                            context,
                          ).copyWith(color: AppColors.gray950),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Badge(
                        label: locked || path.hasPremiumCourse ? 'Premium' : 'Free',
                        color: locked || path.hasPremiumCourse
                            ? const Color(0xFFF97316)
                            : const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          locked
                              ? Icons.lock_outline_rounded
                              : Icons.chevron_right_rounded,
                          color: AppColors.gray500,
                          size: locked ? 15 : 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    path.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.xsRegular(
                      context,
                    ).copyWith(color: AppColors.gray500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.coursesCount(path.courses.length),
                    style: AppTextStyles.xsSemiBold(
                      context,
                    ).copyWith(color: AppColors.primary700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.xsSemiBold(context).copyWith(color: Colors.white),
      ),
    );
  }
}

class _RoadmapPathPaywallDialog extends StatelessWidget {
  const _RoadmapPathPaywallDialog({
    required this.path,
    required this.onSubscribe,
  });

  final RoadmapPath path;
  final VoidCallback onSubscribe;

  static const _includes = ['AI Mentor', 'Hands on Projects', 'Certificate'];

  String get _fallbackAsset {
    if (path.type == 'foundation') return Assets.images.botToMoonPng.path;
    return Assets.images.codeImage.path;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SizedBox.expand(
                      child: path.coverImageUrl != null
                          ? Image.network(
                              path.coverImageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, e, s) => Image.asset(
                                _fallbackAsset,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(_fallbackAsset, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const _Badge(
                            label: 'Premium',
                            color: Color(0xFFF97316),
                          ),
                          const Spacer(),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.gray950,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        path.title,
                        style: AppTextStyles.baseBold(
                          context,
                        ).copyWith(color: AppColors.gray950),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        path.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.xsRegular(
                          context,
                        ).copyWith(color: AppColors.gray500, height: 1.4),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Beginner',
                            style: AppTextStyles.xsRegular(
                              context,
                            ).copyWith(color: AppColors.gray500),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.library_books_outlined,
                            size: 13,
                            color: AppColors.gray400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${path.courses.length} Courses',
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
            const SizedBox(height: 28),
            Text(
              'Includes',
              style: AppTextStyles.baseBold(
                context,
              ).copyWith(color: AppColors.gray950),
            ),
            const SizedBox(height: 12),
            ...List.generate(_includes.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  bottom: index == _includes.length - 1 ? 0 : 10,
                ),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18, color: AppColors.primary700),
                    const SizedBox(width: 8),
                    Text(
                      _includes[index],
                      style: AppTextStyles.smMedium(
                        context,
                      ).copyWith(color: AppColors.primary700),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ButtonFactory.blackButton(
                mainAxisAlignment: MainAxisAlignment.center,
                onPressed: onSubscribe,
                text: 'Unlock Premium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
