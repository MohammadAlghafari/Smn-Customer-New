import 'package:smn_delivery_app/data/models/media.dart';


class Extra {
  String id;
  String extraGroupId;
  String name;
  double price;
  Media image;
  String description;
  bool checked;

  Extra({required this.price,required this.id,required this.description,required this.image,required this.name,required this.checked,required this.extraGroupId});

  factory Extra.fromJSON(Map<String, dynamic> jsonMap) {
    return Extra(
        id : jsonMap['id'].toString(),
        extraGroupId: jsonMap['extra_group_id'] != null ? jsonMap['extra_group_id'].toString() : '0',
    name : jsonMap['name'].toString(),
    price : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0,
    description : jsonMap['description']??"",
    checked : false,
    image : jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media(),

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
