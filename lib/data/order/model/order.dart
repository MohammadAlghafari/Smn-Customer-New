import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';

import '../../home/model/food_order.dart';
import '../../home/model/payment.dart';
import 'order_status.dart';

class Order {
  String id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  bool active;
  DateTime dateTime;
  String date;
  String? time;
  User user;
  User? driver;
  Payment payment;
  Address ?deliveryAddress;
  double? total;

  bool? pickupOrDelivery;

  Order({
    required this.id,
    required this.user,
    required this.dateTime,
    required this.active,
    required this.date,
    required this.deliveryAddress,
    required this.deliveryFee,
    this.driver,
    required this.foodOrders,
    required this.hint,
    required this.orderStatus,
    required this.tax,
    required this.payment,
    required this.time,
    this.total,
  });

  factory Order.fromJSON(Map<String, dynamic> jsonMap) {
    return Order(
      id: jsonMap['id'].toString(),
      tax: jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0,
      deliveryFee: jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0,
      hint: jsonMap['hint'] != null ? jsonMap['hint'].toString() : '',
      active: jsonMap['active'] ?? false,
      orderStatus: jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({}),
      dateTime: jsonMap['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(jsonMap['updated_at']),
      date: jsonMap['date'] != null ? jsonMap['date'].toString() : '',
      time: jsonMap['time'] != null ? jsonMap['time'].toString() : '',
      user: jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({}),
      driver: jsonMap['driver'] != null
          ? User.fromJSON(jsonMap['driver'])
          : User.fromJSON({}),
      deliveryAddress: jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({}),
      payment: jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : Payment.fromJSON({}),
      foodOrders: jsonMap['food_orders'] != null
          ? List.from(jsonMap['food_orders'])
              .map((element) => FoodOrder.fromJSON(element))
              .toList()
          : [],
      total: jsonMap['total'] ?? 0.0,
    );
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["user_id"] = user.id;
    map["order_status_id"] = orderStatus.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map['date'] = date;
    map['time'] = time;
    map['pickupOrDelivery'] = pickupOrDelivery;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders.map((element) => element.toMap()).toList();
    map["payment"] = payment.toMap();
    if (deliveryAddress!=null) {
      map["delivery_address_id"] = deliveryAddress!.id;
    }
    map["total"] = total;
    return map;
  }

  Map editableMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    if (orderStatus.id != 'null') map["order_status_id"] = orderStatus.id;
    if (driver?.id != 'null') map["driver_id"] = driver?.id;
    print(driver?.id);
    map['hint'] = hint;
    map['tax'] = tax;
    map["delivery_fee"] = deliveryFee;
//    map["status"] = orderStatus?.id;
//    map["driver_id"] = orderStatus?.id;
    return map;
  }

  Map cancelMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    if (orderStatus.id != null && orderStatus.id == '1') {
      map["active"] = false;
    }
    return map;
  }

  bool canCancelOrder() {
    return this.active == true &&
        this.orderStatus.id == '1'; // 1 for order received status
  }

  bool canEditOrder() {
    return this.active == true &&
        this.orderStatus.id != '5' &&
        this.orderStatus.id != '6'; // 5 for order delivered status
  }
}
