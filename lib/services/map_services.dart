import 'package:napon/helpers/constants.dart';
import 'package:napon/helpers/request_helper.dart';
import 'package:napon/model/address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:napon/model/base_response.dart';

class MapServices {
  static Future<BaseResponse> getCordinateAddress(Position position) async {
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
}
