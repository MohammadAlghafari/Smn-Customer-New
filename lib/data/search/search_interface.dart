import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

abstract class SearchInterface {
  Future<List<Restaurant>> searchRestaurants({String? search});

  Future<List<Food>> searchFoods({String? search});

  Future<String> getRecentSearch();

  void saveSearch(String search);

  void setRecentSearch(String search);
}
