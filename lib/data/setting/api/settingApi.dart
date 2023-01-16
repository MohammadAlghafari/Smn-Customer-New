//import 'dart:convert';
//import 'dart:io';
//
//import 'package:flutter/cupertino.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/setting/model/setting.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class SettingApi {
  AuthViewModel authViewModel;
  Dio dio;

  SettingApi({required this.authViewModel, required this.dio});

  Future<Setting> getSetting() async {

    final Uri uri;
    if (authViewModel.user != null) {
      uri = Uri.parse( url.setting() + '?api_token=${authViewModel.user!.apiToken}');
    }
    else{
       uri  = Uri.parse( url.setting());
    }
    
    final response = await dio.getUri(uri);

    // response = await http.get(uri, headers: header);
    // final parsed = await jsonDecode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      return Setting.fromJSON({});
    }

    return Setting.fromJSON(response.data['data']);
  }

  Future<User> update(User user) async {
    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}';
    Uri uri = Uri.parse(url.updateSettings(authViewModel.user!.id!, _apiToken));
    // final client = http.Client();
    // final response = await client.post(
    //   uri,
    //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    //   body: json.encode(user.toMap()),
    // );
    try {
      final response = await dio.postUri(uri, data: user.toMap());
      setCurrentUser(response.data);
      authViewModel.updateUser(User.fromJSON(response.data['data']));
      return authViewModel.user!;
    } catch (e) {
      return authViewModel.user!;
    }
  }

  void setCurrentUser(jsonString) async {
    try {
      if (jsonString['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user', json.encode(jsonString['data']));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    Uri uri = Uri.parse(url.changeUserLanguage());

    Map<String, dynamic> _queryParams = {};
    _queryParams['api_token'] =
        authViewModel.user != null ? authViewModel.user!.apiToken : ' ';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('language', languageCode);

    uri = uri.replace(queryParameters: _queryParams);

    try {
      final response = await dio.postUri(uri, data: {
        "language": languageCode,
      });
      print(response.data);
      return;
    } catch (e) {
      print(e.toString());

      return;
    }
  }
}
