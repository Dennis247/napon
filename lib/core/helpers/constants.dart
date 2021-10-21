import 'package:flutter/services.dart';
import 'package:napon/core/model/address.dart';

class Constants {
  static String apiKey = "AIzaSyCWNdYldigVkhZIVkNlkokjO4VVJ8YKPTo";

  static String placeUrl =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";

  static String mapStyle = "";
  static void setMapStyle() {
    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      mapStyle = string;
    });
  }

  static Address address = Address(
      latitude: 6.5244,
      longitude: 3.3792,
      placeFormattedAddress: "Demo",
      placeId: "",
      placeName: "Demo");
}
