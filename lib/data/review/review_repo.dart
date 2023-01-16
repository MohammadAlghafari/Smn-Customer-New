import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/review/review_interface.dart';

import 'api/review_api.dart';

class ReviewRepo implements ReviewInterface {
  ReviewApi reviewApi;

  ReviewRepo({required this.reviewApi});

  @override
  Future<Review> addFoodReview(review, food) {
    return reviewApi.addFoodReview(review, food);
  }

  @override
  Future<Review> addRestaurantReview(Review review, Restaurant restaurant) {
    return reviewApi.addRestaurantReview(review, restaurant);
  }
}
