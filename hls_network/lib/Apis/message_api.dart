import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/chat_contact.dart';
import 'package:hls_network/models/messages.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/providers/firebase_providers.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';

final messageAPIProvider = Provider((ref) {
  return MessageAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

abstract class IMessageAPI {
  FutureEitherVoid sendTextMessage(
      Message message, UserModel sender, UserModel receiver);
  FutureEitherVoid deleteMessage(String messageId, String currentUserId);
  Stream<List<ChatContact>> getChatContacts(String currentUserId);
  Stream<List<Message>> getChatStream(
      String senderUserId, String recieverUserId);
  FutureEitherVoid setChatMessageSeen(
    String recieverUserId,
    String currentUserId,
    String messageId,
  );
}

class MessageAPI implements IMessageAPI {
  final FirebaseFirestore _firestore;

  MessageAPI({required FirebaseFirestore firestore}) : _firestore = firestore;

  @override
  Stream<List<Message>> getChatStream(
      String senderUserId, String recieverUserId) {
    return _firestore
        .collection('messages')
        .doc(senderUserId)
        .collection('chats')
        .doc(recieverUserId)
        .collection('conversations')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  @override
  FutureEitherVoid sendTextMessage(
      Message message, UserModel sender, UserModel receiver) async {
    try {
      await _firestore
          .collection('messages')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.receiverid)
          .collection('conversations')
          .doc(message.id)
          .set(message.toMap());

      await _firestore
          .collection('messages')
          .doc(message.receiverid)
          .collection('chats')
          .doc(message.senderId)
          .collection('conversations')
          .doc(message.id)
          .set(message.toMap());

      var recieverChatContact = ChatContact(
        name: sender.fullName,
        profilePic: sender.profilePic,
        contactId: sender.uid,
        timeSent: message.timeSent,
        lastMessage: message.text,
      );
      await _firestore
          .collection('users')
          .doc(receiver.uid)
          .collection('chats')
          .doc(sender.uid)
          .set(
            recieverChatContact.toMap(),
          );
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContact(
        name: receiver.fullName,
        profilePic: receiver.profilePic,
        contactId: receiver.uid,
        timeSent: message.timeSent,
        lastMessage: message.text,
      );
      await _firestore
          .collection('users')
          .doc(sender.uid)
          .collection('chats')
          .doc(receiver.uid)
          .set(
            senderChatContact.toMap(),
          );

      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<List<ChatContact>> getChatContacts(String currentUserId) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await _firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.fullName,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  @override
  FutureEitherVoid deleteMessage(String chatId, String currentUserId) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc(chatId)
          .delete();
      await _firestore
          .collection('messages')
          .doc(currentUserId)
          .collection('chats')
          .doc(chatId)
          .delete();

      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid setChatMessageSeen(
    String recieverUserId,
    String currentUserId,
    String messageId,
  ) async {
    try {
      await _firestore
          .collection('messages')
          .doc(currentUserId)
          .collection('chats')
          .doc(recieverUserId)
          .collection('conversations')
          .doc(messageId)
          .update({'isSeen': true});

      await _firestore
          .collection('messages')
          .doc(recieverUserId)
          .collection('chats')
          .doc(currentUserId)
          .collection('conversations')
          .doc(messageId)
          .update({'isSeen': true});
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
