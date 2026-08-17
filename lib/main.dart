import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main(){
  const check = String.fromEnvironment('GIPHY_API_KEY');
  print("Key length: ${check.length}");
  runApp(const GifApp());
} 

class GifApp extends StatelessWidget {
  const GifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explore Giphy",
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 156, 122, 213),
      ),
    );
  }
}

Future<void> testCall() async {
  //var uri = Uri.https(authority)
}
