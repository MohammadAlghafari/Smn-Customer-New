class ExtraGroup {
  String id;
  String name;

  ExtraGroup({required this.name, required this.id});

  factory ExtraGroup.fromJSON(Map<String, dynamic> jsonMap) {
    return ExtraGroup(
      id: jsonMap['id'].toString(),
      name: jsonMap['name']??"",
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
