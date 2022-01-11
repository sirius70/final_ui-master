import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_ui/Assistants/requestAssistant.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC7TAo-GE2E_1YIirPioudBr9EUU5Gyov0";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response['results'][0]['formatted_address'];
    }
    return placeAddress;
  }
}
