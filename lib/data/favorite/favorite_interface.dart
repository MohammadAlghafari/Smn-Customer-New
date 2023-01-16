import 'model/favorite.dart';

abstract class FavoriteInterface{

  Future<List<Favorite>> getFavorites();
  Future<Favorite> addFavorite(Favorite favorite);
  Future<Favorite> removeFavorite(Favorite favorite);
  Future<Favorite?> isFavoriteFood(String foodId);
}