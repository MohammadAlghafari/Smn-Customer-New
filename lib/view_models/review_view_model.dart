import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/review/review_repo.dart';
import 'package:smn_delivery_app/smn_customer.dart';

class ReviewViewModel extends ChangeNotifier {
  ReviewRepo reviewRepo;
  Review restaurantReview = Review.fromJSON({'rate': '0'});
  bool isRestaurantReview = true;
  List<Food> foodsOfOrder = [];
  List<Review> foodsReviews = [];

  ReviewViewModel({required this.reviewRepo});

  init(Order order) {
    isRestaurantReview = true;
    for (var _foodOrder in order.foodOrders) {
      if (!foodsOfOrder.contains(_foodOrder.food)) {
        foodsOfOrder.add(_foodOrder.food);
      }
    }
    foodsReviews = List.generate(
        order.foodOrders.length, (_) => Review.fromJSON({'rate': '0'}));
  }

  void addFoodReview(int index) async {
    buildShowDialog(NavigationService.navigatorKey.currentState!.context);
    await reviewRepo.addFoodReview(foodsReviews[index], foodsOfOrder[index]);
    foodsReviews.removeAt(index);
    foodsOfOrder.removeAt(index);
    notifyListeners();
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  }

  void addRestaurantReview(Review review, Restaurant restaurant) async {
    buildShowDialog(NavigationService.navigatorKey.currentState!.context);
    await reviewRepo.addRestaurantReview(review, restaurant);
    isRestaurantReview = false;
    notifyListeners();
    Navigator.pop(NavigationService.navigatorKey.currentState!.context);
  }
}
