import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wildlifego/firebase/firebase_config.dart';
import 'package:wildlifego/main.dart';

import '../../components/layout.dart';

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

      // bottomNavigationBar: const MyBottomAppBar(),

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