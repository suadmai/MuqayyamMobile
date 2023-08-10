// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Prayer{
  String prayerName = "";
  DateTime prayerTime = DateTime.now();
  bool prayed = false;
  bool missed = false;
}

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
  final Duration animationDuration = Duration(seconds: 5);
  late Timer _nextPrayerTimer;
  Prayer currentPrayer = Prayer();

  Prayer subuh = Prayer()
                ..prayerName = "Subuh"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 0,)
                ..prayed = false
                ..missed = false;

  Prayer syuruk = Prayer()
                ..prayerName = "Syuruk"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 7, 09)
                ..prayed = false
                ..missed = false;

  Prayer zuhur = Prayer()
                ..prayerName = "Zuhur"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13, 19)
                ..prayed = false
                ..missed = false;

  Prayer asar = Prayer()
                ..prayerName = "Asar"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16, 39)
                ..prayed = false
                ..missed = false;

  Prayer maghrib = Prayer()
                ..prayerName = "Maghrib"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 24)
                ..prayed = false
                ..missed = false;

  Prayer isyak = Prayer()
                ..prayerName = "Isyak"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 20, 36,)
                ..prayed = false
                ..missed = false;

   @override
    void initState() {
    super.initState();
    setCurrentPrayer();
    //checkForMissedPrayers();
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration, // Adjust the duration as needed
    );
    
    _nextPrayerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Call setState to trigger a UI update
      setState(() {});
      setCurrentPrayer();//check for current prayer every second
      checkForMissedPrayers();//check for missed prayers every second
    });

      _animation = Tween<double>(begin: 0, end: animationDuration.inSeconds.toDouble())
      .animate(_animationController)
        ..addListener(() {
          setState(() {
            _timerSeconds = _animation.value.toInt();
          });

          if (_animation.isDismissed) {
            isTimerRunning = false;
            _stopTimer();
            performPrayer();
          }
        });
    }

  void _startTimer() {
  setState(() {
    _animationController.reverse(from: animationDuration.inSeconds.toDouble());
  });
}

  void _stopTimer() {
    setState(() {
      _animationController.stop();
    });
  }

  void setCurrentPrayer(){
    setState(() {
      List prayers = [subuh, syuruk, zuhur, asar, maghrib, isyak];
      currentPrayer = prayers[0];//for testing purposes, set to subuh
      DateTime now = DateTime.now();

      if(now.isAfter(subuh.prayerTime) && now.isBefore(syuruk.prayerTime)){
        currentPrayer = subuh;
      }
      else if(now.isAfter(syuruk.prayerTime) && now.isBefore(zuhur.prayerTime)){
        currentPrayer = syuruk;
      }
      else if(now.isAfter(zuhur.prayerTime) && now.isBefore(asar.prayerTime)){
        currentPrayer = zuhur;
      }
      else if(now.isAfter(asar.prayerTime) && now.isBefore(maghrib.prayerTime)){
        currentPrayer = asar;
      }
      else if(now.isAfter(maghrib.prayerTime) && now.isBefore(isyak.prayerTime)){
        currentPrayer = maghrib;
      }
      else if(now.isAfter(isyak.prayerTime) || now.isBefore(subuh.prayerTime)){
        currentPrayer = isyak;
      }
      else {
        currentPrayer = syuruk;
      }
    });
  }

//   String currentPrayer(){
//   DateTime now = DateTime.now();
//   if(now.isAfter(subuh.prayerTime) && now.isBefore(syuruk.prayerTime)){
//     return "Subuh";
//   }
//   else if(now.isAfter(syuruk.prayerTime) && now.isBefore(zuhur.prayerTime)){
//     return "Syuruk";
//   }
//   else if(now.isAfter(zuhur.prayerTime) && now.isBefore(asar.prayerTime)){
//     return "Zuhur";
//   }
//   else if(now.isAfter(asar.prayerTime) && now.isBefore(maghrib.prayerTime)){
//     return "Asar";
//   }
//   else if(now.isAfter(maghrib.prayerTime) && now.isBefore(isyak.prayerTime)){
//     return "Maghrib";
//   }
//   else if(now.isAfter(isyak.prayerTime) || now.isBefore(subuh.prayerTime)){
//     return "Isyak";
//   }
//   else {
//     return "Syuruk";
//   }
// }

