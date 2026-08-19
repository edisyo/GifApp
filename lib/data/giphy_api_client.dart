import 'package:flutter/material.dart';
import 'package:gif_app/data/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GiphyApiClient {
  static const _giphyApiKey = String.fromEnvironment('GIPHY_API_KEY');
  static const _apiHost = 'api.giphy.com';
  static const _apiPath = '/v1/gifs/search';

  Future<Map<String, dynamic>> search(
    String query, {
    int limit = 25,
    int offset = 0,
  }) async {
    debugPrint('Calling the API...');

    final uri = Uri.https(_apiHost, _apiPath, {
      'api_key': _giphyApiKey,
      'q': query,
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    // the API Call it self
    final response = await http.get(uri);

    // API call returned JSON
    final body = response.body;

    // API Call status code and message
    final statusCode = response.statusCode;
    final statusMsg = jsonDecode(body)['meta']['msg'];
    debugPrint('API return code: $statusCode - $statusMsg');

    // Catch a bad API response. 200 is Ok.
    if (statusCode != 200) {
      throw ApiException(
        'Connection with ${_apiHost + _apiPath} has failed',
        statusCode: statusCode,
        statusMsg: statusMsg,
      );
    }

    // Decode whole JSON into a MAP - {data, meta, pagination}
    final decoded = jsonDecode(body);

    return decoded;
  }
}
