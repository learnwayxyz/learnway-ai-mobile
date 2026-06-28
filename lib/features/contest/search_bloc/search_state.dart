part of 'search_bloc.dart';

abstract class SearchState<T> {
  const SearchState();
}

class SearchInitial<T> extends SearchState<T> {
  const SearchInitial();
}

class SearchLoading<T> extends SearchState<T> {
  const SearchLoading();
}

class SearchSuccess<T> extends SearchState<T> {
  final List<T> results;
  final String query;

  const SearchSuccess(this.results, this.query);
}

class SearchError<T> extends SearchState<T> {
  final String message;

  const SearchError(this.message);
}

class SearchEmpty<T> extends SearchState<T> {
  final String query;

  const SearchEmpty(this.query);
}
