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

/// The project is loaded and a draft/submit request is in flight.
final class CourseProjectSending extends CourseProjectLoaded {
  const CourseProjectSending(super.project, {required this.isDraft});

  final bool isDraft;

  @override
  List<Object?> get props => [project, isDraft];
}

final class CourseProjectDraftSaved extends CourseProjectLoaded {
  const CourseProjectDraftSaved(super.project);
}

final class CourseProjectSubmitted extends CourseProjectLoaded {
  const CourseProjectSubmitted(super.project);
}

final class CourseProjectActionError extends CourseProjectLoaded {
  const CourseProjectActionError(super.project, this.error);

  final String error;

  @override
  List<Object?> get props => [project, error];
}
