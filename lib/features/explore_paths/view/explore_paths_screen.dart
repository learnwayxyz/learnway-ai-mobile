import 'package:ai_mentor/ai_mentor.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/gen/assets.gen.dart';

@RoutePage()
class ExplorePathsScreen extends StatefulWidget {
  const ExplorePathsScreen({super.key});

  @override
  State<ExplorePathsScreen> createState() => _ExplorePathsScreenState();
}

class _ExplorePathsScreenState extends State<ExplorePathsScreen> {
  int _selectedTabIndex = 0;

  static const _tabs = [
    'All Path',
    'Recommended',
    'Most Popular',
    'Foundation',
  ];

  @override
  void initState() {
    super.initState();
    locator<LearningPathCubit>().fetchLearningPaths();
  }

  List<LearningPathModel> _filterPaths(
    List<LearningPathModel> paths,
    int tab,
  ) {
    switch (tab) {
      case 1:
        return paths.where((p) => p.access.userHasAccess).toList();
      case 2:
        return [...paths]
          ..sort((a, b) => b.totalCourses.compareTo(a.totalCourses));
      case 3:
        return paths.where((p) => p.isFoundation).toList();
      default:
        return paths;
    }
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
            _buildTabBar(),
            Expanded(child: _buildPathList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: const Icon(Icons.arrow_back, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore Paths',
            style: AppTextStyles.xlBold(
              context,
            ).copyWith(color: AppColors.gray950),
          ),
          const SizedBox(height: 4),
          Text(
            'Discover Paths to build in-demand skills and grow your career',
            style: AppTextStyles.smRegular(
              context,
            ).copyWith(color: AppColors.gray500),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tabs.length,
        separatorBuilder: (context, i) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == _selectedTabIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.gray950 : AppColors.gray100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                _tabs[i],
                style: AppTextStyles.smMedium(
                  context,
                ).copyWith(color: selected ? Colors.white : AppColors.gray600),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPathList() {
    return BlocBuilder<LearningPathCubit, LearningPathState>(
      bloc: locator<LearningPathCubit>(),
      builder: (context, state) {
        if (state.status == LearningPathStatus.loading ||
            state.status == LearningPathStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LearningPathStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Failed to load paths',
              style: AppTextStyles.smRegular(
                context,
              ).copyWith(color: AppColors.gray500),
            ),
          );
        }

        final paths = _filterPaths(state.paths, _selectedTabIndex);

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
          itemBuilder: (_, i) => _PathCard(path: paths[i]),
        );
      },
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({required this.path});

  final LearningPathModel path;

  String _fallbackAsset(BuildContext context) {
    if (path.isFoundation) return Assets.images.botToMoonPng.path;
    return Assets.images.codeImage.path;
  }

  Color get _bgColor {
    if (path.isFoundation) return const Color(0xFFFFF9E6);
    return const Color(0xFFE8EAF6);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox.expand(
              child: path.coverImageUrl != null
                  ? Image.network(
                      path.coverImageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, e, s) => Image.asset(
                        _fallbackAsset(context),
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(_fallbackAsset(context), fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Badge(
                    label: path.isPremium ? 'Premium' : 'Free',
                    color: path.isPremium
                        ? const Color(0xFFF97316)
                        : const Color(0xFF16A34A),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: path.isPremium
                        ? null
                        : () => context.router.push(
                              PathCoursesRoute(
                                learningPathId: path.id,
                                pathTitle: path.title,
                              ),
                            ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.gray950,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        path.isPremium
                            ? Icons.lock_outline_rounded
                            : Icons.arrow_outward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
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
                    path.isFoundation ? 'Foundation' : 'Specialization',
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
                    '${path.totalCourses} Courses',
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
