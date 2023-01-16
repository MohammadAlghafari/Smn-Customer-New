import 'package:smn_delivery_app/data/filter/api/filter_api.dart';
import 'package:smn_delivery_app/data/filter/filter_interface.dart';
import 'package:smn_delivery_app/data/home/model/cuisine.dart';

class FilterRepo implements FilterInterface {
  FilterApi filterApi;

  FilterRepo({required this.filterApi});

  @override
  Future<List<Cuisine>> getCuisines() {
    return filterApi.getCuisines();
  }
}
