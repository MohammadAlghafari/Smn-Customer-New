import 'model/faq_category.dart';

abstract class FaqInterface{
  Future<List<FaqCategory>> getFaqCategories();
}