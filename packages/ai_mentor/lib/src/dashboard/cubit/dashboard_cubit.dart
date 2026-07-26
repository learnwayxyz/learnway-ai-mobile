import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required DashboardRepository repository,
    required String Function() getUserId,
  })  : _repository = repository,
        _getUserId = getUserId,
        super(const DashboardState());

  final DashboardRepository _repository;
  final String Function() _getUserId;

  Future<void> fetchDashboard() async {
    final userId = _getUserId();
    if (userId.isEmpty) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: 'No user id available',
        ),
      );
      return;
    }

    emit(state.copyWith(status: DashboardStatus.loading));
    final result = await _repository.getDashboard(userId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(status: DashboardStatus.success, dashboard: dashboard),
      ),
    );
  }
}
