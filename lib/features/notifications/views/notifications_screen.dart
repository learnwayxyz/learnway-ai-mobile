import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/notifications/cubit/notification_cubit.dart';
import 'package:learnwayv2/features/notifications/model/notification_model.dart';
import 'package:learnwayv2/features/notifications/utils/time_formatter.dart';
import 'package:learnwayv2/features/notifications/views/widgets/notification_shimmer.dart';
import 'package:learnwayv2/features/notifications/repository/notification_repository.dart';
import 'package:learnwayv2/router/app_router.dart';
import 'package:core/core.dart';
import 'package:learnwayv2/shared/utilities/standard_spacer.dart';
import 'package:learnwayv2/shared/widgets/app_bar.dart';

@RoutePage()
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.notificationId});

  final String? notificationId;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'All';
  bool _isSelectMode = false;
  Set<String> _selectedNotifications = {};
  late final NotificationCubit _notificationCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _notificationCubit = NotificationCubit(
      locator.get<NotificationRepository>(),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _notificationCubit.loadNotifications();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _notificationCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isCloseToBottom()) {
      _notificationCubit.loadMoreNotifications();
    }
  }

  bool _isCloseToBottom() {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationCubit,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBarFactory.standardAppBar(
          title: 'Notifications',
          barHeight: 10,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const VSpace(20),
                _buildTabSection(),
                const VSpace(20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: BlocBuilder<NotificationCubit, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationLoading) {
                          return const NotificationShimmer();
                        }

                        if (state is NotificationError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: AppTextStyles.smRegular(
                                context,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        if (state is NotificationLoaded ||
                            state is NotificationLoadingMore ||
                            state is NotificationDeleted ||
                            state is NotificationDeleting) {
                          final response = switch (state) {
                            NotificationLoaded() => state.response,
                            NotificationDeleted() => state.response,
                            NotificationDeleting() => state.response,
                            NotificationLoadingMore() => state.currentResponse,
                            _ => null,
                          };

                          if (response == null) return const SizedBox.shrink();

                          final filteredNotifications = _notificationCubit
                              .getFilteredNotifications(_selectedTab);

                          if (filteredNotifications.isEmpty) {
                            return Center(
                              child: Text(
                                'No notifications',
                                style: AppTextStyles.smRegular(
                                  context,
                                  color: AppColors.gray700,
                                ),
                              ),
                            );
                          }

                          final hasMore =
                              response.notifications.length < response.total;
                          final isLoadingMore =
                              state is NotificationLoadingMore;

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                filteredNotifications.length +
                                (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < filteredNotifications.length) {
                                final notification =
                                    filteredNotifications[index];
                                return _buildNotificationItem(
                                  notification: notification,
                                  isFirst: index == 0,
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Center(
                                    child: isLoadingMore
                                        ? const CircularProgressIndicator()
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _isSelectMode && _selectedNotifications.isNotEmpty
            ? _buildBottomActionBar()
            : null,
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final state = _notificationCubit.state;
    if (state is! NotificationLoaded && state is! NotificationDeleted) {
      return const SizedBox.shrink();
    }

    final response = state is NotificationLoaded
        ? (state as NotificationLoaded).response
        : (state as NotificationDeleted).response;

    final hasUnreadSelected = _selectedNotifications.any((id) {
      final notification = response.notifications.firstWhere(
        (n) => n.id == id,
        orElse: () => response.notifications.first,
      );
      return !notification.isRead;
    });

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 20 + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x3F989EA7),
            blurRadius: 10,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: hasUnreadSelected
                ? () async {
                    final idsToMarkAsRead = _selectedNotifications.toList();
                    for (final id in idsToMarkAsRead) {
                      await _notificationCubit.markAsRead(id);
                    }
                    setState(() {
                      _selectedNotifications.clear();
                      _isSelectMode = false;
                    });
                  }
                : null,
            child: Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                color: hasUnreadSelected ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(60),
              ),
              alignment: Alignment.center,
              child: Text(
                'Mark',
                style: AppTextStyles.smSemiBold(
                  context,
                  color: const Color(0xFFFDFDFD),
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showDeleteDialog(context),
            child: Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFD92C20),
                borderRadius: BorderRadius.circular(60),
              ),
              alignment: Alignment.center,
              child: Text(
                'Delete',
                style: AppTextStyles.smSemiBold(
                  context,
                  color: const Color(0xFFFDFDFD),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: _notificationCubit,
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is NotificationDeleted) {
              setState(() {
                _selectedNotifications.clear();
                _isSelectMode = false;
              });
              Navigator.of(dialogContext).pop();
            }
          },
          builder: (context, state) {
            final isDeleting = state is NotificationDeleting;

            return AlertDialog(
              content: isDeleting
                  ? const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(dialogContext),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.gray800,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.gray800,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const VSpace(16),
                        Text(
                          'Delete Notifications',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.baseSemiBold(context),
                        ),
                        const VSpace(8),
                        Text(
                          'Are you sure you want to delete ${_selectedNotifications.length} notification${_selectedNotifications.length > 1 ? 's' : ''}?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.smRegular(
                            context,
                            color: AppColors.gray700,
                          ),
                        ),
                      ],
                    ),
              actions: isDeleting
                  ? null
                  : [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(dialogContext),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.gray300,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.smSemiBold(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _notificationCubit.deleteSelectedNotifications(
                                  _selectedNotifications.toList(),
                                );
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD92C20),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Delete',
                                  style: AppTextStyles.smSemiBold(
                                    context,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEBF5),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/search-icon.svg',
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.smRegular(
                  context,
                  color: const Color(0xFF535861),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: const Color(0xFFEAEBF5),
              ),
              style: AppTextStyles.smRegular(
                context,
                color: const Color(0xFF181D27),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    final state = _notificationCubit.state;
    final filteredNotifications =
        (state is NotificationLoaded || state is NotificationDeleted)
        ? _notificationCubit.getFilteredNotifications(_selectedTab)
        : <NotificationModel>[];
    return Row(
      children: [
        if (!_isSelectMode) ...[
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = 'All';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedTab == 'All'
                    ? Colors.black
                    : const Color(0xFFEAEBF5),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Text(
                'All',
                style: AppTextStyles.smSemiBold(
                  context,
                  color: _selectedTab == 'All'
                      ? const Color(0xFFFDFDFD)
                      : const Color(0xFF414651),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = 'Unread';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedTab == 'Unread'
                    ? Colors.black
                    : const Color(0xFFEAEBF5),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Text(
                'Unread',
                style: AppTextStyles.smSemiBold(
                  context,
                  color: _selectedTab == 'Unread'
                      ? const Color(0xFFFDFDFD)
                      : const Color(0xFF414651),
                ),
              ),
            ),
          ),
        ] else ...[
          Text(
            '${_selectedNotifications.length} Selected',
            style: AppTextStyles.mdBold(
              context,
              color: const Color(0xFF181D27),
            ),
          ),
        ],
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_isSelectMode) {
                if (_selectedNotifications.length ==
                    filteredNotifications.length) {
                  _selectedNotifications.clear();
                } else {
                  _selectedNotifications = Set.from(
                    filteredNotifications.map((n) => n.id),
                  );
                }
              } else {
                _isSelectMode = true;
                _selectedNotifications.clear();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color:
                  (_isSelectMode &&
                      _selectedNotifications.length ==
                          filteredNotifications.length)
                  ? Colors.black
                  : const Color(0xFFEAEBF5),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              _isSelectMode
                  ? (_selectedNotifications.length ==
                            filteredNotifications.length
                        ? 'All Selected'
                        : 'Select All')
                  : 'Select',
              style: AppTextStyles.smSemiBold(
                context,
                color:
                    (_isSelectMode &&
                        _selectedNotifications.length ==
                            filteredNotifications.length)
                    ? const Color(0xFFFDFDFD)
                    : const Color(0xFF414651),
              ),
            ),
          ),
        ),
        if (_isSelectMode) ...[
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _isSelectMode = false;
                _selectedNotifications.clear();
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEAEBF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationItem({
    required NotificationModel notification,
    required bool isFirst,
  }) {
    final isSelected = _selectedNotifications.contains(notification.id);
    final isUnread = !notification.isRead;

    Color getAvatarColor() {
      switch (notification.type.toLowerCase()) {
        case 'achievement':
          return Colors.blue;
        case 'battle':
          return Colors.purple;
        case 'contest':
          return Colors.orange;
        case 'reward':
          return Colors.green;
        case 'streak':
          return Colors.red;
        case 'lesson':
          return Colors.teal;
        case 'friend':
          return Colors.indigo;
        case 'quiz':
          return Colors.pink;
        case 'leaderboard':
          return Colors.amber;
        case 'badge':
          return Colors.cyan;
        default:
          return Colors.blue;
      }
    }

    String getInitial() {
      return notification.title.isNotEmpty
          ? notification.title[0].toUpperCase()
          : '?';
    }

    return GestureDetector(
      onTap: _isSelectMode
          ? () {
              setState(() {
                if (isSelected) {
                  _selectedNotifications.remove(notification.id);
                } else {
                  _selectedNotifications.add(notification.id);
                }
              });
            }
          : () async {
              if (!notification.isRead) {
                await _notificationCubit.markAsRead(notification.id);
              }
              if (mounted) {
                context.router.push(
                  NotificationDetailRoute(notification: notification),
                );
              }
            },
      child: Container(
        padding: EdgeInsets.only(top: isFirst ? 0 : 18, bottom: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEAEBF5), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSelectMode) ...[
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 4, right: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF205AEB)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFA3A7AE), width: 1),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ] else ...[
              if (isUnread)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 18, right: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF205AEB),
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 14),
            ],
            CircleAvatar(
              radius: 22.5,
              backgroundColor: getAvatarColor(),
              child: Text(
                getInitial(),
                style: AppTextStyles.mdBold(context, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.smSemiBold(
                      context,
                      color: const Color(0xFF252B37),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.smRegular(
                      context,
                      color: const Color(0xFF181D27),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getFormattedTime(notification),
                  style: AppTextStyles.smRegular(
                    context,
                    color: const Color(0xFF414651),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
