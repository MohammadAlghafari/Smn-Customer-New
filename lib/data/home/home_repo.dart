import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/home/home_interface.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/home/model/slide.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

import 'api/home_api.dart';

class HomeRepo implements HomeInterface {
  HomeApi homeApi;

  HomeRepo({required this.homeApi}) {}

  @override
  Future<Review> addRestaurantReview(Review review, Restaurant restaurant) {
    return homeApi.addRestaurantReview(review, restaurant);
  }

  @override
  Future<List<Category>> getCategories() async {
    return homeApi.getCategories();
  }

  @override
  Future<List<Restaurant>> getNearRestaurants(
      Address? myLocation, Address ?areaLocation) {
    return homeApi.getNearRestaurants(myLocation, areaLocation);
  }
  @override
  Future<List<Restaurant>> getMoreAllRestaurants(
      Address? myLocation, Address? areaLocation, int page){
    return homeApi.getMoreAllRestaurants(myLocation, areaLocation, page);
  }

  @override
  Future<List<Restaurant>> getPopularRestaurants(Address? myLocation) {
    return homeApi.getPopularRestaurants(myLocation);
  }

  @override
  Future<List<Review>> getRecentReviews() {
    return homeApi.getRecentReviews();
  }

  @override
  Future<Restaurant> getRestaurant(String id, Address address) {
    return homeApi.getRestaurant(id, address);
  }

  @override
  Future<List<Review>> getRestaurantReviews(String id) {
    return homeApi.getRestaurantReviews(id);
  }

  @override
  Future<List<Slide>> getSlides() async {
    return homeApi.getSlides();
  }

  @override
  Future<List<Food>> getTrendingFoods(Address? address) {
    return homeApi.getTrendingFoods(address);
  }
}
