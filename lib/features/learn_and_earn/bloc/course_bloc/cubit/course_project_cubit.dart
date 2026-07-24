import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_data_source/models/course_project_submission.dart';
import 'package:learnwayv2/features/learn_and_earn/learn_and_earn_repository/learn_and_earn_repository.dart';
import 'package:learnwayv2/services/local_storage_service/local_storage_service.dart';

part 'course_project_state.dart';

class CourseProjectCubit extends Cubit<CourseProjectState> {
  CourseProjectCubit({required this.repository})
    : super(CourseProjectInitial());

  final LearnAndEarnRepository repository;

  /// Latest submission result per course, kept outside the state so views
  /// (e.g. the submit form) can tell whether a project is already passed even
  /// while the state is transient (draft saved, action error, ...).
  final Map<String, CourseProjectSubmissionResult> _latestResults = {};

  CourseProjectSubmissionResult? latestResultFor(String courseId) =>
      _latestResults[courseId];

  bool hasPassedProject(String courseId) =>
      _latestResults[courseId]?.assessment?.passed ?? false;

  Future<void> fetchCourseProject(String courseId) async {
    emit(CourseProjectLoading());
    try {
      final result = await repository.fetchCourseProject(courseId);
      await result.fold(
        (failure) async => emit(CourseProjectError(failure.message)),
        (project) async {
          if (project == null || !project.isActive) {
            emit(CourseProjectEmpty());
          } else {
            emit(CourseProjectLoaded(project));
            // The score/assessment lives only in the in-memory submitted
            // state, so restore it from the backend if this course already
            // has a submission on record.
            await _restoreSubmission(courseId, project);
          }
        },
      );
    } catch (e) {
      emit(CourseProjectError(e.toString()));
    }
  }

  Future<void> _restoreSubmission(String courseId, CourseProject project) async {
    final listResult = await repository.fetchCourseProjectSubmissions(courseId);

    await listResult.fold(
      // Leave the loaded state in place; nothing to restore on failure.
      (_) async {},
      (submissions) async {
        if (submissions.isEmpty) return;

        final latest = _latestSubmission(submissions);

        // The list may already carry the scored assessment. If it doesn't,
        // fetch the full submission for its assessment details.
        if (latest.assessment != null) {
          _latestResults[courseId] = latest;
          emit(CourseProjectSubmitted(project, latest));
          return;
        }

        final detail = await repository.fetchCourseProjectSubmission(
          courseId,
          latest.submission.id,
        );
        detail.fold(
          (_) {
            _latestResults[courseId] = latest;
            emit(CourseProjectSubmitted(project, latest));
          },
          (full) {
            _latestResults[courseId] = full ?? latest;
            emit(CourseProjectSubmitted(project, full ?? latest));
          },
        );
      },
    );
  }

  /// Most recent submission by submitted/created time, so a re-submission
  /// always supersedes older attempts.
  CourseProjectSubmissionResult _latestSubmission(
    List<CourseProjectSubmissionResult> submissions,
  ) {
    DateTime keyOf(CourseProjectSubmissionResult r) =>
        r.submission.submittedAt ?? r.submission.createdAt;
    return submissions.reduce(
      (a, b) => keyOf(b).isAfter(keyOf(a)) ? b : a,
    );
  }

  Future<void> saveDraft(
    String courseId, {
    required String submissionType,
    required String content,
    File? file,
  }) async {
    final current = state;
    if (current is! CourseProjectLoaded) return;
    final project = current.project;

    emit(CourseProjectSending(project, isDraft: true));

    // Persist locally so the draft survives even if the request fails.
    await LocalStorageService.saveProjectDraft(
      courseId,
      submissionType: submissionType,
      content: content,
    );

    final result = await repository.sendCourseProject(
      courseId,
      submissionType: submissionType,
      content: content,
      isDraft: true,
      file: file,
    );
    result.fold(
      (failure) => emit(CourseProjectActionError(project, failure.message)),
      (_) => emit(CourseProjectDraftSaved(project)),
    );
  }

  Future<void> submitProject(
    String courseId, {
    required String submissionType,
    required String content,
    File? file,
  }) async {
    final current = state;
    if (current is! CourseProjectLoaded) return;
    final project = current.project;

    emit(CourseProjectSending(project, isDraft: false));

    final result = await repository.sendCourseProject(
      courseId,
      submissionType: submissionType,
      content: content,
      isDraft: false,
      file: file,
    );
    await result.fold(
      (failure) async =>
          emit(CourseProjectActionError(project, failure.message)),
      (submissionResult) async {
        await LocalStorageService.clearProjectDraft(courseId);
        _latestResults[courseId] = submissionResult;
        emit(CourseProjectSubmitted(project, submissionResult));
      },
    );
  }
}
