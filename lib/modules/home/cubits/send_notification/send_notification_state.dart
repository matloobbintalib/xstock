

enum NotificationStatus {
  initial,
  loading,
  loadMore,
  success,
  error,
}

class NotificationState {
  final NotificationStatus notificationStatus;
  final String message;

  NotificationState({
    required this.notificationStatus,
    required this.message,
  });

  factory NotificationState.initial() {
    return NotificationState(
      notificationStatus: NotificationStatus.initial,
      message: '',
    );
  }


  NotificationState copyWith({
    NotificationStatus? notificationStatus,
    String? message,
  }) {
    return NotificationState(
      notificationStatus: notificationStatus ?? this.notificationStatus,
      message: message ?? this.message,
    );
  }
}
