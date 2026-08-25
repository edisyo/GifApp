// An exception caused by an error in a https/ API client.
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String statusMsg;

  // The URL of the HTTP request or response that failed.
  final Uri? uri;

  const ApiException(
    this.message, {
    this.uri,
    required this.statusCode,
    required this.statusMsg,
  });

  @override
  String toString() {
    if (uri != null) {
      return 'ApiException: $message, uri=$uri';
    } else {
      return 'ApiException: $message';
    }
  }
}

// The request never completed - no connection or other network issue
class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;

  // tried to connect to which host
  //final Uri? uri;

  //const NetworkException(this.message, {this.uri});

  /*@override
  String toString() {
    if (uri != null) {
      return 'NetworkException: $message, uri=$uri';
    } else {
      return 'NetworkException: $message';
    }
  }*/

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

// An exception caused by a Json parser (in GifPage.fromJson)
class ParseException implements Exception {
  final String message;

  // what caused the error
  final Object? cause;

  const ParseException(this.message, {this.cause});

  @override
  String toString() {
    if (cause != null) {
      return 'ParseException: $message, cause=$cause';
    } else {
      return 'ParseException: $message';
    }
  }
}
