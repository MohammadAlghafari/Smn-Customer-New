import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'model/chat.dart';
import 'model/conversation.dart';

abstract class MessagesInterface {
  Future<Stream<QuerySnapshot>> getUserConversations(String userId);

  Future<void> removeConversation(String conversationId);

  Future<Stream<QuerySnapshot>> getChats(Conversation conversation);

  Future<void> addMessage(Conversation conversation, Chat chat);

  Future<void> createConversation(Conversation conversation);

  Future<Response> setChatInfo(
      String restaurantId, String userId, String conversationId);
  Future<Response?> setChatMessageInfo(String message, String restaurantId,
      String conversationId, String userId, String isCustomer);

  Future<String> getConversation(List<String> owners);
}
