// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/pages/TrackPrayer.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:wildlifego/pages/new_quran_page.dart';
import 'package:wildlifego/pages/profile_page.dart';
import 'package:wildlifego/pages/new_rewards_page.dart';
import 'package:wildlifego/pages/siri.dart';
import 'package:wildlifego/pages/tasbih.dart';
import '../components/menu_buttons.dart';
import '../services/auth_service.dart';
import 'doctor/Admin_HomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const appVersion = '1.0.1';

void checkAppVersion(BuildContext context) {
  final firebase = FirebaseFirestore.instance;
  firebase.collection('appVersion').doc('version').get().then((value) {
    if (value.exists) {
      if (value.data()!['current_version'] != appVersion) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Kemas kini tersedia'),
              content: Text(
                  'Sila kemas kini aplikasi anda untuk menikmati fungsi terkini!'),
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

class _HomeScreenState extends State<HomeScreen> {

  String? _profilePictureUrl;
  late User _user;

  @override
  void initState() {
    super.initState();
    didChangeDependencies();
    checkAppVersion(context);
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _profilePictureUrl = userDoc.data()?['profilePicture']
          as String?; // Add this to load the profile picture URL
    });
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
    //print(newTextString);
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
        title: const Text("Nusantara™"),
        actions : <Widget>[
          //SIGN OUT NOT USED HERE
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
            icon: CircleAvatar(
              backgroundColor: Colors.white70,
              minRadius: 60.0,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: _profilePictureUrl != null
                    ? NetworkImage(_profilePictureUrl!)
                    : null, // Display the profile picture if available
                child: _profilePictureUrl == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white70)
                    : null, // Show an icon if no profile picture is available
              ),
            ),
          )
        ],
      ),



      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                //adjust height to fit the content
                height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                //make it scrollable
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  MenuButton(
                                    buttonText: 'Jejak Solat',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrackPrayer(),
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Track_Prayer.png',
                                  ),
                                  SizedBox(width: 10),
                            
                                  MenuButton(
                                    buttonText: 'Baca al-Quran',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const QuranPage(), // Pass the userID to the ChatPage
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Read_Quran.png',
                                  ),
                                  SizedBox(width: 10),

                                  MenuButton(
                                    buttonText: 'Tasbih',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TasbihPage(),
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Tasbih.png',
                                  ),
                                  SizedBox(width: 10),

                                  MenuButton(
                                    buttonText: 'Jejak Puasa',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SiriWave(),
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Ramadhan.png',
                                  ),
                                  SizedBox(width: 10),
                            
                                  MenuButton(
                                    buttonText: 'Papan Markah',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LeaderboardPage(), // Pass the userID to the ChatPage
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Leaderboards.png',
                                  ),
                            
                                  SizedBox(width: 10),
                            
                                  MenuButton(
                                    buttonText: 'Hubungi Pakar',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ContactExpert(), // Pass the userID to the ChatPage
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Contact_Expert.png',
                                  ),
                            
                                  SizedBox(width: 10),
                            
                                  MenuButton(
                                    buttonText: 'Ganjaran',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RewardsPage(), // Pass the userID to the ChatPage
                                        ),
                                      );
                                    },
                                    imagePath: 'lib/icons/icons_Rewards.png',
                                  ),
                                ],
                              ),
                            ),
                          )
                    )),
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
