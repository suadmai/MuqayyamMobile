import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/pages/splash_screen.dart';
import 'package:wildlifego/services/auth_gate.dart';
import 'package:wildlifego/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'firebase/firebase_options.dart';
import 'pages/homeScreen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/pages/TrackPrayer.dart';

List<Widget> imageWidgets = [];


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
      
      ),
  );



}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

