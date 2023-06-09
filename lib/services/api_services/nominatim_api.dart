import 'dart:convert';

import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class NominatimApi {
  Future<List<NominatimPlace>> getNominatimPlaces(
      String search, String originLat, String originLon) async {
    List nominatimPlaceList =
        await getNominatimPlaceList(search, originLat, originLon);
    List<NominatimPlace> nominatimPlaces = [];
    for (Map<String, dynamic> json in nominatimPlaceList) {
      nominatimPlaces.add(NominatimPlace.fromJson(json));
    }
    return nominatimPlaces;
  }

  Future<List> getNominatimPlaceList(
      String search, String originLat, String originLon) async {
    Uri uri = API(path: "nominatim-search", queryParameters: {
      "search": search,
      "origin_lat": originLat,
      "origin_lon": originLon
    }).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw API.getError(uri, response);
  }

  Future<NominatimPlace> getStartNominatimPlace(double lat, double lon) async {
    Uri uri = API(
            host: "nominatim.openstreetmap.org",
            path: "reverse",
            queryParameters: {
              "format": "json",
              "lat": lat.toString(),
              "lon": lon.toString()
            },
            local: false)
        .tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return NominatimPlace.fromJson(jsonDecode(response.body));
    }
    throw API.getError(uri, response);
  }
}
