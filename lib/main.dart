import 'package:flutter/material.dart';
import 'package:napon/home/home_screen.dart';
import 'package:napon/home/searchLocation/search_location_viewmodel.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'auth/auth_viewmodel.dart';
import 'home/home_viewmodel.dart';
import 'home/searchLocation/search_location_screen.dart';

void main() {
  runApp(const MyApp());
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
        ],
        child: MaterialApp(
            title: 'Napon',
            theme: ThemeData(
              // This is the theme of your application.

              primarySwatch: Colors.blue,
            ),
            home: const SearchLocationScreen(
              initialLocation: "yaba",
            )),
      );
    });
  }
}