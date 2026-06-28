import 'package:equatable/equatable.dart';
import 'package:learnwayv2/app/app.dart';
import 'package:learnwayv2/app/app_barrel.dart';
import 'package:learnwayv2/features/learn_and_earn/bloc/bloc/registered_course_bloc.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/base_course_models.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/base_models/course_wrapper.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/advanced_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/beginner_registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/intermediate_registered_course.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/learnway_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/enrollment_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_lesson.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_progress.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/lesson_slide.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/registered_courses.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/ai_tutor_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/start_lesson_response.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_exception.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/shared/utilities/filters.dart';
import 'package:learnwayv2/shared/widgets/card_component/lesson_cards_factory.dart';

part 'learn_and_earn_event.dart';
part 'learn_and_earn_state.dart';

class LearnAndEarnBloc extends Bloc<LearnAndEarnEvent, LearnAndEarnState> {
  final LearnAndEarnRepository repository;
  List<LearnWayCourses> cachedLessons = [];
  List<LearnWayCourses> cachedBeginnerCourses = [];
  List<LearnWayCourses> cachedIntermediateCourses = [];
  List<LearnWayCourses> cachedAdvancedCourses = [];
  List<RegisteredCourses> cachedRegisteredCourses = [];
  Map<String, CourseLesson> cachedCourseLessons = {};
  LessonSlidesResponse? cachedSlideData;

  final Map<String, List<AiTutorMessage>> _aiConversations = {};
  final Map<String, AiTutorRateLimit?> _aiRateLimits = {};
  final Set<String> _lessonLimitedLessons = {};
  bool _aiDailyLimitReached = false;

  List<AiTutorMessage> getAiConversation(String lessonId) =>
      List.unmodifiable(_aiConversations[lessonId] ?? []);

  AiTutorRateLimit? getAiRateLimit(String lessonId) =>
      _aiRateLimits[lessonId];

  bool isAiLessonLimited(String lessonId) =>
      _lessonLimitedLessons.contains(lessonId);

  bool get isAiDailyLimitReached => _aiDailyLimitReached;

  LearnAndEarnBloc({LearnAndEarnRepository? repository})
    : repository = repository ?? LearnAndEarnRepository(),
      super(LearnAndEarnInitial()) {
    on<EnrollBeginnerCourse>(_onEnrollBeginnerCourse);
    on<EnrollIntermediateCourse>(_onEnrollIntermediateCourse);
    on<EnrollAdvancedCourse>(_onEnrollAdvancedCourse);
    on<FetchCourseLessons>(_onFetchCourseLessons);
    on<FetchLessonSlides>(_onFetchLessonSlide);
    on<ResetLearnAndEarnBloc>(_onResetLearnAndEarnBloc);
    on<StartLesson>(_onStartLesson);
    on<GetLessonProgress>(_ongetLessonProgress);
    on<FetchDailyLessonsRemaining>(_onFetchDailyLessonsRemaining);
    on<AskAiTutorWithQuickPrompt>(_onAskAiTutorWithQuickPrompt);
    on<AskAiTutorWithCustomQuestion>(_onAskAiTutorWithCustomQuestion);
  }

  Future<void> _onEnrollBeginnerCourse(
    EnrollBeginnerCourse event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    emit(EnrollingBeginnerCourse(cachedBeginnerCourses));

    final result = await repository.enrollCourse(event.courseId);

    await result.fold(
      (l) async => emit(
        EnrollBeginnerCourseError(l.message, lessons: cachedBeginnerCourses),
      ),
      (r) async {
        final registeredCoursesResult = await repository.getMyBeginnerCourses();

        await registeredCoursesResult.fold(
          (error) async {
            emit(
              EnrollBeginnerCourseError(
                error.message,
                lessons: cachedBeginnerCourses,
              ),
            );
          },
          (registeredCourses) async {
            emit(
              EnrolledBeginnerCourse(
                r,
                courses: cachedBeginnerCourses,
                myRegisteredCourses: registeredCourses,
              ),
            );

            // Notify RegisteredCoursesBloc about the update
            final registeredCoursesBloc = locator.get<RegisteredCoursesBloc>();
            registeredCoursesBloc.add(
              UpdateBeginnerRegisteredCourses(courses: registeredCourses),
            );

            final filteredCourse = filterCourses<BeginnerRegisteredCourses>(
              registeredCourses,
              (c) => c.completedAt,
              (c) => c.course.isActive,
            );
            final castedTobase = filteredCourse.cast<BaseRegisteredCourses>();
            final justRegisteredCourse = castedTobase.where(
              (c) => c.id == r.id,
            );
            registerCourseData(justRegisteredCourse.first, LevelType.beginner);
            appRouter.push(LessonRoute(levelType: LevelType.beginner));
          },
        );
      },
    );
  }

