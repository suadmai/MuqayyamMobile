import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerData extends StatefulWidget{
  final String patientId;

  const PrayerData({Key?key, required this.patientId}) : super(key: key);
  
  @override
  State<PrayerData> createState() => _PrayerDataState();
}

  class _PrayerDataState extends State<PrayerData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void startDate(){
    //get the first date from firestore collection
    
  }

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