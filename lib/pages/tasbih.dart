import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TasbihPage extends StatefulWidget {
  @override
  _TasbihPageState createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? lastTap;
  static const int minTapDuration = 200;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    //_saveCount();
  }

  @override
  void dispose() {
    _saveCount();
    super.dispose();
  }

  void _incrementCount() {
    DateTime now = DateTime.now();
      if (lastTap != null && now.difference(lastTap!) < const Duration(milliseconds: minTapDuration)) {
        // If tapped too quickly, show a message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Terlalu Laju!'),
              content: const Text('Pastikan anda berzikir dengan tenang dan khusyuk.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
      return;
    }
    
    setState(() {
      _count++;
    });

    lastTap = now; // Update the last tap time
    
  }

  void _resetCount() {
    setState(() {
      _count = 0;
    });
  }

  void vibrate(){
    if(_count%10 == 0){
      Vibration.vibrate(duration: 5, amplitude: 230);
    }
    else{
      Vibration.vibrate(duration: 5, amplitude: 100);
    }
  }

  void _saveCount() async {
    print('saving count');
    int previousCount = 0;

    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tasbih')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        previousCount = value.data()!['count'];
      }
    });

    await firestore.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('tasbih')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
        'count': _count+previousCount,
      });
    
    await firestore.collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .update({
      'score': FieldValue.increment(_count),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Tasbih', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150, // You can adjust the size as needed
              height: 150, // You can adjust the size as needed
              child: Center(
                child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150), // Set the duration for the text transition
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Text(
                  '$_count',
                  key: ValueKey<int>(_count),
                  style: const TextStyle(fontSize: 48, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: ElevatedButton(
                    //remove style
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    ),
                    onPressed: (){
                      //check if the user taps too fast

                      _incrementCount();
                      vibrate();
                    },
                    child: Container(
                      //add circle shape
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF82618B),
                      ),
                      child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 48,
                            color: Colors.white,),
                        ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      //remove style
                      style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    ),
                      onPressed: (){
                        _resetCount();
                      },
                      child: Container(
                        //add circle shape
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF82618B),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.restart_alt,
                            size: 24,
                            color: Colors.white,),
                      ),
                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
