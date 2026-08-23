import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif_app/bloc/search_bloc.dart';
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
      home: BlocProvider(
        create: (_) => SearchBloc(repository),
        child: SearchPage(),
      ),
    );
  }
}
