import 'package:dio/dio.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class ReviewApi {
  Dio dio;
  AuthViewModel authViewModel;

  ReviewApi({required this.dio, required this.authViewModel});

  Future<Review> addFoodReview(Review review, Food food) async {
    review.user = authViewModel.user!;
    try {
      final response =
          await dio.post(url.foodReviews(), data: review.ofFoodToMap(food));

      if (response.statusCode == 200) {
        return Review.fromJSON(response.data['data']);
      } else {
        return Review.fromJSON({});
      }
    } catch (e) {
      return Review.fromJSON({});
    }
  }

  Future<Review> addRestaurantReview(
      Review review, Restaurant restaurant) async {
    review.user.id=authViewModel.user!.id!;
    try {
      final response = await dio.post(url.restaurantReviews(),
          data: review.ofRestaurantToMap(restaurant));

      if (response.statusCode == 200) {
        return Review.fromJSON(response.data['data']);
      } else {
        return Review.fromJSON({});
      }
    } catch (e) {
      return Review.fromJSON({});
    }
  }
}
