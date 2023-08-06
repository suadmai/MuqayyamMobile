// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class TrackPrayer extends StatefulWidget {
  const TrackPrayer({Key? key}) : super(key: key);
  
  @override
  State<TrackPrayer> createState() => _TrackPrayerState();
}

// Future<void> logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const LoginPage(),
//     ),
//   );
// }

class _TrackPrayerState extends State<TrackPrayer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isTimerRunning = false;
  int _timerSeconds = 0;
  final Duration animationDuration = Duration(minutes: 5);

  DateTime subuhTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 0);
  DateTime zuhurTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 19);
  DateTime asarTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 39);
  DateTime maghribTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 24);
  DateTime isyakTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 36);

  bool subuhPrayed = false;
  bool zuhurPrayed = false;
  bool asarPrayed = false;
  bool maghribPrayed = false;
  bool isyakPrayed = false;
  
   @override
    void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration, // Adjust the duration as needed
    );

    _animation = Tween<double>(begin: 0, end: animationDuration.inSeconds.toDouble())
        .animate(_animationController)
          ..addListener(() {
            setState(() {
              _timerSeconds = _animation.value.toInt();
            
          //   if (_animation.isCompleted) {
          //   performPrayer();
          // }
          if(_animation.isDismissed){
            performPrayer();
          }
            });
          });
  }

  void _startTimer() {
    _animationController.reverse(from: animationDuration.inSeconds.toDouble());
  }

  void _stopTimer() {
    _animationController.stop();
  }

  String currentPrayer(){
  DateTime now = DateTime.now();
  if(now.isBefore(subuhTime)){
    return "Subuh";
  }
  else if(now.isBefore(zuhurTime)){
    return "Zuhur";
  }
  else if(now.isBefore(asarTime)){
    return "Asar";
  }
  else if(now.isBefore(maghribTime)){
    return "Maghrib";
  }
  else if(now.isBefore(isyakTime)){
    return "Isyak";
  }
  else{
    return "Subuh";
  }
}

  void performPrayer(){
    String currentPrayer = this.currentPrayer();
    
    if(currentPrayer == "Subuh"){
      subuhPrayed = true;
    }
    else if(currentPrayer == "Zuhur"){
      zuhurPrayed = true;
    }
    else if(currentPrayer == "Asar"){
      asarPrayed = true;
    }
    else if(currentPrayer == "Maghrib"){
      maghribPrayed = true;
    }
    else if(currentPrayer == "Isyak"){
      isyakPrayed = true;
    }
  }

  String displayMinute(){
    int minute = _timerSeconds ~/ 60;
    int second = _timerSeconds % 60;
    String minuteStr = minute.toString().padLeft(2, '0');
    String secondStr = second.toString().padLeft(2, '0');
    return '$minuteStr:$secondStr';
  }

  double calculateProgress() {
    return 1 - (_animation.value / animationDuration.inSeconds.toDouble());
  }

  @override
  void dispose() {
    _animationController.dispose();
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
          GestureDetector(
            onTap: () {
              setState(() {
                isTimerRunning = !isTimerRunning;
                if (isTimerRunning) {
                  _startTimer();
                } else {
                  _stopTimer();
                }
              });
            },
            child: Container(
            width: 300,
            height: 300,
            decoration: 
                BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF82618B),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                        isTimerRunning ? displayMinute() : "Mula solat ${currentPrayer()}",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),

                      Center(
                        child: 
                        SizedBox(
                          height: 270,
                          width: 270,
                          child: CircularProgressIndicator(
                            value: isTimerRunning ? calculateProgress() : 0.0,
                            backgroundColor:Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                            strokeWidth: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
            ),
          )
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
                          Icon(Icons.check_circle, size: 32, color: subuhPrayed ? Colors.green : Colors.grey,),
                          SizedBox(height: 3,),
                          Text("Subuh", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 32, color: zuhurPrayed ? Colors.green : Colors.grey,),
                          SizedBox(height: 3,),
                          Text("Zohor", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 32, color: asarPrayed ? Colors.green : Colors.grey,),
                          SizedBox(height: 3,),
                          Text("Asar", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 32, color: maghribPrayed ? Colors.green : Colors.grey,),
                          SizedBox(height: 3,),
                          Text("Maghrib", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, size: 32, color: isyakPrayed ? Colors.green : Colors.grey,),
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