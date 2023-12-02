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
    setState(() {
      
    });
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
    subuh = prayerData.data()!['subuh'] == true ? true : false;
    zohor = prayerData.data()!['zohor'] == true ? true : false;
    asar = prayerData.data()!['asar'] == true ? true : false;
    maghrib = prayerData.data()!['maghrib'] == true ? true : false;
    isya = prayerData.data()!['isyak'] == true ? true : false;
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
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align title to the start (left)
                  children: [
                    const Text(
                      'Solat Harian',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                           child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  const Text('Subuh', style: TextStyle(fontSize: 13)),
                                  Icon(subuh ? Icons.circle : Icons.circle, color: subuh ? Colors.greenAccent : Colors.grey, size: 15),
                                ]),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  const Text('Zuhur', style: TextStyle(fontSize: 13)),
                                  Icon(zohor ? Icons.circle : Icons.circle, color: zohor ? Colors.greenAccent : Colors.grey, size: 15),
                                ]),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  const Text('Asar', style: TextStyle(fontSize: 13)),
                                  Icon(asar ? Icons.circle : Icons.circle, color: asar ? Colors.greenAccent : Colors.grey, size: 15),
                                ]),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  const Text('Maghrib', style: TextStyle(fontSize: 13)),
                                  Icon(maghrib ? Icons.circle : Icons.circle, color: maghrib ? Colors.greenAccent : Colors.grey, size: 15),
                                ]),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  const Text('Isya', style: TextStyle(fontSize: 13)),
                                  Icon(isya ? Icons.circle : Icons.circle, color: isya ? Colors.greenAccent : Colors.grey, size: 15),
                                ]),
                              ),
                            ],
                           ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     const Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text('Subuh', style: TextStyle(fontSize: 13)),
                          //         SizedBox(height: 3),
                          //         Text('Zohor', style: TextStyle(fontSize: 13)),
                          //         SizedBox(height: 3),
                          //         Text('Asar', style: TextStyle(fontSize: 13)),
                          //         SizedBox(height: 3),
                          //         Text('Maghrib', style: TextStyle(fontSize: 13)),
                          //         SizedBox(height: 3),
                          //         Text('Isya', style: TextStyle(fontSize: 13)),
                          //       ],
                          //     ),
                          //     Column(
                          //       children: [
                          //         Icon(subuh ? Icons.circle : Icons.circle, color: subuh ? Colors.greenAccent : Colors.grey, size: 15),
                          //         const SizedBox(height: 3),
                          //         Icon(zohor ? Icons.circle : Icons.circle, color: zohor ? Colors.greenAccent : Colors.grey, size: 15),
                          //         const SizedBox(height: 3),
                          //         Icon(asar ? Icons.circle : Icons.circle, color: asar ? Colors.greenAccent : Colors.grey, size: 15),
                          //         const SizedBox(height: 3),
                          //         Icon(maghrib ? Icons.circle : Icons.circle, color: maghrib ? Colors.greenAccent : Colors.grey, size: 15),
                          //         const SizedBox(height: 3),
                          //         Icon(isya ? Icons.circle : Icons.circle, color: isya ? Colors.greenAccent : Colors.grey, size: 15),
                          //       ],
                          //     ),
                          //   ],
                          // ),
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
