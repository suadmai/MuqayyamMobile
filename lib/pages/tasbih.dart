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
        .doc(DateTime.now().toString())
        .get()
        .then((value) {
      if (value.exists) {
        previousCount = value.data()!['count'];
      }
    });

    print (previousCount);

    await firestore.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('tasbih')
      .doc(DateTime.now().toString())
      .set({
        'count': _count+previousCount,
      });

    // _resetCount();
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
            Text(
              'Count',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Container(
              width: 150, // You can adjust the size as needed
              height: 150, // You can adjust the size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF82618B),
              ),
              child: Center(
                child: Text(
                  '$_count',
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _incrementCount,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
