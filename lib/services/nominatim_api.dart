import 'dart:convert';

import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/services/api.dart';
import 'package:http/http.dart' as http;

class NominatimApi {
  Future<List<NominatimPlace>> getNominatimPlaces(String search) async {
    List nominatimPlaceList = await getNominatimPlaceList(search);
    List<NominatimPlace> nominatimPlaces = [];
    for (Map<String, dynamic> json in nominatimPlaceList) {
      nominatimPlaces.add(NominatimPlace.fromJson(json));
    }
    return nominatimPlaces;
  }

  Future<List> getNominatimPlaceList(String search) async {
    Uri uri = API(
        host: "nominatim.openstreetmap.org",
        path: "search",
        queryParameters: {"q": search, "format": "json"}).tokenUri();
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw API.getError(uri, response);
  }
}
