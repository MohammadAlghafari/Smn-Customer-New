import 'dart:convert';

class Notification {
  String id;
  String type;
  String message;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification(
      {required this.message,
      required this.id,
      required this.createdAt,
      required this.data,
      required this.read,
      required this.type});

  factory Notification.fromJSON(Map<String, dynamic> jsonMap) {
    return Notification(
      id: jsonMap['id'] != null ? jsonMap['id'].toString() : '',
      type: jsonMap['type'] != null ? jsonMap['type'].toString() : '',
      message: jsonMap['data'] != null
          ? json.decode(jsonMap['data'])['message'].toString()
          : '',
      data: jsonMap['data'] != null ? {} : {},
      read: jsonMap['read_at'] != null ? true : false,
      createdAt: jsonMap['created_at'] != null
          ? DateTime.parse(jsonMap['created_at'])
          :  DateTime(0),
    );
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
