import 'package:car_pooling/repository/user_repository.dart';
import 'package:car_pooling/services/nominatim_api.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => NominatimApi());
}
