import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/restaurants/model/gallery.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/restaurants/restaurants_interface.dart';

import 'api/restaurants_api.dart';

class RestaurantsRepo implements RestaurantsInterface {
  RestaurantsApi restaurantsApi;

  RestaurantsRepo({required this.restaurantsApi});

  @override
  Future<List<Restaurant>> getRestaurants() {
    return restaurantsApi.getRestaurants();
  }

  @override
  Future<Restaurant> getRestaurant(String id) {
    return restaurantsApi.getRestaurant(id);
  }

  @override
  Future<List<Review>> getRestaurantReviews(String id) {
    return restaurantsApi.getRestaurantReviews(id);
  }

  @override
  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId) {
    return restaurantsApi.getFeaturedFoodsOfRestaurant(restaurantId);
  }

  @override
  Future<List<Gallery>> getGalleries(String idRestaurant) {
    return restaurantsApi.getGalleries(idRestaurant);
  }

  ///chat

  @override
  Future<void> addMessage(Conversation conversation, Chat chat) {
    return restaurantsApi.addMessage(conversation, chat);
  }

  @override
  Future<void> createConversation(Conversation conversation) {
    return restaurantsApi.createConversation(conversation);
  }

  @override
  Future<Stream<QuerySnapshot<Object?>>> getChats(Conversation conversation) {
    return restaurantsApi.getChats(conversation);
  }

  @override
  Future<String?> getConversation(List<String> owners) {
    return restaurantsApi.getConversation(owners);
  }

  @override
  Future<Stream<QuerySnapshot<Object?>>> getUserConversations(String userId) {
    return restaurantsApi.getUserConversations(userId);
  }

  @override
  Future<void> removeConversation(String conversationId) {
    return restaurantsApi.removeConversation(conversationId);
  }

  @override
  Future<void> updateConversation(
      String conversationId, Map<String, dynamic> conversation) {
    return restaurantsApi.updateConversation(conversationId, conversation);
  }

  ///Map
  @override
  Future<List<Restaurant>> getNearRestaurants(
      Address myLocation, Address areaLocation) {
    return restaurantsApi.getNearRestaurants(myLocation, areaLocation);
  }
  @override
  Future<List<Food>> getTrendingFoodsOfRestaurant(String idRestaurant) async {
    return await restaurantsApi.getTrendingFoodsOfRestaurant(idRestaurant);
  }

  @override
  Future<List<Category>> getCategoriesOfRestaurant(String restaurantId) async {
    return await restaurantsApi.getCategoriesOfRestaurant(restaurantId);
  }

  @override
  Future<List<Food>> getFoodsOfRestaurant(String idRestaurant,
      {List<String>? categories}) async {
    return await restaurantsApi.getFoodsOfRestaurant(idRestaurant,
        categories: categories);
  }
}
