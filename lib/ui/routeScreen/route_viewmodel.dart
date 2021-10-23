// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/core/helpers/locator.dart';
import 'package:napon/core/model/address.dart';
import 'package:napon/core/model/direction_details.dart';
import 'package:napon/core/services/map_services.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;

class RouteViewModel with ChangeNotifier {
  String _startId = "";
  // String get startId => _startId;

  String _endId = "";
  //String get endId => _endId;

  Address _startPlaceAddress = Address();
  Address get startPlaceAddress => _startPlaceAddress;

  Address _endPlaceAddress = Constants.address;
  Address get endPlaceAddress => _endPlaceAddress;

  LatLng mostRecentPos = const LatLng(0, 0);

  Set<Polyline> _polyline = {};
  Set<Polyline> get polyline {
    return _polyline;
  }

  LatLngBounds? _bounds;
  LatLngBounds? get bounds {
    return _bounds;
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers {
    return _markers;
  }

  Set<Circle> _locationCircle = {};
  Set<Circle> get locationCircle {
    return _locationCircle;
  }

  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates {
    return _polylineCoordinates;
  }

  DirectionDetails? _directionDetails;
  DirectionDetails get directionDetails => _directionDetails!;

  BitmapDescriptor? _taxiMarkerIcon;
  BitmapDescriptor get taxiMarkerIcon => _taxiMarkerIcon!;
  void setTaxiIconMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.2),
            Platform.isIOS
                ? "assets/images/car_ios.png"
                : "assets/images/car_android.png")
        .then((onValue) {
      _taxiMarkerIcon = onValue;
    });
  }

  GoogleMapController? _mapController;
  GoogleMapController get mapController {
    return _mapController!;
  }

  bool _isLoadingMap = false;
  bool get isLoadingMap => _isLoadingMap;

  Future<void> setTripOnMap(
      {required String startId, required String endId}) async {
    _isLoadingMap = true;
    _startId = startId;
    _endId = endId;

    await getAddressDetails();
    await getPolylinePoints();

    fitPolyLinesToMap();
    setMarkers();
    setCircle();
    _isLoadingMap = false;
    notifyListeners();
  }

  Future<void> getAddressDetails() async {
    var response = await Future.wait([
      locator<MapServices>().getAddress(_startId),
      locator<MapServices>().getAddress(_endId)
    ]);
    if (!response[0].isSucessfull) {
      //failed to get start address show a pop up or something
    } else if (response[0].isSucessfull) {
      _startPlaceAddress = response[0].data as Address;
    }
    if (!response[1].isSucessfull) {
      //failed to get start address show a pop up or something
    } else if (response[1].isSucessfull) {
      _endPlaceAddress = response[1].data as Address;
    }
  }

  void setCircle() {
    Circle mylocation = Circle(
        circleId: const CircleId('mylocation'),
        strokeColor: Colors.red,
        strokeWidth: 5,
        radius: 20,
        center: LatLng(
            _startPlaceAddress.latitude!, _startPlaceAddress.longitude!));

    Circle myDestinationn = Circle(
        circleId: const CircleId('myDestination'),
        strokeColor: Colors.green,
        strokeWidth: 5,
        radius: 20,
        center:
            LatLng(_endPlaceAddress.latitude!, _endPlaceAddress.longitude!));

    _locationCircle.add(mylocation);
    _locationCircle.add(myDestinationn);
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> getPolylinePoints() async {
    var directionResponse = await locator<MapServices>().getDirectionDetails(
        LatLng(_startPlaceAddress.latitude!, _startPlaceAddress.longitude!),
        LatLng(_endPlaceAddress.latitude!, _endPlaceAddress.longitude!));

    if (!directionResponse.isSucessfull) {
      //show pop up for direction failed
      return;
    }

    _directionDetails = directionResponse.data as DirectionDetails;

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(_directionDetails!.encodedEndPoints);

    _polylineCoordinates.clear();
    if (results.isNotEmpty) {
      for (var element in results) {
        _polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
      _polyline.clear();
      Polyline polyline = Polyline(
          polylineId: const PolylineId("polyline"),
          color: Colors.black,
          points: _polylineCoordinates,
          jointType: JointType.round,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      _polyline.add(polyline);
    }
  }

  void setMarkers() {
    // _polyline.
    _markers.clear();
    _markers.add(Marker(
        markerId: const MarkerId("my location"),
        position:
            LatLng(_startPlaceAddress.latitude!, _startPlaceAddress.longitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: "Pick Up Location",
        ),
        onTap: () {}));

    _markers.add(Marker(
        markerId: const MarkerId("my destination"),
        position:
            LatLng(_endPlaceAddress.latitude!, _endPlaceAddress.longitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(
          title: "My Destination",
        ),
        onTap: () {}));
  }

  void fitPolyLinesToMap() {
    final LatLng from =
        LatLng(_startPlaceAddress.latitude!, _startPlaceAddress.longitude!);
    final LatLng to =
        LatLng(_endPlaceAddress.latitude!, _endPlaceAddress.longitude!);
    if (from.latitude > to.latitude && from.longitude > to.longitude) {
      _bounds = LatLngBounds(southwest: to, northeast: from);
    } else if (from.longitude > to.longitude) {
      _bounds = LatLngBounds(
          southwest: LatLng(from.latitude, to.longitude),
          northeast: LatLng(to.latitude, from.longitude));
    } else if (from.latitude > to.latitude) {
      _bounds = LatLngBounds(
          southwest: LatLng(to.latitude, from.longitude),
          northeast: LatLng(from.latitude, to.longitude));
    } else {
      _bounds = LatLngBounds(southwest: from, northeast: to);
    }

    //  _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

//Stream to update current user location
  StreamSubscription<Position>? _taxiPositionStream;
  void setTaxiLocationUpdate(BuildContext context) {
    _taxiPositionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 10)
        .listen((event) {
      final currentPosition = event;

      LatLng pos = LatLng(currentPosition.latitude, currentPosition.longitude);
      var rotation = locator<MapServices>().getMarkerRotation(
          mtk.LatLng(mostRecentPos.latitude, mostRecentPos.longitude),
          mtk.LatLng(pos.latitude, pos.longitude));

      Marker taxiMarker = Marker(
          markerId: const MarkerId("moving"),
          position: pos,
          icon: _taxiMarkerIcon!,
          rotation: rotation,
          infoWindow: const InfoWindow(title: "Current Location"));

      CameraPosition cp = CameraPosition(target: pos, zoom: 14);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(cp));
      _markers.removeWhere((marker) => marker.markerId.value == "moving");
      _markers.add(taxiMarker);
      mostRecentPos = pos;
      var position = pos;

      //   var destination = _tripDetails.destination;
      //   Provider.of<TripDurationViewModel>(context, listen: false)
      //       .updateTripDetails(position, destination);
      //   notifyListeners();
    });
  }
}
