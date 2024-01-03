// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/components/layout.dart';
import '../services/chat_service.dart';

import '../firebase/firebase_config.dart';
import 'chat.dart';

class ContactExpert extends StatefulWidget {
  const ContactExpert({Key? key}) : super(key: key);
  @override
  State<ContactExpert> createState() => _ContactExpertState();
}


class _ContactExpertState extends State<ContactExpert> with SingleTickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Hubungi pakar"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text('Senarai Pakar', style: TextStyle(fontSize: 18),)),
            Tab(child: Text('Perbualan', style: TextStyle(fontSize: 18),)),
          ],
        ),
      ),

      body:
      TabBarView(
        controller: _tabController,
        children: [
          _buildSenaraiPakarTab(),
          _buildPerbualanTab(),
        ],
      ),
    );
  }
}

  Widget _buildSenaraiPakarTab() {

    FirebaseFirestore firestore = FirebaseConfig.firestore;
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[

          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Senarai pakar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('users')
        .where('role', isEqualTo: 'Doktor')
        .where('userID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)//taknak tunjuk diri sendiri
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doctors = snapshot.data!.docs;
            return 
                Expanded(
                  child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index].data();
                    final pfpURL = doctor['profilePicture'] as String?;
                    final userID = doctor['userID'] as String?;
                    final userEmail = doctor['email'] as String?;
                    final username = doctor['username'] as String?;

                    return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(
                                    receiverUserID: userID!,
                                    receiverUserName: username!,
                                    receiverUserEmail: userEmail!,), // Pass the userID to the ChatPage
                                ),
                              );
                            },
                            child: Column(
                                children: [
                                  ListTile(
                                    leading: 
                                    CircleAvatar(
                                      backgroundImage: pfpURL != null
                                          ? NetworkImage(pfpURL)
                                          : null, // Display the profile picture if available
                                      child: pfpURL == null
                                          ? const Icon(Icons.person, color: Colors.white)
                                          : null, // Show an icon if no profile picture is available
                                    ),
                                    title: Text(
                                      '$username',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            );
                  },
                ),
                );
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
          ],
        ),
        )
      );
  }

  Widget _buildPerbualanTab() {
    FirebaseFirestore firestore = FirebaseConfig.firestore;
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    ChatService chatService = ChatService();

    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
          SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Senarai perbualan",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          key: ValueKey<String>('chat_rooms_stream'),
          stream: firestore.collection('chat_rooms')
          .where('members', arrayContains: _firebaseAuth.currentUser!.uid)
          .snapshots(),
          builder: (context, snapshot) {

            
          if (snapshot.hasData) {
            final chats = snapshot.data!.docs;
            return 
                Expanded(
                  child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index].data();
                    final members = chat['members'] as dynamic;
                    final lastMessage = chat['last_message'] as String?;
                    final chatRoomId = chat['chat_room_id'] as String?;
                    //final read = chatService.getUnreadMessagesCount(chatRoomId!);
                    //final unreadCount = chatService.getUnreadMessagesCount(chatRoomId!);
                    
                    final receiverID = members.firstWhere((element) => element != _firebaseAuth.currentUser!.uid);
                    
                    return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(receiverID).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (!userSnapshot.hasData) {
                        return Text('Receiver not found');
                      }
                    
                    final receiverUsername = userSnapshot.data!['username'];
                    final userEmail = userSnapshot.data!['email'];

                    return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => 
                                  Chat(
                                    receiverUserID: receiverID,
                                    receiverUserName: receiverUsername,
                                    receiverUserEmail: userEmail,
                                  ), // Pass the userID to the ChatPage
                                ),
                              );
                            },
                            child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar( 
                                    child: const Icon(Icons.person, color: Colors.white)
                                  ),
                                    title: Text(
                                      '$receiverUsername',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: 
                                    Text(
                                      '$lastMessage',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: 
                                    FutureBuilder<int>(
                                      future: chatService.getUnreadMessagesCount(chatRoomId!), // Replace chatService with your actual service instance
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          // While the future is still executing, show a loading indicator or some other placeholder.
                                          return Text(''); // You can customize this loading indicator.
                                        } else if (snapshot.hasError) {
                                          // If there's an error, display an error message or handle it accordingly.
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          // When the future is complete, you can access the data and display it.
                                          final unreadCount = snapshot.data;

                                          if(unreadCount != 0){
                                              return Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue,
                                              ),
                                              child: Text(
                                                '$unreadCount',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }
                                          else{
                                            return Container();
                                          }
                                        }
                                      },
                                    )
                                  ),
                                  Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            );
                        },
                      );
                    },
                  ),
                );
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return const Text('loading...');
          }
        },
      ),
          ],
        ),
        )
      );
  }