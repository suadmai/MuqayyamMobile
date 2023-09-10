import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class LevelofSurahWidget extends StatelessWidget {
  final String level;
  final String leveldesc;
  final List<String> surahs;
  final String backgroundImageAsset;

  LevelofSurahWidget({
    required this.level,
    required this.leveldesc,
    required this.surahs,
    required this.backgroundImageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              image: DecorationImage(
                image: AssetImage(backgroundImageAsset),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Teacher: $leveldesc',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: surahs
                  .map((surah) => GestureDetector(
                        onTap: () {
                          // Navigate to the placeholder page when tapped.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Placeholder(), // Replace with your actual page
                            ),
                          );
                        },
                        child: Text(
                          surah,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class QuranPage extends StatefulWidget {
  const QuranPage({Key? key}) : super(key: key);

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFEBEBEB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF82618B),
          title: const Text("Baca Al-Quran"),
          actions: [
            IconButton(
              onPressed: () {
                // Go to profile page
              },
              icon: const Icon(
                Icons.account_circle,
                size: 30,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle floating action button press
          },
          backgroundColor: Color(0xFF82618B),
          child: const Icon(Icons.podcasts),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: Column(
            children: [


              // 
              SizedBox(height: 16.0),
              LevelofSurahWidget(
                level: 'Level 1',
                leveldesc: 'Mr. Smith',
                backgroundImageAsset: 'images/level1.jpg',
                surahs: ['Apple', 'Banana', 'Orange'],
              ),
              SizedBox(height: 16.0),
              LevelofSurahWidget(
                level: 'Mathematics',
                leveldesc: 'Mr. Smith',
                backgroundImageAsset: 'images/level2.jpg',
                surahs: ['Apple', 'Banana', 'Orange'],
              ),
            ],
          ),
        ),

        //Bottom App Bar
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF82618B),
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // Handle home button press
                  },
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    // Handle search button press
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    // Handle trophy button press
                  },
                  icon: const Icon(Icons.emoji_events),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    // Handle settings button press
                  },
                  icon: const Icon(Icons.settings),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
