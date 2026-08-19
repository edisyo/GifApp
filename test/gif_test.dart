import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gif_app/data/models/gif.dart';

void main() {
  test('creates a Gif from json map', () {
    // First
    // copied one gifs[0] String from web api call
    const String stringOneFromJson = '''{
      "id": "WvyqAY4hbSdZC",
      "title": "chilli GIF",
      "images": {
        "fixed_height_downsampled": {
          "height": "200",
          "width": "133",
          "size": "93985",
          "url": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200_d.gif",
          "webp_size": "57854",
          "webp": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200_d.webp"
        },
        "fixed_width_downsampled": {
          "height": "300",
          "width": "200",
          "size": "191387",
          "url": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200w_d.gif",
          "webp_size": "111360",
          "webp": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200w_d.webp"
        }
      }
    }''';

    // decode it
    final decode = jsonDecode(stringOneFromJson);

    // create a Gif Object
    final gif = Gif.fromJson(decode);

    // the Test
    expect(gif.id, 'WvyqAY4hbSdZC');
    expect(gif.title, 'chilli GIF');
    expect(
      gif.previewUrl,
      'https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200_d.gif',
    );
    expect(
      gif.fullUrl,
      'https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200w_d.gif',
    );
  });

  test(
    'falls back to an empty string if giphy didnt return a title field in json',
    () {
      // copied one gifs[0] string from web api call and removed title field
      const String stringTwoFromJson = '''{
      "id": "WvyqAY4hbSdZC",
      "images": {
        "fixed_height_downsampled": {
          "height": "200",
          "width": "133",
          "size": "93985",
          "url": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200_d.gif",
          "webp_size": "57854",
          "webp": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200_d.webp"
        },
        "fixed_width_downsampled": {
          "height": "300",
          "width": "200",
          "size": "191387",
          "url": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200w_d.gif",
          "webp_size": "111360",
          "webp": "https://media1.giphy.com/media/v1.Y2lkPWEyNGIwNWM0MGk0cGRhZGZ6YTh1ejFveTk3Z2VuMzZsdXQ3cTQ4M2VyY3J4NGdiYyZlcD12MV9naWZzX3NlYXJjaCZjdD1n/WvyqAY4hbSdZC/200w_d.webp"
        }
      }
    }''';

      // decode it
      final decode = jsonDecode(stringTwoFromJson);

      // create a Gif Object
      final gif = Gif.fromJson(decode);

      // the Test
      expect(gif.title, '');
    },
  );
}
