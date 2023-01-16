import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/home/model/slide.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

import 'model/food.dart';

abstract class HomeInterface {
  Future<List<Slide>> getSlides();

  Future<List<Category>> getCategories();

  Future<List<Restaurant>> getNearRestaurants(
      Address? myLocation, Address? areaLocation);

  Future<List<Restaurant>> getPopularRestaurants(Address? myLocation);

  Future<List<Review>> getRestaurantReviews(String id);

  Future<List<Review>> getRecentReviews();

  Future<Restaurant> getRestaurant(String id, Address address);

  Future<Review> addRestaurantReview(Review review, Restaurant restaurant);

  Future<List<Food>> getTrendingFoods(Address address);

  Future<List<Restaurant>> getMoreAllRestaurants(
      Address? myLocation, Address? areaLocation, int page);
}
