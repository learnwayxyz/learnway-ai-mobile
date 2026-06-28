class NotificationException implements Exception {
  final String message;

  NotificationException(this.message);

  @override
  String toString() => message;
}

class NotificationFailure extends NotificationException {
  NotificationFailure(super.message);
}
