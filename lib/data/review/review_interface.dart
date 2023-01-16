import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

abstract class ReviewInterface{
  Future<Review> addFoodReview(Review review, Food food);
  Future<Review> addRestaurantReview(Review review,Restaurant restaurant);
}