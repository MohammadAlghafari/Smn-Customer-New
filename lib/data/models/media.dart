import 'package:smn_delivery_app/const/url.dart' as urlConst;

class Media {
  String? id;
  String? name;
  String? url;
  String? thumb;
  String? icon;
  String? size;

  // Media() {
  //   url = "${urlConst.baseUrl}images/image_default.png";
  //   thumb = "${urlConst.baseUrl}images/image_default.png";
  //   icon = "${urlConst.baseUrl}images/image_default.png";
  // }

  Media({this.id, this.name, this.icon, this.size, this.thumb, this.url});

  factory Media.fromJSON(Map<String, dynamic> jsonMap) {
    // try {
    //   id = jsonMap['id'].toString();
    //   name = jsonMap['name'];
    //   url = jsonMap['url'];
    //   thumb = jsonMap['thumb'];
    //   icon = jsonMap['icon'];
    //   size = jsonMap['formated_size'];
    // } catch (e) {
    //   url = "${urlConst.baseUrl}images/image_default.png";
    //   thumb = "${urlConst.baseUrl}images/image_default.png";
    //   icon = "${urlConst.baseUrl}images/image_default.png";
    // }
    return Media(
      id: jsonMap['id'].toString(),
      name: jsonMap['name'],
      url: jsonMap['url'] ?? "${urlConst.baseUrl}images/image_default.png",
      thumb: jsonMap['thumb'] ?? "${urlConst.baseUrl}images/image_default.png",
      icon: jsonMap['icon'] ?? "${urlConst.baseUrl}images/image_default.png",
      size: jsonMap['formated_size'] ?? "",
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
