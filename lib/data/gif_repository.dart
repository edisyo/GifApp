import 'package:gif_app/data/gif_page.dart';
import 'package:gif_app/data/giphy_api_client.dart';

class GifRepository {
  //one call - one GifPage back
  final GiphyApiClient _apiClient;

  GifRepository({
    required this._apiClient
  });

  Future<GifPage> getGifs(String query, {int limit = 25, int offset = 0}) async{
    final decodedCall = await _apiClient.search(query, limit: limit, offset: offset); 

    return GifPage.fromJson(decodedCall);
  }
}