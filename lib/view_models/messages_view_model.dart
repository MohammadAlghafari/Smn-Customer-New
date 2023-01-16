import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/messages/messages_repo.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';

import '../smn_customer.dart';

class MessagesViewModel extends ChangeNotifier {
  MessagesRepo messagesRepo;
  AuthViewModel authViewModel;
  NotificationsViewModel notificationsViewModel;
  Conversation? conversation;
  late Stream<QuerySnapshot> conversations;
  Stream<QuerySnapshot>? chats;
  Restaurant? restaurant;
  bool loadingConversations = true;
  bool loadingConversation = true;
  bool loadingChats = true;

  MessagesViewModel(
      {required this.messagesRepo,
      required this.authViewModel,
      required this.notificationsViewModel});

  listenForConversations() async {
    if (authViewModel.user == null) return;
    loadingConversations = true;
    messagesRepo
        .getUserConversations(authViewModel.user!.id!)
        .then((snapshots) {
      conversations = snapshots;
      loadingConversations = false;
      notifyListeners();
    });
  }

  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.docs;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }

  Future<void> removeConversation(
    String conversationId,
  ) async {
    return await messagesRepo.removeConversation(conversationId);
  }

  listenForChats(Conversation _conversation) async {
    // if (_conversation.lastMessage!.isEmpty) return;
    loadingChats = true;
    if (!_conversation.readByUsers!.contains(authViewModel.user!.id!)) {
      _conversation.readByUsers!.add(authViewModel.user!.id!);
    }
    await messagesRepo.getChats(_conversation).then((snapshots) {
      chats = snapshots;
      loadingConversation = false;
      loadingChats = false;
      notifyListeners();
    });
  }

  addMessage(
      Conversation? _conversation, String text, int len, String restaurantId,
      {Restaurant? restaurant}) async {
    Chat _chat = Chat(
        text: text,
        time: DateTime.now().toUtc().millisecondsSinceEpoch,
        userId: authViewModel.user!.id,
        user: authViewModel.user!);
    if (_conversation == null) {
      _conversation = Conversation.fromJSON({});
      _conversation.id = UniqueKey().toString();
      _conversation.readByUsers = [
        restaurant!.users[0].id!,
        authViewModel.user!.id!
      ];
      _conversation.visibleToUsers = [
        restaurant.users[0].id!,
        authViewModel.user!.id!
      ];
      _conversation.lastMessage = text;
      _conversation.lastMessageTime = _chat.time;
      _conversation.users = [restaurant.users[0], authViewModel.user!];
      await createConversation(_conversation);
    } else {
      _conversation.readByUsers = [authViewModel.user!.id!];
      _conversation.lastMessage = text;
      _conversation.lastMessageTime = _chat.time;
    }

    messagesRepo.addMessage(_conversation, _chat).then((value) async {
      for (var i = 0; i < _conversation!.users!.length; i++) {
        /// set data of messages on php host
        if (len == 0) {
          print("not chat found");
          await messagesRepo.setChatInfo(
              restaurantId, "${authViewModel.user!.id}", "${_conversation.id}");
        }
        await messagesRepo.setChatMessageInfo(text, restaurantId,
            _conversation.id!, authViewModel.user!.id.toString(), "0");
        notificationsViewModel.sendNotification(
            text,
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                    .newMessageFrom +
                " " +
                authViewModel.user!.name,
            _conversation.users![i]);
        break;
      }
    });
  }

  createConversation(Conversation _conversation) async {
    conversation = _conversation;
    await messagesRepo.createConversation(_conversation).then((value) async {
      await listenForChats(_conversation);
    });
  }

  Future<String> getConversation(List<String> owners) async {
    return messagesRepo.getConversation(owners);
  }

  initialConversation(Restaurant? restaurant) async {
    this.restaurant = restaurant;
    loadingConversation = true;
    List<String> chatOwners = [];
    for (int i = 0; i < restaurant!.users.length; i++) {
      chatOwners.add(restaurant.users[i].id!);
    }
    if (authViewModel.user == null) return;
    chatOwners.add(authViewModel.user!.id!);
    List<User> users = restaurant.users.map((e) {
      e.image = restaurant.image;
      return e;
    }).toList();
    users.add(authViewModel.user!);
    var id = await messagesRepo.getConversation(chatOwners);
    if (id.isEmpty) {
      //1646547259791
      //1646547238527
      //1646547245381
      //1646547245381
      // await createConversation(Conversation.fromJSONRestaurant(
      //     {"users": users, "name": restaurant!.name, "id": id}));
      // listenForChats(conversation);
      chats = null;
      conversation = null;
      loadingConversation = false;
      notifyListeners();
    } else {
      conversation = Conversation.fromJSONRestaurant({
        "users": users,
        "name": restaurant.name,
        "id": id,
        'messages': 'messages'
      });
      listenForChats(conversation!);
    }
  }
}
