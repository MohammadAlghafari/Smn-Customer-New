import 'package:smn_delivery_app/data/models/media.dart';

class Gallery {
  String id;
  Media image;
  String description;

  Gallery({required this.id, required this.image, required this.description});

  factory Gallery.fromJSON(Map<String, dynamic> jsonMap) {
    return Gallery(
      id: jsonMap['id'].toString(),
      image: jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : Media.fromJSON({}),
      description: jsonMap['description'],
    );
  }
}
