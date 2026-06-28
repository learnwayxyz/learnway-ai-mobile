import 'package:equatable/equatable.dart';
import 'package:learnwayv2/features/bookmarks/models/bookmark_model.dart';

class BookmarkState extends Equatable {
  final bool isLoading;
  final List<BookmarkModel> bookmarks;
  final List<BookmarkModel> filteredBookmarks;
  final String searchQuery;
  final String? errorMessage;

  const BookmarkState({
    this.isLoading = false,
    this.bookmarks = const [],
    this.filteredBookmarks = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  BookmarkState copyWith({
    bool? isLoading,
    List<BookmarkModel>? bookmarks,
    List<BookmarkModel>? filteredBookmarks,
    String? searchQuery,
    String? errorMessage,
  }) {
    return BookmarkState(
      isLoading: isLoading ?? this.isLoading,
      bookmarks: bookmarks ?? this.bookmarks,
      filteredBookmarks: filteredBookmarks ?? this.filteredBookmarks,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasBookmarks => bookmarks.isNotEmpty;
  bool get hasFilteredBookmarks => filteredBookmarks.isNotEmpty;
  bool get isSearching => searchQuery.isNotEmpty;

  @override
  List<Object?> get props => [
    isLoading,
    bookmarks,
    filteredBookmarks,
    searchQuery,
    errorMessage,
  ];
}
