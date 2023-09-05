import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
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
        title: const Text("Only basic UI!"),
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

      //BOTTOM APP BAR

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
      body: Stack(
        children: [
          Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              
            ),
          ),
      ],
      )
    ),
    );
  }
}