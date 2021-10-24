import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:napon/core/helpers/locator.dart';
import 'package:napon/core/model/direction_details.dart';
import 'package:napon/core/services/map_services.dart';

class TripDurationViewModel with ChangeNotifier {
  bool isRequestingDirection = false;

  DirectionDetails? _directionDetails;
  DirectionDetails get directionDetails => _directionDetails!;

  String _tripDuration = "";
  String get tripDuration {
    return _tripDuration;
  }

  Timer? timer;
  int _tripDurationCounter = 0;
  int get tripDurationCounter => _tripDurationCounter;

  void startTripTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      _tripDurationCounter++;
    });
  }

  void setTripDirection(DirectionDetails newDirectionDetails) {
    _directionDetails = newDirectionDetails;
  }

  void updateTripDetails(LatLng position, LatLng destination) async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;
      var directionDetails = await locator<MapServices>()
          .getDirectionDetails(position, destination);
      if (!directionDetails.isSucessfull) {
        return;
      }
      _tripDuration = directionDetails.data.durationText;
      notifyListeners();
      isRequestingDirection = false;
    }
  }

  void stopTimer() {
    timer!.cancel();
  }
}
