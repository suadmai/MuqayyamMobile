import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'claim_page.dart';

void main() {
  runApp(MaterialApp(
    home: RewardsPage(),
  ));
}

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    fetchUserScore();
  }

  Future<void> fetchUserScore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final int? userScore = userDoc.get('score') as int?;
      if (userScore != null) {
        setState(() {
          totalPoints = userScore;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Ganjaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Markah saya',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalPoints.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFF82618B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ganjaran yang boleh ditebus',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rewards')
                    .orderBy('points_required', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document = documents[index];
                        return RewardItem(
                          rewardId: document.id,
                          title: document.get('title') as String,
                          description: document.get('description') as String,
                          pointsRequired:
                              document.get('points_required') as int,
                          userPoints: totalPoints,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RewardItem extends StatelessWidget {
  final String rewardId;
  final String title;
  final String description;
  final int pointsRequired;
  final int userPoints;

  RewardItem({
    required this.rewardId,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.userPoints,
  });

  Future<bool> isRewardClaimed(String userId) async {
    final DocumentSnapshot redeemedDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('redeemedRewards')
        .doc(rewardId)
        .get();

    return redeemedDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: getProgress(),
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF82618B)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mata diperlukan: $pointsRequired',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // final isClaimed =
                  //     await isRewardClaimed(FirebaseAuth.instance.currentUser!.uid);

                  // if (isClaimed) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Anda telah menebus ganjaran ini sebelum ini.'),
                  //     ),
                  //   );
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text('Anda telah berjaya menebus ganjaran ini!'),
                  //     ),
                  //   );

                  //   await FirebaseFirestore.instance
                  //       .collection('users')
                  //       .doc(FirebaseAuth.instance.currentUser!.uid)
                  //       .collection('redeemedRewards')
                  //       .doc(rewardId)
                  //       .set({
                  //     'claimedAt': FieldValue.serverTimestamp(),
                  //   });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClaimPage(rewardId: rewardId),
                      ),
                    );
                  //}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: userPoints >= pointsRequired
                      ? const Color(0xFF82618B)
                      : Colors.grey,
                ),
                child: const Text('Tebus'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getProgress() {
    if (pointsRequired <= 0) {
      return 1.0;
    }
    return userPoints / pointsRequired;
  }
}
