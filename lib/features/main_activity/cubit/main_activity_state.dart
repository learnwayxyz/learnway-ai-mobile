part of 'main_activity_cubit.dart';

class MainActivityState extends Equatable {
  const MainActivityState({
    this.currentIndex = 0,
    this.activeBottomNav = const [],
    this.inActiveBottomNav = const [],
    this.pages = const [],
    this.timestamp,
  });

  final int currentIndex;
  final List<BottomNavItems> inActiveBottomNav;
  final List<BottomNavItems> activeBottomNav;
  final List<Widget> pages;
  final DateTime? timestamp;

  @override
  List<Object?> get props => [
    currentIndex,
    inActiveBottomNav,
    activeBottomNav,
    pages,
    timestamp,
  ];

  MainActivityState copyWith({
    int? currentIndex,
    List<BottomNavItems>? inActiveBottomNav,
    List<BottomNavItems>? activeBottomNav,
    List<Widget>? pages,
    DateTime? timestamp,
  }) {
    return MainActivityState(
      currentIndex: currentIndex ?? this.currentIndex,
      inActiveBottomNav: inActiveBottomNav ?? this.inActiveBottomNav,
      activeBottomNav: activeBottomNav ?? this.activeBottomNav,
      pages: pages ?? this.pages,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

List<BottomNavItems> _inActiveBottomNav = [
  BottomNavItems(
    icon: Assets.images.navIcons.homeNavIconInactive,
    label: 'Home',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.learnNavIconInactive,
    label: 'Learn',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.leaderNavIconInactive,
    label: 'Leader',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.walletNavIconInactive,
    label: 'Wallet',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.profileNavIconInactive,
    label: 'Account',
  ),
];

List<BottomNavItems> _activeBottomNav = [
  BottomNavItems(icon: Assets.images.navIcons.homeNavIconActive, label: 'Home'),
  BottomNavItems(
    icon: Assets.images.navIcons.learnNavIconActive,
    label: 'Learn',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.leaderNavIconActive,
    label: 'Leader',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.walletNavIconActive,
    label: 'Wallet',
  ),
  BottomNavItems(
    icon: Assets.images.navIcons.profileNavIconActive,
    label: 'Account',
  ),
];

class BottomNavItems {
  final String icon;
  final String label;

  BottomNavItems({required this.icon, required this.label});
}
