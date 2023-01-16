import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/notifications/model/notification.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class NotificationsApi {
  AuthViewModel authViewModel;
  SettingViewModel settingViewModel;
  Dio dio;

  NotificationsApi(
      {required this.authViewModel,
      required this.settingViewModel,
      required this.dio});

  Future<List<Notification>> getNotifications() async {
    if (authViewModel.user == null) {
      return [];
    }
    Uri uri = Helper.getUri('api/notifications');
    Map<String, dynamic> _queryParams = {};
    User _user = authViewModel.user!;
    //print('uri' + '$uri');

    _queryParams['api_token'] = _user.apiToken;
    _queryParams['search'] = 'notifiable_id:${_user.id}';
    _queryParams['searchFields'] = 'notifiable_id:=';
    _queryParams['orderBy'] = 'created_at';
    _queryParams['sortedBy'] = 'desc';
    _queryParams['limit'] = '10';
    uri = uri.replace(queryParameters: _queryParams);
    if (_user.id == null) return [];
    final response = await dio.getUri(uri);
    return (response.data as List)
        .map<Notification>((json) => Notification.fromJSON(json))
        .toList();
  }

  Future<Notification> markAsReadNotifications(
      Notification notification) async {
    User _user = authViewModel.user!;

    if (_user.apiToken == null) {
      return Notification.fromJSON({});
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final response = await dio.putUri(
        Uri.parse(url.markAsReadNotifications(notification.id, _apiToken)),
        data: notification.markReadMap());

    return Notification.fromJSON(response.data['data']);
  }

  Future<Notification> removeNotification(Notification cart) async {
    User _user = authViewModel.user!;

    if (_user.apiToken == null) {
      return Notification.fromJSON({});
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final response = await dio.deleteUri(
      Uri.parse(url.removeNotification(cart.id, _apiToken)),
    );
    return Notification.fromJSON(response.data['data']);
  }

  Future<void> sendNotification(String body, String title, User user) async {
    final data = {
      "notification": {"body": "$body", "title": "$title"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "messages",
        "status": "done"
      },
      "to": "${user.deviceToken}"
    };
    // final client = http.Client();
    // final response = await client.post(
    //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //   headers: {
    //     HttpHeaders.contentTypeHeader: 'application/json',
    //     HttpHeaders.authorizationHeader:
    //         "key=${settingViewModel.setting.fcmKey}",
    //   },
    //   body: json.encode(data),
    // );
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "key=${settingViewModel.setting.fcmKey}";
    final response = await dio.postUri(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),data:data,
    );
  }
}
