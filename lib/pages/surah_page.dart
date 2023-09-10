import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurahPage extends StatelessWidget {
  final String surahName;

  SurahPage({required this.surahName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('quran')
              .doc('level_1') // Update with the appropriate document ID
              .collection('surahs')
              .doc('level1_surah1') // Update with the appropriate surah document ID
              .collection('Ayats') // Reference the "Ayats" subcollection
              .orderBy('ayat_number') // Optionally, order by a field if needed
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final ayats = snapshot.data!.docs;

            if (ayats.isEmpty) {
              return Text('No Ayats found for this surah.');
            }

            return ListView.builder(
              itemCount: ayats.length,
              itemBuilder: (context, index) {
                final ayatData = ayats[index].data() as Map<String, dynamic>;
                final arabic = ayatData['arabic'] as String;
                final meaning = ayatData['meaning'] as String;
                final ayatNumber = ayatData['ayat_number'] as int;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ayat $ayatNumber:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Arabic:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      arabic,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Meaning:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      meaning,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Divider(), // Add a divider between ayats
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
