import 'package:smn_delivery_app/data/home/model/cuisine.dart';

abstract class FilterInterface{
  Future<List<Cuisine>> getCuisines();
}