import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlifego/components/prayerwidget.dart';
import 'package:wildlifego/components/quranwidget.dart';
import 'package:wildlifego/components/scorewidget.dart';
import 'package:wildlifego/components/zikirWidget.dart';
import 'package:wildlifego/firebase/firebase_config.dart';
import 'package:wildlifego/main.dart';
import 'package:wildlifego/pages/chat.dart';

import '../../components/layout.dart';
import '../../components/rewardswidget.dart';

class PatientDetails extends StatefulWidget {
  final String patientId;

  const PatientDetails({super.key, required this.patientId});
  @override
  State<PatientDetails> createState() => _PatientDetailsState();
  
}

String displayNone(String text){
  if(text == ""){
    return "Tiada";
  }else{
    return text;
  }
}

class _PatientDetailsState extends State<PatientDetails>{
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  String userID = "";
  String username = "";
  String userEmail = "";
  bool showMore = false;

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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Maklumat Pengguna", style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firestore.collection("users")
                        .where("userID", isEqualTo: widget.patientId)
                        .snapshots(),
                  
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  final patient = snapshot.data!.docs.first.data();
                  String? pfpURL = patient['profilePicture'] as String?;
                  String? patientName = patient['username'] as String?;
                  String? patientAge = patient['age'] as String?;
                  String? patientAddress = patient['address'] as String?;
                  String? patientPhone = patient['phone'] as String;
                  String? patientSurgery = patient['surgery'] as String?;
                  String? patientSymptoms = patient['symptoms'] as String?;
                  String? patientEmail = patient['email'] as String?;
          
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Adjust the value to make the corners rounder
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                   Container(
                                          child: pfpURL != null
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  NetworkImage(pfpURL),
                                            )
                                          :
                                          const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors
                                                .blue, // Set the profile image's background color
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
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
                                RichText(text: TextSpan(
                                      text: 'Umur: ',
                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(text: patientAge ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    )),

                                const SizedBox(height: 12),
                                RichText(text: TextSpan(
                                      text: 'Alamat Emel: ',
                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(text: patientEmail.toString() ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    )),

                                const SizedBox(height: 12),
                                RichText(text: TextSpan(
                                      text: 'Nombor Telefon: ',
                                      style: const TextStyle(fontSize: 14, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(text: patientAddress ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    )),
                                Visibility(
                                  visible: showMore,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                  const SizedBox(height: 12),
                                      RichText(
                                        maxLines: 3,
                                        text: TextSpan(      
                                        text: 'Alamat: ',
                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: patientPhone ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                  const SizedBox(height: 12),
                                  RichText(text: TextSpan(
                                        text: 'Pembedahan: ',
                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: displayNone(patientSurgery.toString()), style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                  const SizedBox(height: 12),
                                  RichText(text: TextSpan(
                                        text: 'Simptom: ',
                                        style: const TextStyle(fontSize: 14, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(text: displayNone(patientSymptoms.toString()), style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                    ]
                                  )
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    IconButton(
                                      onPressed: (){
                                        setState(() {
                                          showMore = !showMore;
                                        });
                                      },
                                      icon: showMore? const Icon(Icons.expand_less, color: Colors.black,) :
                                      const Icon(Icons.expand_more, color: Colors.black,),)
                                  ],),
                                ],
                              ),
                            ],
                          ),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    content: RewardsWidget(patientId: widget.patientId),
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(vertical: 20),
                              ),
                            ),
                            icon: const Icon(Icons.card_giftcard_rounded, color: Colors.black),
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: Text(
                                'Semak Kod Tebusan',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          ),
                          const SizedBox(width: 8),
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
                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 20)),
                              )
                            ),
                          ),
                        ],
                      ),
                ),
                //PrayerData(patientId: widget.patientId),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ScoreWidget(patientId: widget.patientId),
                    const SizedBox(width: 4),
                    PrayerWidget(patientId: widget.patientId)
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    QuranWidget(patientId: widget.patientId),
                    const SizedBox(width: 4),
                    ZikirWidget(patientId: widget.patientId),
                  ],
                )
              ]
            ),
        )
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