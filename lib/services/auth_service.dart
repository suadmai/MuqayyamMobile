import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      //sign in
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //create new documentfor user in collection in case doesent exist yet
      _firebaseFirestore.collection("users").doc(userCredential.user?.uid).set({
        "uid" : userCredential.user?.uid,
        "email" : email,
      });


      return userCredential;
    }
    // catch any login errors
    on FirebaseAuthException catch (e) {
      throw Exception("You are not Gehh yet!!! You cannot enter lahh");
    }
  }

  //create new user

  Future<UserCredential> signUpWithEmailandPassword(
      String username, String role, String email, String password) async {
    try {

      //create new user
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //create new documentfor user in collection after create user

      _firebaseFirestore.collection("users").doc(userCredential.user?.uid).set({
        "username" : username,
        "role" : role,
        "uid" : userCredential.user?.uid,
        "email" : email,
      });


      return userCredential;
    }
    // catch any register errors
    on FirebaseAuthException catch (e) {
      throw Exception("You failed at being gehh!!! Try again lahh");
    }
  }

  //sign user ouT
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
