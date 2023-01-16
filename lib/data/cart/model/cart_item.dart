import 'package:smn_delivery_app/data/home/model/extra.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

class CartItem {
  String? id;
  Food food;
  double quantity;
  List<Extra> extras;
  String userId;

  CartItem({
    required this.id,
    required this.food,
    required this.quantity,
    required this.extras,
    required this.userId,
  });

  factory CartItem.fromJSON(Map<String, dynamic> jsonMap) {
    return CartItem(
        id: jsonMap['id'].toString(),
        quantity:
            jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0,
        food: jsonMap['food'] != null
            ? Food.fromJSON(jsonMap['food'])
            : Food.fromJSON({}),
        extras: jsonMap['extras'] != null
            ? List.from(jsonMap['extras'])
                .map((element) => Extra.fromJSON(element))
                .toList()
            : [],
        userId: "");
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["food_id"] = food.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }

  double getFoodPrice() {
    double result = food.price;
    if (extras.isNotEmpty) {
      extras.forEach((Extra extra) {
        result += extra.price != null ? extra.price : 0;
      });
    }
    return result;
  }

  bool isSame(CartItem cart) {
    bool _same = true;
    _same &= food == cart.food;
    _same &= extras.length == cart.extras.length;
    if (_same) {
      for (var _extra in extras) {
        _same &= cart.extras.contains(_extra);
      }
    }
    return _same;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
