import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class PlacePickerViewModel extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
}
