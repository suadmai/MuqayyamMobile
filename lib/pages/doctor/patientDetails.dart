import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlifego/firebase/firebase_config.dart';
import 'package:wildlifego/main.dart';

import '../../components/layout.dart';
import '../../components/prayer_widget.dart';

class PatientDetails extends StatefulWidget {
  final patientId;

  const PatientDetails({super.key, required this.patientId});
  @override
  State<PatientDetails> createState() => _PatientDetailsState();
  
}

class _PatientDetailsState extends State<PatientDetails>{
  FirebaseFirestore firestore = FirebaseConfig.firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "Pantau Pesakit"),
      bottomNavigationBar: const MyBottomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firestore.collection("users")
                    .where("role", isEqualTo: "doctor")
                    .where("userID", isEqualTo: widget.patientId)
                    .snapshots(),
                  
                  builder: (context, snapshot){
                  if(snapshot.hasData){
      
                    final patient = snapshot.data!.docs.first.data();
                    final username = patient['username'] as String?;
                    final score = patient['score'] as int?;
                    final email = patient['email'] as String?;
      
                    return Column(
                      children: [
                        const Icon(Icons.account_circle, size: 100,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: ${username!}'),
                            Text('Umur: 23'),
                            Text('Masalah kesihatan: tiada'),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 149, 125, 173),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text('Skor\n${score!}',
                                    textAlign: TextAlign.center, 
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold),
                                      )
                                    ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255,174, 218, 198),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text('Pencapaian\nEmas',
                                    textAlign: TextAlign.center, 
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold),
                                      )
                                    ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: PrayerData(patientId: widget.patientId)
                        ),
                      ],
                    );
                  }
                  else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }
                ),
          )
        ),
      ),
      );
  }
}