  Future<void> _onEnrollIntermediateCourse(
    EnrollIntermediateCourse event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    emit(EnrollingBeginnerCourse(cachedIntermediateCourses));

    final result = await repository.enrollCourse(event.courseId);

    await result.fold(
      (l) async => emit(
        EnrollIntermediateCourseError(l.message, cachedIntermediateCourses),
      ),
      (r) async {
        final registeredCoursesResult = await repository
            .getMyIntermediateCourses();

        await registeredCoursesResult.fold(
          (error) async {
            emit(
              EnrollIntermediateCourseError(
                error.message,
                cachedIntermediateCourses,
              ),
            );
          },
          (registeredCourses) async {
            emit(
              EnrolledIntermediateCourse(
                r,
                courses: cachedIntermediateCourses,
                myRegisteredCourses: registeredCourses,
              ),
            );

            // Notify RegisteredCoursesBloc about the update
            final registeredCoursesBloc = locator.get<RegisteredCoursesBloc>();
            registeredCoursesBloc.add(
              UpdateIntermediateRegisteredCourses(courses: registeredCourses),
            );

            final filteredCourse = filterCourses<IntermediateRegisteredCourse>(
              registeredCourses,
              (c) => c.completedAt,
              (c) => c.course.isActive,
            );
            final castedTobase = filteredCourse.cast<BaseRegisteredCourses>();
            final justRegisteredCourse = castedTobase.where(
              (c) => c.id == r.id,
            );
            registerCourseData(
              justRegisteredCourse.first,
              LevelType.intermediate,
            );
            appRouter.push(LessonRoute(levelType: LevelType.intermediate));
          },
        );
      },
    );
  }

  Future<void> _onEnrollAdvancedCourse(
    EnrollAdvancedCourse event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    emit(EnrollingAdvancedCourse(cachedAdvancedCourses));

    final result = await repository.enrollCourse(event.courseId);

    await result.fold(
      (l) async =>
          emit(EnrollAdvancedCourseError(l.message, cachedAdvancedCourses)),
      (r) async {
        final registeredCoursesResult = await repository.getMyAdvancedCourses();

        await registeredCoursesResult.fold(
          (error) async {
            emit(
              EnrollAdvancedCourseError(error.message, cachedAdvancedCourses),
            );
          },
          (registeredCourses) async {
            emit(
              EnrolledAdvancedCourse(
                r,
                courses: cachedAdvancedCourses,
                myRegisteredCourses: registeredCourses,
              ),
            );

            // Notify RegisteredCoursesBloc about the update
            final registeredCoursesBloc = locator.get<RegisteredCoursesBloc>();
            registeredCoursesBloc.add(
              UpdateAdvancedRegisteredCourses(courses: registeredCourses),
            );

            final filteredCourse = filterCourses<AdvancedRegisteredCourses>(
              registeredCourses,
              (c) => c.completedAt,
              (c) => c.course.isActive,
            );
            final castedTobase = filteredCourse.cast<BaseRegisteredCourses>();
            final justRegisteredCourse = castedTobase.where(
              (c) => c.id == r.id,
            );
            registerCourseData(justRegisteredCourse.first, LevelType.advanced);
            appRouter.push(LessonRoute(levelType: LevelType.advanced));
          },
        );
      },
    );
  }

  Future<void> _onFetchCourseLessons(
    FetchCourseLessons event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    final courseId = event.id;
    final hasCachedData = cachedCourseLessons.containsKey(courseId);

    if (!event.forceRefresh && hasCachedData) {
      emit(FetchedCourseLessons(cachedCourseLessons[courseId]!));
      return;
    }

    emit(FetchingCourseLessons(courseLessons: cachedCourseLessons[courseId]));
    final lessons = await repository.getCourseLessons(courseId);
    lessons.fold(
      (l) => emit(
        FetchCourseLessonsError(
          l.message,
          courseLessons: cachedCourseLessons[courseId],
        ),
      ),
      (r) {
        cachedCourseLessons[courseId] = r;
        emit(FetchedCourseLessons(r, showSuccessSnackbar: true));
      },
    );
  }

