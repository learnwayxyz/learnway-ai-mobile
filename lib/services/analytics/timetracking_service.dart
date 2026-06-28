///
class TimeTrackingService {
  final Map<String, DateTime> _slideStartTime = {};
  final Map<String, Duration> _slideDurations = {};
  DateTime? _lessonStartTime;
  Duration _totalLessonDuration = Duration.zero;
  void startLesson(String lessonId) {
    _lessonStartTime = DateTime.now();
    _totalLessonDuration = Duration.zero;
  }

  void startSlideShow(String slideId) {
    _slideStartTime[slideId] = DateTime.now();
    _slideDurations[slideId] = Duration.zero;
  }

  void endSlideShow(String slideId) {
    final startTime = _slideStartTime[slideId];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _slideDurations[slideId] =
          (_slideDurations[slideId] ?? Duration.zero) + duration;
      _slideStartTime.remove(slideId);
    }
  }

  Duration timeSpentOnSlide(String slideId) {
    return _slideDurations[slideId] ?? Duration.zero;
  }

  Duration totalLessonTime() {
    if (_lessonStartTime != null) {
      return DateTime.now().difference(_lessonStartTime!);
    }
    return _totalLessonDuration;
  }

  Map<String, Duration> getAllSlideTimes() {
    return Map.from(_slideDurations);
  }

  void reset() {
    _slideStartTime.clear();
    _slideDurations.clear();
    _lessonStartTime = null;
    _totalLessonDuration = Duration.zero;
  }
}
