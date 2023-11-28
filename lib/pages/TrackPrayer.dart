// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:wildlifego/components/bottom_app_bar.dart';

extension StringExtensions on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class PrayerTime {
  final String name;
  final String time;

  PrayerTime({required this.name, required this.time});

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      name: json['name'],
      time: json['time'],
    );
  }
}

class Prayer{
  String prayerName = "";
  DateTime prayerTime = DateTime.now();
  bool prayed = false;
  bool missed = false;
  int prayerScore = 0;
}

class TrackPrayer extends StatefulWidget {
  final Prayer subuh;
  final Prayer syuruk;
  final Prayer zohor;
  final Prayer asar;
  final Prayer maghrib;
  final Prayer isyak;

  const TrackPrayer(
    {Key? key,
    required this.subuh, 
    required this.syuruk,
    required this.zohor,
    required this.asar,
    required this.maghrib,
    required this.isyak,
    }) : super(key: key);
  
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
  bool prayersReset = false;
  bool prayerTimesUpdated = false;
  DateTime lastResetDate = DateTime.now().subtract(Duration(days: 1));
  Prayer currentPrayer = Prayer();

  Prayer subuh = Prayer();
  Prayer syuruk = Prayer();
  Prayer zohor = Prayer();
  Prayer asar = Prayer();
  Prayer maghrib = Prayer();
  Prayer isyak = Prayer();

  // Prayer subuh = Prayer()
  //               ..prayerName = "subuh"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = false
  //               ..missed = false
  //               ..prayerScore = 5;

  // Prayer syuruk = Prayer()
  //               ..prayerName = "syuruk"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = true
  //               ..missed = false;

  // Prayer zohor = Prayer()
  //               ..prayerName = "zohor"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = false
  //               ..missed = false
  //               ..prayerScore = 4;

  // Prayer asar = Prayer()
  //               ..prayerName = "asar"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = false
  //               ..missed = false
  //               ..prayerScore = 4;

  // Prayer maghrib = Prayer()
  //               ..prayerName = "maghrib"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = false
  //               ..missed = false
  //               ..prayerScore = 3;

  // Prayer isyak = Prayer()
  //               ..prayerName = "isyak"
  //               ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
  //               ..prayed = false
  //               ..missed = false
  //               ..prayerScore = 4;

   @override
    void initState() {
    super.initState();
    initializePage();
    //checkForMissedPrayers();
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration, // Adjust the duration as needed
    );
    
    _nextPrayerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Call setState to trigger a UI update
      setState(() {});
      // if(prayerTimesUpdated){
      //   setCurrentPrayer();
      //   checkForMissedPrayers();
      // }
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
  

  Future<void> initializePage() async {
    subuh = widget.subuh;
    syuruk = widget.syuruk;
    zohor = widget.zohor;
    asar = widget.asar;
    maghrib = widget.maghrib;
    isyak = widget.isyak;
    setCurrentPrayer();
    checkForMissedPrayers();
    //fetchPrayerTimes();
    //await syncPrayerData();
  }

  Future<void> storePrayerData() async {
    Map<String,bool>prayerData = {
      'subuh': subuh.prayed,
      'syuruk': syuruk.prayed,
      'zohor': zohor.prayed,
      'asar': asar.prayed,
      'maghrib': maghrib.prayed,
      'isyak': isyak.prayed,
    };
    String currentDate;

    if(DateTime.now().isBefore(subuh.prayerTime)){
      //if the current time is before subuh, set the date to yesterday
      //print('current time is before subuh');
      currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
    }
    else{
      //print('current time is after subuh');
      currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    //store prayer data for each user
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('daily_prayers').doc(currentDate).set(prayerData);
    //await FirebaseFirestore.instance.collection('daily_prayers').doc(currentDate).set(prayerData);
    print('firebase write from storePrayerData');
  }

  // Future <void> syncPrayerData() async{
  //   String currentDate;
  //   try{
  //     if(DateTime.now().isBefore(subuh.prayerTime)){
  //       //if the current time is before subuh, set the date to yesterday
  //       //print('current time is before subuh\nThe time now is ${DateTime.now()} and subuh is ${subuh.prayerTime}');
  //       currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
  //       //print('the date is $currentDate');
  //     }
  //     else{
  //       //print('current time is after subuh\nThe time now is ${DateTime.now()} and subuh is ${subuh.prayerTime}');
  //       currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //       //print('the date is $currentDate');
  //     }

  //     //read prayer data from firebase of each user
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('daily_prayers').doc(currentDate).get();
  //     print('firebase read from syncPrayerData');
  //     if(snapshot.exists){
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       //print(data);
  //       setState(() {
  //         subuh.prayed = data['subuh'];
  //         syuruk.prayed = data['syuruk'];
  //         zohor.prayed = data['zohor'];
  //         asar.prayed = data['asar'];
  //         maghrib.prayed = data['maghrib'];
  //         isyak.prayed = data['isyak'];
  //       });
  //     }
  //     else{
  //       print('snapshot does not exist');
  //       storePrayerData();
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }

//   Future<void> fetchPrayerTimes() async {
//   final response = await http.get(Uri.parse('https://waktu-solat-api.herokuapp.com/api/v1/prayer_times.json?zon=gombak'));

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     List<dynamic> dataJson = jsonData['data'][0]['waktu_solat'];
//     List<Prayer> prayers = [subuh, syuruk, zohor, asar, maghrib, isyak]; // Use the Prayer objects directly
    
//     DateTime now = DateTime.now();

//     for (var waktuSolatJson in dataJson) {
//       String prayerName = waktuSolatJson['name'];
//       String prayerTime = waktuSolatJson['time'];

//       // Parse the prayerTime string and create a new DateTime object
//       List<int> parsedTime = prayerTime.split(':').map(int.parse).toList();
//       DateTime updatedDateTime = DateTime(now.year, now.month, now.day, parsedTime[0], parsedTime[1]);
//       //print('$prayerName : $updatedDateTime');
//       if (prayerName != "imsak") {
//         // Find the corresponding Prayer object and update its prayerTime
//         prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerTime = updatedDateTime;
//         //print('updated ${prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerName} to ${prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerTime}');
//       }
//     }

//     // Update the UI or perform any necessary actions after updating prayer times
//     // setState(() {
//     //   // ...
//     // });
//   } else {
//     print('Failed to fetch data');
//   }
//   prayerTimesUpdated = true;
// }

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

