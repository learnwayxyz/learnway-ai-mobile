import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnwayv2/features/home/home_bloc/home_bloc.dart';
import 'package:learnwayv2/features/home/home_bloc/home_state.dart';
import 'package:learnwayv2/features/home/home_repository/user_profile_model.dart';
import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/back_button.dart';
import 'package:learnwayv2/shared/widgets/card_component/card_strategies/dissmissable_app_bar_strategy.dart';

enum AppBarType { home, standard }

abstract class AppBarContentStrategy {
  Widget buildContent(BuildContext context);
}

class HomeAppBarContentStrategy implements AppBarContentStrategy {
  const HomeAppBarContentStrategy();

  @override
  Widget buildContent(BuildContext context) {
    return const _HomeAppBarContent();
  }
}

class _HomeAppBarContent extends StatefulWidget {
  const _HomeAppBarContent();

  @override
  State<_HomeAppBarContent> createState() => _HomeAppBarContentState();
}

enum SelectedIcon { notification, streak }

class _HomeAppBarContentState extends State<_HomeAppBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  SelectedIcon _selectedIcon = SelectedIcon.notification;

  double _dragOffset = 0.0;

  static const double _iconWidth = 24.0;
  static const double _iconSpacing = 8.0;
  static const double _whiteContainerPadding = 4.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNotificationTap() {
    context.router.push(NotificationsRoute()).then((_) {
      setState(() {
        _selectedIcon = SelectedIcon.notification;
        _dragOffset = 0.0;
      });
    });
  }

  void _onStreakTap() {
    if (_selectedIcon == SelectedIcon.streak) return;

    setState(() {
      _selectedIcon = SelectedIcon.streak;
      _dragOffset = 0.0;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-_iconWidth * 2, _iconWidth * 2);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragOffset < -20) {
      setState(() {
        _selectedIcon = SelectedIcon.notification;
        _dragOffset = 0.0;
      });
    } else if (_dragOffset > 20) {
      setState(() {
        _selectedIcon = SelectedIcon.streak;
        _dragOffset = 0.0;
      });
    } else {
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning 👋';
    } else if (hour < 17) {
      return 'Good afternoon 👋';
    } else {
      return 'Good evening 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return BlocSelector<HomeBloc, HomeState, UserProfileModel?>(
      selector: (state) => state.userProfile,
      builder: (context, userProfile) {
        final profile = userProfile ?? UserProfileModel.empty();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 15,
            bottom: 15,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    profile.profileImageUrl != null &&
                        profile.profileImageUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(profile.profileImageUrl!)
                    : null,
                backgroundColor: AppColors.gray200,
                child:
                    profile.profileImageUrl == null ||
                        profile.profileImageUrl!.isEmpty
                    ? Icon(Icons.person, color: AppColors.gray500)
                    : null,
              ),
              HSpace(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getGreeting(),
                    style: AppTextStyles.sm(context, color: subtitleColor),
                  ),
                  Text(
                    profile.username ?? '',
                    style: AppTextStyles.baseBold(context, color: textColor),
                  ),
                ],
              ),
              const Spacer(),
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, notificationState) {
                  final unreadCount = notificationState is NotificationLoaded
                      ? notificationState.response.notifications
                            .where((n) => !n.isRead)
                            .length
                      : 0;

                  return GestureDetector(
                    onHorizontalDragUpdate: _handleDragUpdate,
                    onHorizontalDragEnd: _handleDragEnd,
                    onTapDown: (_) {
                      _animationController.forward();
                    },
                    onTapUp: (_) {
                      _animationController.reverse();
                    },
                    onTapCancel: () {
                      _animationController.reverse();
                    },
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.blueGray25,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: _onNotificationTap,
                                  child: Container(
                                    width: _iconWidth,
                                    height: _iconWidth,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/notification.svg',
                                          width: 20,
                                          height: 20,
                                          colorFilter: ColorFilter.mode(
                                            textColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),

                                        if (_selectedIcon !=
                                                SelectedIcon.notification &&
                                            unreadCount > 0)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (profile.currentStreak != null &&
                                    profile.currentStreak! > 0) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _onStreakTap,
                                    child: Container(
                                      width: _iconWidth,
                                      height: _iconWidth,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/flames.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              top: 0,
                              left: _selectedIcon == SelectedIcon.notification
                                  ? 0 + _dragOffset
                                  : ((profile.currentStreak != null &&
                                            profile.currentStreak! > 0)
                                        ? _iconWidth +
                                              _iconSpacing +
                                              _dragOffset
                                        : 0 + _dragOffset),
                              child: GestureDetector(
                                onHorizontalDragUpdate: _handleDragUpdate,
                                onHorizontalDragEnd: _handleDragEnd,
                                onTap: () {
                                  if (_selectedIcon ==
                                      SelectedIcon.notification) {
                                    _onNotificationTap();
                                  }
                                },
                                child: Container(
                                  width: _iconWidth,
                                  height: _iconWidth,
                                  padding: EdgeInsets.all(
                                    _whiteContainerPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Center(
                                        child:
                                            _selectedIcon ==
                                                SelectedIcon.notification
                                            ? SvgPicture.asset(
                                                'assets/images/notification.svg',
                                                width: 16,
                                                height: 16,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                      Colors.black,
                                                      BlendMode.srcIn,
                                                    ),
                                              )
                                            : Image.asset(
                                                'assets/images/flames.png',
                                                width: 16,
                                                height: 16,
                                              ),
                                      ),
                                      Positioned(
                                        right: -6,
                                        top: -6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _selectedIcon ==
                                                    SelectedIcon.notification
                                                ? Colors.red
                                                : Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 14,
                                          ),
                                          child: Text(
                                            _selectedIcon ==
                                                    SelectedIcon.notification
                                                ? (unreadCount > 9
                                                      ? '9+'
                                                      : '$unreadCount')
                                                : '${profile.currentStreak}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class StandardAppBarContentStrategy implements AppBarContentStrategy {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;

  const StandardAppBarContentStrategy({
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget buildContent(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Column(children: [CustomBackButton(onPress: onBackPressed)])
          : null,
      title: Text(title, style: AppTextStyles.baseSemiBold(context)),
      actions: actions,
      centerTitle: true,
      elevation: 0,
    );
  }
}

class AppBarFactory {
  static PreferredSizeWidget homeAppBar() {
    return CustomAppBar(
      contentStrategy: HomeAppBarContentStrategy(),
      appBarType: AppBarType.home,
    );
  }

  static PreferredSizeWidget standardAppBar({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    bool showBackButton = true,
    int? barHeight,
  }) {
    return CustomAppBar(
      contentStrategy: StandardAppBarContentStrategy(
        title: title,
        onBackPressed: onBackPressed,
        actions: actions,
        showBackButton: showBackButton,
      ),
      appBarType: AppBarType.standard,
      barHeight: barHeight ?? 30,
    );
  }

  static PreferredSizeWidget centeredTitleAppBar({
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    Color? backgroundColor,
  }) {
    return CustomAppBar(
      contentStrategy: StandardAppBarContentStrategy(
        title: title,
        actions: actions,
        showBackButton: false,
      ),
      appBarType: AppBarType.standard,
      bottom: bottom,
      backgroundColor: backgroundColor,
    );
  }

  static PreferredSizeWidget dismissableAppBar({
    required String title,
    VoidCallback? onDismiss,
  }) {
    return CustomAppBar(
      contentStrategy: DismissableAppBarContentStrategy(
        title: title,
        onDismiss: onDismiss,
      ),
      appBarType: AppBarType.standard,
      barHeight: 50,
      backgroundColor: Color(0xff12c2e8),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.contentStrategy,
    required this.appBarType,
    this.backgroundColor,
    this.elevation,
    this.title,
    this.barHeight = 30,
    this.bottom,
  });

  final AppBarContentStrategy contentStrategy;
  final AppBarType appBarType;
  final Color? backgroundColor;
  final double? elevation;
  final String? title;
  final int barHeight;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
    kTextTabBarHeight + barHeight + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final themeAppBarColor = Theme.of(context).appBarTheme.backgroundColor;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? themeAppBarColor,
      elevation: elevation ?? 0,
      flexibleSpace: SafeArea(
        bottom: false,
        child: contentStrategy.buildContent(context),
      ),
      bottom: bottom,
    );
  }
}
