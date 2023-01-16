import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/data/filter/model/filter.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class CategoryApi {
  Dio dio;
  AuthViewModel authViewModel;
  SharedPreferences prefs;

  CategoryApi({
    required this.dio,
    required this.authViewModel,
    required this.prefs,
  });

  // Future<List<Food>> getFoodsByCategory(String id)async {
  //   User _user = authViewModel.user!;
  //   final String _apiToken = 'api_token=${_user.apiToken}&';
  //   final response = await dio.get(url.getFaqCategories(_apiToken));
  //   return (response.data['data'] as List)
  //       .map<Food>((json) => Food.fromJSON(json))
  //       .toList();
  // }

  Future<List<Food>> getFoodsByCategory(categoryId,int page) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {};
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['with'] = 'restaurant';
    _queryParams['search'] = 'category_id:$categoryId';
    _queryParams['searchFields'] = 'category_id:=';
    _queryParams = filter.toQuery(oldQuery: _queryParams);
    _queryParams['paginate'] = '10';
    _queryParams['page'] = page.toString();
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data']['data'] as List)
          .map<Food>((json) => Food.fromJSON(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
