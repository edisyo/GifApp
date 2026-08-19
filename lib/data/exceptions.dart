/// An exception caused by an error in a pkg/http client.
  class ApiException implements Exception {
    final String message;

    /// The URL of the HTTP request or response that failed.
    final Uri? uri;

    ApiException(this.message, [this.uri]);

    @override
    String toString() {
      if (uri != null) {
        return 'ClientException: $message, uri=$uri';
      } else {
        return 'ClientException: $message';
      }
    }
  }

