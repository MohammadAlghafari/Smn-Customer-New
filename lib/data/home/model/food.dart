import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/data/models/media.dart';

import '../../restaurants/model/restaurant.dart';
import 'category.dart';
import 'extra.dart';
import 'extra_group.dart';
import 'nutrition.dart';

class Food {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String weight;
  String unit;
  String packageItemsCount;
  bool featured;
  bool deliverable;
  bool isFavorite;
  Restaurant restaurant;
  Category category;
  List<Extra> extras;
  List<ExtraGroup> extraGroups;
  List<Review> foodReviews;
  List<Nutrition> nutritions;

  Food(
      {required this.name,
      required this.image,
      required this.description,
      required this.id,
      required this.price,
      required this.extras,
      required this.isFavorite,
      required this.category,
      required this.deliverable,
      required this.discountPrice,
      required this.extraGroups,
      required this.featured,
      required this.foodReviews,
      required this.ingredients,
      required this.nutritions,
      required this.packageItemsCount,
      required this.restaurant,
      required this.unit,
      required this.weight});

  factory Food.fromJSON(Map<String, dynamic> jsonMap) {
    return Food(
      id: jsonMap['id'].toString(),
      name: jsonMap['name'] ?? "",
      isFavorite: jsonMap['is_favorite'] == 0,
      price: jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0,
      discountPrice: jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0,
      description: jsonMap['description'] ?? "",
      ingredients: jsonMap['ingredients'] ?? "",
      weight: jsonMap['weight'] != null ? jsonMap['weight'].toString() : '',
      unit: jsonMap['unit'] != null ? jsonMap['unit'].toString() : 'g',
      packageItemsCount: jsonMap['package_items_count'] != null
          ? jsonMap['package_items_count'].toString()
          : '1',
      featured: jsonMap['featured'] ?? false,
      deliverable: jsonMap['deliverable'] ?? false,
      restaurant: jsonMap['restaurant'] != null
          ? Restaurant.fromJSON(jsonMap['restaurant'])
          : Restaurant.fromJSON({}),
      category: jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : Category.fromJSON({}),
      image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : Media.fromJSON({}),
      extras:
          jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
              ? List.from(jsonMap['extras'])
                  .map((element) => Extra.fromJSON(element))
                  .toSet()
                  .toList()
              : [],
      extraGroups: jsonMap['extra_groups'] != null &&
              (jsonMap['extra_groups'] as List).length > 0
          ? List.from(jsonMap['extra_groups'])
              .map((element) => ExtraGroup.fromJSON(element))
              .toSet()
              .toList()
          : [],
      foodReviews: jsonMap['approved_reviews'] != null &&
              (jsonMap['approved_reviews'] as List).isNotEmpty
          ? List.from(jsonMap['approved_reviews'])
              .map((element) => Review.fromJSON(element))
              .toSet()
              .toList()
          : [],
      nutritions: jsonMap['nutrition'] != null &&
              (jsonMap['nutrition'] as List).length > 0
          ? List.from(jsonMap['nutrition'])
              .map((element) => Nutrition.fromJSON(element))
              .toSet()
              .toList()
          : [],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["ingredients"] = ingredients;
    map["weight"] = weight;
    return map;
  }

  double getRate() {
    double _rate = 0;
    foodReviews.forEach((e) => _rate += double.parse(e.rate));
    _rate = _rate > 0 ? (_rate / foodReviews.length) : 0;
    return _rate;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
