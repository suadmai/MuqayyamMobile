import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/pages/TrackPrayer.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:wildlifego/pages/new_quran_page.dart';
import 'package:wildlifego/pages/profile_page.dart';
import 'package:wildlifego/pages/ramadan_page.dart';
import 'package:wildlifego/pages/ranking_page.dart';
import 'package:wildlifego/pages/rewards_page.dart';

import '../services/auth_service.dart';
import 'doctor/Admin_HomeScreen.dart';
import 'leaderboards.dart';

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
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text('Sign Out'),
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
      backgroundColor: const Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Muqayyam Mobile™"),
        actions: [
          // IconButton(
          //   onPressed: signOut,
          //   icon: const Icon(Icons.logout),
          // ),


          IconButton(
            onPressed: () {

              //go to profile page
              Navigator.push(
                
                context,
                MaterialPageRoute(
                builder: (context) =>  const ProfilePage(), // Pass the userID to the ChatPage
                ),
              );

              
              
            },
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
          )
        ],
      ),


      //DRAWER NOT USED FOR NOW
      
//       drawer: Drawer(
//   child: StreamBuilder<User?>(
//     stream: FirebaseAuth.instance.authStateChanges(),
//     builder: (context, userSnapshot) {
//       if (userSnapshot.connectionState == ConnectionState.waiting) {
//         return CircularProgressIndicator();
//       } else if (!userSnapshot.hasData) {
//         return Container(); // No user is signed in, you can handle this case as needed.
//       }

//       final User user = userSnapshot.data!;
//       return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
//         builder: (context, userDocumentSnapshot) {
//           if (userDocumentSnapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (!userDocumentSnapshot.hasData) {
//             return Container(); // Handle the case when user data is not available.
//           }

//           final userData = userDocumentSnapshot.data!.data() as Map<String, dynamic>?;
//           final String? nickname = userData?['username'] as String?;

//           return ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("images/profile.jpg"),
//                     fit: BoxFit.cover,
//                   ),
//                   color: Colors.blue,
//                 ),
//                 child: Text(
//                   nickname ?? 'Anonymous', // Display the user's nickname or 'Anonymous' if not available
//                   style: TextStyle(
//                     backgroundColor: Colors.black.withOpacity(0.5),
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.star_rounded),
//                 iconColor: Colors.yellow,
//                 title: const Text('Pangkat'),
//                 onTap: () {
//                   // Update the state of the app.
//                   // ...
//                 },
//               ),
//               ListTile(
                
//                 leading : const Icon(Icons.card_giftcard),
//                 iconColor: Colors.blue,
//                 title: const Text('Hadiah'),
//                 onTap: () {
//                   // Update the state of the app.
//                   // ...
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     },
//   ),
// ),

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
        backgroundColor: const Color(0xFF82618B),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF82618B),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Updated alignment
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset: const Offset(0, 3), // Changes position of shadow
                          blurRadius: 6, // Increases the blur of the shadow
                          spreadRadius: 0, // Increases the size of the shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            
                            child: Row(
                              //make it scrollable
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TrackPrayer(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.mosque_rounded,
                                          size: 32,
                                        )),
                                    const Text(
                                      "Jejak solat",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const QuranPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.import_contacts_rounded,
                                          size: 32,
                                        )),
                                    const Text(
                                      "Baca al-Quran",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),

                                Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    IconButton(
      onPressed: () {
        // final currentDate = DateTime.now();
        // final enableDate = DateTime(2024, 3, 12);

        // if (currentDate.isAfter(enableDate)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RamadanPage(),
            ),
          );
        // } 
        // else {
        //   showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('Access Restricted'),
        //         content: Text('Access to this page will be available after March 12, 2024.'),
        //         actions: <Widget>[
        //           TextButton(
        //             child: Text('OK'),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     },
        //   );
        // }
      },
      icon: const Icon(
        Icons.nights_stay_rounded,
        size: 32,
      ),
    ),
    const Text(
      "Jejak Ramadan",
      style: TextStyle(fontSize: 12),
    ),
  ],
),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LeaderboardPage(), // Pass the userID to the ChatPage
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.star_rounded,
                                          size: 32,
                                        )),
                                    const Text(
                                      "Pencapaian",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ContactExpert(), // Pass the userID to the ChatPage
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.contact_support_rounded,
                                          size: 32,
                                        )),
                                    const Text(
                                      "Hubungi pakar",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                   RewardsPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.card_giftcard_rounded,
                                          size: 32,
                                          color: Colors.blue,
                                        )),
                                    const Text(
                                      "Hadiah",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RankingPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.star_rounded,
                                          size: 32,
                                          color: Colors.yellow,
                                        )),
                                    const Text(
                                      "Pangkat",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 10),
                                
                              ],
                            ),
                          )),
                    )),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Maklumat terkini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('AllPosts')
                        .orderBy('date', descending: true)
                        .snapshots(),
                        builder: (context, snapshot) {
                        if (snapshot.hasData) {
                        final posts = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index].data();
                            final userID = post['userID'] as String?;
                            final username =
                                post['username'] as String?;
                            final title =
                                post['title'] as String?;
                            final description = post['description']
                                as String?;
                            final date = post["date"] as String?;
                            final imageURL = post['imageURL'] as String?;
                            final postType = post['postType'] as String?;
                            
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors
                                                  .blue, // Set the profile image's background color
                                              child: Icon(
                                                Icons.person,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Add some space between the profile image and the name
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '$username', // Replace with the user's name
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      //SizedBox(height: 8),
                                                      Text(
                                                        // date format dd/mm/yyyy
                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(date!)), 
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(height: 12),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '$title',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                4), // Add some space between the title and the description
                                        Text(
                                          '$description',
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 10,
                                        ),
                                        const SizedBox(height: 8),
                                        if (postType == 'image' && imageURL != null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child:
                                          Image.network(
                                            imageURL,
                                            width: double.infinity, // Make the image expand to the full width
                                            height: 400, // Set the height as needed
                                            fit: BoxFit.cover,
                                          ),
                                          ),
                                        if (postType == 'video' && imageURL != null)
                                          VideoPlayerWidget(videoUrl: imageURL),
                                          // ClipRRect(
                                          //   borderRadius:
                                          //     BorderRadius.circular(16),
                                          //     child: AspectRatio(
                                          //     aspectRatio: 16 / 9,
                                          //     child: VideoPlayer(
                                          //       VideoPlayerController.networkUrl(
                                          //         Uri.parse(imageURL),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                      ]),
                                ),
                              );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return ErrorWidget(snapshot.error!);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//VIEW ONLY