  void resetPrayers(){
    print('resetPrayers() called');
    DateTime now = DateTime.now();

    if(now.day != lastResetDate.day){
        print('last reset was on $lastResetDate\nresetting prayers');
        subuh..prayed = false..missed = false;
        syuruk..prayed = true..missed = false;
        zohor..prayed = false..missed = false;
        asar..prayed = false..missed = false;
        maghrib..prayed = false..missed = false;
        isyak..prayed = false..missed = false;
        lastResetDate = DateTime.now();
    }
    else{
      print('prayers already reset');
    }
  }

  void setCurrentPrayer(){
    setState(() {
      //List prayers = [subuh, syuruk, zohor, asar, maghrib, isyak];
      //currentPrayer = prayers[0];//for testing purposes, set to subuh
      DateTime now = DateTime.now();

      if(now.isAfter(subuh.prayerTime) && now.isBefore(syuruk.prayerTime)){
        currentPrayer = subuh;
        //fetchPrayerTimes();
        resetPrayers();
        storePrayerData();
        //print('current prayer: ${currentPrayer.prayerName}');
      }
      else if(now.isAfter(syuruk.prayerTime) && now.isBefore(zohor.prayerTime)){
        currentPrayer = syuruk;
        //print('current prayer: ${currentPrayer.prayerName} because the time is $now and syuruk is ${syuruk.prayerTime}');
      }
      else if(now.isAfter(zohor.prayerTime) && now.isBefore(asar.prayerTime)){
        currentPrayer = zohor;
        //print('current prayer: ${currentPrayer.prayerName}');
      }
      else if(now.isAfter(asar.prayerTime) && now.isBefore(maghrib.prayerTime)){
        currentPrayer = asar;
        //print('current prayer: ${currentPrayer.prayerName}');
      }
      else if(now.isAfter(maghrib.prayerTime) && now.isBefore(isyak.prayerTime)){
        currentPrayer = maghrib;
        //print('current prayer: ${currentPrayer.prayerName}');
      }
      else if(now.isAfter(isyak.prayerTime) || now.isBefore(subuh.prayerTime)){
        currentPrayer = isyak;
        //print('current prayer: ${currentPrayer.prayerName} because the time is $now and isyak is ${isyak.prayerTime}');
      }
      else {
        currentPrayer = isyak;
        //print('else territory: ${currentPrayer.prayerName}');
      }
    });
  }

  String timeTillNextPrayer() {
  List<Prayer> prayers = [subuh, syuruk, zohor, asar, maghrib, isyak];
  
  int currentIndex = prayers.indexWhere((prayer) => prayer == currentPrayer);
  Prayer nextPrayer = prayers[currentIndex];
  Duration timeRemaining;

  if (currentIndex >= 0 && currentIndex < prayers.length-1) {
    nextPrayer = prayers[currentIndex + 1];
    if(currentPrayer == subuh){
      nextPrayer = zohor;
    }
    
  timeRemaining = nextPrayer.prayerTime.difference(DateTime.now());
  } 
  else { // If the current prayer is the last prayer of the day (isyak)
    nextPrayer = subuh;
    if (DateTime.now().isAfter(isyak.prayerTime)) {
    // Calculate time remaining until the next "subuh" prayer after midnight
    DateTime nextSubuh = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, subuh.prayerTime.hour, subuh.prayerTime.minute);
    timeRemaining = nextSubuh.difference(DateTime.now());
    if (timeRemaining.isNegative) {
      // If the current time is after "subuh," it means the next "subuh" is tomorrow
      nextSubuh = nextSubuh.add(Duration(days: 1));
      timeRemaining = nextSubuh.difference(DateTime.now());
    }
  } else {
    // Calculate time remaining for other prayers
    timeRemaining = nextPrayer.prayerTime.difference(DateTime.now());
}
  }

