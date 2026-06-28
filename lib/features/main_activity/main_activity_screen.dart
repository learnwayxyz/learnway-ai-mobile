import 'package:learnwayv2/app/app_barrel.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

@RoutePage()
class MainActivityScreen extends StatefulWidget {
  const MainActivityScreen({super.key});

  @override
  State<MainActivityScreen> createState() => _MainActivityScreenState();
}

class _MainActivityScreenState extends State<MainActivityScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    final currentIndex = context.read<MainActivityCubit>().state.currentIndex;
    _controller = PersistentTabController(initialIndex: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainActivityCubit, MainActivityState>(
      listenWhen: (prev, curr) => prev.currentIndex != curr.currentIndex,
      listener: (context, state) {
        _controller.jumpToTab(state.currentIndex);
      },
      child: BlocBuilder<MainActivityCubit, MainActivityState>(
        builder: (context, state) {
          return PersistentTabView(
            controller: _controller,
            tabs: _tabsFromState(state),
            onTabChanged: (index) {
              context.read<MainActivityCubit>().navigateTo(index);
            },
            navBarBuilder: (navBarConfig) => Style1BottomNavBar(
              navBarConfig: navBarConfig,
              height: 60,
              navBarDecoration: NavBarDecoration(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  List<PersistentTabConfig> _tabsFromState(MainActivityState state) {
    return List.generate(state.pages.length, (index) {
      final isActive = index == state.currentIndex;
      final item = isActive
          ? state.activeBottomNav[index]
          : state.inActiveBottomNav[index];

      return PersistentTabConfig(
        screen: state.pages[index],
        item: ItemConfig(
          icon: SvgPicture.asset(
            item.icon,
            colorFilter: ColorFilter.mode(
              isActive ? AppColors.gray900 : AppColors.gray400,
              BlendMode.srcIn,
            ),
          ),
          title: item.label,
          activeForegroundColor: AppColors.gray900,
          inactiveForegroundColor: AppColors.gray600,
          textStyle: AppTextStyles.xsRegular(context),
        ),
      );
    });
  }
}
