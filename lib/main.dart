import 'package:flutter/material.dart';
import 'package:gif_app/data/gif_repository.dart';
import 'package:gif_app/data/giphy_api_client.dart';

void main() {
  runApp(const GifApp());
}

class GifApp extends StatelessWidget {
  const GifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore Giphy",
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 156, 122, 213),
        appBar: AppBar(
          title: Text('Testing'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: testApi,
          backgroundColor: Colors.deepPurpleAccent,
          hoverColor: Colors.deepOrange,
          focusColor: Colors.blue,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

Future<void> testApi() async {
  final apiClient = GiphyApiClient();

  final gifRepo = GifRepository(apiClient: apiClient);
  final page = await gifRepo.getGifs("chili", limit: 1, offset: 0);
}
