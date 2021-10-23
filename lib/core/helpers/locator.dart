import 'package:get_it/get_it.dart';
import 'package:napon/core/services/map_services.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(MapServices());
}
