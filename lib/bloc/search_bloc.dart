import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_event.dart';
import 'package:gif_app/bloc/search_state.dart';
import 'package:gif_app/data/gif_page.dart';
import 'package:gif_app/data/gif_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GifRepository _repository;

  SearchBloc(this._repository) : super(SearchStateInitial()) {
    // restartable() means the Bloc processes only the last event - the last query typed
    // solves the query race bug
    on<SearchQueryChanged>(_onQueryChanged, transformer: restartable());
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    // 1. emit initial - empty query → back to initial, return
    // 2. emit loading
    // 3. try: call repository, emit loaded or empty
    // 4. catch: emit error

    // --------------------- 1 ---------------------
    // empty query - start-up and search box erased
    // ---------------------------------------------

    if (event.query.isEmpty) {
      emit(SearchStateInitial());
      return;
    }

    // --------------------- 2 ---------------------
    // emit loading state
    // ---------------------------------------------
    emit(SearchStateLoading());

    // ------------------ 3 and 4 ------------------
    // what state came back from the Giphy Call
    // ---------------------------------------------

    try {
      final GifPage gifPage = await _repository.getGifs(event.query);

      if (gifPage.gifs.isEmpty) {
        emit(SearchStateEmpty(query: event.query));
      } else {
        emit(
          SearchStateLoaded(
            gifs: gifPage.gifs,
            query: event.query,
            totalCount: gifPage.totalCount,
          ),
        );
      }
    } catch (e) {
      emit(SearchStateError(error: e.toString()));
    }
  }
}
