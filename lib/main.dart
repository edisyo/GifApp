import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const giphyApiKey = String.fromEnvironment('GIPHY_API_KEY');

void main(){
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
  var uri = Uri.https(
    "api.giphy.com",
    "/v1/gifs/search",
    {
      'api_key': giphyApiKey,
      'q': 'cats',
      'limit': '4'
    });

  final response = await http.get(uri);
  final body = response.body;
  print('Response status: ${response.statusCode}');
  print('Response body: $body');
}
