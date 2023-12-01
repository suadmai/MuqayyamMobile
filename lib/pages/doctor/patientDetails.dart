import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlifego/components/prayerwidget.dart';
import 'package:wildlifego/firebase/firebase_config.dart';
import 'package:wildlifego/main.dart';
import 'package:wildlifego/pages/chat.dart';

import '../../components/layout.dart';

class PatientDetails extends StatefulWidget {
  final String patientId;

  const PatientDetails({super.key, required this.patientId});
  @override
  State<PatientDetails> createState() => _PatientDetailsState();
  
}

class _PatientDetailsState extends State<PatientDetails>{
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  String userID = "";
  String username = "";
  String userEmail = "";
  bool bookmarked = false;

  @override
  void initState() {
    super.initState();
    firestore
        .collection('users')
        .doc(widget.patientId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          userID = documentSnapshot.get('userID');
          username = documentSnapshot.get('username');
          userEmail = documentSnapshot.get('email');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "Pantau Pesakit"),

      // bottomNavigationBar: const MyBottomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestore.collection("users")
                      .where("userID", isEqualTo: widget.patientId)
                      .snapshots(),
                
                builder: (context, snapshot) {
        
                final patient = snapshot.data!.docs.first.data();
                String? _profilePictureUrl = patient['profilePicture'] as String?;
                String? patientName = patient['username'] as String?;
                String? patientAge = "";
                String? patientGender = "";
                String? patientEmail = patient['email'] as String?;
                String? healthInfo = "";
        
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person, size: 40,),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  patientName.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                children: [
                                  RichText(text: const TextSpan(
                                    text: 'Jantina: ',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(text: 'lelaki', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                                  const SizedBox(width: 20),
                                  RichText(text: const TextSpan(
                                    text: 'Umur: ',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(text: '30', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              RichText(text: TextSpan(
                                    text: 'Alamat Emel: ',
                                    style: const TextStyle(fontSize: 14, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(text: patientEmail.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                              const SizedBox(height: 12),
                              RichText(text: const TextSpan(
                                    text: 'Masalah kesihatan: ',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(text: 'tiada', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                              ],
                            ),
                           
                          ],
                        ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                    onPressed: () {
                      const snackBar = SnackBar(content: Text('Penanda berjaya ditambah'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        bookmarked = !bookmarked;
                      });
                      print(bookmarked);
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: Icon(
                        bookmarked ? Icons.bookmark_add_outlined : Icons.bookmark,
                        color: Colors.black,
                        key: ValueKey<bool>(bookmarked),
                      ),
                    ),
                    label: Text(
                      bookmarked ? 'Tambah Penanda' : 'Buang Penanda',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(100, 50)),
                    ),
                  ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //go to chat page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              receiverUserID: userID,
                              receiverUserName: username,
                              receiverUserEmail: userEmail), // Pass the userID to the ChatPage
                          ),
                        );
                      },
                      icon: const Icon(Icons.mail_outline_rounded, color: Colors.black,),
                      label: const Text('Hantar Mesej', style: TextStyle(color: Colors.black),),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(100, 50)),
                      )
                    ),
                  ),
                ],
              ),
              //PrayerData(patientId: widget.patientId),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: 
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
                    ),
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: Text('Box 1', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                    )
                  ),
                  const SizedBox(width: 6),
                  PrayerWidget(patientId: widget.patientId)
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: 
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
                    ),
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: Text('Box 1', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                    )
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: 
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
                    ),
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: Text('Box 1', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}

class PrayerData extends StatefulWidget{
  final String patientId;

  const PrayerData({Key?key, required this.patientId}) : super(key: key);
  
