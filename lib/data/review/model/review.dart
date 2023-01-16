import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

import '../../home/model/food.dart';

class Review {
  String id;
  String review;
  String rate;
  User user;

  Review({
    required this.id,
    required this.user,
    required this.rate,
    required this.review,
  });

  // Review.init(this.rate);

  factory Review.fromJSON(Map<String, dynamic> jsonMap) {
    return Review(
      id: jsonMap['id'].toString(),
      review: jsonMap['review']??"",
      rate: jsonMap['rate'].toString() ,
      user: jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({}),
    );
  }

  Map toMap() {
    var map =  Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofRestaurantToMap(Restaurant restaurant) {
    var map = this.toMap();
    map["restaurant_id"] = restaurant.id;
    return map;
  }

  Map ofFoodToMap(Food food) {
    var map = this.toMap();
    map["food_id"] = food.id;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
