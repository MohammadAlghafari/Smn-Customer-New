import 'package:smn_delivery_app/data/models/media.dart';

class Cuisine {
  String id;
  String name;
  String description;
  Media image;
  bool selected;

  Cuisine({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.selected,
  });

  factory Cuisine.fromJSON(Map<String, dynamic> jsonMap) {
    return Cuisine(
      id: jsonMap['id'].toString(),
      name: jsonMap['name']??'',
      description: jsonMap['description']??'',
      image: jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty
          ? Media.fromJSON(jsonMap['media'][0])
          : Media.fromJSON({}),
      selected: jsonMap['selected'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    var map =  <String, dynamic>{};
    map['id'] = id;
    return map;
  }

  @override
  bool operator == (dynamic other) {
    return other.id == id;
  }

  @override
  int get hashCode => super.hashCode;


}
