import 'package:http/http.dart' as http;

class API {
  String? host;
  String path;
  Map<String, dynamic>? queryParameters;
  bool local;

  API({this.host, required this.path, this.queryParameters, this.local = true});

  Uri tokenUri() {
    host ??= local ? "10.0.2.2" : host;
    return Uri(
        scheme: local ? "http" : "https",
        host: host,
        port: local ? 8000 : null,
        path: path,
        queryParameters: queryParameters);
  }

  static Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n" +
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}
