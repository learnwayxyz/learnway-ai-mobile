part of 'course_tabs_bloc.dart';

enum CourseStatus { all, current, completed }

enum LayoutType { grid, list }

abstract class CourseTabsEvent extends Equatable {
  const CourseTabsEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTabEvent extends CourseTabsEvent {
  final CourseStatus tab;

  const ChangeTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ChangeLayoutEvent extends CourseTabsEvent {
  final LayoutType layout;

  const ChangeLayoutEvent(this.layout);

  @override
  List<Object?> get props => [layout];
}

class NavigateToCurrentTabEvent extends CourseTabsEvent {
  const NavigateToCurrentTabEvent();
}

class NavigateToCompletedTabEvent extends CourseTabsEvent {
  const NavigateToCompletedTabEvent();
}
