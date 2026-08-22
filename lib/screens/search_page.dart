import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_app/data/gif_page.dart';
import 'package:gif_app/data/gif_repository.dart';

// Widget Class
class SearchPage extends StatefulWidget {
  // variables, that gets passed from outside and used inside the widget
  final GifRepository repository;
  const SearchPage({super.key, required this.repository});

  // Create a state
  @override
  State<SearchPage> createState() => _SearchPageState();
}

// State class
class _SearchPageState extends State<SearchPage> {
  // declare what needs to survive widget rebuilds - memory
  Future<GifPage>? _gifsFuture;

  // Text Field controller
  final _textEditingController = TextEditingController();

  // Query timer
  Timer? _debounce;

  // Runs once, before Widget build()
  @override
  void initState() {
    //parent's setup first
    super.initState();

    // Trigger search on app startup
    //_gifsFuture = widget.repository.getGifs('chili', limit: 25, offset: 0);
  }

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
    print('Query changed - ${query}');

    // Cancel existing timers, user still typing
    _debounce?.cancel();

    // User paused - trigger the search!
    _debounce = Timer(Duration(milliseconds: 750), () {
      if (query.isEmpty) {
        // Tells Widget to rebuild it.
        // Since in body there is _gifsFuture ? empty : grid.
        // This will change the screen back to an empty Screen
        setState(() {
          _gifsFuture = null;
        });
        return;
      }

      //fire the search
      setState(() {
        _gifsFuture = widget.repository.getGifs(query);
      });
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
            hintText: 'What GIF you want to see?',
          ),
          controller: _textEditingController,
          onChanged: (value) => _onQueryChanged(value),
        ),
        toolbarHeight: 70,
      ),
      body: _gifsFuture == null
          ? _showEmptyPage('No GIFs to show.\nUse the search box!')
          : _showGrid(),
    );
  }

  Widget _showEmptyPage(String message) => Center(child: Text(message));

  Widget _showGrid() {
    return FutureBuilder<GifPage>(
      future: _gifsFuture!,
      builder: (context, snapshot) {
        // 1. still waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          //show "Loading data..."
          return Text("Loading data");
        }

        // 2. did it throw?
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        // Check if results are not empty - no gifs for query
        if (snapshot.data!.gifs.isEmpty) {
          print("Empty query!");
          return _showEmptyPage('No GIFs found.\nTry another keyword!');
        } else {
          print("show grid!");
          return Column(
            children: [
              // Results Label on top
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Showing ${snapshot.data!.count} out of ${snapshot.data!.totalCount} results for ${_textEditingController.text}',
                ),
              ),

              // 3. otherwise, show data - the grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: snapshot.data!.gifs.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final gif = snapshot.data!.gifs[index];
                      return Image.network(gif.previewUrl, fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
            ], // Children
          );
        }
      },
    );
  }
}
