import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class LevelofSurahWidget extends StatelessWidget {
  final String level;
  final String leveldesc;
  final Color backgroundColor;
  final List<String> surahs;

  LevelofSurahWidget({
    required this.level,
    required this.leveldesc,
    required this.backgroundColor,
    required this.surahs,
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
        crossAxisAlignment: CrossAxisAlignment.start,  //items to the right
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
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
                    color: Colors.white, // Text color for class name
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Teacher: $leveldesc',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Text color for teacher name
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white, // Background color for the list of fruits
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: surahs
                  .map((surah) => Text(
                        surah,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black, // Text color for fruits
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Baca Al-Quran"),
        actions: [
          IconButton(
            onPressed: () {
              //go to profile page
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
          
        }, 
        backgroundColor: Color(0xFF82618B),
        child: const Icon(Icons.podcasts),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      
      
      body: Center(
        child: Column(
          
          children: [

            SizedBox(height: 16.0), // Added SizedBox



             LevelofSurahWidget(
                  level: 'Level 1',
                  leveldesc: 'Mr. Smith',
                  backgroundColor: Colors.blue, // Set your desired background color
                  surahs: ['Apple', 'Banana', 'Orange'],
                ),
      
                SizedBox(height: 16.0), // Added SizedBox
      
                LevelofSurahWidget(
                  level: 'Mathematics',
                  leveldesc: 'Mr. Smith',
                  backgroundColor: Color.fromARGB(255, 210, 21, 21), // Set your desired background color
                  surahs: ['Apple', 'Banana', 'Orange'],
                ),
            
          
        ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF82618B),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Updated alignment
            children: <Widget>[
              // Home
              IconButton(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),

              // Search (You can replace this with your desired search functionality)
              IconButton(
                onPressed: () {
                  // Add your search functionality here
                },
                icon: const Icon(Icons.search),
                color: Colors.white,
              ),

              // Trophy (You can replace this with your desired trophy functionality)
              IconButton(
                onPressed: () {
                  // Add your trophy functionality here
                },
                icon: const Icon(Icons.emoji_events),
                color: Colors.white,
              ),

              // Settings (You can replace this with your desired settings functionality)
              IconButton(
                onPressed: () {
                  // Add your settings functionality here
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