import 'package:equatable/equatable.dart';

class Gif extends Equatable {
  const Gif({
    required this.id,
    required this.title,
    required this.previewUrl,
    required this.fullUrl,
  });

  final String id;
  final String title;
  final String previewUrl;
  final String fullUrl;

  @override
  List<Object> get props => [id];

  factory Gif.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;

    final id = json['id'];
    final title = json['title'] ?? '';
    final previewUrl = images?['fixed_height_downsampled']?['url'] ?? '';
    final fullUrl = images?['fixed_width_downsampled']?['url'] ?? '';

    return Gif(id: id, title: title, previewUrl: previewUrl, fullUrl: fullUrl);

    //TO-DO: implement a rendition fallback - go through a list of renditions, not just one rendition
  }
}
