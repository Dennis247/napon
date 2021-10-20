import 'package:flutter/material.dart';
import 'package:napon/helpers/constants.dart';
import 'package:napon/helpers/request_helper.dart';
import 'package:napon/model/address.dart';
import 'package:napon/model/autosugesstion.dart';

class SearchLocationViewModel with ChangeNotifier {
  bool _isMylocationSelected = false;
  bool get isMylocationSelected {
    return _isMylocationSelected;
  }

  List<AutoSuggestion> _autoSuggestionsList = [];
  List<AutoSuggestion> get autoSuggestionsList {
    return _autoSuggestionsList;
  }

  Address _mylocationAddress = Address(
      latitude: 0.0,
      longitude: 0.0,
      placeFormattedAddress: "",
      placeId: "",
      placeName: "");

  Address get mylocationAddress => _mylocationAddress;

  Address _myDestinationAddress = Address(
      latitude: 0.0,
      longitude: 0.0,
      placeFormattedAddress: "",
      placeId: "",
      placeName: "");
  Address get myDestinationAddress => _myDestinationAddress;

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

  void setPickUpAddress(Address address) {
    _mylocationAddress = address;
  }

  void setMyDestination(String destination) {
    _myDestinationAddress.placeFormattedAddress = destination;
  }

  Future<void> getPlaceDetails(String placeId) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=${Constants.apiKey}&place_id=$placeId&language=en&sessiontoken=1234567';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      //TODO show a pop up that failed to get place details
      return;
    }
    if (response['status'] == 'OK') {
      if (_isMylocationSelected) {
        _mylocationAddress = Address(
            latitude: double.parse(
                response['result']['geometry']['location']['lat'].toString()),
            longitude: double.parse(
                response['result']['geometry']['location']['lng'].toString()),
            placeFormattedAddress: response[''],
            placeName: response['name'],
            placeId: placeId);
      } else {
        _myDestinationAddress = Address(
            latitude: double.parse(
                response['result']['geometry']['location']['lat'].toString()),
            longitude: double.parse(
                response['result']['geometry']['location']['lng'].toString()),
            placeFormattedAddress: response[''],
            placeName: response['name'],
            placeId: placeId);
      }
    }
  }
}
