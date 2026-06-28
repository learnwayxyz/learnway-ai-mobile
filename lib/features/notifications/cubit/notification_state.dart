part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final NotificationResponse response;

  const NotificationLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class NotificationLoadingMore extends NotificationState {
  final NotificationResponse currentResponse;

  const NotificationLoadingMore(this.currentResponse);

  @override
  List<Object?> get props => [currentResponse];
}

class NotificationDeleting extends NotificationState {
  final NotificationResponse response;
  final List<String> deletingIds;

  const NotificationDeleting(this.response, this.deletingIds);

  @override
  List<Object?> get props => [response, deletingIds];
}

class NotificationDeleted extends NotificationState {
  final NotificationResponse response;

  const NotificationDeleted(this.response);

  @override
  List<Object?> get props => [response];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
