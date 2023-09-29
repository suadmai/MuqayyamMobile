// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/pages/doctor/patientDetails.dart';
import '../../firebase/firebase_config.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);
  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList>{
  FirebaseFirestore firestore = FirebaseConfig.firestore;
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
        title: const Text("Pantau pesakit"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.podcasts), 
        backgroundColor: Color(0xFF82618B),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottomNavigationBar: BottomAppBar(
      //   color: Color(0xFF82618B),
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 10.0,
      //   child: SizedBox(
      //     height: 60.0,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround, // Updated alignment
      //       children: <Widget>[
      //         // Home
      //         IconButton(
      //           onPressed: () {
                  
      //           },
      //           icon: const Icon(Icons.home),
      //           color: Colors.white,
      //         ),

      //         // Search (You can replace this with your desired search functionality)
      //         IconButton(
      //           onPressed: () {
      //             // Add your search functionality here
      //           },
      //           icon: const Icon(Icons.search),
      //           color: Colors.white,
      //         ),

      //         // Trophy (You can replace this with your desired trophy functionality)
      //         IconButton(
      //           onPressed: () {
      //             // Add your trophy functionality here
      //           },
      //           icon: const Icon(Icons.emoji_events),
      //           color: Colors.white,
      //         ),

      //         // Settings (You can replace this with your desired settings functionality)
      //         IconButton(
      //           onPressed: () {
      //             // Add your settings functionality here
      //           },
      //           icon: const Icon(Icons.settings),
      //           color: Colors.white,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      
      body:Center(
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
                "Senarai pesakit",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('users')
        .where('role', isEqualTo: 'doctor')
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
              final userID = doctor['userID'] as String?;
              final userEmail = doctor['email'] as String?;
              final username = doctor['username'] as String?;

        return InkWell(

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetails(
                    patientId: userID,
                  )
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
      )
    );
  }
}