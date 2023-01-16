import 'package:smn_delivery_app/data/models/media.dart';


class Category {
  String id;
  String name;
  Media image;

  Category({required this.id, required this.image, required this.name});

  factory Category.fromJSON(Map<String, dynamic> jsonMap) {
    return Category(
      id: jsonMap['id'].toString(),
      name: jsonMap['name']??"",
      image: jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty
          ? Media.fromJSON(jsonMap['media'][0])
          :  Media.fromJSON({}),
    );
  }
}
