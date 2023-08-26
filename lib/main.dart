import 'package:flutter/material.dart';

class TrackPrayer extends StatefulWidget {
  const TrackPrayer({Key? key}) : super(key: key);

  @override
  State<TrackPrayer> createState() => _TrackPrayerState();
}

class _TrackPrayerState extends State<TrackPrayer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isTimerRunning = false;
  int _timerSeconds = 0;
  final Duration animationDuration = Duration(seconds: 5);


  Prayer subuh = Prayer()
    ..prayerName = "subuh"
    ..prayerStatus = "false";

  // ... (similarly define other Prayer objects)

  @override
  void initState() {
    super.initState();
    // Initialize controllers and timers
    // ...

    // Set up animations and listeners
    // ...
  }

  @override
  void dispose() {
    // Cancel timers and dispose of controllers
    // ...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Selamat pagi!"),
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
      //floating action button must be center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(
            //context,
            //MaterialPageRoute(
              //builder: (context) =>
                  //CameraPage(cameraController: _cameraController),
            //),
          //);
        }, 
        backgroundColor: Color(0xFF82618B),
        child: const Icon(Icons.podcasts),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackPrayer(),
                    ),
                  );
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          SizedBox(height: 3,),
                          Text("Subuh", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          SizedBox(height: 3,),
                          Text("Zohor", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          SizedBox(height: 3,),
                          Text("Asar", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          SizedBox(height: 3,),
                          Text("Maghrib", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          SizedBox(height: 3,),
                          Text("Isyak", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
      )
    );
  }
  }


class Prayer {
  String prayerName = "";
  DateTime prayerTime = DateTime.now();
  String prayerStatus = "false";
}

void main() {
  runApp(MaterialApp(
    home: TrackPrayer(),
  ));
}