
import 'package:smn_delivery_app/data/models/media.dart';

enum UserState { available, away, busy }

class User {
  String? id;
  String name;
  String email;

  String? password;
  String? apiToken;
  String? deviceToken;
  String? phone;
  bool? verifiedPhone;

  String? verificationId;
  String? address;
  String? bio;
  Media image;

  // used for indicate if client logged in or not
  bool auth;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.apiToken,
      required this.deviceToken,
      required this.phone,
      required this.address,
      required this.bio,
      required this.image,
      required this.auth,
      this.verifiedPhone,this.verificationId});

  factory User.fromJSON(Map<String, dynamic> jsonMap) {
    return User(
        id: jsonMap['id'].toString(),
        name: jsonMap['name'] ?? ' ',
        email: jsonMap['email'] ?? ' ',
        apiToken: jsonMap['api_token'] ?? "",
        deviceToken: jsonMap['device_token'] ?? "",
        phone: jsonMap['phone'] ?? "",
        /*verifiedPhone: jsonMap['custom_fields'] == null ||
                jsonMap['custom_fields']['verifiedPhone'] == null
            ? false
            : jsonMap['custom_fields']['verifiedPhone']['view'] == '1',*/
        verifiedPhone:true,
        address: jsonMap['address']??'',
        bio: jsonMap['custom_fields'] == null||jsonMap['custom_fields'].isEmpty
            ? ""
            : jsonMap['custom_fields']['bio']['view'],
        image: jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty
            ? Media.fromJSON(jsonMap['media'][0])
            : Media.fromJSON({}),
        auth: true);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "api_token": apiToken,
        "device_token": deviceToken,
        "phone": phone,
        "custom_fields": {
          "cart": {"view": address},
          "bio": {"view": bio},
          "verifiedPhone": {"view": verifiedPhone}
        },
        "media": [image.toMap()]
      };

  Map<String, dynamic> toMap() {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone;
    map["verifiedPhone"] = verifiedPhone;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image.toMap();
    return map;
  }
  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = image.thumb;
    map["device_token"] = deviceToken;
    return map;
  }
}
