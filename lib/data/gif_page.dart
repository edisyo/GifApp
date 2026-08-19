import 'package:gif_app/data/models/gif.dart';

class GifPage {
  // All items in one page
  final List<Gif> gifs;

  // Total items for this keyword found
  final int totalCount;

  // Items returned in this API call
  final int count;

  // Skipped count before the current page is starting (so previous pages is the offset)
  final int offset;

  const GifPage({
    required this.gifs,
    required this.totalCount,
    required this.count,
    required this.offset,
  });

  factory GifPage.fromJson(Map<String, dynamic> json) {
    // pulls pagination block into a variable - Map
    final pagination = json['paginationnn'] as Map<String, dynamic>;

    // returns a value of 'total_count' key
    final totalCount = pagination['total_count'] as int;
    final count = pagination['count'] as int;
    final offset = pagination['offset'] as int;

    final gifs = (json['data'] as List)
        .map((listItem) => Gif.fromJson(listItem))
        .toList();

    return GifPage(
      gifs: gifs,
      totalCount: totalCount,
      count: count,
      offset: offset,
    );
  }
}
