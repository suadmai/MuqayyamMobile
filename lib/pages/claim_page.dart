import 'package:flutter/material.dart';

class ClaimPage extends StatelessWidget {
  const ClaimPage({Key? key}) : super(key: key);

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