import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/models/media.dart';

class Restaurant {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String ?phone;
  String? mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  String avgTime;
  bool closed;
  bool availableForDelivery;
  bool hasLicense;
  double deliveryRange;
  double distance;
  List<User> users;

  Restaurant(
      {required this.id,
      required this.name,
      required this.image,
      required this.rate,
      required this.address,
      required this.description,
      required this.phone,
      required this.mobile,
      required this.information,
      required this.deliveryFee,
      required this.adminCommission,
      required this.defaultTax,
      required this.latitude,
      required this.longitude,
      required this.closed,
      required this.availableForDelivery,
      required this.hasLicense,
      required this.deliveryRange,
      required this.avgTime,
      required this.distance,
      required this.users});

  factory Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    return Restaurant(
      id: jsonMap['id'].toString(),
      name: jsonMap['name'] ?? "",
      image: jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty
          ? Media.fromJSON(jsonMap['media'][0])
          : Media.fromJSON({}),
      rate: jsonMap['rate'] ?? '0',
      deliveryFee: 0.0,
      // jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0,
      adminCommission: jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0,
      deliveryRange: jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0,
      address: jsonMap['address'] ?? "",
      description: jsonMap['description'] ?? "",
      phone: jsonMap['phone'] ?? "",
      mobile: jsonMap['mobile'] ?? "",
      defaultTax: jsonMap['default_tax'] != null
          ? double.parse(jsonMap['default_tax'].toString())
          : 0.0,
      information: jsonMap['information'] ?? "",
      latitude: jsonMap['latitude'] ?? "33.33",
      avgTime: jsonMap['avg_time'] ?? '',

      longitude: jsonMap['longitude'] ?? "33.33",
      closed: jsonMap['closed'] ?? false,
      availableForDelivery: jsonMap['available_for_delivery'] ?? false,
      hasLicense: jsonMap['has_license'] ?? false,
      distance: jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0,
      users: jsonMap['users'] != null && (jsonMap['users'] as List).isNotEmpty
          ? List.from(jsonMap['users'])
              .map((element) => User.fromJSON(element))
              .toSet()
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}
