import 'package:flutter/material.dart';
import 'package:napon/core/helpers/constants.dart';
import 'package:napon/core/helpers/request_helper.dart';
import 'package:napon/core/model/autosugesstion.dart';

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
    if (query.length > 1) {
      String baseUrl = Constants.placeUrl;
      String url =
          '$baseUrl?radius=100000&language=en&sessionToken=123254251&components=country:ng&strictbounds=true&location=6.5244, 3.3792&key=${Constants.apiKey}&input=$query';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var suggestions = response["predictions"];
        _autoSuggestionsList = (suggestions as List)
            .map((e) => AutoSuggestion.fromJson(e))
            .toList();
        notifyListeners();
      }
    }
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