  @override
  State<PrayerData> createState() => _PrayerDataState();
}

  class _PrayerDataState extends State<PrayerData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      //sort in descending order using document 
      stream: firestore
          .collection("users")
          .doc(widget.patientId)
          .collection("daily_prayers")
          .snapshots(),
          builder: (context, snapshot) {
          if (snapshot.hasData) {
          final prayers = snapshot.data!.docs;

          // Create a list of prayer data for each day
          final prayerData = prayers.map((prayerDoc) {
            final data = prayerDoc.data();
            final date = prayerDoc.id;
            final subuh = data['subuh'];
            final zohor = data['zohor'];
            final asar = data['asar'];
            final maghrib = data['maghrib'];
            final isyak = data['isyak'];

            return {
              'Date': date,
              'Subuh': subuh,
              'Zohor': zohor,
              'Asar': asar,
              'Maghrib': maghrib,
              'Isyak': isyak,
            };
          }).toList();

          final columns = List<DataColumn>.generate(prayerData.length + 1, (index) {
            if (index == 0) {
              // The first column is for 'Date'
              return const DataColumn(
                label: Text('Tarikh'),
              );
            } else {
              // Other columns correspond to prayers
              return DataColumn(
                label: Text(DateFormat('dd/M').
                            format(DateTime.parse(prayerData[index - 1]['Date']
                            .toString()))),
              );
            }
          });

          final rows = [
            DataRow(
              cells: List<DataCell>.generate(prayerData.length + 1, (index) {
                if (index == 0) {
                  // The first cell is for 'Date'
                  return const DataCell(Text('Subuh'));
                } else {
                  // Other cells correspond to prayer times
                  return DataCell(
                    //Text(prayerData[index - 1]['Zohor'].toString())
                    Align(
                      
                      child: Icon(
                        //if true, show green check icon, else show red cross icon
                        prayerData[index - 1]['Subuh'] == true ? Icons.check : Icons.close,
                        color: prayerData[index - 1]['Subuh'] == true ? Colors.green : Colors.red,
                      ),
                    )
                    ); // Subtract 1 to account for the 'Date' column
                }
              }),
            ),
            DataRow(
              cells: List<DataCell>.generate(prayerData.length + 1, (index) {
                if (index == 0) {
                  // The first cell is for 'Date'
                  return const DataCell(Text('Zohor'));
                } else {
                  // Other cells correspond to prayer times
                  return DataCell(
                    //Text(prayerData[index - 1]['Zohor'].toString())
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        //if true, show green check icon, else show red cross icon
                        prayerData[index - 1]['Zohor'] == true ? Icons.check : Icons.close,
                        color: prayerData[index - 1]['Zohor'] == true ? Colors.green : Colors.red,
                      ),
                    )
                    ); // Subtract 1 to account for the 'Date' column
                }
              }),
            ),
            DataRow(
              cells: List<DataCell>.generate(prayerData.length + 1, (index) {
                if (index == 0) {
                  // The first cell is for 'Date'
                  return const DataCell(Text('Asar'));
                } else {
                  // Other cells correspond to prayer times
                  return DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        //if true, show green check icon, else show red cross icon
                        prayerData[index - 1]['Asar'] == true ? Icons.check : Icons.close,
                        color: prayerData[index - 1]['Asar'] == true ? Colors.green : Colors.red,
                      ),
                    )
                    ); // Subtract 1 to account for the 'Date' column
                }
              }),
            ),
            DataRow(
              cells: List<DataCell>.generate(prayerData.length + 1, (index) {
                if (index == 0) {
                  // The first cell is for 'Date'
                  return const DataCell(Text('Maghrib'));
                } else {
                  // Other cells correspond to prayer times
                  return DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        //if true, show green check icon, else show red cross icon
                        prayerData[index - 1]['Maghrib'] == true ? Icons.check : Icons.close,
                        color: prayerData[index - 1]['Maghrib'] == true ? Colors.green : Colors.red,
                      ),
                    )
                    ); // Subtract 1 to account for the 'Date' column
                }
              }),
            ),
            DataRow(
              cells: List<DataCell>.generate(prayerData.length + 1, (index) {
                if (index == 0) {
                  // The first cell is for 'Date'
                  return const DataCell(Text('Isyak'));
                } else {
                  // Other cells correspond to prayer times
                  return DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        //if true, show green check icon, else show red cross icon
                        prayerData[index - 1]['Isyak'] == true ? Icons.check : Icons.close,
                        color: prayerData[index - 1]['Isyak'] == true ? Colors.green : Colors.red,
                      ),
                    )
                    ); // Subtract 1 to account for the 'Date' column
                }
              }),
            ),
          ];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 30,
              columns: columns,
              rows: rows,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}