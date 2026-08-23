import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_event.dart';
import 'package:gif_app/bloc/search_state.dart';
import 'package:gif_app/data/gif_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GifRepository _repository;
  static const _pageLimit = 25;

  SearchBloc(this._repository) : super(SearchStateInitial()) {
    // restartable() means the Bloc processes only the last event - the last query typed
    // solves the query race bug
    on<SearchQueryChanged>(_onQueryChanged, transformer: restartable());

    // droppable() ignores new events while there is one already being processed
    on<NextPageRequested>(_onNextPageRequested, transformer: droppable());
  }

  // Event Handlers
  
  // Event _onQueryChaned()
  // ---------------------------------------------
  // When query changes - this will try to create the first page
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
      // Offset 0, because this is the first page
      final page = await _repository.getGifs(event.query);

      if (page.gifs.isEmpty) {
        emit(SearchStateEmpty(query: event.query));
      } else {
        emit(
          SearchStateLoaded(
            gifs: page.gifs,
            query: event.query,
            totalCount: page.totalCount,
            offset: page.gifs.length,
            hasReachedEnd: page.count < _pageLimit
          ),
        );
      }
    } catch (e) {
      emit(SearchStateError(error: e.toString()));
    }
  }

  // Event _onNextPageRequested()
  // ---------------------------------------------
  // This will be at least 2nd page
  // so whenever a user scrolls to get more pages
  Future<void> _onNextPageRequested (
    NextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    // 1. Use only in SearchStateLoaded State
    // 2. If there is nothing more to load, also return
    // 3. Emit the isLoadingMore flag
    // 4. Get next page and add it to grid


    // Important!  state is a getter, copy to local first, then can access its fields
    final currentState = state;
    // --------------------- 1 ---------------------
    // Use only in SearchStateLoaded State
    // This makes the currentState = Loaded after the return (Dart promotion)
    // --------------------------------------------- 
    if(currentState is! SearchStateLoaded) return;

    // --------------------- 2 ---------------------
    // End of results or already isLoadingMore, then return
    // --------------------------------------------- 
    if(currentState.hasReachedEnd || currentState.isLoadingMore) return;

    // --------------------- 3 ---------------------
    // Emit the new State - 
    // change states isLoadMore to true, 
    // while keeping current values passed to the state
    // ---------------------------------------------
     
    emit(SearchStateLoaded(
      gifs: currentState.gifs, 
      query: currentState.query, 
      totalCount: currentState.totalCount, 
      offset: currentState.offset,
      hasReachedEnd: currentState.hasReachedEnd,
      isLoadingMore: true
    ));

    // --------------------- 4 ---------------------
    // Fetch next page and append to the grid
    // ---------------------------------------------

    try {
      // Get next page of GIFs
      final page = await _repository.getGifs(
        currentState.query,
        limit: _pageLimit,
        offset: currentState.offset
      );

      // Add the new page
      final newGifList = currentState.gifs + page.gifs;
      final newOffset = currentState.gifs.length + page.count;
      final hasReachedEnd = page.count < _pageLimit;

      // Update the state, so another page gets built
      emit(SearchStateLoaded(
        gifs: newGifList,
        query: currentState.query,
        totalCount: currentState.totalCount,
        offset: newOffset,
        hasReachedEnd: hasReachedEnd,
        isLoadingMore: false
      ));

    } catch (e) {
      // Catched an error - the end ->
      // show last valid Grid (without the new page added)
      emit(SearchStateLoaded(
        gifs: currentState.gifs,
        query: currentState.query,
        totalCount: currentState.totalCount,
        offset: currentState.offset,
        hasReachedEnd: currentState.hasReachedEnd,
        isLoadingMore: false
      ));
    }
      
  }
}
