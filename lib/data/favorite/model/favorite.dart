import 'package:smn_delivery_app/data/home/model/extra.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

class Favorite {
  String id;
  Food food;
  List<Extra> extras;
  String userId;

  Favorite({
    required this.id,
    required this.food,
    required this.extras,
    required this.userId,
  });

  factory Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    return Favorite(
        id: jsonMap['id'].toString(),
        food: jsonMap['food'] != null
            ? Food.fromJSON(jsonMap['food'])
            : Food.fromJSON({}),
        extras: jsonMap['extras'] != null
            ? List.from(jsonMap['extras'])
                .map((element) => Extra.fromJSON(element))
                .toList()
            : [],
        userId: '');
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["food_id"] = food.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
