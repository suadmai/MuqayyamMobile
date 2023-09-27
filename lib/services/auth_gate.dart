import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../pages/doctor/Admin_HomeScreen.dart';
import '../pages/homeScreen.dart';
import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the user is logged in
          if (snapshot.hasData) {
            // User is logged in, fetch their role from Firestore
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.done) {
                    if (roleSnapshot.hasData) {
                      final userRole = roleSnapshot.data!['role'];

                      // Check user role and navigate accordingly
                      if (userRole == 'Doktor') {
                        return const AdminHomeScreen();
                      } else {
                        return const HomeScreen();
                      }
                    } else {
                      // Handle error or loading state
                      return const CircularProgressIndicator(); // Placeholder for loading
                    }
                  } else {
                    // Handle error or loading state
                    return const CircularProgressIndicator(); // Placeholder for loading
                  }
                },
              );
            }
          }

          // User is NOT logged in
          return const LoginOrRegister();
        },
      ),
    );
  }
}
