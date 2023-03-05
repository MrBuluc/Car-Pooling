import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/models/trip.dart';
import 'package:car_pooling/services/api_services/match_api.dart';

import '../models/match_response.dart';
import '../services/api_services/nominatim_api.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();
  final MatchApi _matchApi = locator<MatchApi>();

  Future<List<NominatimPlace>> getNominatimPlaces(String search, double west,
      double south, double east, double north) async {
    return await _nominatimApi.getNominatimPlaces(
        search, west, south, east, north);
  }

  Future<NominatimPlace> getStartNominatimPlace(double lat, double lon) async {
    return await _nominatimApi.getStartNominatimPlace(lat, lon);
  }

  Future<MatchResponse> match(Role role, Trip trip) async {
    return await _matchApi.match(role, trip.toJson());
  }
}
