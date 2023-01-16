import 'dart:async';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:smn_delivery_app/data/auth/model/step.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsUtil {
  static const BASE_URL =
      "https://maps.googleapis.com/maps/api/directions/json?";

  static MapsUtil _instance = new MapsUtil.internal();

  MapsUtil.internal();

  factory MapsUtil() => _instance;

  JsonDecoder get _decoder => const JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(Uri.parse(BASE_URL + url)).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"messages\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      List<LatLng> steps = [];
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        // throw new Exception(e);
      }

      return steps;
    });
  }

  List<LatLng> parseSteps(final responseBody) {
    List<Step> _steps = responseBody.map<Step>((json) {
      return Step.fromJson(json);
    }).toList();
    List<LatLng> _latLang =
        _steps.map((Step step) => step.startLatLng).toList();
    return _latLang;
  }

  Future<String> getAddressName({required LatLng location, required String apiKey,required String mobileLanguage}) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&language=${mobileLanguage}&key=$apiKey';
      var response = jsonDecode((await http.get(Uri.parse(endPoint),))
          .body);

      return response['results'][0]['formatted_address'];
    } catch (e) {
      return '';
    }
  }

  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
