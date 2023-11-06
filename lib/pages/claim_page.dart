import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClaimPage extends StatefulWidget {
  final String uniqueCode;

  const ClaimPage({Key? key, required this.uniqueCode}) : super(key: key);

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
  final firebase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    print('unique code is: $widget.uniqueCode');
    //_initializeRedemption();
  }

  // Future<void> _initializeRedemption() async {
  //   final String uniqueCode = await createUniqueCode();
  //   await createRedemption(uniqueCode);
  // }

  // Future<String> createUniqueCode() async {
  //   String code = "";
  //   //check from user document if the code already exists

  //   QuerySnapshot existingCodes = await firebase
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('redemptions')
  //       .get();

  //   do {
  //     code = Random().nextInt(999999).toString().padLeft(6, '0');
  //   } while (existingCodes.docs.any((doc) => doc['code'] == code));

  //   print('the code is : $code');
  //   return code;
  // }

  // Future<void> createRedemption(String uniqueCode) async {
  //   //check if reward with rewardId exists in any of the user's redemptions
  //   QuerySnapshot existingRedemptions = await firebase
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('redemptions')
  //       .where('rewardId', isEqualTo: widget.rewardId)
  //       .get();

  //   if (existingRedemptions.docs.isEmpty) {
  //   //create a firebase document inside user document
  //   DocumentReference userReference = firebase.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  //   CollectionReference redemptionsCollectionRef = userReference.collection('redemptions');
  //   DocumentReference redemptionDocumentRef = redemptionsCollectionRef.doc(uniqueCode);

  //   await redemptionDocumentRef.set({
  //   'code': uniqueCode,
  //   'userId': FirebaseAuth.instance.currentUser!.uid,
  //   'rewardId': widget.rewardId,
  //   });
  //     setState(() {
  //       uniqueCode = uniqueCode;
  //     });
  //   }
  //   else{
  //     //set the unique code to the existing code
  //     setState(() {
  //       uniqueCode = existingRedemptions.docs.first['code'];
  //     });
  //     print('reward already redeemed');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Tebus ganjaran'),
      backgroundColor: const Color(0xFF82618B),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Tahniah!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Anda telah berjaya menebus ganjaran ini',
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Kod Unik Anda:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.uniqueCode,
              style: const TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            // FutureBuilder<String>(
            //   future: createUniqueCode(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       return Text(
            //         snapshot.data ?? 'Generating code...',
            //         style: const TextStyle(fontSize: 20.0),
            //         textAlign: TextAlign.center,
            //       );
            //     } else {
            //       return const CircularProgressIndicator(); // Show a loading indicator while generating the code.
            //     }
            //   },
            // ),
          ],
        ),
      ),
    ),
  );
}

}
