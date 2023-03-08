import 'package:http/http.dart' as http;

class API {
  String? host;
  int? port;
  String path;
  Map<String, dynamic>? queryParameters;
  bool local = true;

  API({this.host, this.port, required this.path, this.queryParameters});

  Uri tokenUri() {
    host ??= local ? "10.0.2.2" : host;
    return Uri(
        scheme: local ? "http" : "https",
        host: host,
        port: port,
        path: path,
        queryParameters: queryParameters);
  }

  static Exception getError(Uri uri, http.Response response) {
    print("Request $uri failed\n" +
        "Response: ${response.statusCode} ${response.body}");
    throw response;
  }
}