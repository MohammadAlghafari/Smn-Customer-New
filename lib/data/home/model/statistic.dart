import 'package:flutter/material.dart';

class Statistic {
  String id;
  String value;
  String description;
  Color? textColor;
  Color? backgroundColor;

  Statistic({
    required this.id,
    required this.value,
    required this.description,
    this.textColor,
    this.backgroundColor,
  });

  factory Statistic.fromJSON(Map<String, dynamic> jsonMap) {
    return Statistic(
        id: jsonMap['id'].toString(),
        value: jsonMap['value'].toString(),
        description: jsonMap['description'].toString() );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["value"] = value;
    map["description"] = description;
    return map;
  }
}
