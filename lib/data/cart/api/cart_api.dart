import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/const/Constants.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/cart/model/cart_item.dart';
import 'package:smn_delivery_app/data/cart/model/coupon.dart';
import 'package:smn_delivery_app/data/home/model/payment.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/smn_customer.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class CartApi {
  Dio dio;
  AuthViewModel authViewModel;

  CartApi({required this.dio, required this.authViewModel});

  Future<List<CartItem>> getCart() async {
    if (authViewModel.user == null) {
      return [];
    }
    User _user = authViewModel.user!;

    final String _apiToken = 'api_token=${_user.apiToken}&';
    final Uri uri = Uri.parse(
        '${url.api_base_url}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=');
    // final cartResponse = await dio.getUri(uri);

    // List carts = cartResponse.data['data'];
    // final cart = CartItem.fromJSON(
    //     carts != null && carts.isNotEmpty && carts[0] != null ? carts[0] : {});
    // final restaurantId = cart.food.restaurant.id;
    // Uri uriFee = Helper.getUri('api/restaurant/delivery_fee/$restaurantId');
    // Map<String, dynamic> _queryParams = {};
    // if (authViewModel.deliveryAddress != null &&
    //     !authViewModel.deliveryAddress!.isUnknown()) {
    //   _queryParams['myLon'] =
    //       authViewModel.deliveryAddress!.longitude.toString();
    //   _queryParams['myLat'] =
    //       authViewModel.deliveryAddress!.latitude.toString();
    //   _queryParams['areaLon'] =
    //       authViewModel.deliveryAddress!.longitude.toString();
    //   _queryParams['areaLat'] =
    //       authViewModel.deliveryAddress!.latitude.toString();
    // }
    // _queryParams['with'] = 'users';
    // uriFee = uriFee.replace(queryParameters: _queryParams);
    // final feeResponse = await dio.getUri(uriFee);
    // final deliveryFee = double.parse(feeResponse.data['data'] != null
    //     ? feeResponse.data['data']['delivery_fee']
    //     : '0.0');

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<CartItem>((json) => CartItem.fromJSON(json))
        .toList();
  }

  Future<int> getCartCount() async {
    User _user = authViewModel.user!;
    if (_user.apiToken == null) {
      return 0;
    }
    final String _apiToken = 'api_token=${_user.apiToken}&';
    final Uri uri = Uri.parse(
        '${url.api_base_url}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=');
    final response = await dio.getUri(uri);
    return response.data as int;
  }

  Future<CartItem> addCart(CartItem cart, bool reset) async {
    User _user = authViewModel.user!;
    if (_user.apiToken == null) {
      return CartItem.fromJSON({});
    }
    Map<String, dynamic> decodedJSON = {};
    final String _apiToken = 'api_token=${_user.apiToken}';
    final String _resetParam = 'reset=${reset ? 1 : 0}';
    cart.userId = _user.id!;
    final Uri uri =
        Uri.parse('${url.api_base_url}carts?$_apiToken&$_resetParam');
    try {
      final response = await dio.postUri(uri, data: cart.toMap());

      return CartItem.fromJSON(response.data['data']);
    } on FormatException catch (e) {
      // print(CustomTrace(StackTrace.current, messages: e.toString()));
    }
    return CartItem.fromJSON(decodedJSON);
  }

  Future<CartItem?> updateCart(CartItem cart) async {
    User _user = authViewModel.user!;
    if (_user.apiToken == null) {
      return CartItem.fromJSON({});
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    cart.userId = _user.id!;
    print('cart.id');
    print(cart.id);
    final Uri uri = Uri.parse('${url.api_base_url}carts/${cart.id}?$_apiToken');
    try {
      final response = await dio.putUri(uri, data: cart.toMap());
      return CartItem.fromJSON(response.data['data']);
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return null;
    }
  }

  Future<bool> removeCart(CartItem cart) async {
    User _user = authViewModel.user!;
    if (_user.apiToken == null) {
      return false;
    }
    final String _apiToken = 'api_token=${_user.apiToken}';
    final Uri uri = Uri.parse('${url.api_base_url}carts/${cart.id}?$_apiToken');
    try {
      final response = await dio.deleteUri(uri);
      return response.data['data'] as bool;
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<double> getDeliveryFee({required String restaurantId}) async {
    try {
      Uri uriFee = Helper.getUri('api/restaurant/delivery_fee/$restaurantId');
      Map<String, dynamic> _queryParams = {};
      if (authViewModel.deliveryAddress != null) {
        _queryParams['myLon'] =
            authViewModel.deliveryAddress!.longitude.toString();
        _queryParams['myLat'] =
            authViewModel.deliveryAddress!.latitude.toString();
        _queryParams['areaLon'] =
            authViewModel.deliveryAddress!.longitude.toString();
        _queryParams['areaLat'] =
            authViewModel.deliveryAddress!.latitude.toString();
      }
      _queryParams['with'] = 'users';
      uriFee = uriFee.replace(queryParameters: _queryParams);
      final feeResponse = await dio.getUri(uriFee);
      double deliveryFee = double.parse(feeResponse.data['data'] != null
          ? feeResponse.data['data']['delivery_fee']
          : '0.0');
      print('deliveryFee = ' + deliveryFee.toString());
      return deliveryFee;
    } catch (e) {
      return Future.value(0.0);
    }
  }

  Future<Coupon?> verifyCoupon(String code) async {
    Uri uri = Helper.getUri('api/coupons');
    User _user = authViewModel.user!;
    if (_user.apiToken == null) {
      return null;
    }
    Map<String, dynamic> query = {
      'api_token': _user.apiToken,
      'with': 'discountables',
      'search': 'code:$code',
      'searchFields': 'code:=',
    };
    uri = uri.replace(queryParameters: query);
    try {
      final response = await dio.getUri(uri);
      print('Coupon $code = ' + response.data['date'].toString());
      return Coupon.fromJSON(response.data['data'][0]);
    } catch (e) {
      return Coupon(
          id: '',
          code: '',
          discount: 0,
          discountType: '',
          valid: false,
          discountables: []);
    }
  }

  Future<Order?> addOrder(Order order, Payment payment) async {
    if (authViewModel.user == null) {
      return Order.fromJSON({});
    }
    User _user = authViewModel.user!;
    // CreditCard _creditCard = await userRepo.getCreditCard();
    order.user = _user;
    order.payment = payment;
    order.date = Constants.date.toString();
    order.time = Constants.time;
    if(order.deliveryAddress!=null)Constants.pickupOrDelivery=true;
    order.pickupOrDelivery = Constants.pickupOrDelivery;

    Uri uri = Uri.parse(url.addOrder(apiToken: _user.apiToken!));

    Map params = order.toMap();
    // params.addAll(_creditCard.toMap());
    try {
      final response = await dio.postUri(uri, data: params);
      var map = response.data;

      return map['data'] != null ? Order.fromJSON(map['data']) : null;
    } catch (e) {
      final response = e as DioError;
      // showToast(context: NavigationService.navigatorKey.currentState!.context, messages: response.response!.data['messages']);
      showSnackBar(message: (response.response!.data['message']));
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
      return null;
    }
  }
}
