import 'package:smn_delivery_app/data/home/model/food.dart';

abstract class CategoryInterface {
  Future<List<Food>> getFoodsByCategory(String id,int page);
}
