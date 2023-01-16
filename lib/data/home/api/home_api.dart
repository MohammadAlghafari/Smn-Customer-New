import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/filter/model/filter.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/home/model/slide.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class HomeApi {
  AuthViewModel authViewModel;
  Dio dio;

  HomeApi({required this.authViewModel, required this.dio});

  Future<List<Restaurant>> getNearRestaurants(
      Address? myLocation, Address? areaLocation) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['limit'] = '8';
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (myLocation != null &&
        areaLocation != null &&
        !myLocation.isUnknown() &&
        !areaLocation.isUnknown()) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
      _queryParams['areaLon'] = areaLocation.longitude.toString();
      _queryParams['areaLat'] = areaLocation.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }

  Future<List<Restaurant>> getPopularRestaurants(Address? myLocation) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

    _queryParams['limit'] = '6';
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    _queryParams['popular'] = 'all';
    if (myLocation != null && !myLocation.isUnknown()) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }

  Future<List<Restaurant>> searchRestaurants(
      String search, Address address) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] = 'name:$search;description:$search';
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    _queryParams['searchFields'] = 'name:like;description:like';
    _queryParams['limit'] = '5';
    if (address != null && !address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    uri = uri.replace(queryParameters: _queryParams);
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }

  Future<Restaurant> getRestaurant(String id, Address address) async {
    Uri uri = Helper.getUri('api/restaurants/$id');
    Uri uriFee = Helper.getUri('api/restaurant/delivery_fee/$id');
    Map<String, dynamic> _queryParams = {};
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (address != null && !address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    _queryParams['with'] = 'users';
    uri = uri.replace(queryParameters: _queryParams);
    uriFee = uriFee.replace(queryParameters: _queryParams);
    final response = await dio.getUri(uri);
    final responseFee = await dio.getUri(uriFee);
    final deliveryFee = double.parse(responseFee.data['data']['delivery_fee']);
    final restaurant = Restaurant.fromJSON(response.data);
    restaurant.deliveryFee = deliveryFee;
    return restaurant;
  }

  Future<List<Review>> getRestaurantReviews(String id) async {
    final Uri uri;
    if (authViewModel.user != null) {
      uri = Uri.parse(
          '${url.api_base_url}restaurant_reviews?with=user&search=restaurant_id:$id&api_token=${authViewModel.user!.apiToken}');
    } else {
      uri = Uri.parse(
          '${url.api_base_url}restaurant_reviews?with=user&search=restaurant_id:$id');
    }

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Review>((json) => Review.fromJSON(json))
        .toList();
  }

  Future<List<Review>> getRecentReviews() async {
    final Uri uri;

    if (authViewModel.user != null) {
      uri = Uri.parse(
          '${url.api_base_url}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user&api_token=${authViewModel.user!.apiToken}');
    } else {
      uri = Uri.parse(
          '${url.api_base_url}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user');
    }
    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Review>((json) => Review.fromJSON(json))
        .toList();
  }

  Future<Review> addRestaurantReview(
      Review review, Restaurant restaurant) async {

    final Uri uri;
    if (authViewModel.user != null) {
      uri = Uri.parse('${url.api_base_url}restaurant_reviews&api_token=${authViewModel.user!.apiToken}');
    }
    else{
       uri = Uri.parse('${url.api_base_url}restaurant_reviews');
    }

    
    review.user = authViewModel.user!;
    final response =
        await dio.putUri(uri, data: review.ofRestaurantToMap(restaurant));
    if (response.statusCode == 200) {
      return Review.fromJSON(response.data['data']);
    }
    return Review.fromJSON({});
  }

  Future<List<Food>> getTrendingFoods(Address? address) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;
    _queryParams['limit'] = '6';
    _queryParams['trending'] = 'week';
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (address != null && !address.isUnknown()) {
      _queryParams['myLon'] = address.longitude.toString();
      _queryParams['myLat'] = address.latitude.toString();
      _queryParams['areaLon'] = address.longitude.toString();
      _queryParams['areaLat'] = address.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Food>((json) => Food.fromJSON(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Slide>> getSlides() async {
    Uri uri = Helper.getUri('api/slides');
    Map<String, dynamic> _queryParams = {
      'with': 'food;restaurant',
      'search': 'enabled:1',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Slide>((json) => Slide.fromJSON(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Category>> getCategories() async {
    Uri uri = Helper.getUri('api/categories');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    filter.delivery = false;
    filter.open = false;
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Category>((json) => Category.fromJSON(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Restaurant>> getMoreAllRestaurants(
      Address? myLocation, Address? areaLocation, int page) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    _queryParams['paginate'] = '10';
    _queryParams['page'] = page.toString();
    if (authViewModel.user != null) {
      _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (myLocation != null &&
        areaLocation != null &&
        !myLocation.isUnknown() &&
        !areaLocation.isUnknown()) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
      _queryParams['areaLon'] = areaLocation.longitude.toString();
      _queryParams['areaLat'] = areaLocation.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data']['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }
}
