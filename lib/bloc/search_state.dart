import 'package:equatable/equatable.dart';
import 'package:gif_app/data/models/gif.dart';

// 5 states in total for Search
//  SearchStateInitial
//  SearchStateLoading
//  SearchStateLoaded
//  SearchStateEmpty
//  SearchStateError

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// current start-up + searchbox cleared
final class SearchStateInitial extends SearchState {}

// loading results
final class SearchStateLoading extends SearchState {}

// gifs + query + totalCount
final class SearchStateLoaded extends SearchState {
  const SearchStateLoaded({
    required this.gifs,
    required this.query,
    required this.totalCount,
    required this.offset,
    this.isLoadingMore = false,
    this.hasReachedEnd = false
  });

  final List<Gif> gifs;
  final String query;
  final int totalCount;
  final int offset;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  @override
  List<Object> get props => [gifs, query, totalCount, offset, isLoadingMore, hasReachedEnd];
}

// empty response
final class SearchStateEmpty extends SearchState {
  const SearchStateEmpty({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

// caught exception
final class SearchStateError extends SearchState {
  const SearchStateError({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
