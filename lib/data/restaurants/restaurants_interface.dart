import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

import 'model/gallery.dart';

abstract class RestaurantsInterface {
  Future<List<Restaurant>> getRestaurants();

  Future<Restaurant> getRestaurant(String id);

  Future<List<Review>> getRestaurantReviews(String id);

  Future<List<Gallery>> getGalleries(String idRestaurant);

  Future<List<Food>> getFeaturedFoodsOfRestaurant(String restaurantId);

  Future<List<Food>> getTrendingFoodsOfRestaurant(String idRestaurant);

  Future<List<Category>> getCategoriesOfRestaurant(String restaurantId);
  Future<List<Food>>getFoodsOfRestaurant(String idRestaurant, {List<String>? categories});
  ///chat
  Future<void> createConversation(Conversation conversation);

  Future<Stream<QuerySnapshot>> getUserConversations(String userId);

  Future<String?> getConversation(List<String> owners);

  Future<Stream<QuerySnapshot>> getChats(Conversation conversation);

  Future<void> addMessage(Conversation conversation, Chat chat);

  Future<void> removeConversation(String conversationId);

  Future<void> updateConversation(
      String conversationId, Map<String, dynamic> conversation);

  ///Map
  Future<List<Restaurant>> getNearRestaurants(
      Address myLocation, Address areaLocation);
}
