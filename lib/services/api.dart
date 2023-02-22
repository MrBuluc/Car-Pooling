import 'package:http/http.dart' as http;

class API {
  String? path;
  String? host;
  Map<String, dynamic>? queryParameters;

  API({this.path, this.host, this.queryParameters});

  Uri tokenUri() => Uri(
      scheme: "https",
      host: host,
      path: path,
      queryParameters: queryParameters);

  static Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n" +
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}
