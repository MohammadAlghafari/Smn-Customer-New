import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/filter/model/filter.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/restaurants/model/gallery.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class RestaurantsApi {
  AuthViewModel authViewModel;
  Dio dio;
  SharedPreferences prefs;

  RestaurantsApi(
      {required this.authViewModel, required this.dio, required this.prefs});

  Future<List<Restaurant>> getRestaurants() async {
    Uri uri = Helper.getUri('api/manager/restaurants');
    Map<String, dynamic> _queryParams = {};

    if (authViewModel.user!.apiToken == null) {
      return [];
    }
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    _queryParams['orderBy'] = 'id';
    _queryParams['sortedBy'] = 'desc';
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Restaurant>((json) => Restaurant.fromJSON(json))
        .toList();
  }

  Future<Restaurant> getRestaurant(String id) async {
    Uri uri = Helper.getUri('api/restaurants/$id');
    Map<String, dynamic> _queryParams = {};
    _queryParams['with'] = 'users';
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return Restaurant.fromJSON(response.data['data']);
  }

  Future<List<Review>> getRestaurantReviews(String id) async {
    Uri uri = Helper.getUri('api/restaurant_reviews');
    Map<String, dynamic> _queryParams = {};
    _queryParams['with'] = 'user';
    _queryParams['search'] = 'restaurant_id:$id';
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    _queryParams['limit'] = '5';
    uri = uri.replace(queryParameters: _queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Review>((json) => Review.fromJSON(json))
        .toList();
  }

  Future<List<Gallery>> getGalleries(String idRestaurant) async {
    Map<String, dynamic> _queryParams = {};
    Uri uri = Helper.getUri('api/galleries');
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    _queryParams['search'] = 'restaurant_id:$idRestaurant';

    uri = uri.replace(queryParameters: _queryParams);
    try{
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Gallery>((json) => Gallery.fromJSON(json))
          .toList();
    }
    catch(e){
      return [];
    }
  }

  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/foods');
   Map<String, dynamic> _queryParams = {
     'with': 'category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
   };
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters:_queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Food>((json) => Food.fromJSON(json))
        .toList();
  }

  Future<List<Food>> getTrendingFoodsOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/foods');
    Map<String, dynamic> _queryParams = {
     'with': 'category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId;featured:1',
      'searchFields': 'restaurant_id:=;featured:=',
      'searchJoin': 'and',
   };
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters:_queryParams);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Food>((json) => Food.fromJSON(json))
        .toList();
  }

  Future<List<Category>> getCategoriesOfRestaurant(String restaurantId) async {
    Uri uri = Helper.getUri('api/categories');
    Map<String, dynamic> _queryParams = {'restaurant_id': restaurantId};
   if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    uri = uri.replace(queryParameters: _queryParams);
    final response = await dio.getUri(uri);
    print(response.data);
    return (response.data['data'] as List)
        .map<Category>((json) => Category.fromJSON(json))
        .toList();
  }

  Future<List<Food>> getFoodsOfRestaurant(String restaurantId,
      {List<String>? categories}) async {
    Uri uri = Helper.getUri('api/foods/categories');
    Map<String, dynamic> query = {
      'with': 'restaurant;category;extras;foodReviews',
      'search': 'restaurant_id:$restaurantId',
      'searchFields': 'restaurant_id:=',
    };

  if (authViewModel.user != null){
    query['api_token'] = authViewModel.user?.apiToken;
  }

    if (categories != null && categories.isNotEmpty) {
      query['categories[]'] = categories;
    }
    uri = uri.replace(queryParameters: query);

    final response = await dio.getUri(uri);
    return (response.data['data'] as List)
        .map<Food>((json) => Food.fromJSON(json))
        .toList();
  }

  ///chat
  Future<void> createConversation(Conversation conversation) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversation.id)
        .set(conversation.toMap())
        .catchError((e) {
      print(e);
    });
  }

  Future<Stream<QuerySnapshot>> getUserConversations(String userId) async {
    return await FirebaseFirestore.instance
        .collection("conversations")
        .where('visible_to_users', arrayContains: userId)
        //.orderBy('time', descending: true)
        .snapshots();
  }

  Future<String?> getConversation(List<String> owners) async {
    try {
      String id = await FirebaseFirestore.instance
          .collection("conversations")
          .where(
            'visible_to_users',
            isEqualTo: owners,
          )
          .get()
          .then((value) {
        if (value.docs.length > 0) {
          return value.docs[0].id;
        } else {
          return '';
        }
      });
      return id;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<Stream<QuerySnapshot>> getChats(Conversation conversation) async {
    return updateConversation(
            conversation.id!, {'read_by_users': conversation.readByUsers})
        .then((value) async {
      return await FirebaseFirestore.instance
          .collection("conversations")
          .doc(conversation.id)
          .collection("chats")
          .orderBy('time', descending: true)
          .snapshots();
    });
  }

  Future<void> addMessage(Conversation conversation, Chat chat) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversation.id)
        .collection("chats")
        .add(chat.toMap())
        .whenComplete(() {
      updateConversation(conversation.id!, conversation.toUpdatedMap());
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> removeConversation(
    String conversationId,
  ) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversationId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateConversation(
      String conversationId, Map<String, dynamic> conversation) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversationId)
        .update(conversation)
        .catchError((e) {
      print(e.toString());
    });
  }

  /// map
  Future<List<Restaurant>> getNearRestaurants(
      Address myLocation, Address areaLocation) async {
    Uri uri = Helper.getUri('api/restaurants');
    Map<String, dynamic> _queryParams = {};
    Filter filter =
        Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

    _queryParams['limit'] = '6';
    if(authViewModel.user != null){
    _queryParams['api_token'] = authViewModel.user!.apiToken;
    }
    if (myLocation != null &&
        !myLocation.isUnknown() &&
        !areaLocation.isUnknown()) {
      _queryParams['myLon'] = myLocation.longitude.toString();
      _queryParams['myLat'] = myLocation.latitude.toString();
      _queryParams['areaLon'] = areaLocation.longitude.toString();
      _queryParams['areaLat'] = areaLocation.latitude.toString();
    }
    _queryParams.addAll(filter.toQuery());
    uri = uri.replace(queryParameters: _queryParams);
    try {
      // final client = new http.Client();
      // final streamedRest = await client.send(http.Request('get', uri));
      final response = await dio.getUri(uri);
      return (response.data['data'] as List)
          .map<Restaurant>((json) => Restaurant.fromJSON(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
