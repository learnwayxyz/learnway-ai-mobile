import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

part 'registered_course_event.dart';
part 'registered_course_state.dart';

class RegisteredCoursesBloc
    extends Bloc<RegisteredCoursesEvent, RegisteredCoursesState> {
  final LearnAndEarnRepository repository;
  List<BeginnerRegisteredCourses> cachedBeginnerRegisteredCourses = [];
  List<IntermediateRegisteredCourse> cachedIntermediateRegisteredCourses = [];
  List<AdvancedRegisteredCourses> cachedAdvancedRegisteredCourses = [];
  List<LearnWayCourses> cachedBeginnerCourses = [];
  List<LearnWayCourses> cachedIntermediateCourses = [];
  List<LearnWayCourses> cachedAdvancedCourses = [];

  RegisteredCoursesBloc({LearnAndEarnRepository? repository})
    : repository = repository ?? LearnAndEarnRepository(),
      super(RegisteredCoursesInitial()) {
    on<LoadBeginnerRegisteredCourses>(_onLoadBeginnerRegisteredCourses);
    on<LoadIntermediateRegisteredCourses>(_onLoadIntermediateRegisteredCourses);
    on<LoadAdvancedRegisteredCourses>(_onLoadAdvancedRegisteredCourses);
    on<RefreshRegisteredCourses>(_onRefreshRegisteredCourses);
    on<UpdateBeginnerRegisteredCourses>(_onUpdateBeginnerRegisteredCourses);
    on<UpdateIntermediateRegisteredCourses>(
      _onUpdateIntermediateRegisteredCourses,
    );
    on<UpdateAdvancedRegisteredCourses>(_onUpdateAdvancedRegisteredCourses);
    on<BackgroundRefreshBeginnerRegisteredCourses>(
      _onBackgroundRefreshBeginnerRegisteredCourses,
    );
    on<BackgroundRefreshIntermediateRegisteredCourses>(
      _onBackgroundRefreshIntermediateRegisteredCourses,
    );
    on<BackgroundRefreshAdvancedRegisteredCourses>(
      _onBackgroundRefreshAdvancedRegisteredCourses,
    );
    on<ResetRegisteredCoursesBloc>(_onResetRegisteredCoursesBloc);
  }

  Future<void> _onLoadBeginnerRegisteredCourses(
    LoadBeginnerRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    if (cachedBeginnerRegisteredCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        LoadedBeginnerRegisteredCourses(
          cachedBeginnerRegisteredCourses,
          allCourses: cachedBeginnerCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(LoadingBeginnerRegisteredCourses(cachedBeginnerCourses));
    final registeredCourses = await repository.getMyBeginnerCourses();

    registeredCourses.fold(
      (l) {
        emit(
          LoadedBeginnerRegisteredCoursesError(
            l.message,
            lessons: cachedBeginnerCourses,
          ),
        );
      },
      (r) {
        cachedBeginnerRegisteredCourses = r;
        emit(
          LoadedBeginnerRegisteredCourses(
            r,
            allCourses: cachedBeginnerCourses,
            isBackgroundRefresh: false,
          ),
        );
      },
    );
  }

  Future<void> _onLoadIntermediateRegisteredCourses(
    LoadIntermediateRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    if (cachedIntermediateRegisteredCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        LoadedIntermediateRegisteredCourses(
          cachedIntermediateRegisteredCourses,
          allCourses: cachedIntermediateCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(LoadingIntermediateRegisteredCourses(cachedIntermediateCourses));
    final registeredCourses = await repository.getMyIntermediateCourses();

    registeredCourses.fold(
      (l) {
        emit(
          LoadedIntermediateRegisteredCoursesError(
            l.message,
            lessons: cachedIntermediateCourses,
          ),
        );
      },
      (r) {
        cachedIntermediateRegisteredCourses = r;
        emit(
          LoadedIntermediateRegisteredCourses(
            r,
            allCourses: cachedIntermediateCourses,
            isBackgroundRefresh: false,
          ),
        );
      },
    );
  }

  Future<void> _onLoadAdvancedRegisteredCourses(
    LoadAdvancedRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    if (cachedAdvancedRegisteredCourses.isNotEmpty && !event.forceRefresh) {
      emit(
        LoadedAdvancedRegisteredCourses(
          cachedAdvancedRegisteredCourses,
          allCourses: cachedAdvancedCourses,
          isBackgroundRefresh: false,
        ),
      );
      return;
    }

    emit(LoadingAdvancedRegisteredCourses(cachedAdvancedCourses));
    final registeredCourses = await repository.getMyAdvancedCourses();

    registeredCourses.fold(
      (l) {
        emit(
          LoadedAdvancedRegisteredCoursesError(
            l.message,
            lessons: cachedAdvancedCourses,
          ),
        );
      },
      (r) {
        cachedAdvancedRegisteredCourses = r;
        emit(
          LoadedAdvancedRegisteredCourses(
            r,
            allCourses: cachedAdvancedCourses,
            isBackgroundRefresh: false,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshRegisteredCourses(
    RefreshRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    switch (event.levelType) {
      case LevelType.beginner:
        cachedBeginnerRegisteredCourses.clear();
        add(LoadBeginnerRegisteredCourses(forceRefresh: true));
        break;
      case LevelType.intermediate:
        cachedIntermediateRegisteredCourses.clear();
        add(LoadIntermediateRegisteredCourses(forceRefresh: true));
        break;
      case LevelType.advanced:
        cachedAdvancedRegisteredCourses.clear();
        add(LoadAdvancedRegisteredCourses(forceRefresh: true));
        break;
    }
  }

  void _onUpdateBeginnerRegisteredCourses(
    UpdateBeginnerRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) {
    cachedBeginnerRegisteredCourses = event.courses;
    emit(
      LoadedBeginnerRegisteredCourses(
        event.courses,
        allCourses: cachedBeginnerCourses,
      ),
    );
  }

  void _onUpdateIntermediateRegisteredCourses(
    UpdateIntermediateRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) {
    cachedIntermediateRegisteredCourses = event.courses;
    emit(
      LoadedIntermediateRegisteredCourses(
        event.courses,
        allCourses: cachedIntermediateCourses,
      ),
    );
  }

  void _onUpdateAdvancedRegisteredCourses(
    UpdateAdvancedRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) {
    cachedAdvancedRegisteredCourses = event.courses;
    emit(
      LoadedAdvancedRegisteredCourses(
        event.courses,
        allCourses: cachedAdvancedCourses,
      ),
    );
  }

  Future<void> _onBackgroundRefreshBeginnerRegisteredCourses(
    BackgroundRefreshBeginnerRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final registeredCourses = await repository.getMyBeginnerCourses();
    registeredCourses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedBeginnerRegisteredCourses = r;
        emit(
          LoadedBeginnerRegisteredCourses(
            r,
            allCourses: cachedBeginnerCourses,
            isBackgroundRefresh: true,
          ),
        );
      },
    );
  }

  Future<void> _onBackgroundRefreshIntermediateRegisteredCourses(
    BackgroundRefreshIntermediateRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final registeredCourses = await repository.getMyIntermediateCourses();
    registeredCourses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedIntermediateRegisteredCourses = r;
        emit(
          LoadedIntermediateRegisteredCourses(
            r,
            allCourses: cachedIntermediateCourses,
            isBackgroundRefresh: true,
          ),
        );
      },
    );
  }

  Future<void> _onBackgroundRefreshAdvancedRegisteredCourses(
    BackgroundRefreshAdvancedRegisteredCourses event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    // Don't emit loading state, just fetch and update
    final registeredCourses = await repository.getMyAdvancedCourses();
    registeredCourses.fold(
      (l) => {}, // Don't emit error state during background refresh
      (r) {
        cachedAdvancedRegisteredCourses = r;
        emit(
          LoadedAdvancedRegisteredCourses(
            r,
            allCourses: cachedAdvancedCourses,
            isBackgroundRefresh: true,
          ),
        );
      },
    );
  }

  Future<void> _onResetRegisteredCoursesBloc(
    ResetRegisteredCoursesBloc event,
    Emitter<RegisteredCoursesState> emit,
  ) async {
    // Clear all cached data
    cachedBeginnerRegisteredCourses.clear();
    cachedIntermediateRegisteredCourses.clear();
    cachedAdvancedRegisteredCourses.clear();
    cachedBeginnerCourses.clear();
    cachedIntermediateCourses.clear();
    cachedAdvancedCourses.clear();

    // Emit initial state
    emit(RegisteredCoursesInitial());
  }
}
