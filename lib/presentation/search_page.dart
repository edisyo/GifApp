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
  late Future<GifPage> _gifsFuture;

  // runs once
  @override
  void initState(){
    //parent's setup first
    super.initState();

    // one search call
    _gifsFuture = widget.repository.getGifs('chili', limit: 6, offset: 0);
  }

  // runs when something changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: FutureBuilder<GifPage>(
        future: _gifsFuture, 
        builder: (context, snapshot) {
          // 1. still waiting
          if(snapshot.connectionState == ConnectionState.waiting){
            //show "Loading data..."
            return Text("Loading data");
          }

          // 2. did it throw?
          if(snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }

          // 3. otherwise, show data
          return GridView.builder(
            itemCount: snapshot.data!.gifs.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8
            ),
            itemBuilder: (context, index) {
              final gif = snapshot.data!.gifs[index];
              return Image.network(gif.previewUrl, fit: BoxFit.cover); 
            },
          ); 


        },
      ),
    );
  }

}