import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/play/models/career_path_model.dart';
import 'package:learnwayv2/features/play/models/roadmap_model.dart';
import 'package:learnwayv2/features/play/repository/roadmap_repository.dart';

enum RoadmapStatus { initial, loading, success, failure }

class RoadmapState {
  const RoadmapState({
    this.status = RoadmapStatus.initial,
    this.roadmap,
    this.errorMessage,
    this.careerPathsStatus = RoadmapStatus.initial,
    this.careerPaths = const [],
    this.careerPathsError,
  });

  final RoadmapStatus status;
  final RoadmapModel? roadmap;
  final String? errorMessage;
  final RoadmapStatus careerPathsStatus;
  final List<CareerPathModel> careerPaths;
  final String? careerPathsError;

  RoadmapState copyWith({
    RoadmapStatus? status,
    RoadmapModel? roadmap,
    String? errorMessage,
    RoadmapStatus? careerPathsStatus,
    List<CareerPathModel>? careerPaths,
    String? careerPathsError,
  }) {
    return RoadmapState(
      status: status ?? this.status,
      roadmap: roadmap ?? this.roadmap,
      errorMessage: errorMessage,
      careerPathsStatus: careerPathsStatus ?? this.careerPathsStatus,
      careerPaths: careerPaths ?? this.careerPaths,
      careerPathsError: careerPathsError,
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

  Future<void> fetchCareerPaths(String userId) async {
    emit(state.copyWith(careerPathsStatus: RoadmapStatus.loading));

    final result = await _repository.fetchCareerPaths(userId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          careerPathsStatus: RoadmapStatus.failure,
          careerPathsError: failure.message,
        ),
      ),
      (paths) => emit(
        state.copyWith(
          careerPathsStatus: RoadmapStatus.success,
          careerPaths: paths,
        ),
      ),
    );
  }
}
