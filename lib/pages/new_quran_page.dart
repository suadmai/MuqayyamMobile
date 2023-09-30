import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/components/layout.dart';
import 'package:wildlifego/pages/surah_page.dart';

import '../components/bottom_app_bar.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({Key? key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {

  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
  backgroundColor: const Color(0xFF82618B),
  title: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid) // Assuming user is signed in
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final userDoc = snapshot.data!;
        final userScore = userDoc['score'] ?? 0; // Replace 'score' with the actual field name in Firestore
        return Text('Baca al-Quran');
      } else {
        return const Text('User Score: Loading...'); // Display loading while fetching data
      }
    },
  ),
),

// bottomNavigationBar: MyBottomAppBar(
       
//       ),

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
                            'Pilih surah',
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
                                                    builder: (context) => const Placeholder(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                '$title',
                                                style: const TextStyle(
                                                  fontSize: 24,
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
                                                if (surahSnapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (surahSnapshot.hasError) {
                                                  return ErrorWidget(surahSnapshot.error!);
                                                }
                                                final surahs = surahSnapshot.data!.docs;

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: surahs.map<Widget>((surahDoc) {
                                                    final surahData = surahDoc.data() as Map<String, dynamic>;
                                                    final surahName = surahData['surah_name'] as String;

                                                    return GestureDetector(
                                                      onTap: () async {
                                                        final user = _auth.currentUser;
                                                        if (user != null) {
                                                          final userId = user.uid;
                                                          final surahRef = FirebaseFirestore.instance
                                                              .collection('users')
                                                              .doc(userId)
                                                              .collection('reading_records')
                                                              .doc(surahName);

                                                          final surahDoc = await surahRef.get();

                                                          // Handle the tap event, e.g., navigate to a details page
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => SurahPage(
                                                                surahName: surahName,
                                                                levelName: levels[index].id,
                                                              ),
                                                            ),
                                                          );

                                                          if (!surahDoc.exists) {
                                                            // Surah has not been read, mark as read
                                                            await surahRef.set({
                                                              'isRead': true,
                                                            });

                                                            // Update user's total points
                                                            final userRef = FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(userId);

                                                            // Increment the user's score by 5
                                                            userRef.update({
                                                              'score': FieldValue.increment(5),
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              surahName,
                                                              style: const TextStyle(
                                                                fontSize: 24,
                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          StreamBuilder<DocumentSnapshot>(
                                                            stream: FirebaseFirestore.instance
                                                                .collection('users')
                                                                .doc(_auth.currentUser!.uid)
                                                                .collection('reading_records')
                                                                .doc(surahName)
                                                                .snapshots(),
                                                            builder: (context, readStatusSnapshot) {
                                                              if (readStatusSnapshot.connectionState == ConnectionState.waiting) {
                                                                return const CircularProgressIndicator();
                                                              }
                                                              if (readStatusSnapshot.hasError) {
                                                                return ErrorWidget(readStatusSnapshot.error!);
                                                              }

                                                              final readStatusData = readStatusSnapshot.data?.data() as Map<String, dynamic>?;

                                                              // Check if the Surah is marked as read or not
                                                              final isRead = readStatusData?['isRead'] ?? false;

                                                              // Choose the appropriate icon and color based on the read status
                                                              //create a circle indicator
                                                              final icon = isRead
                                                                  ? const Icon(
                                                                      Icons.circle,
                                                                      color: Colors.greenAccent,
                                                                    )
                                                                  : const Icon(
                                                                      Icons.circle,
                                                                      color: Color.fromARGB(0xFF, 0xD9, 0xD9, 0xD9),
                                                                    );

                                                              return icon;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
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
      // Add a button here to go to a placeholder page
    );
  }
}
