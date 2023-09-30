import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ClaimPage extends StatefulWidget {
  final rewardId;

  const ClaimPage({Key? key, required this.rewardId}) : super(key: key);

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
  final firebase = FirebaseFirestore.instance;
  
  Future<String> createUniqueCode() async{
    String code = "";
    final existingCodes = await firebase.collection('redeptions').get();

    do {
      code = Random().nextInt(999999).toString().padLeft(6, '0');
    } while (existingCodes.docs.any((doc) => doc['code'] == code));

    print('the code is : $code');
    return code;
  }

  void createRedemption(){
    firebase 
      .collection('redeptions')
      .add({
        'code': createUniqueCode(),
        'userId' : FirebaseAuth.instance.currentUser!.uid,
        'rewardId' : rewardId,
      });
  }

  @override
  void initState() {
    super.initState();
    createUniqueCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tebus ganjaran'),
        backgroundColor: const Color(0xFF82618B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //add pdding to the column
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100.0,),
              const SizedBox(height: 16.0),
              Text(
                //a;
                'Tahniah!',
                style: TextStyle(
                  fontSize: 24.0, 
                  fontWeight: FontWeight.bold
                  
                  ),
                  textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Anda telah berjaya menebus ganjaran ini',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              Image.asset(
                'images/qr.jpg',
                width: 200.0,
                height: 200.0,
              ),

              const SizedBox(height: 16.0),
              Text(
                'Sila tunjukkan kod QR untuk menebus ganjaran ini',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
                
              ),

            ],
          ),
        ),
      ),
    );
  }
}