import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/smn_customer.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class ApiHandler {
  AuthViewModel authViewModel;
  Dio dio;

  ApiHandler({required this.authViewModel, required this.dio});

  Future<void> getApi(
      {required String url,
      required Map<String, dynamic> body,
      required Function result,
      required Map<String, dynamic> queryParams,
      Function? onFail}) async {
    try {
      buildShowDialog(NavigationService.navigatorKey.currentState!.context);
      Uri uri = Uri.parse(url);
      uri = uri.replace(queryParameters: queryParams);

      final response = await dio.getUri(uri);
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      result(response.statusCode, response.data);
    } catch (e) {
      final response = e as DioError;
      if (response.response!.data['message'] != null) {
        showSnackBar(message: (response.response!.data['message']));
      }
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      if (onFail != null) onFail();
    }
  }
}
