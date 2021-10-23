import 'package:flutter/material.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/core/helpers/locator.dart';
import 'package:napon/core/helpers/request_helper.dart';
import 'package:napon/core/model/autosugesstion.dart';
import 'package:napon/core/services/map_services.dart';

class SearchLocationViewModel with ChangeNotifier {
  bool _isMylocationSelected = false;
  bool get isMylocationSelected {
    return _isMylocationSelected;
  }

  List<AutoSuggestion> _autoSuggestionsList = [];
  List<AutoSuggestion> get autoSuggestionsList {
    return _autoSuggestionsList;
  }

  AutoSuggestion? _mylocationAddress;
  AutoSuggestion? get ylocationAddress => _mylocationAddress;

  AutoSuggestion? _myDestinationAddress;
  AutoSuggestion? get myDestinationAddress => _myDestinationAddress;

  void setIsMyLocationSelected(bool value) {
    _isMylocationSelected = value;
  }

  void searchPlace(String query) async {
    _autoSuggestionsList.clear();
    _autoSuggestionsList = await locator<MapServices>().searchPlace(query);
    notifyListeners();
  }

  Future<void> setSugesstion(AutoSuggestion autoSuggestion,
      {bool notify = false}) async {
    if (_isMylocationSelected) {
      _mylocationAddress = autoSuggestion;
    } else {
      _myDestinationAddress = autoSuggestion;
    }
    if (notify) notifyListeners();
  }
}
