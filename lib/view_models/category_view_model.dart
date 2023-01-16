import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/data/category/category_repo.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

class CategoryViewModel extends ChangeNotifier {
  List<Food> foods = <Food>[];

  CategoryRepo categoryRepo;

  ///pagination
  static int page = 0;
  final ScrollController sc = ScrollController();
  bool isLoading = false;
  late String id;
  CategoryViewModel({required this.categoryRepo});

  void listenForFoodsByCategory({required String id}) async {
    this.id=id;
    foods.clear();
    page = 0;
    getMoreAllRestaurants(id: id);
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        getMoreAllRestaurants(id: this.id);
      }
    });
    // foods = await categoryRepo.getFoodsByCategory(id);
  }

  Future<void> getMoreAllRestaurants({required String id}) async {
    isLoading = true;
    if (page != 0) notifyListeners();
    page++;
    foods.addAll(await categoryRepo.getFoodsByCategory(id, page));
    isLoading = false;
    notifyListeners();
  }
}
