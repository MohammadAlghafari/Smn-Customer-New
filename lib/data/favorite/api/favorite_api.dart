import 'package:dio/dio.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/favorite/model/favorite.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class FavoriteApi {
  Dio dio;

  AuthViewModel authViewModel;

  FavoriteApi({required this.authViewModel, required this.dio});

  Future<List<Favorite>> getFavorites() async {
    if (authViewModel.user == null) {
      return [];
    }
    final response = await dio.get(url.getFavorite(
        apiToken: authViewModel.user!.apiToken!,
        userId: authViewModel.user!.id!));
    return (response.data['data'] as List)
        .map<Favorite>((json) => Favorite.fromJSON(json))
        .toList();
  }

  Future<Favorite> addFavorite(Favorite favorite) async {
    if (authViewModel.user == null) {
      return Favorite.fromJSON({});
    }
    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}';
    favorite.userId = authViewModel.user!.id!;
    try {
      final response = await dio.post(
        url.addFavorite(_apiToken),
        data: favorite.toMap(),
      );
      return Favorite.fromJSON(response.data['data']);
    } catch (e) {
      return Favorite.fromJSON({});
    }
  }

  Future<Favorite> removeFavorite(Favorite favorite) async {
    if (authViewModel.user == null) {
      return Favorite.fromJSON({});
    }
    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}';
    try {
      final response = await dio.delete(
        url.deleteFavorite(_apiToken, favorite.id),
      );
      return Favorite.fromJSON(response.data['data']);
    } catch (e) {
      return Favorite.fromJSON({});
    }
  }

  Future<Favorite?> isFavoriteFood(String foodId) async {
    if (authViewModel.user == null) {
      return null;
    }
    final String _apiToken = 'api_token=${authViewModel.user!.apiToken}&';
    try {
      final response = await dio
          .get(url.isFavorite(_apiToken, authViewModel.user!.id!, foodId));

      if (response.data['data'] == null) return null;
      return Favorite.fromJSON(response.data['data'] );
    } catch (e) {
      return null;
    }
  }
}
