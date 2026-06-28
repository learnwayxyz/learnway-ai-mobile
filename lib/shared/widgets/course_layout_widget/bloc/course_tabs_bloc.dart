import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_tabs_event.dart';
part 'course_tabs_state.dart';

class CourseTabsBloc extends Bloc<CourseTabsEvent, CourseTabsState> {
  CourseTabsBloc() : super(const CourseTabsState()) {
    on<ChangeTabEvent>(_onChangeTab);
    on<ChangeLayoutEvent>(_onChangeLayout);
    on<NavigateToCurrentTabEvent>(_onNavigateToCurrentTab);
    on<NavigateToCompletedTabEvent>(_onNavigateToCompletedTab);
  }

  void _onChangeTab(ChangeTabEvent event, Emitter<CourseTabsState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onChangeLayout(ChangeLayoutEvent event, Emitter<CourseTabsState> emit) {
    emit(state.copyWith(layoutType: event.layout));
  }

  void _onNavigateToCurrentTab(
    NavigateToCurrentTabEvent event,
    Emitter<CourseTabsState> emit,
  ) {
    emit(state.copyWith(selectedTab: CourseStatus.current));
  }

  void _onNavigateToCompletedTab(
    NavigateToCompletedTabEvent event,
    Emitter<CourseTabsState> emit,
  ) {
    emit(state.copyWith(selectedTab: CourseStatus.completed));
  }

  void navigateToCurrentTab() {
    add(const NavigateToCurrentTabEvent());
  }

  void navigateToCompletedTab() {
    add(const NavigateToCompletedTabEvent());
  }

  void changeTab(CourseStatus tab) {
    add(ChangeTabEvent(tab));
  }

  void changeLayout(LayoutType layout) {
    add(ChangeLayoutEvent(layout));
  }
}
