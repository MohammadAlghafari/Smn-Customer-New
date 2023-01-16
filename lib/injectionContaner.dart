import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/data/category/api/category_api.dart';
import 'package:smn_delivery_app/data/category/category_repo.dart';
import 'package:smn_delivery_app/data/faq/api/faq_api.dart';
import 'package:smn_delivery_app/data/favorite/api/favorite_api.dart';
import 'package:smn_delivery_app/data/favorite/favorite_repo.dart';
import 'package:smn_delivery_app/data/filter/api/filter_api.dart';
import 'package:smn_delivery_app/data/filter/filter_repo.dart';
import 'package:smn_delivery_app/data/notifications/api/notifications_api.dart';
import 'package:smn_delivery_app/data/restaurants/api/restaurants_api.dart';
import 'package:smn_delivery_app/data/review/api/review_api.dart';
import 'package:smn_delivery_app/data/review/review_repo.dart';
import 'package:smn_delivery_app/data/search/api/search_api.dart';
import 'package:smn_delivery_app/data/search/search_repo.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/category_view_model.dart';
import 'package:smn_delivery_app/view_models/faq_veiw_model.dart';
import 'package:smn_delivery_app/view_models/favorite_view_model.dart';
import 'package:smn_delivery_app/view_models/filter_view_model.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';
import 'package:smn_delivery_app/view_models/pickUp_delivery_view_model.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';
import 'package:smn_delivery_app/view_models/review_view_model.dart';
import 'package:smn_delivery_app/view_models/search_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

import 'data/auth/api/auth_api.dart';
import 'data/auth/auth_repo.dart';
import 'data/cart/api/cart_api.dart';
import 'data/cart/cart_repo.dart';
import 'data/faq/fac_repo.dart';
import 'data/home/api/home_api.dart';
import 'data/home/home_repo.dart';
import 'data/messages/api/messages_api.dart';
import 'data/messages/messages_repo.dart';
import 'data/notifications/notifications_repo.dart';
import 'data/order/api/order_api.dart';
import 'data/order/order_repo.dart';
import 'data/restaurants/restaurents_repo.dart';
import 'data/setting/api/settingApi.dart';
import 'data/setting/setting_repo.dart';

final si = GetIt.instance;

Future<void> init() async {
  /// Core
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('language')) {
    prefs.setString('language', 'en');
  }
  si.registerLazySingleton(() => prefs);
  Dio dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      if (prefs.containsKey('language')) {
        options.headers['language'] = prefs.getString('language');
      }
      handler.next(options);
    },
  ));
  dio.options.headers['content-Type'] = 'application/json';

  si.registerLazySingleton(() => dio);

  /// Provider
  si.registerLazySingleton(() => AuthViewModel(authRepo: si(), prefs: si()));
  si.registerLazySingleton(
      () => HomeViewModel(homeRepo: si(), authViewModel: si()));
  si.registerLazySingleton(
      () => SettingViewModel(settingRepo: si(), prefs: si()));
  si.registerLazySingleton(() => RestaurantsViewModel(
      restaurantsRepo: si(), settingViewModel: si(), authViewModel: si()));
  si.registerLazySingleton(() => CategoryViewModel(categoryRepo: si()));
  si.registerLazySingleton(
      () => CartViewModel(cartRepo: si(), authViewModel: si()));
  si.registerLazySingleton(() => FaqViewModel(faqRepo: si()));
  si.registerLazySingleton(() => OrderViewModel(orderRepo: si()));
  si.registerLazySingleton(() => FavoriteViewModel(favoriteRepo: si()));
  si.registerLazySingleton(() => PickupDeliveryViewModel(authViewModel: si()));
  si.registerLazySingleton(
      () => FilterViewModel(filterRepo: si(), prefs: si()));
  si.registerLazySingleton(
      () => NotificationsViewModel(notificationsRepo: si()));
  si.registerLazySingleton(() => MessagesViewModel(
      messagesRepo: si(), authViewModel: si(), notificationsViewModel: si()));
  si.registerLazySingleton(
      () => SearchViewModel(authRepo: si(), searchRepo: si()));
  si.registerLazySingleton(() => ReviewViewModel(reviewRepo: si()));

  /// Repos
  si.registerLazySingleton(() => AuthRepo(authApi: si()));
  si.registerLazySingleton(() => SettingRepo(settingApi: si()));
  si.registerLazySingleton(() => HomeRepo(homeApi: si()));
  si.registerLazySingleton(() => RestaurantsRepo(restaurantsApi: si()));
  si.registerLazySingleton(() => CategoryRepo(categoryApi: si()));
  si.registerLazySingleton(() => OrderRepo(orderApi: si()));
  si.registerLazySingleton(() => MessagesRepo(messagesApi: si()));
  si.registerLazySingleton(() => NotificationsRepo(notificationsApi: si()));
  si.registerLazySingleton(() => FaqRepo(faqApi: si()));
  si.registerLazySingleton(() => CartRepo(cartApi: si()));
  si.registerLazySingleton(() => FavoriteRepo(favoriteApi: si()));
  si.registerLazySingleton(() => FilterRepo(filterApi: si()));
  si.registerLazySingleton(() => SearchRepo(searchApi: si()));
  si.registerLazySingleton(() => ReviewRepo(reviewApi: si()));

  /// APIs Call
  si.registerLazySingleton(() => AuthApi(dio: si(), prefs: si()));
  si.registerLazySingleton(() => FaqApi(dio: si(), authViewModel: si()));
  si.registerLazySingleton(() => SettingApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => HomeApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(
      () => RestaurantsApi(authViewModel: si(), dio: si(), prefs: si()));
  si.registerLazySingleton(
      () => CategoryApi(prefs: si(), authViewModel: si(), dio: si()));
  si.registerLazySingleton(() =>
      NotificationsApi(authViewModel: si(), dio: si(), settingViewModel: si()));
  si.registerLazySingleton(() => OrderApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => MessagesApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => CartApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => FavoriteApi(authViewModel: si(), dio: si()));
  si.registerLazySingleton(() => FilterApi(dio: si()));
  si.registerLazySingleton(() => SearchApi(dio: si(), authViewModel: si()));
  si.registerLazySingleton(() => ReviewApi(dio: si(), authViewModel: si()));
}
