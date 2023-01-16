import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/faq/fac_repo.dart';
import 'package:smn_delivery_app/data/faq/model/faq_category.dart';

class FaqViewModel extends ChangeNotifier {
  bool loadingData = true;
  List<FaqCategory> faqs = <FaqCategory>[];
  FaqRepo faqRepo;

  FaqViewModel({required this.faqRepo}) {
    listenForFaqs();
  }

  void listenForFaqs({String? message}) async {
    faqs = await faqRepo.getFaqCategories();
    loadingData=false;
    notifyListeners();
  }

  Future<void> refreshFaqs() async {
    faqs.clear();
    print('refreshed');
    listenForFaqs(message: 'Faqs refreshed successfuly');
  }
}
