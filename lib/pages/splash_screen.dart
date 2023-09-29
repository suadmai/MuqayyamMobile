import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wildlifego/pages/homeScreen.dart';
import 'package:wildlifego/services/auth_gate.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AuthGate()));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 250, 216, 255)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage('images/icon_transparent.png'),
                height: 300,
                width: 300,
              ),
              SizedBox(height: 10),
              Text(
                'Selamat Datang ke Nusantara™!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:Color(0xFF82618B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  
                ),
              )
            ],
          )),
    );
  }
}
