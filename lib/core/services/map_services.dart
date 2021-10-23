import 'package:napon/core/helpers/constants.dart';
import 'package:napon/core/helpers/request_helper.dart';
import 'package:napon/core/model/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:napon/core/model/autosugesstion.dart';
import 'package:napon/core/model/base_response.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:napon/core/model/direction_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  Future<BaseResponse> getCordinateAddress(Position position) async {
    try {
      Address placeAddress = Address();
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.apiKey}";
      var response = await RequestHelper.getRequest(url);
      if (response != "failed") {
        placeAddress.placeFormattedAddress =
            response['results'][0]['formatted_address'];
        placeAddress.placeId = response['results'][0]['place_id'];

        return BaseResponse(
            isSucessfull: true, message: '', data: placeAddress);
      }
    } catch (e) {
      return BaseResponse(
          isSucessfull: true, message: e.toString(), data: null);
    }
    return BaseResponse(
        isSucessfull: false, message: 'failed to get Address', data: '');
  }

  double getMarkerRotation(mtk.LatLng soure, mtk.LatLng detsination) {
    var rotation = mtk.SphericalUtil.computeHeading(soure, detsination);
    return rotation.toDouble();
  }

  Future<List<AutoSuggestion>> searchPlace(String query) async {
    try {
      if (query.length > 1) {
        String baseUrl = Constants.placeUrl;
        String url =
            '$baseUrl?radius=100000&language=en&sessionToken=123254251&components=country:ng&strictbounds=true&location=6.5244, 3.3792&key=${Constants.apiKey}&input=$query';
        var response = await RequestHelper.getRequest(url);
        if (response == 'failed') {
          return [];
        }
        if (response['status'] == 'OK') {
          var suggestions = response["predictions"];
          var results = (suggestions as List)
              .map((e) => AutoSuggestion.fromJson(e))
              .toList();
          return results;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<BaseResponse> getAddress(String placeId) async {
    try {
      const String baseUrl =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String url =
          '$baseUrl?key=${Constants.apiKey}&place_id=$placeId&language=en&sessiontoken=1234567';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return BaseResponse(
            isSucessfull: false, message: 'failed to get Address', data: '');
      }
      if (response['status'] == 'OK') {
        return BaseResponse(
            isSucessfull: true,
            message: "fetched address sucessfully",
            data: Address(
                latitude: double.parse(response['result']['geometry']
                        ['location']['lat']
                    .toString()),
                longitude: double.parse(response['result']['geometry']
                        ['location']['lng']
                    .toString()),
                placeFormattedAddress: response['result']['formatted_address'],
                placeName: response['result']['name'],
                placeId: placeId));
      }
      return BaseResponse(
          isSucessfull: false, message: 'failed to get Address', data: '');
    } catch (e) {
      return BaseResponse(
          isSucessfull: false,
          message: 'failed to get Address',
          data: e.toString());
    }
  }

  int getEstaimatedFares(DirectionDetails details, int durationValue) {
    double baseFare = 300;
    double distanceFare = ((details.distanceValue / 1000) * 100);
    double timeFare = ((durationValue / 60) * 10);
    final totlaFare = baseFare + distanceFare + timeFare;

    return totlaFare.truncate();
  }

  Future<BaseResponse> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    try {
      String url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=${Constants.apiKey}";
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        return BaseResponse(isSucessfull: false, message: '', data: '');
      }
      DirectionDetails _directionDetails = DirectionDetails(
          durationText: response['routes'][0]['legs'][0]['duration']['text'],
          durationValue: response['routes'][0]['legs'][0]['duration']['value'],
          distanceText: response['routes'][0]['legs'][0]['distance']['text'],
          distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
          encodedEndPoints: response['routes'][0]['overview_polyline']
              ['points']);

      return BaseResponse(
          isSucessfull: true, message: '', data: _directionDetails);
    } catch (e) {
      return BaseResponse(isSucessfull: false, message: '', data: '');
    }
  }
}
