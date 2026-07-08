import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/features/play/repository/roadmap_repository.dart';

enum RoadmapStatus { initial, loading, success, failure }

class RoadmapState {
  const RoadmapState({
    this.status = RoadmapStatus.initial,
    this.roadmap,
    this.errorMessage,
  });

  final RoadmapStatus status;
  final RoadmapModel? roadmap;
  final String? errorMessage;

  RoadmapState copyWith({
    RoadmapStatus? status,
    RoadmapModel? roadmap,
    String? errorMessage,
  }) {
    return RoadmapState(
      status: status ?? this.status,
      roadmap: roadmap ?? this.roadmap,
      errorMessage: errorMessage,
    );
  }
}

class RoadmapCubit extends Cubit<RoadmapState> {
  RoadmapCubit(this._repository) : super(const RoadmapState());

  final RoadmapRepository _repository;

  Future<void> fetchMyRoadmap() async {
    emit(state.copyWith(status: RoadmapStatus.loading));

    final result = await _repository.fetchMyRoadmap();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RoadmapStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (roadmap) => emit(
        state.copyWith(status: RoadmapStatus.success, roadmap: roadmap),
      ),
    );
  }
}
