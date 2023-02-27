import 'package:car_pooling/locator.dart';
import 'package:car_pooling/models/nominatim_place.dart';
import 'package:car_pooling/services/nominatim_api.dart';

class UserRepository {
  final NominatimApi _nominatimApi = locator<NominatimApi>();

  Future<List<NominatimPlace>> getNominatimPlaces(String search, double west,
      double south, double east, double north) async {
    return await _nominatimApi.getNominatimPlaces(
        search, west, south, east, north);
  }

  Future<NominatimPlace> getStartNominatimPlace(double lat, double lon) async {
    return await _nominatimApi.getStartNominatimPlace(lat, lon);
  }
}
