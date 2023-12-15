import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class ZikirWidget extends StatefulWidget {
  final String patientId;

  const ZikirWidget({super.key, required this.patientId});

  @override
  State<ZikirWidget> createState() => _ZikirWidgetState();
}

class _ZikirWidgetState extends State<ZikirWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  int totalZikir = 0;

  @override
  void initState() {
    super.initState();
    print(widget.patientId);
    getZikir();
  }

   Future <void> getZikir() async{
    final DocumentSnapshot<Map<String, dynamic>> 
    userData = await firestore.
                collection('users').
                doc(widget.patientId).
                collection('tasbih').
                doc(widget.patientId).
                get();
   
    setState(() {
      totalZikir = userData.data()!['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: 
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align title to the start (left)
                  children: [
                    const Text(
                      'Jumlah Zikir',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$totalZikir',  
                          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        );
}
}
