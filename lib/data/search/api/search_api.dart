import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class SearchApi {
  Dio dio;
  AuthViewModel authViewModel;

  SearchApi({required this.dio, required this.authViewModel});

  void setRecentSearch(search) async {
    if (search != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('recent_search', search);
    }
  }

  Future<String> getRecentSearch() async {
    String _search = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('recent_search')) {
      _search = prefs.get('recent_search').toString();
    }
    return _search;
  }

  Future<List<Restaurant>> searchRestaurants(String search) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] =
        'name:$search;description:$search;name_arb:$search;description_arb:$search';
    _queryParams['searchFields'] =
        'name:like;description:like;name_arb:like;description_arb:like';
    _queryParams['limit'] = '5';
    if (authViewModel.deliveryAddress != null &&
        !authViewModel.deliveryAddress!.isUnknown()) {
      _queryParams['myLon'] =
          authViewModel.deliveryAddress!.longitude.toString();
      _queryParams['myLat'] =
          authViewModel.deliveryAddress!.latitude.toString();
      _queryParams['areaLon'] =
          authViewModel.deliveryAddress!.longitude.toString();
      _queryParams['areaLat'] =
          authViewModel.deliveryAddress!.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }

  Future<List<Food>> searchFoods(String search) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] = 'name:$search;description:$search;name_ar:$search;description_ar:$search';
    _queryParams['searchFields'] =
        'name:like;description:like;name_arb:like;description_arb:like';
    _queryParams['limit'] = '5';
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (authViewModel.deliveryAddress != null &&
        !authViewModel.deliveryAddress!.isUnknown()) {
      _queryParams['myLon'] =
          authViewModel.deliveryAddress!.longitude.toString();
      _queryParams['myLat'] =
          authViewModel.deliveryAddress!.latitude.toString();
      _queryParams['areaLon'] =
          authViewModel.deliveryAddress!.longitude.toString();
      _queryParams['areaLat'] =
          authViewModel.deliveryAddress!.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Food>((json) => Food.fromJSON(json))
        .toList();
  }
}
