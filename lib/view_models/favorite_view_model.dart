import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/data/favorite/favorite_repo.dart';
import 'package:smn_delivery_app/data/favorite/model/favorite.dart';
import 'package:smn_delivery_app/data/home/model/extra.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

class FavoriteViewModel extends ChangeNotifier {
  bool loadingData = true;
  List<Favorite> favorites = [];
  Favorite? favorite;
  FavoriteRepo favoriteRepo;

  FavoriteViewModel({required this.favoriteRepo}) {
    getFavorites();
  }

  void listenForFavorite({required String foodId}) async {
    favorite = await favoriteRepo.isFavoriteFood(foodId);
  }

  Future<void> getFavorites() async {
    favorites = await favoriteRepo.getFavorites();
    notifyListeners();
  }

  Future<void> refreshFavorites() async {
    favorites.clear();
    await getFavorites();
  }

  addToFavorite(Food food) async {
    var _favorite = Favorite.fromJSON({});
    _favorite.food = food;
    _favorite.extras = food.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    await favoriteRepo.addFavorite(_favorite);
    refreshFavorites();
  }

  Future<void> removeFavorite() async {
    if (favorite == null) return;
    favoriteRepo.removeFavorite(favorite!);
    refreshFavorites();

  }
}
