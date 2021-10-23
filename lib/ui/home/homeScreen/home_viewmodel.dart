import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:napon/core/helpers/locator.dart';
import 'package:napon/core/model/address.dart';
import 'package:napon/core/services/map_services.dart';
//import 'package:napon/model/address.dart';

class HomeViewModel extends ChangeNotifier {
  Position? _currentPosition = const Position(
      latitude: 6.5244,
      longitude: 3.3792,
      timestamp: null,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  Position? get currentPosition => _currentPosition;

  Address? _pickUpAddress;
  Address? get pickUpAddress => _pickUpAddress;

  Future<void> getCurrentPosition(GoogleMapController mapController) async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    LatLng pos = LatLng(_currentPosition!.latitude, currentPosition!.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);

    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    final addRessResponse =
        await locator<MapServices>().getCordinateAddress(_currentPosition!);

    if (!addRessResponse.isSucessfull) {
      //do nothing || or show a notification that it failed to get base address
      return;
    }
    //set pick up address
    _pickUpAddress = addRessResponse.data as Address;
    _pickUpAddress = Address(
        latitude: pos.latitude,
        longitude: pos.longitude,
        placeFormattedAddress: _pickUpAddress!.placeFormattedAddress,
        placeId: _pickUpAddress!.placeId,
        placeName: _pickUpAddress!.placeName);
  }
}
