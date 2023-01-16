import 'package:smn_delivery_app/data/category/api/category_api.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

import 'category_interface.dart';

class CategoryRepo implements CategoryInterface {
  CategoryApi categoryApi;
  CategoryRepo({required this.categoryApi});

  @override
  Future<List<Food>> getFoodsByCategory(String id,int page)async {
    return categoryApi.getFoodsByCategory(id,page);
  }
}
