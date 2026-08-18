import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_app/data/models/gif.dart';
import 'package:http/http.dart' as http;

const giphyApiKey = String.fromEnvironment('GIPHY_API_KEY');

void main() {
  print("Key length: ${giphyApiKey.length}");
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
          onPressed: testCall,
          backgroundColor: Colors.deepPurpleAccent,
          hoverColor: Colors.deepOrange,
          focusColor: Colors.blue,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}

Future<void> testCall() async {
  print('Calling the API...');
  final uri = Uri.https('api.giphy.com', '/v1/gifs/search', {
    'api_key': giphyApiKey,
    'q': 'cats',
    'limit': '4',
  });

  final response = await http.get(uri);
  final body = response.body;               // API call returned JSON
  final statusCode = response.statusCode;   // API Call status code
  final decoded = jsonDecode(body);         // Decode whole JSON into a MAP - data, meta, pagination
  final data = decoded['data'];             // Accessing the DATA field in API response
  final first = data[0];                    // Access the first GIF
  
  final Gif firstGif = Gif.fromJson(first); // Turning API Data (JSON) into an actual Object - <Gif>
  print(firstGif.id);
  print(firstGif.title);
  print(firstGif.previewUrl);
  print(firstGif.fullUrl);
}
