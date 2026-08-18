class Gif {
  final String id;
  final String title;
  final String previewUrl;
  final String fullUrl;

  const Gif({
    required this.id,
    required this.title,
    required this.previewUrl,
    required this.fullUrl,
  });

  factory Gif.fromJson(Map<String, dynamic> json){
    final id = json['id'];
    final title = json['title'] ?? '';
    final previewUrl = json['images']?['fixed_height_downsampled']?['url'] ?? '';
    final fullUrl = json['images']?['fixed_width_downsampled']?['url'] ?? '';

    return Gif(id: id, title: title, previewUrl: previewUrl, fullUrl: fullUrl);
  }
}
