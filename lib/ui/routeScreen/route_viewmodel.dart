// import 'package:flutter/cupertino.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class RouteViewModel with ChangeNotifier{
//   Future<void> getPlaceDetails(String placeId) async {
//     const String baseUrl =
//         'https://maps.googleapis.com/maps/api/place/details/json';
//     String url =
//         '$baseUrl?key=${Constants.apiKey}&place_id=$placeId&language=en&sessiontoken=1234567';
//     var response = await RequestHelper.getRequest(url);
//     if (response == 'failed') {
//       //TODO show a pop up that failed to get place details
//       return;
//     }
//     if (response['status'] == 'OK') {
//       if (_isMylocationSelected) {
//         _mylocationAddress = Address(
//             latitude: double.parse(
//                 response['result']['geometry']['location']['lat'].toString()),
//             longitude: double.parse(
//                 response['result']['geometry']['location']['lng'].toString()),
//             placeFormattedAddress: response[''],
//             placeName: response['name'],
//             placeId: placeId);
//       } else {
//         _myDestinationAddress = Address(
//             latitude: double.parse(
//                 response['result']['geometry']['location']['lat'].toString()),
//             longitude: double.parse(
//                 response['result']['geometry']['location']['lng'].toString()),
//             placeFormattedAddress: response[''],
//             placeName: response['name'],
//             placeId: placeId);
//       }
//     }
//   }

// }