import 'package:equatable/equatable.dart';

class Gif extends Equatable {
  const Gif({
    required this.id,
    required this.title,
    required this.previewUrl,
    required this.fullUrl,
    this.username = '',
    this.rating = '',
    this.importDatetime = '',
    this.userDisplayName = '',
    this.userProfileUrl = '',
    this.userDescription = '',
    this.imageHeight = '',
    this.imageWidth = '',
    this.imageSize = ''
  });

  final String id;
  final String title;
  final String previewUrl;
  final String fullUrl;

  //for Detail View
  final String username;
  final String rating;
  final String importDatetime;
  final String userDisplayName;
  final String userProfileUrl;
  final String userDescription;
  final String imageHeight;
  final String imageWidth;
  final String imageSize;

  @override
  List<Object> get props => [id];

  factory Gif.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;

    final id = json['id'];
    final title = json['title'] ?? '';
    final previewUrl = images?['fixed_height_downsampled']?['url'] ?? '';
    final fullUrl = images?['fixed_height']?['url'] ?? '';

    //for Detail View
    final user = json['user'] as Map<String, dynamic>?;

    final username = json['username'] ?? '';
    final rating = json['rating'] ?? '';
    final importDatetime = json['import_datetime'] ?? '';

    final userDisplayName = user?['display_name'] ?? '';
    final userProfileUrl = user?['profile_url'] ?? '';
    final userDescription = user?['description'] ?? '';

    final imageHeight = images?['fixed_height']?['height'] ?? '';
    final imageWidth = images?['fixed_height']?['width'] ?? '';
    final imageSize = images?['fixed_height']?['size'] ?? '';

    return Gif(
      id: id,
      title:
      title,
      previewUrl: previewUrl,
      fullUrl: fullUrl,

      //for Detail View
      username: username,
      rating: rating,
      importDatetime: importDatetime,
      userDisplayName: userDisplayName,
      userProfileUrl: userProfileUrl,
      userDescription: userDescription,
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      imageSize: imageSize
    );
  }
}
