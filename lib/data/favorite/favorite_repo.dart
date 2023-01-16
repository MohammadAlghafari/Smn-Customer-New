import 'package:smn_delivery_app/data/favorite/api/favorite_api.dart';
import 'package:smn_delivery_app/data/favorite/model/favorite.dart';

import 'favorite_interface.dart';

class FavoriteRepo implements FavoriteInterface {
  FavoriteApi favoriteApi;

  FavoriteRepo({required this.favoriteApi});

  @override
  Future<List<Favorite>> getFavorites() {
    return favoriteApi.getFavorites();
  }

  @override
  Future<Favorite> addFavorite(Favorite favorite) {
    return favoriteApi.addFavorite(favorite);
  }

  @override
  Future<Favorite> removeFavorite(Favorite favorite) {
    return favoriteApi.removeFavorite(favorite);
  }

  @override
  Future<Favorite?> isFavoriteFood(String foodId) {
    return favoriteApi.isFavoriteFood(foodId);
  }
}
