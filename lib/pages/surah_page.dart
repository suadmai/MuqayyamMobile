import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurahPage extends StatelessWidget {
  final String levelName;
  final String surahName;

  SurahPage({required this.levelName, required this.surahName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        backgroundColor: const Color(0xFF82618B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('quran')
              .doc(levelName) // Use the levelName parameter
              .collection('surahs')
              .where('surah_name', isEqualTo: surahName) // Filter by surah_name
              .limit(1) // Limit the result to 1 document
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final surahDocs = snapshot.data!.docs;

            if (surahDocs.isEmpty) {
              return Text('Surah not found.');
            }

            // Assuming there's only one matching surah document
            final surahDoc = surahDocs[0];
            final surahId = surahDoc.id;

            // Now, retrieve the Ayats for this surah
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('quran')
                  .doc(levelName) // Use the levelName parameter
                  .collection('surahs')
                  .doc(surahId) // Use the retrieved surah document ID
                  .collection('Ayats') // Reference the "Ayats" subcollection
                  .orderBy('ayat_number') // Optionally, order by a field if needed
                  .snapshots(),
              builder: (context, ayatSnapshot) {
                if (ayatSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (ayatSnapshot.hasError) {
                  return Text('Error: ${ayatSnapshot.error}');
                }

                final ayats = ayatSnapshot.data!.docs;

                if (ayats.isEmpty) {
                  return Text('No Ayats found for this surah.');
                }

                return ListView.builder(
                  itemCount: ayats.length,
                  itemBuilder: (context, index) {
                    final ayatData = ayats[index].data() as Map<String, dynamic>;
                    final arabic = ayatData['arabic'] as String;
                    final meaning = ayatData['meaning'] as String;
                    final ayatNumber = int.tryParse(ayatData['ayat_number'] as String) ?? 0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arabic,
                          textAlign: TextAlign.right,
                          style: TextStyle(

                            fontSize: 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          meaning,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(), // Add a divider between ayats
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
