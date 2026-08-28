import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_bloc.dart';
import 'package:gif_app/bloc/search_event.dart';
import 'package:gif_app/bloc/search_state.dart';
import 'package:gif_app/data/models/gif.dart';
import 'package:go_router/go_router.dart';

class GifGridView extends StatefulWidget {
  const GifGridView({super.key});

  @override
  State<GifGridView> createState() => _GifGridViewState();
}


class _GifGridViewState extends State<GifGridView> {
  
  final _scrollController = ScrollController();

  @override
  void initState() {
    //parent's setup first
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  // Triggers when the State is destroyed - closing the app, hot restart
  @override
  void dispose() {
    // Cleanup here
    _scrollController.dispose();

    // Parents Dispose last!
    super.dispose();
  }

  void _onScroll(){
    final position = _scrollController.position;
    final diff = position.maxScrollExtent - position.pixels;

    if(diff  < 200) context.read<SearchBloc>().add(NextPageRequested());
  }

  void _onImageTap(Gif gif){
    context.push('/gif', extra: gif);
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildBlocStates();
  }

  Widget _buildBlocStates() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return switch (state) {
          SearchStateInitial() => _showSearchStateInitial(),
          SearchStateLoading() => _showSearchStateLoading(),
          SearchStateEmpty() => _showSearchStateEmpty(state),
          SearchStateError() => _showSearchStateError(state),
          SearchStateLoaded() => _showSearchStateLoaded(state),
        };
      },
    );
  }

  Widget _showSearchStateInitial() {
    return Center(child: const Text('Use Search box to find GIFs!'));
  }

  Widget _showSearchStateLoading() {
    return Center(child: const CircularProgressIndicator.adaptive());
  }

  Widget _showSearchStateEmpty(SearchStateEmpty state) {
    return Center(child: Text('No results for ${state.query}\nTry another keyword!'));
  }

  Widget _showSearchStateError(SearchStateError state) {
    return Center(child: Text('Error: ${state.error}'));
  }

  Widget _showSearchStateLoaded(SearchStateLoaded state) {
    return Column(
      children: [
        // Results Label on top
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            state.query.isEmpty
              ? 'Showing ${state.gifs.length} trending GIFs'
              : 'Showing ${state.gifs.length} out of ${state.totalCount} results for ${state.query}'
          ),
        ),

        // 3. otherwise, show data - the grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              controller: _scrollController,
              itemCount: state.gifs.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final gif = state.gifs[index];
                return InkWell(
                  onTap: () => _onImageTap(gif),
                  child: Image.network(gif.previewUrl, fit: BoxFit.cover)
                );
              },
            ),
          ),
        ),

        // Load Next Page Spinner
        if(state.isLoadingMore) const CircularProgressIndicator.adaptive(),
      ], // Children
    );
  }

}