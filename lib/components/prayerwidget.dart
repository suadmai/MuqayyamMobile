import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class PrayerWidget extends StatefulWidget {
  final String patientId;

  const PrayerWidget({super.key, required this.patientId});

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  bool subuh = false;
  bool zohor = false;
  bool asar = false;
  bool maghrib = false;
  bool isya = false;

  @override
  void initState() {
    super.initState();
    print(widget.patientId);
    getPrayerData();
  }

   Future <void> getPrayerData() async{
    final DocumentSnapshot<Map<String, dynamic>> 
    prayerData = await firestore.
                collection('users').
                doc(widget.patientId).
                collection('daily_prayers').
                doc(DateFormat('yyyy-MM-dd').format(DateTime.now())).
                get();
    print('collected data');
    subuh = prayerData.data()!['subuh'];
    zohor = prayerData.data()!['zohor'];
    asar = prayerData.data()!['asar'];
    maghrib = prayerData.data()!['maghrib'];
    isya = prayerData.data()!['isyak'];
    print(prayerData);
    setState(() {});

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Solat Hari Ini', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Subuh', style: TextStyle(fontSize: 13,),),
                            SizedBox(height: 2,),
                            Text('Zohor', style: TextStyle(fontSize: 13,),),
                            SizedBox(height: 2,),
                            Text('Asar', style: TextStyle(fontSize: 13,),),
                            SizedBox(height: 2,),
                            Text('Maghrib', style: TextStyle(fontSize: 13,),),
                            SizedBox(height: 2,),
                            Text('Isyak', style: TextStyle(fontSize: 13,),),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(subuh ? Icons.circle : Icons.circle, color: subuh ? Colors.greenAccent : Colors.grey, size: 15,),
                            const SizedBox(height: 3,),
                            Icon(zohor ? Icons.circle : Icons.circle, color: zohor ? Colors.greenAccent : Colors.grey, size: 15,),
                            const SizedBox(height: 3,),
                            Icon(asar ? Icons.circle : Icons.circle, color: asar ? Colors.greenAccent : Colors.grey, size: 15,),
                            const SizedBox(height: 3,),
                            Icon(maghrib ? Icons.circle : Icons.circle, color: maghrib ? Colors.greenAccent : Colors.grey, size: 15,),
                            const SizedBox(height: 3,),
                            Icon(isya ? Icons.circle : Icons.circle, color: isya ? Colors.greenAccent : Colors.grey, size: 15,),
                          ],
                        ),
                      ],)
                  ],
                ),
              ),
          )
          )
        );
}
}
