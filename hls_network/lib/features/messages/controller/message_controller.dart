import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/message_api.dart';
import 'package:hls_network/models/chat_contact.dart';
import 'package:hls_network/models/messages.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/utils.dart';
import 'package:uuid/uuid.dart';

final messageControllerProvider =
    StateNotifierProvider<MessageController, bool>((ref) {
  return MessageController(
    messageAPI: ref.watch(messageAPIProvider),
  );
});

final usersChatProvider=StreamProvider.family((ref , String currentUser){
  final messageController=ref.watch(messageControllerProvider.notifier);
  return messageController.chatContacts(currentUser);
});

class MessageController extends StateNotifier<bool> {
  final MessageAPI _messageAPI;
  MessageController({required MessageAPI messageAPI})
      : _messageAPI = messageAPI,
        super(false);

  Stream<List<Message>> chatStream(String senderUserId, String recieverUserId) {
    return _messageAPI.getChatStream(senderUserId, recieverUserId);
  }

 Stream<List<ChatContact>> chatContacts(String currentUserId) {
    return _messageAPI.getChatContacts(currentUserId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required UserModel receiver,
    required UserModel sender,
  }) async {
    String id = const Uuid().v1();
    final message = Message(
      text: text,
      receiverid: receiver.uid,
      timeSent: DateTime.now(),
      id: id,
      senderId: sender.uid,
      isSeen: false,
    );
    final res = await _messageAPI.sendTextMessage(message, sender,receiver);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

   void setChatMessageSeen(
    String recieverUserId,
    String currentUserId,
    String messageId,
  ) async {
    await _messageAPI.setChatMessageSeen(
      recieverUserId,
      currentUserId,
      messageId,
    );
  }

  void deleteMessage(String chatId, String currentUserId) async {
  final res = await _messageAPI.deleteMessage(chatId, currentUserId);
  res.fold((l) => null, (r) => null);
}
}
