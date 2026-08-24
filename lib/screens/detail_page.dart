import 'package:flutter/material.dart';
import 'package:gif_app/data/models/gif.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.gif});

  final Gif gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GIF Details'),
      ),
      body: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: .center,
        children: [
          // First the image
          Expanded(
            flex: 1,
            child: Image.network(
              gif.fullUrl,
              fit: BoxFit.fitHeight,
              loadingBuilder: (context, child, loadingProgress) {
                if(loadingProgress == null){
                  return child;
                }
                return Center(child: CircularProgressIndicator.adaptive());
              },
            ),
          ),

          // Then details
          Expanded(
            flex: 1,
            child: 
              Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Text('Title: ${gif.title.isEmpty ? 'Gif' : gif.title}'),
                  Text('ID: ${gif.id}')
                ],
              ),
          ),
        ],
      ),
    );
  }
}