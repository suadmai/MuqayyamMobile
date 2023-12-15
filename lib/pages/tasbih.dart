import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class TasbihPage extends StatefulWidget {
  @override
  _TasbihPageState createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    setState(() {
      _count++;
    });
  }

  void _resetCount() {
    setState(() {
      _count = 0;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Tasbih'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150, // You can adjust the size as needed
              height: 150, // You can adjust the size as needed
              child: Center(
                child: Text(
                  '$_count',
                  style: const TextStyle(fontSize: 48, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 32),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _incrementCount,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
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
