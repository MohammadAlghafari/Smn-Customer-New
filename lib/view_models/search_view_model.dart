import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/data/auth/auth_repo.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/search/search_repo.dart';

class SearchViewModel extends ChangeNotifier {
  SearchRepo searchRepo;
  AuthRepo authRepo;
  List<Restaurant> restaurants = <Restaurant>[];
  List<Food> foods = <Food>[];
  bool loadingFoods = true;
  bool loadingRestaurants = true;

  SearchViewModel({required this.searchRepo, required this.authRepo}) {
    listenForRestaurants();
    listenForFoods();
  }

  listenForRestaurants({String? search}) async {
    search ??= await searchRepo.getRecentSearch();
    // Address _address = deliveryAddress.value;
    restaurants = await searchRepo.searchRestaurants(search: search);
    loadingRestaurants = false;
    notifyListeners();
  }

  listenForFoods({String? search}) async {
    search ??= await searchRepo.getRecentSearch();
    // Address _address = deliveryAddress.value;
    foods = await searchRepo.searchFoods(search: search);
    loadingFoods = false;
    notifyListeners();
  }

  Future<void> refreshSearch(search) async {
    bool loadingFoods = true;
    bool loadingRestaurants = true;
    restaurants = <Restaurant>[];
    foods = <Food>[];
    await listenForRestaurants(search: search);
    await listenForFoods(search: search);

  }

  void saveSearch(String search) {
    searchRepo.setRecentSearch(search);
  }
}
