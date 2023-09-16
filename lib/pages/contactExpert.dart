// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_config.dart';
import 'chat.dart';

class ContactExpert extends StatefulWidget {
  const ContactExpert({Key? key}) : super(key: key);
  @override
  State<ContactExpert> createState() => _ContactExpertState();
}

// Future<void> logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const LoginPage(),
//     ),
//   );
// }

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
        actions: [
          IconButton(
            onPressed: () {
              //go to profile page
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text('Senarai Pakar', style: TextStyle(fontSize: 18),)),
            Tab(child: Text('Perbualan', style: TextStyle(fontSize: 18),)),
          ],
        ),
      ),
      //floating action button must be center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(
            //context,
            //MaterialPageRoute(
              //builder: (context) =>
                  //CameraPage(cameraController: _cameraController),
            //),
          //);
        },
        child: const Icon(Icons.podcasts), 
        backgroundColor: Color(0xFF82618B),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF82618B),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Updated alignment
            children: <Widget>[
              // Home
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactExpert(),
                    ),
                  );
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),

              // Search (You can replace this with your desired search functionality)
              IconButton(
                onPressed: () {
                  // Add your search functionality here
                },
                icon: const Icon(Icons.search),
                color: Colors.white,
              ),

              // Trophy (You can replace this with your desired trophy functionality)
              IconButton(
                onPressed: () {
                  // Add your trophy functionality here
                },
                icon: const Icon(Icons.emoji_events),
                color: Colors.white,
              ),

              // Settings (You can replace this with your desired settings functionality)
              IconButton(
                onPressed: () {
                  // Add your settings functionality here
                },
                icon: const Icon(Icons.settings),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body:
      TabBarView(
        controller: _tabController,
        children: [
          // First Tab: Senarai Pakar
          _buildSenaraiPakarTab(),

          // Second Tab: Perbualan
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
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('users')
        .where('role', isEqualTo: 'doctor')
        .where('userID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)//taknak tunjuk diri sendiri
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doctors = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    'Senarai pakar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index].data();
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
                                    leading: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.person,
                                        size: 24,
                                        color: Colors.white,
                                      ),
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
                ),
              ],
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

    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('chat_rooms')
        .where('members', arrayContains: _firebaseAuth.currentUser!.uid)
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final chats = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Text(
                    'Senarai perbualan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index].data();
                    final members = chat['members'] as dynamic;
                    final lastMessage = chat['last_message'] as String?;
                    final receiverID = members.firstWhere((element) => element != _firebaseAuth.currentUser!.uid);
                    
                    return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(receiverID).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return Text('Sebentar...');
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
                                      radius: 24,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.person,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      '$receiverUsername',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      '$lastMessage',
                                      style: TextStyle(fontSize: 14),
                                    ),
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
                ),
              ],
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