//tutup dulu 
  String timeTillNextPrayer() {
  List<Prayer> prayers = [subuh, syuruk, zuhur, asar, maghrib, isyak];
  
  int currentIndex = prayers.indexWhere((prayer) => prayer == currentPrayer);
  Prayer nextPrayer = prayers[currentIndex];
  Duration timeRemaining;

  if (currentIndex >= 0 && currentIndex < prayers.length - 1) {
    nextPrayer = prayers[currentIndex + 1];
    if(currentPrayer == subuh){
      nextPrayer = zuhur;
    }
  timeRemaining = nextPrayer.prayerTime.difference(DateTime.now());
  } 
  else {
    if(currentPrayer == isyak){
      nextPrayer = subuh;
    }
    if(DateTime.now().isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59,))){//if before 11.59pm
    print("before 11.59pm");
      Duration midnightTillSubuh = nextPrayer.prayerTime.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00,));
      Duration nowTillMidnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59,).difference(DateTime.now());
      timeRemaining = midnightTillSubuh + nowTillMidnight;
      print('${DateTime.now()} \n${timeRemaining}');
      //print(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59,).difference(DateTime.now()));
    }
    else{
      print("after 11.59pm");
      timeRemaining = nextPrayer.prayerTime.difference(DateTime.now());
    }
  }

  int hours = timeRemaining.inHours;
  int minutes = timeRemaining.inMinutes.remainder(60);
  int seconds = timeRemaining.inSeconds.remainder(60);

   return hours>0 ? "Azan seterusnya dalam\n$hours jam, $minutes minit, $seconds saat" : "Azan seterusnya dalam\n$minutes minit, $seconds saat";
}


  void checkForMissedPrayers(){
    setState(() {
      List prayers = [subuh, syuruk, zuhur, asar, maghrib, isyak];

      for(int i=0; i<prayers.length; i++){
        if(prayers[i] == currentPrayer){//if current prayer, break
        print('${currentPrayer.prayerName}\n${prayers[i].prayerName}\nis current prayer: ${currentPrayer == prayers[i]}');
        break;
        }
        else if(prayers[i]!= currentPrayer && prayers[i].prayed == false){
          print("missed prayer: ${prayers[i].prayerName}");
          prayers[i].missed = true;
        }
      }
      });
  }

  void performPrayer() {
    setState(() {
    currentPrayer.prayed = true;
    print("${currentPrayer.prayerName} prayed}");
    //checkForMissedPrayers();
    });
  }

  Prayer getCurrentPrayer(){
    setState(() {
    });
    List<Prayer> prayers = [subuh, syuruk, zuhur, asar, maghrib, isyak];
    Prayer currentPrayerObj = prayers.firstWhere((prayer) => prayer == currentPrayer);
    return currentPrayerObj;
  }

  String circleText() {
    List prayers = [subuh, syuruk, zuhur, asar, maghrib, isyak];
    
    if(currentPrayer.prayed == true){
      return timeTillNextPrayer();
    }
    else if(isTimerRunning)
    {
      return displayMinute();
    }
    else{
      return "Mula solat ${currentPrayer.prayerName}";
    }
}
  IconData getPrayerIcon(Prayer prayer) {
  
  if(prayer.prayed == true){
    return Icons.check_circle;
  }
  else if(prayer.missed == true){
    return Icons.cancel;
  }
  else{
    return Icons.check_circle;
  }
}

Color getPrayerIconColor(Prayer prayer) {
  if(prayer == currentPrayer && prayer.prayed == false){
    return Colors.blue;
  }
  else if(prayer.prayed == true){
    return Colors.green;
    }
    else if(prayer.missed == true){
      return Colors.red;
    }
    else{
      return Colors.grey;
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
    _nextPrayerTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Jejak solat"),
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
                if (!isTimerRunning) {
                  // Update the prayer status after finishing the current prayer
                  // performPrayer();
                }
              }
            });
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF82618B),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15), // Shadow color
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Text(
                          circleText(),
                          // isTimerRunning
                          //     ? displayMinute()
                          //     : "Mula solat ${currentPrayer()}",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 270,
                      width: 270,
                      child: CircularProgressIndicator(
                        value: isTimerRunning ? calculateProgress() : 0.0,
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
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
                          Icon(
                            getPrayerIcon(subuh),
                            color: getPrayerIconColor(subuh),
                            size: 32,
                          ),
                          SizedBox(height: 3,),
                          Text("Subuh", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          getPrayerIcon(zuhur),
                          size: 32, 
                          color : getPrayerIconColor(zuhur),
                          ),
                          SizedBox(height: 3,),
                          Text("Zohor", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          getPrayerIcon(asar),
                          size: 32, 
                          color : getPrayerIconColor(asar),
                          ),
                          SizedBox(height: 3,),
                          Text("Asar", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          getPrayerIcon(maghrib), 
                          size: 32, 
                          color : getPrayerIconColor(maghrib),
                          ),
                          SizedBox(height: 3,),
                          Text("Maghrib", style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                          getPrayerIcon(isyak),
                          size: 32, 
                          color : getPrayerIconColor(isyak),
                          ),
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