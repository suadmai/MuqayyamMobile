import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:wildlifego/pages/register_page.dart';
import 'package:wildlifego/pages/login_page.dart';

import '../pages/doctor/Admin_HomeScreen.dart';
import '../pages/homeScreen.dart';
import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key});

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
                    if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
                      final userRole = roleSnapshot.data!['role'];

                      // Check user role and navigate accordingly
                      if (userRole == 'Doktor') {
                        return const AdminHomeScreen();
                      } else {
                        return  HomeScreen();
                      }
                    } else {
                      // Handle the case where the document is missing or null
                      return const Center(
                        child: CircularProgressIndicator(), // Placeholder for loading
                      );
                    }
                  } else if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for the data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // Handle other connection states
                    return const Center(
                      child: Text('Error loading data'),
                    );
                  }
                },
              );
            }
          }

          // User is NOT logged in
          return LoginPage();
        },
      ),
    );
  }
}
