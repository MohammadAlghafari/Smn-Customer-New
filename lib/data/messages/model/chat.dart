import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';

class Chat {
  String? id = UniqueKey().toString();

  // messages text
  String text;

  // time of the messages
  int time;

  // user id who send the messages
  String? userId;

  User user;

  Chat(
      {required this.text,
      required this.time,
      this.userId,
      this.id,
      required this.user});

  factory Chat.fromJSON(Map<String, dynamic> jsonMap) {
    return Chat(
        id: jsonMap['id'] != null ? jsonMap['id'].toString() : null,
        text: jsonMap['text'] != null ? jsonMap['text'].toString() : '',
        time: jsonMap['time'] != null ? jsonMap['time'] : 0,
        userId: jsonMap['user'] != null ? jsonMap['user'].toString() : null,
        user: User.fromJSON({}));
  }

  Map<String, dynamic> toMap() {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["text"] = text;
    map["time"] = time;
    map["user"] = userId;
    map["create_at"] = FieldValue.serverTimestamp();
    return map;
  }
}
