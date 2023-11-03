import 'package:flutter/material.dart';

class TasbihPage extends StatefulWidget {
  @override
  _TasbihPageState createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _count = 0;

  void _incrementCount() {
    setState(() {
      _count++;
    });
  }

  void _resetCount() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Tasbih'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Container(
              width: 150, // You can adjust the size as needed
              height: 150, // You can adjust the size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF82618B),
              ),
              child: Center(
                child: Text(
                  '$_count',
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _incrementCount,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
