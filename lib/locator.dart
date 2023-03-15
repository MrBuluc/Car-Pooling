import 'package:car_pooling/repository/user_repository.dart';
import 'package:car_pooling/services/api_services/end_trip_api.dart';
import 'package:car_pooling/services/api_services/match_api.dart';
import 'package:get_it/get_it.dart';

import 'services/api_services/nominatim_api.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => NominatimApi());
  locator.registerLazySingleton(() => MatchApi());
  locator.registerLazySingleton(() => EndTripApi());
}
