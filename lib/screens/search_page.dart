import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_bloc.dart';
import 'package:gif_app/bloc/search_event.dart';
import 'package:gif_app/screens/widgets/gif_grid_view.dart';

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
// --------------------------
class _SearchPageState extends State<SearchPage> {
  // Text Field controller
  final _textEditingController = TextEditingController();

  // Query timer
  Timer? _debounce;

  // Triggers when the State is destroyed - closing the app, hot restart
  @override
  void dispose() {
    // Cleanup here
    _debounce?.cancel();
    _textEditingController.dispose();

    // Parents Dispose last!
    super.dispose();
  }

  // Runs when text inside TexField changes
  void _onQueryChanged(String query) {
    // Cancel existing timers, user still typing
    _debounce?.cancel();

    // User paused - trigger the search!
    _debounce = Timer(Duration(milliseconds: 750), () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }
  

  // runs when something changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Powered By GIPHY',
            prefixIcon: Icon(Icons.search)
          ),
          controller: _textEditingController,
          onChanged: _onQueryChanged,
        ),
        toolbarHeight: 70,
      ),
      body: const GifGridView(),
    );
  }
}