  int hours = timeRemaining.inHours;
  int minutes = timeRemaining.inMinutes.remainder(60);
  int seconds = timeRemaining.inSeconds.remainder(60);

   return hours > 0 ?
    "${nextPrayer.prayerName.capitalizeFirst()} dalam\n$hours jam, $minutes minit, $seconds saat"
    : "${nextPrayer.prayerName.capitalizeFirst()} dalam\n$minutes minit, $seconds saat"; 
}

  void checkForMissedPrayers(){
    setState(() {
      List prayers = [subuh, syuruk, zohor, asar, maghrib, isyak];

      for(int i=0; i<prayers.length; i++){
        if(prayers[i] == currentPrayer){//if current prayer, break
        //print('${currentPrayer.prayerName}\n${prayers[i].prayerName}\nis current prayer: ${currentPrayer == prayers[i]}');
        break;
        }
        else if(prayers[i]!= currentPrayer && prayers[i].prayed == false){
          //print("missed prayer: ${prayers[i].prayerName}");
          prayers[i].missed = true;
        }
      }
      });
  }

  void performPrayer() {
    setState(() {
    currentPrayer.prayed = true;
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'score': FieldValue.increment(currentPrayer.prayerScore)});
    storePrayerData();
    //print("${currentPrayer.prayerName} prayed}");
    //checkForMissedPrayers();
    });
  }

  Prayer getCurrentPrayer(){
    setState(() {
    });
    List<Prayer> prayers = [subuh, syuruk, zohor, asar, maghrib, isyak];
    Prayer currentPrayerObj = prayers.firstWhere((prayer) => prayer == currentPrayer);
    return currentPrayerObj;
  }

  String circleText() {
    
    if(currentPrayer.prayed == true || currentPrayer.prayerName == "syuruk"){
      return timeTillNextPrayer();
    }
    else if(isTimerRunning)
    {
      return displayMinute();
    }
    else{
      return "Mula solat ${currentPrayer.prayerName.capitalizeFirst()}";
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     //Navigator.push(
      //       //context,
      //       //MaterialPageRoute(
      //         //builder: (context) =>
      //             //CameraPage(cameraController: _cameraController),
      //       //),
      //     //);
      //   }, 
      //   backgroundColor: Color(0xFF82618B),
      //   child: const Icon(Icons.podcasts),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: MyBottomAppBar(
      //   
      // ),


      body: Stack(
        children: [
          Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          GestureDetector(
          onTap: () {
            setState(() {
              if(!currentPrayer.prayed){
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
              }
            });
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPrayer.prayed? Color(0xFF82618B).withOpacity(0.3): Color(0xFF82618B),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            getPrayerIcon(subuh),
                            color: getPrayerIconColor(subuh),
                            size: 32,
                          ),
                          //SizedBox(height: 3,),
                          Text("Subuh", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                          //display prayer time in 24 hour format
                          Text(
                          DateFormat('HH:mm').format(subuh.prayerTime),
                          style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                          getPrayerIcon(zohor),
                          size: 32, 
                          color : getPrayerIconColor(zohor),
                          ),
                          //SizedBox(height: 3,),
                          Text("Zohor", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                          Text(
                          DateFormat('HH:mm').format(zohor.prayerTime),
                          style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                          getPrayerIcon(asar),
                          size: 32, 
                          color : getPrayerIconColor(asar),
                          ),
                          //SizedBox(height: 3,),
                          Text("Asar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                          Text(
                          DateFormat('HH:mm').format(asar.prayerTime),
                          style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                          getPrayerIcon(maghrib), 
                          size: 32, 
                          color : getPrayerIconColor(maghrib),
                          ),
                          //SizedBox(height: 3,),
                          Text("Maghrib", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                          Text(
                          DateFormat('HH:mm').format(maghrib.prayerTime),
                          style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                          getPrayerIcon(isyak),
                          size: 32, 
                          color : getPrayerIconColor(isyak),
                          ),
                          //SizedBox(height: 3,),
                          Text("Isyak", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                          Text(
                          DateFormat('HH:mm').format(isyak.prayerTime),
                          style: TextStyle(fontSize: 12),
                          ),
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
  //THE HENTAM WAY
}