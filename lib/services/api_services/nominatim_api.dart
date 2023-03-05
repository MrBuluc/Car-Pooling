import 'dart:convert';

import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/services/api_services/api.dart';
import 'package:http/http.dart' as http;

class NominatimApi {
  Future<List<NominatimPlace>> getNominatimPlaces(String search, double west,
      double south, double east, double north) async {
    List nominatimPlaceList =
        await getNominatimPlaceList(search, west, south, east, north);
    List<NominatimPlace> nominatimPlaces = [];
    for (Map<String, dynamic> json in nominatimPlaceList) {
      nominatimPlaces.add(NominatimPlace.fromJson(json));
    }
    return nominatimPlaces;
  }

  Future<List> getNominatimPlaceList(String search, double west, double south,
      double east, double north) async {
    Uri uri = API(
        host: "nominatim.openstreetmap.org",
        path: "search",
        queryParameters: {
          "q": search,
          "format": "json",
          "bounded": "1",
          "viewbox": "$west,$south,$east,$north"
        }).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
        }).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return NominatimPlace.fromJson(jsonDecode(response.body));
    }
    throw API.getError(uri, response);
  }
}
