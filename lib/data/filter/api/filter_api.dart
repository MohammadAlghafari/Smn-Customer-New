import 'package:dio/dio.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/home/model/cuisine.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../smn_customer.dart';

class FilterApi{
  Dio dio;

  FilterApi({required this.dio});

  Future<List<Cuisine>> getCuisines() async {
    Uri uri = Uri.parse(url.getCuisines());
    try {
      final response = await dio.getUri(uri);
      print(response.data);
      return (response.data['data'] as List)
          .map<Cuisine>((json) => Cuisine.fromJSON(json))
          .toList();
    } catch (e) {
      showSnackBar(
          message: (AppLocalizations.of(
              NavigationService.navigatorKey.currentContext!)!
              .verify_your_internet_connection));
      return [];
    }
  }

}