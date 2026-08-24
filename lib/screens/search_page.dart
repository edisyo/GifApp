import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_bloc.dart';
import 'package:gif_app/bloc/search_event.dart';
import 'package:gif_app/bloc/search_state.dart';
import 'package:gif_app/data/models/gif.dart';
import 'package:go_router/go_router.dart';

// Widget Class
class SearchPage extends StatefulWidget {
  // variables, that gets passed from outside and used inside the widget
  //edit final GifRepository repository;
  const SearchPage({super.key});

  // Create a state
  @override
  State<SearchPage> createState() => _SearchPageState();
}

// State class
class _SearchPageState extends State<SearchPage> {
  // Text Field controller
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  // Query timer
  Timer? _debounce;

  // Runs once, before Widget build()
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
    _debounce?.cancel();
    _textEditingController.dispose();
    _scrollController.dispose();

    // Parents Dispose last!
    super.dispose();
  }

  // Runs when text inside TexField changes
  void _onQueryChanged(String query) {
    print('Query changed - $query');

    // Cancel existing timers, user still typing
    _debounce?.cancel();

    // User paused - trigger the search!
    _debounce = Timer(Duration(milliseconds: 750), () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }

  void _onScroll(){
    var position = _scrollController.position;
    var diff = position.maxScrollExtent - position.pixels;

    if(diff  < 200) context.read<SearchBloc>().add(NextPageRequested());
  }

  void _onImageTap(Gif gif){
    context.push('/gif', extra: gif);
  }
  

  // runs when something changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'What GIF you want to see?',
          ),
          controller: _textEditingController,
          onChanged: (value) => _onQueryChanged(value),
        ),
        toolbarHeight: 70,
      ),
      body: _buildBlocStates(),
    );
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
    return const Text('Use Search box to find GIFs!');
  }

  Widget _showSearchStateLoading() {
    return const CircularProgressIndicator.adaptive();
  }

  Widget _showSearchStateEmpty(SearchStateEmpty state) {
    return Text('No results for ${state.query}\nTry another keyword!');
  }

  Widget _showSearchStateError(SearchStateError state) {
    return Text('Error: ${state.error}');
  }

  Widget _showSearchStateLoaded(SearchStateLoaded state) {
    return Column(
      children: [
        // Results Label on top
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Showing ${state.gifs.length} out of ${state.totalCount} results for ${state.query}',
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
