import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/model/message.dart';

class ChatService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getChatRoomId (String userId, String otherUserId){
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return chatRoomId;
  }

  //sending the message
  Future<void> sendMessage (String recieverId, String message) async {
    print('SENDING MESSAGE');
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: recieverId,
      message: message,
      timestamp: timestamp,
      read : false,
    );

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .collection("messages")
    .add(newMessage.toMap());

    await _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .set({
      "members" : ids, //list of members in the chat room
      "last_message" : message,
      "chat_room_id" : chatRoomId,
    },SetOptions(merge: true));

  }

  //getting the messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .collection("messages")
    .orderBy("timestamp",descending: false)
    .snapshots();
  }

  Future<List<Map<String, dynamic>>> getUnreadMessages(String chatRoomId) async {
  final QuerySnapshot<Map<String, dynamic>> unreadMessagesQuery =
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection("messages")
          .where("receiverId", isEqualTo: _firebaseAuth.currentUser!.uid)
          .where('read', isEqualTo: false)
          .get();

      final List<Map<String, dynamic>> unreadMessages = [];

      for (final doc in unreadMessagesQuery.docs) {
        final messageData = doc.data();
        messageData['messageId'] = doc.id; // Store the document ID in the message data
        unreadMessages.add(messageData);
      }
      return unreadMessages;
    }

  Future<void> setReadMessages(String userId, String otherUserId) async {
    final chatRoomId = getChatRoomId(userId, otherUserId);
    final unreadMessages = await getUnreadMessages(chatRoomId);

    for(var messages in unreadMessages){

      final messageId = messages['messageId'];

      await _firestore.collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .doc(messageId)
      .update({
        'read': true,
      });

    }
  } 

  Future<int> getUnreadMessagesCount(String chatRoomId) async {
    final unreadMessages = await getUnreadMessages(chatRoomId);
    print('number of unread messages : ${unreadMessages.length}');
    return unreadMessages.length;
  }
  
}
