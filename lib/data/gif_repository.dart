import 'package:gif_app/data/exceptions.dart';
import 'package:gif_app/data/gif_page.dart';
import 'package:gif_app/data/giphy_api_client.dart';
import 'package:http/http.dart';

class GifRepository {
  //one call - one GifPage back
  final GiphyApiClient _apiClient;

  GifRepository({required this._apiClient});

  // For Giphy's Search Endpoint
  Future<GifPage> getGifs(
    String query, {
    int limit = 25,
    int offset = 0,
  }) async {
    try {
      final decodedCall = await _apiClient.search(
        query,
        limit: limit,
        offset: offset,
      );
      return GifPage.fromJson(decodedCall);
    } on ClientException catch (e) {
      throw NetworkException("No response from API host. $e");
    } on ApiException {
      // already our type — rethrow keeps the original stack trace
      rethrow;
    } catch (e) {
      // throws either TypeError or FormatError - catch all
      throw ParseException("Couldnt parse JSON", cause: e);
    }
  }

  // For Giphy's Search Endpoint
  Future<GifPage> getTrendingGifs({
    int limit = 25,
    int offset = 0,
  }) async {
    try {
      final decodedCall = await _apiClient.trending(limit: limit, offset: offset);
      return GifPage.fromJson(decodedCall);
    } on ClientException catch (e) {
      throw NetworkException("No response from API host. $e");
    } on ApiException {
      // already our type — rethrow keeps the original stack trace
      rethrow;
    } catch (e) {
      // throws either TypeError or FormatError - catch all
      throw ParseException("Couldnt parse JSON", cause: e);
    }
  }
}
