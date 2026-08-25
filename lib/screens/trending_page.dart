import 'package:flutter/material.dart';
import 'package:gif_app/screens/widgets/gif_grid_view.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trending'),
            Text('Powered by GIPHY', style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: const GifGridView(),
    );
  }
}