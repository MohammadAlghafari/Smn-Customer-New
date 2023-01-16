import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/credit_card.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/utili/maps_util.dart';

import '../../../smn_customer.dart';

class AuthApi {
  Dio dio;
  SharedPreferences prefs;

  AuthApi({
    required this.dio,
    required this.prefs,
  });

  Future<User?> login(String email, String password) async {
    try {
      final response = await dio.post(url.login(), data: {
        "email": email,
        "password": password,
        'device_token': await getDeviceToken()
      });
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data != "") {
        setCurrentUser(response.data['data']);
        return User.fromJSON(response.data['data']);
      } else {
        showSnackBar(
            message: (AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .wrong_email_or_password));
        return null;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return null;
    }
    // final response = await dio.post(url.api_base_url + "login",
    //     data: {'email': email, 'password': password});
    // // user.toMap()
    // setCurrentUser(response.data);
    // return User.fromJSON(response.data['data']);
  }

  Future<String> getDeviceToken() async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    return token;
  }

  Future<Map<String, dynamic>> checkRegister(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url.checkRegister());
    final response = await dio.postUri(uri, data: body);

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      return response.data;
    } else {
      throw Exception(response.data);
    }
  }

  Future<bool> sendOTP(String number) async {
    try {
      final response = await dio.post(url.sendOTP(), data: {"phone": number});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> verifyOTP(String phone, String code) async {
    try {
      final response = await dio
          .post(url.verifyOTP(), data: {"token": code, "phone": phone});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<User> register(Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url.register());
    // final String url = '${GlobalConfiguration().getValue('api_base_url')}register';
    body['device_token'] = await getDeviceToken();
    final response = await dio.postUri(uri, data: body);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      setCurrentUser(response.data['data']);

      return User.fromJSON(response.data['data']);
    } else {
      return User.fromJSON({});
    }
    return User.fromJSON({});
  }

  // Future<Map<String, dynamic>> checkRegister(User user) async {
  //   final String url =
  //       '${GlobalConfiguration().getValue('api_base_url')}check-register';
  //   final client = new http.Client();
  //   final response = await client.post(
  //     url,
  //     headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //     body: json.encode(user.toMap()),
  //   );
  //   if (response.statusCode == 200 &&
  //       response.body != null &&
  //       response.body != "") {
  //     return json.decode(response.body);
  //   } else {
  //     print(CustomTrace(StackTrace.current, messages: response.body).toString());
  //     throw new Exception(response.body);
  //   }
  // }

  Future<bool> resetPassword(String email) async {
    final response = await dio.post(url.api_base_url + "send_reset_link_email",
        data: {'email': email});
    // user.toMap()
    setCurrentUser(response.data);
    return response.statusCode == 200;
  }

  Future<void> logout() async {
    await prefs.remove('current_user');
  }

  void setCurrentUser(jsonString) async {
    try {
      if (jsonString['data'] != null) {
        await prefs.setString('current_user', json.encode(jsonString['data']));
      }
    } catch (e) {}
  }

  Future<void> setCreditCard(CreditCard creditCard) async {
    if (creditCard != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('credit_card', json.encode(creditCard.toMap()));
    }
  }

  Future<User> getCurrentUser() async {
    return User.fromJSON(json.decode(prefs.getString('current_user')!));
  }

  Future<CreditCard> getCreditCard() async {
    if (prefs.getString('credit_card') == null) return CreditCard.fromJSON({});
    return CreditCard.fromJSON(json.decode(prefs.getString('credit_card')!));
  }

  Future<User> update(User user) async {
    final String _apiToken = 'api_token=${user.apiToken}';
    final Uri uri = Uri.parse('${url.api_base_url}users/${user.id}?$_apiToken');
    final response = await dio.postUri(uri, data: user.toMap());
    setCurrentUser(response.data);
    return User.fromJSON(response.data['data']);
  }

  Future<List<Address>> getAddresses(User user) async {
    User _user = user;
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final Uri uri = Uri.parse(
        '${url.api_base_url}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc');
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Address>((json) => Address.fromJSON(json))
        .toList();
  }

  Future<Address> addAddress(Address address, User user) async {
    final String _apiToken = 'api_token=${user.apiToken}';
    address.userId = user.id!;

    final response = await dio.post(
        "${url.api_base_url}delivery_addresses?$_apiToken",
        data: address.toMap());
    return Address.fromJSON(response.data['data']);
  }

  Future<Address> updateAddress(Address address, User user) async {
    final String _apiToken = 'api_token=${user.apiToken}';
    address.userId = user.id!;
    final response = await dio.put(
        "${url.api_base_url}delivery_addresses/${address.id}?$_apiToken",
        data: address.toMap());
    return Address.fromJSON(response.data['data']);
  }

  Future<Address> removeDeliveryAddress(Address address, User user) async {
    final String _apiToken = 'api_token=${user.apiToken}';

    try {
      final response = await dio.delete(
          "${url.api_base_url}delivery_addresses/${address.id}?$_apiToken");
      return Address.fromJSON(response.data['data']);
    }catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return Address.fromJSON({});
    }
  }

  Future<Address> changeCurrentLocation(Address _address) async {
    if (!_address.isUnknown()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('delivery_address', json.encode(_address.toMap()));
    }
    return _address;
  }

  Future<dynamic> setCurrentLocation(String googleMapsKey) async {
    Location location = Location();
    MapsUtil mapsUtil = MapsUtil();
    final whenDone = Completer();
    Address _address = Address.fromJSON({});
    try {
      if (!await location.serviceEnabled()) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .please_make_sure_you_enable_gps_and_try_again,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 6,
        );
        Navigator.pop(NavigationService.navigatorKey.currentContext!);

        return;
      }
      location.requestService().then((value) async {
        if (!value) {
          return;
        }
        location.getLocation().then((_locationData) async {
          String _addressName = await mapsUtil.getAddressName(
              location:
                  LatLng(_locationData.latitude!, _locationData.longitude!),
              apiKey: googleMapsKey,
              mobileLanguage: prefs.getString('languageCode')!);
          // final coordinates =  Coordinates(latitude, longitude);
          // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          //
          // var first = addresses.first;

          _address = Address.fromJSON({
            'address': _addressName,
            'latitude': _locationData.latitude,
            'longitude': _locationData.longitude
          });
          await changeCurrentLocation(_address);
          whenDone.complete(_address);
        }).catchError((e) {
          whenDone.complete(_address);
        });
      });
      return whenDone.future;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteAccount(String apiToken) async {
    try {
      Map<String, dynamic> _queryParams = {};
      _queryParams['api_token'] = apiToken;
      Uri uri = Uri.parse(url.deleteAccount());
      uri = uri.replace(queryParameters: _queryParams);
      final response = await dio.deleteUri(
        uri,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .verify_your_internet_connection));
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      return false;
    }
  }
}
