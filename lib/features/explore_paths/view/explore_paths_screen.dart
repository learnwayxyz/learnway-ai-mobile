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
    final paths = _pathsForTab(_selectedTabIndex);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: paths.length,
      separatorBuilder: (context, i) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _PathCard(path: paths[i]),
    );
  }

  List<_PathItem> _pathsForTab(int tab) {
    switch (tab) {
      case 1:
        return [
          _PathItem(
            fallbackAsset: Assets.images.codeImage.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Software Developer',
            description:
                'Build websites, apps and powerful software solutions from scratch.',
            level: 'Beginner',
            courseCount: 8,
            isPremium: false,
          ),
          _PathItem(
            fallbackAsset: Assets.images.codeImage.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Software Developer',
            description:
                'Build websites, apps and powerful software solutions from scratch.',
            level: 'Beginner',
            courseCount: 8,
            isPremium: false,
          ),
          _PathItem(
            fallbackAsset: Assets.images.codeImage.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Software Developer',
            description:
                'Build websites, apps and powerful software solutions from scratch.',
            level: 'Beginner',
            courseCount: 8,
            isPremium: false,
          ),
        ];
      default:
        return [
          _PathItem(
            fallbackAsset: Assets.images.botToMoonPng.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Digital Literacy',
            description:
                'Master AI tools and automation to solve problems, save time and boost productivity.',
            level: 'Beginner',
            courseCount: 2,
            isPremium: false,
          ),
          _PathItem(
            fallbackAsset: Assets.images.botToMoonPng.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Premium',
            badgeColor: const Color(0xFFF97316),
            title: 'AI & Automation',
            description:
                'Master AI tools and automation to solve problems, save time and boost productivity.',
            level: 'Beginner',
            courseCount: 2,
            isPremium: true,
          ),
          _PathItem(
            fallbackAsset: Assets.images.megaPhones.path,
            bgColor: const Color(0xFFFFF9E6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Digital Marketing Professional',
            description:
                'Learn to grow brands, create content and run high-converting marketing campaigns.',
            level: 'Beginner',
            courseCount: 4,
            isPremium: false,
          ),
          _PathItem(
            fallbackAsset: Assets.images.megaPhones.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Data Analyst',
            description:
                'Turn data into insights and make smarter, data-driven decisions.',
            level: 'Beginner',
            courseCount: 2,
            isPremium: false,
          ),
          _PathItem(
            fallbackAsset: Assets.images.codeImage.path,
            bgColor: const Color(0xFFE8EAF6),
            badgeLabel: 'Free',
            badgeColor: const Color(0xFF16A34A),
            title: 'Software Developer',
            description:
                'Build websites, apps and powerful software solutions from scratch.',
            level: 'Beginner',
            courseCount: 8,
            isPremium: false,
          ),
        ];
    }
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({required this.path});

  final _PathItem path;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: path.bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox.expand(
              child: path.imageUrl != null
                  ? Image.network(
                      path.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Image.asset(
                        path.fallbackAsset,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Image.asset(path.fallbackAsset, fit: BoxFit.contain),
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
                  _Badge(label: path.badgeLabel, color: path.badgeColor),
                  const Spacer(),
                  Container(
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
                    path.level,
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
                    '${path.courseCount} Courses',
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

class _PathItem {
  const _PathItem({
    this.imageUrl,
    required this.fallbackAsset,
    required this.bgColor,
    required this.badgeLabel,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.level,
    required this.courseCount,
    required this.isPremium,
  });

  final String? imageUrl;
  final String fallbackAsset;
  final Color bgColor;
  final String badgeLabel;
  final Color badgeColor;
  final String title;
  final String description;
  final String level;
  final int courseCount;
  final bool isPremium;
}
