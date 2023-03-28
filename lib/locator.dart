import 'package:car_pooling/repository/user_repository.dart';
import 'package:car_pooling/services/api_services/trip/end_trip_api.dart';
import 'package:car_pooling/services/api_services/trip/match_api.dart';
import 'package:car_pooling/services/api_services/user/review_api.dart';
import 'package:car_pooling/services/api_services/user/vehicle_api.dart';
import 'package:get_it/get_it.dart';

import 'services/api_services/nominatim_api.dart';
import 'services/api_services/trip/trips_api.dart';
import 'services/api_services/user/user_api.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => NominatimApi());
  locator.registerLazySingleton(() => MatchApi());
  locator.registerLazySingleton(() => EndTripApi());
  locator.registerLazySingleton(() => TripsApi());
  locator.registerLazySingleton(() => UserApi());
  locator.registerLazySingleton(() => ReviewApi());
  locator.registerLazySingleton(() => VehicleApi());
}
