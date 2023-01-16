import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/order/model/order_status.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class OrderApi {
  Dio dio;

  AuthViewModel authViewModel;

  OrderApi({required this.authViewModel, required this.dio});

  Future<List<Order>> getOrders() async {
    if (authViewModel.user == null) {
      return [];
    }
    // User _user = authViewModel.user!;
    // final String _apiToken = 'api_token=${_user.apiToken}&';
    // Uri.parse(
    //     '${url.api_base_url}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc&isCustomer=1');

    final Uri uri = Uri.parse(url.getOrders(userId: authViewModel.user!.id!, apiToken: authViewModel.user!.apiToken!));
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Order>((json) => Order.fromJSON(json))
        .toList();
  }

  Future<Order> cancelOrder(Order order) async {
    User _user = authViewModel.user!;
    final String _apiToken = 'api_token=${_user.apiToken}';
    final Uri uri =
        Uri.parse('${url.api_base_url}orders/${order.id}?$_apiToken');
    final response = await dio.putUri(
      uri,
      data: order.cancelMap(),
    );
    if (response.statusCode == 200) {
      return Order.fromJSON(response.data['data']);
    } else {
      throw  Exception(response.data);
    }
  }

  Future<List<OrderStatus>> getOrderStatus()async{
    if (authViewModel.user == null) {
      return [];
    }

    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}';


    final response = await dio.get(url.getOrderStatuses(_apiToken));
    return (response.data['data'] as List)
        .map<OrderStatus>((json) => OrderStatus.fromJSON(json))
        .toList();
  }
}
