import 'package:flutter/material.dart';
import 'package:gif_app/data/gif_repository.dart';
import 'package:gif_app/data/giphy_api_client.dart';
import 'package:gif_app/screens/search_page.dart';

void main() {
  final apiClient = GiphyApiClient();
  final gifRepository = GifRepository(apiClient: apiClient);

  runApp(GifApp(repository: gifRepository));
}

class GifApp extends StatelessWidget {
  final GifRepository repository;

  const GifApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore Giphy",
      home: SearchPage(repository: repository),
    );
  }
}
