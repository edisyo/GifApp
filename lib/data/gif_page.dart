import 'package:gif_app/data/models/gif.dart';

class GifPage{
  final List<Gif> gifs;     // All items in one page
  final int totalCount;     // Total items for this keyword found
  final int count;          // Items returned in this API call
  final int offset;         // Skip count before the current page is starting

  const GifPage({
    required this.gifs,
    required this.totalCount,
    required this.count,
    required this.offset
  });

  factory GifPage.fromJson(Map<String, dynamic> json){
    final pagination = json['pagination'] as Map<String, dynamic>;  // pulls pagination block into a variable - Map
    final totalCount = pagination['total_count'] as int;            // returns a value of 'total_count' key
    final count = pagination['count'] as int;
    final offset = pagination['offset'] as int;

    final gifs = (json['data'] as List)
      .map((listItem) => Gif.fromJson(listItem))
      .toList();

    return GifPage(gifs: gifs, totalCount: totalCount, count: count, offset: offset);
  }
}