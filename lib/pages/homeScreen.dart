// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/components/layout.dart';
import 'package:wildlifego/pages/TrackPrayer.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:wildlifego/pages/new_quran_page.dart';
import 'package:wildlifego/pages/profile_page.dart';
import 'package:wildlifego/pages/ramadan_page.dart';
import 'package:wildlifego/pages/ranking_page.dart';
import 'package:wildlifego/pages/new_rewards_page.dart';


import '../components/bottom_app_bar.dart';
import '../services/auth_service.dart';
import 'doctor/Admin_HomeScreen.dart';
import 'leaderboards.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  const appVersion = '0.5.0';

  void checkAppVersion(BuildContext context){
    final firebase = FirebaseFirestore.instance;
    firebase.collection('appVersion').doc('version').get().then((value) {
      if(value.exists){
        if(value.data()!['current_version'] != appVersion){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Kemas kini tersedia'),
                content: Text('Sila kemas kini aplikasi anda untuk menikmati fungsi terkini!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
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
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

      // Handle navigation or other functionality based on the selected tab.
  }


  @override
  void initState() {
    super.initState();
    checkAppVersion(context);
  }

  bool containsNumber(String text) {
    final regex = RegExp(r'\d');
    return regex.hasMatch(text);
  }

  String formatText(String text) {
    var newText = text.split('');
    //loop through each character
    for (int i = 0; i < newText.length; i++) {
      //if the character is a hyphen followed by a space
      if (newText[i] == '-' &&
          i + 1 < newText.length &&
          newText[i + 1] == ' ') {
        if (i > 0) {
          newText[i] = '\n\n-';
        } else {
          newText[i] = '-';
        }
      }
      //if the character is a period followed by a number
      if (containsNumber(newText[i]) &&
          newText[i + 1] == '.' &&
          i + 1 < newText.length) {
        if (i > 0) {
          newText[i] = '\n\n${newText[i]}';
        } else {
          newText[i] = newText[i];
        }
      }
    }
    String newTextString = newText.join();
    print(newTextString);
    return newTextString;
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
        title: const Text("Muqayyam™"),
        actions: [
          //
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
                  builder: (context) =>
                      const ProfilePage(), // Pass the userID to the ChatPage
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

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomAppBar(
         onTabSelected: _onTabSelected,
        currentIndex: _currentIndex,
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
                          offset: Offset(0, 3), // Changes position of shadow
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
                                        icon: Icon(
                                          Icons.mosque_rounded,
                                          size: 32,
                                          color:
                                              Color.fromARGB(255, 74, 80, 255),
                                        )),
                                    Text(
                                      "Jejak solat",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
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
                                        icon: Icon(
                                          Icons.import_contacts_rounded,
                                          size: 32,
                                          color: Colors.green,
                                        )),
                                    Text(
                                      "Baca al-Quran",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
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
                                            builder: (context) =>
                                                const RamadanPage(),
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
                                      icon: Icon(
                                        Icons.nights_stay_rounded,
                                        size: 32,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Text(
                                      "Jejak Ramadan",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
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
                                        icon: Icon(
                                          Icons.star_rounded,
                                          size: 32,
                                          color: Colors.yellow,
                                        )),
                                    Text(
                                      "Pencapaian",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
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
                                        icon: Icon(
                                          Icons.contact_support_rounded,
                                          size: 32,
                                          color: Color(0xFF82618B),
                                        )),
                                    Text(
                                      "Hubungi pakar",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
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
                                        icon: Icon(
                                          Icons.card_giftcard_rounded,
                                          size: 32,
                                          color: Colors.blue,
                                        )),
                                    Text(
                                      "Ganjaran",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          )),
                    )),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Maklumat terkini",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
                          final username = post['username'] as String?;
                          final title = post['title'] as String?;
                          final description = post['description'] as String?;
                          final date = post["date"] as String?;
                          final imageURL = post['imageURL'] as String?;
                          final postType = post['postType'] as String?;

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
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors
                                              .blue, // Set the profile image's background color
                                          child: Icon(
                                            Icons.person,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Add some space between the profile image and the name
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$username', // Replace with the user's name
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  //SizedBox(height: 8),
                                                  Text(
                                                    // date format dd/mm/yyyy
                                                    DateFormat("dd/MM/yyyy")
                                                        .format(DateTime.parse(
                                                            date!)),
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                    SizedBox(
                                        height:
                                            4), // Add some space between the title and the description
                                    Text(
                                      formatText(description!),
                                      style: TextStyle(fontSize: 14),
                                      //maxLines: 10,
                                    ),
                                    SizedBox(height: 8),
                                    if (postType == 'image' && imageURL != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          imageURL,
                                          width: double
                                              .infinity, // Make the image expand to the full width
                                          height:
                                              400, // Set the height as needed
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
