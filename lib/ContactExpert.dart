// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

class _ContactExpertState extends State<ContactExpert> {
  @override
  void initState() {
    super.initState();
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
      Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'doctor').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doctors = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Senarai pakar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index].data();
                    final userID = doctor['userID'] as String?;
                    final username = doctor['username'] as String?;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$username',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Chat(userID: userID!), // Pass the userID to the ChatPage
                                              ),
                                            );
                                        },
                                        icon: Icon(Icons.chat),
                                        label: Text('Bual'),
                                        style: ElevatedButton.styleFrom(primary: Colors.green),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                          
                                        },
                                        icon: Icon(Icons.calendar_today),
                                        label: Text('Buat Temu Janji'),
                                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }
}