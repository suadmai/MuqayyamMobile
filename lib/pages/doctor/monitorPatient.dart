// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/pages/doctor/patientDetails.dart';
import 'package:wildlifego/pages/register_page.dart';
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
      ),
      
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
                "Senarai Pengguna",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.collection('users')
        .where('role', isEqualTo: 'Pengguna')
        .where('userID', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)//taknak tunjuk diri sendiri
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            return 
          Expanded(
            child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data();
              final userID = user['userID'] as String?;
              final pfpURL = user['profilePicture'] as String?;
              final username = user['username'] as String?;

        return InkWell(

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetails(
                    patientId: userID as String,
                  )
                ),
              );
            },

            child: Column(
                children: [
                  ListTile(
                    leading: 
                    Container(
                      child: pfpURL != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              NetworkImage(pfpURL),
                        )
                      :
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors
                            .blue, // Set the profile image's background color
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.white,
                        ),
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