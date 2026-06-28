import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/notifications/model/notification_model.dart';
import 'package:learnwayv2/features/notifications/repository/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(NotificationInitial());

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh || state is! NotificationLoaded) {
      emit(NotificationLoading());
    }

    final result = await _repository.getUserNotifications(limit: 50, offset: 0);

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (response) => emit(NotificationLoaded(response)),
    );
  }

  Future<void> loadMoreNotifications() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final currentCount = currentState.response.notifications.length;
    if (currentCount >= currentState.response.total) return;

    emit(NotificationLoadingMore(currentState.response));

    final result = await _repository.getUserNotifications(
      limit: 50,
      offset: currentCount,
    );

    result.fold((failure) => emit(NotificationLoaded(currentState.response)), (
      response,
    ) {
      final allNotifications = [
        ...currentState.response.notifications,
        ...response.notifications,
      ];

      emit(
        NotificationLoaded(
          NotificationResponse(
            notifications: allNotifications,
            total: response.total,
            limit: response.limit,
            offset: response.offset,
          ),
        ),
      );
    });
  }

  Future<void> markAsRead(String notificationId) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await _repository.markAsRead(notificationId);

    result.fold((failure) => emit(NotificationError(failure.message)), (_) {
      final updatedNotifications = currentState.response.notifications
          .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
          .toList();

      emit(
        NotificationLoaded(
          NotificationResponse(
            notifications: updatedNotifications,
            total: currentState.response.total,
            limit: currentState.response.limit,
            offset: currentState.response.offset,
          ),
        ),
      );
    });
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await _repository.markAllAsRead();

    result.fold((failure) => emit(NotificationError(failure.message)), (_) {
      final updatedNotifications = currentState.response.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      emit(
        NotificationLoaded(
          NotificationResponse(
            notifications: updatedNotifications,
            total: currentState.response.total,
            limit: currentState.response.limit,
            offset: currentState.response.offset,
          ),
        ),
      );
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;
    final result = await _repository.deleteNotification(notificationId);

    result.fold((failure) => emit(NotificationError(failure.message)), (_) {
      final updatedNotifications = currentState.response.notifications
          .where((n) => n.id != notificationId)
          .toList();

      emit(
        NotificationLoaded(
          NotificationResponse(
            notifications: updatedNotifications,
            total: currentState.response.total - 1,
            limit: currentState.response.limit,
            offset: currentState.response.offset,
          ),
        ),
      );
    });
  }

  Future<void> deleteSelectedNotifications(List<String> notificationIds) async {
    final currentState = state;
    final response = switch (currentState) {
      NotificationLoaded() => currentState.response,
      NotificationDeleted() => currentState.response,
      _ => null,
    };

    if (response == null) return;

    emit(NotificationDeleting(response, notificationIds));

    for (final id in notificationIds) {
      await _repository.deleteNotification(id);
    }

    final updatedNotifications = response.notifications
        .where((n) => !notificationIds.contains(n.id))
        .toList();

    emit(
      NotificationDeleted(
        NotificationResponse(
          notifications: updatedNotifications,
          total: response.total - notificationIds.length,
          limit: response.limit,
          offset: response.offset,
        ),
      ),
    );
  }

  List<NotificationModel> getFilteredNotifications(String filter) {
    final currentState = state;

    final response = switch (currentState) {
      NotificationLoaded() => currentState.response,
      NotificationDeleted() => currentState.response,
      NotificationDeleting() => currentState.response,
      _ => null,
    };

    if (response == null) return [];

    if (filter == 'Unread') {
      return response.notifications.where((n) => !n.isRead).toList();
    }

    return response.notifications;
  }

  NotificationModel? findNotificationById(String notificationId) {
    final currentState = state;
    if (currentState is! NotificationLoaded) return null;

    try {
      return currentState.response.notifications.firstWhere(
        (n) => n.id == notificationId,
      );
    } catch (_) {
      return null;
    }
  }
}
