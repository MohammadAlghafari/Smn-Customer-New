import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/search/api/search_api.dart';
import 'package:smn_delivery_app/data/search/search_interface.dart';

class SearchRepo implements SearchInterface {
  SearchApi searchApi;

  SearchRepo({required this.searchApi});

  @override
  Future<List<Restaurant>> searchRestaurants({String? search}) async {
    search ??= await searchApi.getRecentSearch();
    return await searchApi.searchRestaurants(search);
  }

  @override
  Future<List<Food>> searchFoods({String? search}) async {
    search ??= await searchApi.getRecentSearch();
    return await searchApi.searchFoods(search);
  }

  @override
  Future<String> getRecentSearch() async {
    return searchApi.getRecentSearch();
  }

  @override
  void saveSearch(String search) {
    searchApi.setRecentSearch(search);
  }

  @override
  void setRecentSearch(String search) {
    searchApi.setRecentSearch(search);
  }
}
