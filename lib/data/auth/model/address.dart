import 'package:location/location.dart';

class Address {
  String id;
  String description;
  String? address;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;

  Address(
      {required this.id,
      this.address,
      required this.description,
      required this.isDefault,
      required this.userId,
      required this.latitude,
      required this.longitude});

  factory Address.fromJSON(Map<String, dynamic> jsonMap) {
    return Address(
        id: jsonMap['id'].toString(),
        description: jsonMap['description'] != null
            ? jsonMap['description'].toString()
            : "",
        address: jsonMap['address'],
        latitude:
            jsonMap['latitude'] != null ? jsonMap['latitude'].toDouble() : 0.0,
        longitude: jsonMap['longitude'] != null
            ? jsonMap['longitude'].toDouble()
            : 0.0,
        isDefault: jsonMap['is_default'] ?? false,
        userId: "");
  }

  bool isUnknown() {
    return latitude == 0.0 && longitude == 0.0;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  bool isSameAddress(Address e) {
    return double.parse((e.longitude).toStringAsFixed(3)) ==
            double.parse((longitude).toStringAsFixed(3)) &&
        double.parse((e.latitude).toStringAsFixed(3)) ==
            double.parse((latitude).toStringAsFixed(3));
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
