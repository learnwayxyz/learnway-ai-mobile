import '../models/mentor_dashboard_model.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  final DashboardStatus status;
  final MentorDashboardModel? dashboard;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    MentorDashboardModel? dashboard,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
