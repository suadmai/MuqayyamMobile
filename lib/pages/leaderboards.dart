
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/components/layout.dart';
import '../firebase/firebase_config.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>{

  @override
  void initState() {
    super.initState();
  }

  Color getBorderColor(String userID){
    if(FirebaseAuth.instance.currentUser!.uid == userID){
      return Colors.blue;
    }
    else{
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Papan markah", style: TextStyle(color: Colors.white)),
      ),
      body:
       Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'Pengguna')
                    .orderBy('score', descending: true)
                    .snapshots(),
                  builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final user = data[index].data();
                        final username = user['username'] as String?;
                        final score = user['score'] as int?;
                        final userID = user['userID'] as String?;
                        final profilePicture = user['profilePicture'] as String?;
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: getBorderColor(userID!),
                              width: 2,
                            ),
                            boxShadow: const[
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset:  Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Text('# ${index + 1}'),
                                  const SizedBox(width: 10),
                                  CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  backgroundImage: profilePicture != null
                                      ? NetworkImage(profilePicture)
                                      : null, // Display the profile picture if available
                                  child: profilePicture == null
                                      ? const Icon(Icons.person, color: Colors.white)
                                      : null, // Show an icon if no profile picture is available
                                ),
                                  const SizedBox(width: 10),
                                  Text(
                                  username!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                    score.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ),
                            ],
                          ),
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
            ),
          ],
        ),
       )
    );
  }
}
