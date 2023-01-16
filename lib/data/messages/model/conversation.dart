import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';

class Conversation {
  String? id;

  // conversation name for example chat with restaurant name
  String? name;

  // Chats messages
  String? lastMessage;

  int? lastMessageTime;

  // Ids of users that read the chat messages
  List<String>? readByUsers;

  // Ids of users in this conversation
  List<String?>? visibleToUsers;

  // users in the conversation
  List<User>? users;

  // Conversation(this.users, {this.id = null, this.name = ''}) {
  //   visibleToUsers = this.users!.map((user) => user.id).toList();
  //   readByUsers = [];
  // }

  Conversation(
      {this.id,
      this.name,
      this.lastMessage,
      this.lastMessageTime,
      this.readByUsers,
      this.users,
      this.visibleToUsers});

  factory Conversation.fromJSON(Map<String, dynamic> jsonMap) {
    // try {
    //   id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
    //   name = jsonMap['name'] != null ? jsonMap['name'].toString() : '';
    //   readByUsers = jsonMap['read_by_users'] != null
    //       ? List.from(jsonMap['read_by_users'])
    //       : [];
    //   visibleToUsers = jsonMap['visible_to_users'] != null
    //       ? List.from(jsonMap['visible_to_users'])
    //       : [];
    //   lastMessage =
    //       jsonMap['messages'] != null ? jsonMap['messages'].toString() : '';
    //   lastMessageTime = jsonMap['time'] != null ? jsonMap['time'] : 0;
    //   users = jsonMap['users'] != null
    //       ? List.from(jsonMap['users']).map((element) {
    //           element['media'] = [
    //             {'thumb': element['thumb']}
    //           ];
    //           return User.fromJSON(element);
    //         }).toList()
    //       : [];
    // } catch (e) {
    //   id = '';
    //   name = '';
    //   readByUsers = [];
    //   users = [];
    //   lastMessage = '';
    //   lastMessageTime = 0;
    // }


    return Conversation(
        users:(jsonMap['users'] != null)
            ? List.from(jsonMap['users']).map((element) {
          element['media'] = [
            {'thumb': element['thumb']}
          ];
          return User.fromJSON(element);
        }).toList()
            : [],
        id: jsonMap['id'] != null ? jsonMap['id'].toString() : null,
        name: jsonMap['name'] != null ? jsonMap['name'].toString() : '',
        lastMessage:
            jsonMap['messages'] != null ? jsonMap['messages'].toString() : '',
        lastMessageTime: jsonMap['time'] != null ? jsonMap['time'] : 0,
        readByUsers: jsonMap['read_by_users'] != null
            ? List.from(jsonMap['read_by_users'])
            : [],
        visibleToUsers: jsonMap['visible_to_users'] != null
            ? List.from(jsonMap['visible_to_users'])
            : []);
  }

  factory Conversation.fromJSONRestaurant(Map<String, dynamic> jsonMap) {
    // try {
    //   id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
    //   name = jsonMap['name'] != null ? jsonMap['name'].toString() : '';
    //   readByUsers = jsonMap['read_by_users'] != null
    //       ? List.from(jsonMap['read_by_users'])
    //       : [];
    //   visibleToUsers = jsonMap['visible_to_users'] != null
    //       ? List.from(jsonMap['visible_to_users'])
    //       : [];
    //   lastMessage =
    //       jsonMap['messages'] != null ? jsonMap['messages'].toString() : '';
    //   lastMessageTime = jsonMap['time'] != null ? jsonMap['time'] : 0;
    //   users = jsonMap['users'] != null
    //       ? List.from(jsonMap['users']).map((element) {
    //           element['media'] = [
    //             {'thumb': element['thumb']}
    //           ];
    //           return User.fromJSON(element);
    //         }).toList()
    //       : [];
    // } catch (e) {
    //   id = '';
    //   name = '';
    //   readByUsers = [];
    //   users = [];
    //   lastMessage = '';
    //   lastMessageTime = 0;
    // }


    return Conversation(
        users: jsonMap['users']??[],
        id: jsonMap['id'] != null ? jsonMap['id'].toString() : null,
        name: jsonMap['name'] != null ? jsonMap['name'].toString() : '',
        lastMessage:
        jsonMap['messages'] != null ? jsonMap['messages'].toString() : '',
        lastMessageTime: jsonMap['time'] != null ? jsonMap['time'] : 0,
        readByUsers: jsonMap['read_by_users'] != null
            ? List.from(jsonMap['read_by_users'])
            : [],
        visibleToUsers: jsonMap['visible_to_users'] != null
            ? List.from(jsonMap['visible_to_users'])
            : []);
  }
  Map<String, dynamic> toMap() {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["users"] =
        users!.map((element) => element.toRestrictMap()).toSet().toList();
    map["visible_to_users"] =
        users!.map((element) => element.id).toSet().toList();
    map["read_by_users"] = readByUsers;
    map["messages"] = lastMessage;
    map["time"] = lastMessageTime;
    map["create_at"] = FieldValue.serverTimestamp();
    return map;
  }

  Map<String, dynamic> toUpdatedMap() {
    var map =  <String, dynamic>{};
    map["messages"] = lastMessage;
    map["time"] = lastMessageTime;
    map["read_by_users"] = readByUsers;
    map["create_at"] = FieldValue.serverTimestamp();
    return map;
  }
}
