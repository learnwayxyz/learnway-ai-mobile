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
    icon: 'assets/images/nav_icons/home_nav_icon_inactive.svg',
    label: 'Home',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/play_nav_icon_inactive.svg',
    label: 'Play',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/leader_nav_icon_inactive.svg',
    label: 'Leader',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/wallet_nav_icon_inactive.svg',
    label: 'Wallet',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/profile_nav_icon_inactive.svg',
    label: 'Account',
  ),
];

List<BottomNavItems> _activeBottomNav = [
  BottomNavItems(
    icon: 'assets/images/nav_icons/home_nav_icon_active.svg',
    label: 'Home',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/play_nav_icon_active.svg',
    label: 'Play',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/leader_nav_icon_active.svg',
    label: 'Leader',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/wallet_nav_icon_active.svg',
    label: 'Wallet',
  ),
  BottomNavItems(
    icon: 'assets/images/nav_icons/profile_nav_icon_active.svg',
    label: 'Account',
  ),
];

class BottomNavItems {
  final String icon;
  final String label;

  BottomNavItems({required this.icon, required this.label});
}
