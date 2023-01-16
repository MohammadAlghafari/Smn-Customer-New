import 'dart:async';

import 'package:dio/dio.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/faq/model/faq_category.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class FaqApi {
  Dio dio;

  AuthViewModel authViewModel;

  FaqApi({required this.authViewModel, required this.dio});

  Future<List<FaqCategory>> getFaqCategories() async {
    final String _apiToken =
        'api_token=${authViewModel.user == null ? '' : authViewModel.user!.apiToken}&';
    final response = await dio.get(url.getFaqCategories(_apiToken));
    return (response.data['data'] as List)
        .map<FaqCategory>((json) => FaqCategory.fromJSON(json))
        .toList();
  }
}
