import 'package:flutter/material.dart';
import 'package:gif_app/data/models/gif.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.gif});

  final Gif gif;

  Widget _detailRow(String label, String value){
    return
      Text.rich(
        TextSpan(children: [
          // Label
          TextSpan(
            text: '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold)),

          // Value
          TextSpan(text: value),
        ])
      );
  }

  String _formatSize(String bytes){
    // Check if bytes has a value in json string
    if (bytes.isEmpty) return '-';

    final inInt = int.tryParse(bytes);
    if(inInt == null) return '-';

    final roundedDivision = (inInt / 1000).toStringAsFixed(0);
    return '$roundedDivision kB';
  }

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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
          ),

          // Then details
          Expanded(
            flex: 1,
            child: 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: ListView(
                  children: [

                    // Title
                    Text(
                      textAlign: .center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      gif.title.isEmpty ? 'Gif' : gif.title
                    ),
                    // Gif By
                    Center(child: _detailRow('Gif by', gif.userDisplayName)),
                    SizedBox(height: 32),

                    // Rest of details
                    _detailRow('ID', gif.id),
                    _detailRow('Uploaded', gif.importDatetime),
                    _detailRow('Rating', gif.rating),
                    SizedBox(height: 16),
                    _detailRow('Username', gif.username),
                    _detailRow('User Description', gif.userDescription),
                    _detailRow('Users Profile', gif.userProfileUrl),
                    SizedBox(height: 16),
                    _detailRow('Height', '${gif.imageHeight} px'),
                    _detailRow('Width', '${gif.imageWidth} px'),
                    _detailRow('Size', _formatSize(gif.imageSize)),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}