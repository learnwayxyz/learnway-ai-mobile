part of 'course_project_cubit.dart';

sealed class CourseProjectState extends Equatable {
  const CourseProjectState();

  @override
  List<Object?> get props => [];
}

final class CourseProjectInitial extends CourseProjectState {}

final class CourseProjectLoading extends CourseProjectState {}

final class CourseProjectEmpty extends CourseProjectState {}

class CourseProjectLoaded extends CourseProjectState {
  const CourseProjectLoaded(this.project);

  final CourseProject project;

  @override
  List<Object?> get props => [project];
}

final class CourseProjectError extends CourseProjectState {
  const CourseProjectError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

final class CourseProjectSending extends CourseProjectLoaded {
  const CourseProjectSending(super.project, {required this.isDraft});

  final bool isDraft;

  @override
  List<Object?> get props => [project, isDraft];
}

final class CourseProjectDraftSaved extends CourseProjectLoaded {
  const CourseProjectDraftSaved(super.project);
}

/// A server-side draft was found for this project; the submit form should
/// prefill from it.
final class CourseProjectDraftLoaded extends CourseProjectLoaded {
  const CourseProjectDraftLoaded(super.project, this.draft);

  final ProjectSubmission draft;

  @override
  List<Object?> get props => [project, draft];
}

final class CourseProjectSubmitted extends CourseProjectLoaded {
  const CourseProjectSubmitted(super.project, this.result);

  final CourseProjectSubmissionResult result;

  @override
  List<Object?> get props => [project, result];
}

final class CourseProjectActionError extends CourseProjectLoaded {
  const CourseProjectActionError(super.project, this.error);

  final String error;

  @override
  List<Object?> get props => [project, error];
}
