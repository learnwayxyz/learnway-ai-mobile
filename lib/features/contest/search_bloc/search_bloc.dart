import 'package:bloc/bloc.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc<T> extends Bloc<SearchEvent, SearchState<T>> {
  final Future<List<T>> Function(String query) searchFunction;

  SearchBloc({required this.searchFunction}) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState<T>> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    try {
      final results = await searchFunction(event.query);

      if (results.isEmpty) {
        emit(SearchEmpty(event.query));
      } else {
        emit(SearchSuccess(results, event.query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState<T>> emit) {
    emit(const SearchInitial());
  }
}
