import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/home/home_repo.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/home/model/slide.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeRepo homeRepo;
  AuthViewModel authViewModel;
  List<Category> categories = <Category>[];
  List<Slide> slides = <Slide>[];
  List<Restaurant> nearByRestaurants = <Restaurant>[];
  List<Restaurant> allRestaurants = <Restaurant>[];
  List<Restaurant> popularRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<Food> trendingFoods = <Food>[];

  HomeViewModel({required this.homeRepo, required this.authViewModel}) {
    listenForTopRestaurants();
    listenForSlides();
    listenForTrendingFoods();
    listenForCategories();
    listenForPopularRestaurants();
    listenForRecentReviews();
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        getMoreAllRestaurants();
      }
    });
    getMoreAllRestaurants();
  }

  Future<void> applyFilter() async {
    await listenForTopRestaurants();
    listenForSlides();
    listenForTrendingFoods();
    listenForCategories();
    listenForPopularRestaurants();
    listenForRecentReviews();
  }

  Future<void> listenForSlides() async {
    slides = await homeRepo.getSlides();
    notifyListeners();
  }

  Future<void> listenForCategories() async {
    categories = await homeRepo.getCategories();
    notifyListeners();
  }

  Future<void> listenForTopRestaurants() async {
    nearByRestaurants = await homeRepo.getNearRestaurants(
        authViewModel.deliveryAddress, authViewModel.deliveryAddress);
    notifyListeners();
  }

  Future<void> listenForPopularRestaurants() async {
    popularRestaurants =
        await homeRepo.getPopularRestaurants(authViewModel.deliveryAddress);
    notifyListeners();
  }

  Future<void> listenForRecentReviews() async {
    recentReviews = await homeRepo.getRecentReviews();
    notifyListeners();
  }

  Future<void> listenForTrendingFoods() async {
    trendingFoods =
        await homeRepo.getTrendingFoods(authViewModel.deliveryAddress);
    notifyListeners();
  }

  Future<void> refreshHome() async {
    slides = <Slide>[];
    categories = <Category>[];
    nearByRestaurants = <Restaurant>[];
    popularRestaurants = <Restaurant>[];
    recentReviews = <Review>[];
    trendingFoods = <Food>[];
    await listenForSlides();
    await refreshAllRestaurant();
    await listenForTopRestaurants();
    await listenForTrendingFoods();
    await listenForCategories();
    await listenForPopularRestaurants();
    await listenForRecentReviews();
  }

  ///pagination
  static int page = 0;
  final ScrollController sc = ScrollController();
  bool isLoading = false;

  Future<void> getMoreAllRestaurants() async {
    isLoading = true;
    notifyListeners();
    page++;
    allRestaurants.addAll(await homeRepo.getMoreAllRestaurants(
        authViewModel.deliveryAddress, authViewModel.deliveryAddress, page));
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAllRestaurant() async {
    page = 1;
    allRestaurants.clear();
    allRestaurants.addAll(await homeRepo.getMoreAllRestaurants(
        authViewModel.deliveryAddress, authViewModel.deliveryAddress, page));
    isLoading = false;
    notifyListeners();
  }
}
