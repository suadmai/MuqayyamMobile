// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Future<void> logout(BuildContext context) async {
//   await FirebaseAuth.instance.signOut();
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const LoginPage(),
//     ),
//   );
// }

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void signOut() async {
  bool confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: Text('Sign Out'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  if (confirm) {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Selamat pagi!"),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              //go to profile page
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
      ),
      //floating action button must be center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(
            //context,
            //MaterialPageRoute(
              //builder: (context) =>
                  //CameraPage(cameraController: _cameraController),
            //),
          //);
        },
        child: const Icon(Icons.podcasts), 
        backgroundColor: Color(0xFF82618B),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF82618B),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Updated alignment
            children: <Widget>[
              // Home
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),

              // Search (You can replace this with your desired search functionality)
              IconButton(
                onPressed: () {
                  // Add your search functionality here
                },
                icon: const Icon(Icons.search),
                color: Colors.white,
              ),

              // Trophy (You can replace this with your desired trophy functionality)
              IconButton(
                onPressed: () {
                  // Add your trophy functionality here
                },
                icon: const Icon(Icons.emoji_events),
                color: Colors.white,  
              ),

              // Settings (You can replace this with your desired settings functionality)
              IconButton(
                onPressed: () {
                  // Add your settings functionality here
                },
                icon: const Icon(Icons.settings),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: 
      Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  offset: Offset(0, 3), // Changes position of shadow
                  blurRadius: 6, // Increases the blur of the shadow
                  spreadRadius: 0, // Increases the size of the shadow
                  ),
                ],
                ),
                child: Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.mosque_rounded, size: 32,)),
                        Text("Jejak solat", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.import_contacts_rounded, size: 32,)),
                        Text("Baca al-Quran", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.star_rounded, size: 32,)),
                        Text("Pencapaian", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.contact_support_rounded, size: 32,)),
                        Text("Hubungi pakar", style: TextStyle(fontSize: 12),),
                      ],
                    ),
                  ],
                )
                ),
              )
              ),
            ),
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('AllPosts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!.docs;
            final postCount = posts.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Maklumat terkini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index].data();
                      final postID = post['postID'] as String?;
                      final userID = post['userID'] as String?; // Handle null value
                      // final imageURL =
                      //     post['imageURL'] as String?;
                      final title = post['title'] as String?; // Handle null value
                      final description = post['description'] as String?; // Handle null value
                      final date = post["date"] as String?;

                      // return GestureDetector(
                      //   onTap: () {
                      //     // Navigate to details page and pass the report details
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => ViewDetailsPage(
                      //           reportID: reportID ?? '',
                      //           userID: userID ?? '',
                      //           animalType: animalType ?? '',
                      //           imageURL: imageURL ?? '',
                      //           title: title ?? '',
                      //           description: description ?? '',
                      //           location: location ?? '',
                      //         ),
                      //       ),
                      //     );
                      //   },
                        //child: 
                        return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue, // Set the profile image's background color
                                child: Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8), // Add some space between the profile image and the name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text(
                                      '$userID', // Replace with the user's name
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      //SizedBox(height: 8),
                                      Text(
                                      "$date", // Replace with the user's name
                                      style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: 12),
                                    ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                          '$title',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4), // Add some space between the title and the description
                        Text(
                          '$description',
                          style: TextStyle(fontSize: 14),
                          maxLines: 10,
                        ),
                          ]
                        ),
                        ),
                      );
                      //);
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
          ],
        ),
        )
      ),
    );
  }
}


//VIEW ONLY




