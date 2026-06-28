part of 'course_tabs_bloc.dart';

class CourseTabsState extends Equatable {
  final CourseStatus selectedTab;
  final LayoutType layoutType;

  const CourseTabsState({
    this.selectedTab = CourseStatus.all,
    this.layoutType = LayoutType.grid,
  });

  CourseTabsState copyWith({
    CourseStatus? selectedTab,
    LayoutType? layoutType,
  }) {
    return CourseTabsState(
      selectedTab: selectedTab ?? this.selectedTab,
      layoutType: layoutType ?? this.layoutType,
    );
  }

  @override
  List<Object?> get props => [selectedTab, layoutType];
}
