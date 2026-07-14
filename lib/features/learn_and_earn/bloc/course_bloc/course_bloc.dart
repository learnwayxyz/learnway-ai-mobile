import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/core/di/locator.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/learn_and_earn_data_source.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

part 'course_event.dart';
part 'course_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final LearnAndEarnRepository repository;

  // Independent caches for course lists
  List<LearnWayCourses> cachedBeginnerCourses = [];
  List<LearnWayCourses> cachedIntermediateCourses = [];
  List<LearnWayCourses> cachedAdvancedCourses = [];

  // Timestamps for last fetch to prevent unnecessary background refreshes
  DateTime? lastBeginnerFetch;
  DateTime? lastIntermediateFetch;
  DateTime? lastAdvancedFetch;

  CoursesBloc({LearnAndEarnRepository? repository})
    : repository =
          repository ??
          LearnAndEarnRepository(locator<LearnAndEarnDataSource>()),
      super(CoursesInitial()) {
    on<FetchBeginnerCourses>(_onFetchBeginnerCourses);
    on<FetchIntermediateCourses>(_onFetchIntermediateCourses);
    on<FetchAdvancedCourses>(_onFetchAdvancedCourses);
    on<RefreshCourses>(_onRefreshCourses);
    on<BackgroundRefreshBeginnerCourses>(_onBackgroundRefreshBeginnerCourses);
    on<BackgroundRefreshIntermediateCourses>(
      _onBackgroundRefreshIntermediateCourses,
    );
    on<BackgroundRefreshAdvancedCourses>(_onBackgroundRefreshAdvancedCourses);
    on<ResetCoursesBloc>(_onResetCoursesBloc);
  }

  Future<void> _onFetchBeginnerCourses(
    FetchBeginnerCourses event,
    Emitter<CoursesState> emit,
  ) async {
    if (cachedBeginnerCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        FetchedBeginnerCourses(
          cachedBeginnerCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(FetchingBeginnerCourses());
    final courses = await repository.getBeginnerCourse();

    courses.fold((l) => emit(FetchBeginnerCoursesError(l.message)), (r) {
      cachedBeginnerCourses = r;
      lastBeginnerFetch = DateTime.now();
      emit(FetchedBeginnerCourses(r, isBackgroundRefresh: false));
    });
  }

  Future<void> _onFetchIntermediateCourses(
    FetchIntermediateCourses event,
    Emitter<CoursesState> emit,
  ) async {
    if (cachedIntermediateCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        FetchedIntermediateCourses(
          cachedIntermediateCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(FetchingIntermediateCourses());
    final courses = await repository.getIntermediateCourse();

    courses.fold((l) => emit(FetchIntermediateCoursesError(l.message)), (r) {
      cachedIntermediateCourses = r;
      lastIntermediateFetch = DateTime.now();
      emit(FetchedIntermediateCourses(r, isBackgroundRefresh: false));
    });
  }

  Future<void> _onFetchAdvancedCourses(
    FetchAdvancedCourses event,
    Emitter<CoursesState> emit,
  ) async {
    if (cachedAdvancedCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        FetchedAdvancedCourses(
          cachedAdvancedCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(FetchingAdvancedCourses());
    final courses = await repository.getAdvancedCourse();

    courses.fold((l) => emit(FetchAdvancedCoursesError(l.message)), (r) {
      cachedAdvancedCourses = r;
      lastAdvancedFetch = DateTime.now();
      emit(FetchedAdvancedCourses(r, isBackgroundRefresh: false));
    });
  }

  Future<void> _onRefreshCourses(
    RefreshCourses event,
    Emitter<CoursesState> emit,
  ) async {
    switch (event.levelType) {
      case LevelType.beginner:
        cachedBeginnerCourses.clear();
        add(FetchBeginnerCourses(forceRefresh: true));
        break;
      case LevelType.intermediate:
        cachedIntermediateCourses.clear();
        add(FetchIntermediateCourses(forceRefresh: true));
        break;
      case LevelType.advanced:
        cachedAdvancedCourses.clear();
        add(FetchAdvancedCourses(forceRefresh: true));
        break;
    }
  }

  Future<void> _onBackgroundRefreshBeginnerCourses(
    BackgroundRefreshBeginnerCourses event,
    Emitter<CoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final courses = await repository.getBeginnerCourse();
    courses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedBeginnerCourses = r;
        lastBeginnerFetch = DateTime.now();
        emit(FetchedBeginnerCourses(r, isBackgroundRefresh: true));
      },
    );
  }

  Future<void> _onBackgroundRefreshIntermediateCourses(
    BackgroundRefreshIntermediateCourses event,
    Emitter<CoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final courses = await repository.getIntermediateCourse();
    courses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedIntermediateCourses = r;
        lastIntermediateFetch = DateTime.now();
        emit(FetchedIntermediateCourses(r, isBackgroundRefresh: true));
      },
    );
  }

  Future<void> _onBackgroundRefreshAdvancedCourses(
    BackgroundRefreshAdvancedCourses event,
    Emitter<CoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final courses = await repository.getAdvancedCourse();
    courses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedAdvancedCourses = r;
        lastAdvancedFetch = DateTime.now();
        emit(FetchedAdvancedCourses(r, isBackgroundRefresh: true));
      },
    );
  }

  Future<void> _onResetCoursesBloc(
    ResetCoursesBloc event,
    Emitter<CoursesState> emit,
  ) async {
    // Clear all cached data
    cachedBeginnerCourses.clear();
    cachedIntermediateCourses.clear();
    cachedAdvancedCourses.clear();

    // Reset timestamps
    lastBeginnerFetch = null;
    lastIntermediateFetch = null;
    lastAdvancedFetch = null;

    // Emit initial state
    emit(CoursesInitial());
  }
}