  Future<void> _onFetchLessonSlide(
    FetchLessonSlides event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    final courseId = event.id;
    emit(FetchingLessonSlide(courseLessons: cachedCourseLessons[courseId]));

    final slides = await repository.getLessonSlides(event.id);
    slides.fold(
      (l) => emit(
        FetchLessonSlideError(
          l.message,
          courseLessons: cachedCourseLessons[courseId],
        ),
      ),
      (r) {
        emit(
          FetchedLessonSlide(r, courseLessons: cachedCourseLessons[courseId]),
        );
      },
    );
  }

  Future<void> _onStartLesson(
    StartLesson event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    emit(StartingLesson());
    final lessonId = event.lessonId;
    final courseId = event.courseId;

    final result = await repository.startLesson(lessonId, courseId);
    result.fold((l) => emit(StartedLessonError(l.message)), (r) {
      emit(StartedLesson(r));
    });
  }

  Future<void> _ongetLessonProgress(
    GetLessonProgress event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    final result = await repository.getLessonProgress(event.courseId);
    result.fold((l) => emit(GotLessonProgressError(l.message)), (r) {
      emit(GotLessonProgress(r));
    });
  }

  Future<void> _onFetchDailyLessonsRemaining(
    FetchDailyLessonsRemaining event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    // Side effect only: updates LocalStorageService.dailyLessonsNotifier.
    // LessonBuilder listener handles the UI rebuild.
    await repository.fetchDailyLessonsRemaining();
  }

  Future<void> _onAskAiTutorWithQuickPrompt(
    AskAiTutorWithQuickPrompt event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    await _performAiTutorRequest(
      emit: emit,
      lessonId: event.lessonId,
      promptType: event.promptType,
      displayLabel: event.displayLabel,
    );
  }

  Future<void> _onAskAiTutorWithCustomQuestion(
    AskAiTutorWithCustomQuestion event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    await _performAiTutorRequest(
      emit: emit,
      lessonId: event.lessonId,
      promptType: AiTutorPromptType.custom,
      customQuestion: event.customQuestion,
    );
  }

  Future<void> _performAiTutorRequest({
    required Emitter<LearnAndEarnState> emit,
    required String lessonId,
    required AiTutorPromptType promptType,
    String? customQuestion,
    String? displayLabel,
  }) async {
    _aiConversations.putIfAbsent(lessonId, () => []).add(
      AiTutorMessage(
        text: customQuestion ?? displayLabel ?? promptType.apiValue,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );

    emit(const AiTutorLoading());
    final result = await repository.askAiTutor(
      lessonId: lessonId,
      promptType: promptType,
      customQuestion: customQuestion,
    );
    result.fold(
      (failure) {
        if (failure is AiTutorLessonLimitFailure) {
          _lessonLimitedLessons.add(lessonId);
          emit(const AiTutorLessonLimitReached());
        } else if (failure is AiTutorDailyLimitFailure) {
          _aiDailyLimitReached = true;
          emit(const AiTutorDailyLimitReached());
        } else {
          _aiConversations[lessonId]!.add(
            AiTutorMessage(
              text: failure.message,
              isUser: false,
              timestamp: DateTime.now(),
              isError: true,
            ),
          );
          emit(AiTutorRequestFailed(failure.message));
        }
      },
      (data) {
        _aiConversations[lessonId]!.add(
          AiTutorMessage(
            text: data.response,
            isUser: false,
            timestamp: DateTime.now(),
            fromCache: data.fromCache,
          ),
        );
        _aiRateLimits[lessonId] = data.rateLimitRemaining;
        emit(AiTutorResponseReceived(data));
      },
    );
  }

  Future<void> _onResetLearnAndEarnBloc(
    ResetLearnAndEarnBloc event,
    Emitter<LearnAndEarnState> emit,
  ) async {
    // Clear all cached data
    cachedLessons.clear();
    cachedBeginnerCourses.clear();
    cachedIntermediateCourses.clear();
    cachedAdvancedCourses.clear();
    cachedRegisteredCourses.clear();
    cachedCourseLessons.clear();
    cachedSlideData = null;
    _aiConversations.clear();
    _aiRateLimits.clear();
    _lessonLimitedLessons.clear();
    _aiDailyLimitReached = false;

    // Emit initial state
    emit(LearnAndEarnInitial());
  }
}
