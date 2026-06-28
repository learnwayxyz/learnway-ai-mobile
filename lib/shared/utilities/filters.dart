List<T> filterCourses<T extends Object>(
  List<T> courses,
  DateTime? Function(T) completedAtGetter,
  bool Function(T) isActiveGetter,
) {
  return courses.where((course) {
    final completedAt = completedAtGetter(course);
    final isActive = isActiveGetter(course);
    // Return courses that are enrolled, active, but not completed
    return completedAt == null && isActive;
  }).toList();
}

List<T> filterCompletedCourses<T>(
  List<T> courses,
  DateTime? Function(T) getCompletedAt,
  bool Function(T) isActive,
) {
  return courses.where((course) {
    final completedAt = getCompletedAt(course);
    return completedAt != null && isActive(course);
  }).toList();
}
