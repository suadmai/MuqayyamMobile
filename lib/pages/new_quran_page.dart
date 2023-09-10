import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/pages/surah_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({Key? key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('quran').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final levels = snapshot.data!.docs;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Choose a Level',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemCount: levels.length,
                            itemBuilder: (context, index) {
                              final level = levels[index].data();
                              final title = level['title'] as String?;
                              final description = level['description'] as String?;

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12.0),
                                            topRight: Radius.circular(12.0),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Handle the tap event, e.g., navigate to a details page
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Placeholder(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                '$title',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '$description',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              maxLines: 10,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            // Display surah names
                                            FutureBuilder<QuerySnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('quran')
                                                  .doc(levels[index].id)
                                                  .collection('surahs')
                                                  .get(),
                                              builder: (context, surahSnapshot) {
                                                if (surahSnapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                }
                                                if (surahSnapshot.hasError) {
                                                  return ErrorWidget(surahSnapshot.error!);
                                                }
                                                final surahs = surahSnapshot.data!.docs;

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Surah Names:',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: surahs.map<Widget>((surahDoc) {
                                                        final surahData = surahDoc.data() as Map<String, dynamic>;
                                                        final surahName = surahData['surah_name'] as String;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            // Handle the tap event, e.g., navigate to a details page
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => SurahPage(
                                                                  surahName: surahName,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            surahName,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.blue,
                                                              decoration: TextDecoration.underline,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error!);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
