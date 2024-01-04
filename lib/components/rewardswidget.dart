import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/firebase/firebase_config.dart';


class RewardsWidget extends StatefulWidget {
  final String patientId;

  const RewardsWidget({Key? key, required this.patientId}) : super(key: key);

  @override
  State<RewardsWidget> createState() => _RewardsWidgetState();
}

class _RewardsWidgetState extends State<RewardsWidget> {
  FirebaseFirestore firestore = FirebaseConfig.firestore;
  late var redemptions = [];
  final redemtionList = [];

  @override
  void initState() {
    super.initState();
    getRedemptions();
  }

  void getRedemptions() async {
    final redemptionsData =
        await firestore.collection('users').doc(widget.patientId).collection('redemptions').get();
    setState(() {
      redemptions = redemptionsData.docs;
    });

    for (var redemption in redemptions) {
      redemtionList.add(redemption.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Senarai Kod Tebusan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: redemptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Container(
                        alignment: Alignment.center,
                        child: Text(
                          redemptions[index].id,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Selesai'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
