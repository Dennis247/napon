import 'package:get_it/get_it.dart';
import 'package:napon/core/services/map_services.dart';
import 'package:napon/ui/routeScreen/trip_duration_viewmodel.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(MapServices());
  // locator.reg(TripDurationViewModel());
}
