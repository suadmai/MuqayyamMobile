import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class ScoreWidget extends StatefulWidget {
  final String patientId;

  const ScoreWidget({super.key, required this.patientId});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    print(widget.patientId);
    getScore();
  }

   Future <void> getScore() async{
    final DocumentSnapshot<Map<String, dynamic>> 
    userData = await firestore.
                collection('users').
                doc(widget.patientId).
                get();
    
    userScore = userData.data()!['score'];
    setState(() {
      
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
                      'Jumlah Markah',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          userScore.toString(),
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
