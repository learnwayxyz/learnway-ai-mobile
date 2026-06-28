import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwayv2/features/bookmarks/models/bookmark_model.dart';
import 'package:learnwayv2/features/bookmarks/cubit/bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkState(bookmarks: _getDummyBookmarks()));

  void loadBookmarks() {
    // No loading needed since we're using dummy data
    final bookmarks = _getDummyBookmarks();
    emit(state.copyWith(bookmarks: bookmarks));
  }

  void searchBookmarks(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', filteredBookmarks: state.bookmarks));
      return;
    }

    final filtered =
        state.bookmarks.where((bookmark) {
          return bookmark.title.toLowerCase().contains(query.toLowerCase()) ||
              bookmark.author.toLowerCase().contains(query.toLowerCase()) ||
              bookmark.question.toLowerCase().contains(query.toLowerCase()) ||
              bookmark.description.toLowerCase().contains(query.toLowerCase());
        }).toList();

    emit(state.copyWith(searchQuery: query, filteredBookmarks: filtered));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: '', filteredBookmarks: state.bookmarks));
  }

  void removeBookmark(String bookmarkId) {
    final updatedBookmarks =
        state.bookmarks.where((b) => b.id != bookmarkId).toList();
    final updatedFiltered =
        state.filteredBookmarks.where((b) => b.id != bookmarkId).toList();

    emit(
      state.copyWith(
        bookmarks: updatedBookmarks,
        filteredBookmarks: updatedFiltered,
      ),
    );
  }

  static List<BookmarkModel> _getDummyBookmarks() {
    return [
      BookmarkModel(
        id: '1',
        title: 'Introduction to the Internet',
        author: 'Francis Owusu-Mensah',
        question: 'Question',
        description:
            'Studying how CBD awareness and availability as it related to pain management alternatives.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lessonId: 'lesson_1',
        courseId: 'course_1',
      ),
      BookmarkModel(
        id: '2',
        title: 'Introduction to the Internet',
        author: 'Francis Owusu-Mensah',
        question: 'Question',
        description:
            'Studying how CBD awareness and availability as it related to pain management alternatives.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lessonId: 'lesson_2',
        courseId: 'course_1',
      ),
      BookmarkModel(
        id: '3',
        title: 'Introduction to the Internet',
        author: 'Francis Owusu-Mensah',
        question: 'Question',
        description:
            'Studying how CBD awareness and availability as it related to pain management alternatives.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lessonId: 'lesson_3',
        courseId: 'course_1',
      ),
    ];
  }
}
