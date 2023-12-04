import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class QuranWidget extends StatefulWidget {
  final String patientId;

  const QuranWidget({super.key, required this.patientId});

  @override
  State<QuranWidget> createState() => _QuranWidgetState();
}

class _QuranWidgetState extends State<QuranWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  int readCount = 0;

  @override
  void initState() {
    super.initState();
    print(widget.patientId);
    getReadingRecord();
    setState(() {
      
    });
  }

   Future <void> getReadingRecord() async{
    final QuerySnapshot<Map<String, dynamic>> 
    readingData = await firestore.
                collection('users').
                doc(widget.patientId).
                collection('reading_records').
                get();
    
    countReadSurah(readingData.docs);
    setState(() {
      
    });
  }

  void countReadSurah(dynamic userReadData){
    int count = 0;
    for (var i = 0; i < userReadData.length; i++) {
      if (userReadData[i]['isRead'] == true) {
        count++;
      }
    }
    readCount = count;
    print(readCount);
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
                      'Surah Dibaca',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          readCount.toString(),
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
