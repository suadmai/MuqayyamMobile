import 'package:flutter/material.dart';
import 'dart:async';

class RamadanPage extends StatefulWidget {
  const RamadanPage({Key? key});

  @override
  State<RamadanPage> createState() => _RamadanPageState();
}

class _RamadanPageState extends State<RamadanPage> {
  int daysFasted = 0;
  late Timer timer; // Timer object for updating the time remaining.
  DateTime iftarTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 20); // Set the Iftar time to 7:20 PM.
  bool isButtonEnabled = false;

  String getTimeRemaining() {
    final now = DateTime.now();
    final difference = iftarTime.isAfter(now) ? iftarTime.difference(now) : Duration.zero;
    isButtonEnabled = difference.inMinutes <= 10;
    return '${difference.inHours}h ${difference.inMinutes.remainder(60)}m ${difference.inSeconds.remainder(60)}s';
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer when the widget is initialized.
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        getTimeRemaining();
      });
    });
  }

  void incrementFasts() {
    final now = DateTime.now();
    final difference = iftarTime.isAfter(now) ? iftarTime.difference(now) : Duration.zero;
    if (difference.inMinutes <= 10) {
      setState(() {
        daysFasted++;
      });
    } else {
      showSnackbar("Boleh tekan 10 minit sebelum buka.");
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed to prevent memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramadan Fasting Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hari Sudah Berpuasa: $daysFasted',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Waktu berbuka akan tiba dalam: ${getTimeRemaining()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '(Hanya boleh tekan 10 minit sebelum buka)',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isButtonEnabled ? incrementFasts : null,
                  child: Text('Saya Sudah Berpuasa'),
                  style: ButtonStyle(
                    backgroundColor: isButtonEnabled
                        ? MaterialStateProperty.all(Colors.blue) // Change the button color when enabled
                        : MaterialStateProperty.all(Colors.grey), // Grey out the button when disabled
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
