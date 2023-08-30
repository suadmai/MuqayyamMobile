import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  //insance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

      return userCredential;
    }
    // catch any login errors
    on FirebaseAuthException catch (e) {
      throw Exception("You are not Gehh yet!!! You cannot enter lahh");
    }
  }

  //create new user

  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      //create new user
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
