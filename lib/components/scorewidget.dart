import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class ScoreWidget extends StatefulWidget {
  final String patientId;

  const ScoreWidget({Key? key, required this.patientId}) : super(key: key);

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    getScore();
  }

  Future<void> getScore() async {
    final userData = await firestore.collection('users').doc(widget.patientId).get();
    setState(() {
      userScore = userData.data()!['score'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Jumlah Markah',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                TweenAnimationBuilder(
                  tween: IntTween(begin: 0, end: userScore),
                  duration: const Duration(seconds: 1),
                  builder: (context, int value, child) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
