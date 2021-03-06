import 'package:flutter/material.dart';
import 'package:napon/core/helpers/locator.dart';
import 'package:napon/ui/alarm/alarm_screen.dart';
import 'package:napon/ui/alarm/alarm_viewmodel.dart';
import 'package:napon/ui/home/homeScreen/home_screen.dart';
import 'package:napon/ui/home/placePickerScreen/place_picker_screen.dart';
import 'package:napon/ui/home/searchScreen/search_location_screen.dart';
import 'package:napon/ui/home/searchScreen/search_location_viewmodel.dart';
import 'package:napon/ui/routeScreen/route_viewmodel.dart';
import 'package:napon/ui/routeScreen/trip_duration_viewmodel.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

import 'core/helpers/constants.dart';
import 'ui/auth/auth_viewmodel.dart';
import 'ui/home/homeScreen/home_viewmodel.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
  Constants.setMapStyle();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => SearchLocationViewModel()),
          ChangeNotifierProvider(create: (_) => RouteViewModel()),
          ChangeNotifierProvider(create: (_) => TripDurationViewModel()),
          ChangeNotifierProvider(create: (_) => AlarmViewModel()),
        ],
        child: MaterialApp(
          title: 'Napon',
          theme: ThemeData(
            // This is the theme of your application.

            primarySwatch: Colors.green,
          ),
          home: const AlarmScreen(),
          routes: {
            PlacePickerScreen.routeName: (context) => const PlacePickerScreen(),
            HomeScreen.routeName: (context) => const HomeScreen()
          },
        ),
      );
    });
  }
}
