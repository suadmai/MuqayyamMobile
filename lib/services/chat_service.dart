import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/model/message.dart';

class ChatService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sending the message
  Future<void> sendMessage (String recieverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: recieverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .set({
      "members" : ids, //list of members in the chat room
      "last_message" : message,
    });SetOptions(merge: true);

    await _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .collection("messages")
    .add(newMessage.toMap());
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
  

  
}
