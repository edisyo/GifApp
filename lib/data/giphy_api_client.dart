import 'package:http/http.dart' as http;
import 'dart:convert';


  
class GiphyApiClient {
  static const _giphyApiKey = String.fromEnvironment('GIPHY_API_KEY');
  static const _apiHost = 'api.giphy.com';
  static const _apiPath = '/v1/gifs/search';
  

  Future<Map<String, dynamic>> search(String query, {int limit = 25, int offset = 0}) async {
    print("Key length: ${_giphyApiKey.length}");
    print('Calling the API...');

    final uri = Uri.https(_apiHost, _apiPath, {
      'api_key': _giphyApiKey,
      'q': query,
      'limit': limit.toString(),
      'offset': offset.toString()
    });

    final response = await http.get(uri);         // the API Call it self
    final body = response.body;                   // API call returned JSON
    final statusCode = response.statusCode;       // API Call status code
      print('API return code: $statusCode');
    final decoded = jsonDecode(body);             // Decode whole JSON into a MAP - {data, meta, pagination}

    return decoded;
  }
}