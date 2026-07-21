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

  Future<void> fetchCourseProject(String courseId) async {
    emit(CourseProjectLoading());
    try {
      final result = await repository.fetchCourseProject(courseId);
      result.fold((failure) => emit(CourseProjectError(failure.message)), (
        project,
      ) {
        if (project == null || !project.isActive) {
          emit(CourseProjectEmpty());
        } else {
          emit(CourseProjectLoaded(project));
        }
      });
    } catch (e) {
      emit(CourseProjectError(e.toString()));
    }
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
        emit(CourseProjectSubmitted(project, submissionResult));
      },
    );
  }
}
