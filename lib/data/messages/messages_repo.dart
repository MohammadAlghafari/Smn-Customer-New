import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'api/messages_api.dart';
import 'messages_interface.dart';
import 'model/chat.dart';
import 'model/conversation.dart';

class MessagesRepo extends MessagesInterface {
  MessagesApi messagesApi;

  MessagesRepo({required this.messagesApi});

  @override
  Future<Stream<QuerySnapshot<Object?>>> getUserConversations(String userId) {
    return messagesApi.getUserConversations(userId);
  }

  @override
  Future<void> removeConversation(String conversationId) {
    return messagesApi.removeConversation(conversationId);
  }

  @override
  Future<Stream<QuerySnapshot>> getChats(Conversation conversation) {
    return messagesApi.getChats(conversation);
  }

  @override
  Future<void> addMessage(Conversation conversation, Chat chat) async {
    return messagesApi.addMessage(conversation, chat);
  }

  @override
  Future<void> createConversation(Conversation conversation) {
    return messagesApi.createConversation(conversation);
  }

  @override
  Future<Response> setChatInfo(
      String restaurant_id, String user_id, String conversation_id) {
    return messagesApi.setChatInfo(restaurant_id, user_id, conversation_id);
  }

  @override
  Future<Response?> setChatMessageInfo(String message, String restaurantId,
      String conversationId, String userId, String isCustomer) {
    return messagesApi.setChatMessageInfo(
        message, restaurantId, conversationId, userId, isCustomer);
  }

  @override
  Future<String> getConversation(List<String> owners) {
    return messagesApi.getConversation(owners);
  }
}
