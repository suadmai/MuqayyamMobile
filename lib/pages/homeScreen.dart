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
import 'package:wildlifego/pages/tasbih.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/bottom_app_bar.dart';
import '../components/menu_buttons.dart';
import '../services/auth_service.dart';
import 'doctor/Admin_HomeScreen.dart';
import 'leaderboards.dart';

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
  //FOR DETAILED BOTTOM APP BAR (CustomBottomAppBar)

  // int _currentIndex = 0;

  // void _onTabSelected(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });

  //     // Handle navigation or other functionality based on the selected tab.
  // }

  String? _profilePictureUrl;
  late User _user;
  bool prayerTimesUpdated = false;
  
  Prayer subuh = Prayer()
                ..prayerName = "subuh"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = false
                ..missed = false
                ..prayerScore = 5;

  Prayer syuruk = Prayer()
                ..prayerName = "syuruk"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = true
                ..missed = false;

  Prayer zohor = Prayer()
                ..prayerName = "zohor"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = false
                ..missed = false
                ..prayerScore = 4;

  Prayer asar = Prayer()
                ..prayerName = "asar"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = false
                ..missed = false
                ..prayerScore = 4;

  Prayer maghrib = Prayer()
                ..prayerName = "maghrib"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = false
                ..missed = false
                ..prayerScore = 3;

  Prayer isyak = Prayer()
                ..prayerName = "isyak"
                ..prayerTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                ..prayed = false
                ..missed = false
                ..prayerScore = 4;

  @override
  void initState() {
    super.initState();
    checkAppVersion(context);
    initializePage();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }
  
  Future<void> fetchPrayerTimes() async {
  final response = await http.get(Uri.parse('https://waktu-solat-api.herokuapp.com/api/v1/prayer_times.json?zon=gombak'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    List<dynamic> dataJson = jsonData['data'][0]['waktu_solat'];
    List<Prayer> prayers = [subuh, syuruk, zohor, asar, maghrib, isyak]; // Use the Prayer objects directly
    
    DateTime now = DateTime.now();

    for (var waktuSolatJson in dataJson) {
      String prayerName = waktuSolatJson['name'];
      String prayerTime = waktuSolatJson['time'];

      // Parse the prayerTime string and create a new DateTime object
      List<int> parsedTime = prayerTime.split(':').map(int.parse).toList();
      DateTime updatedDateTime = DateTime(now.year, now.month, now.day, parsedTime[0], parsedTime[1]);
      //print('$prayerName : $updatedDateTime');
      if (prayerName != "imsak") {
        // Find the corresponding Prayer object and update its prayerTime
        prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerTime = updatedDateTime;
        //print('updated ${prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerName} to ${prayers.firstWhere((prayer) => prayer.prayerName == prayerName).prayerTime}');
      }
    }

    // Update the UI or perform any necessary actions after updating prayer times
    setState(() {
      // ...
    });
  } else {
    print('Failed to fetch data');
  }
    prayerTimesUpdated = true;
  }

  Future <void> syncPrayerData() async{
    String currentDate;
    try{
      if(DateTime.now().isBefore(subuh.prayerTime)){
        //if the current time is before subuh, set the date to yesterday
        //print('current time is before subuh\nThe time now is ${DateTime.now()} and subuh is ${subuh.prayerTime}');
        currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
        //print('the date is $currentDate');
      }
      else{
        //print('current time is after subuh\nThe time now is ${DateTime.now()} and subuh is ${subuh.prayerTime}');
        currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        //print('the date is $currentDate');
      }

      //read prayer data from firebase of each user
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('daily_prayers').doc(currentDate).get();
      print('firebase read from syncPrayerData');
      if(snapshot.exists){
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          subuh.prayed = data['subuh'];
          syuruk.prayed = data['syuruk'];
          zohor.prayed = data['zohor'];
          asar.prayed = data['asar'];
          maghrib.prayed = data['maghrib'];
          isyak.prayed = data['isyak'];
        print(data);
        setState(() {
        });
      }
      else{
        print('snapshot does not exist');
        //storePrayerData();
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<void> initializePage() async {
    await fetchPrayerTimes();
    syncPrayerData();
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
        actions: [
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

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottomNavigationBar: MyBottomAppBar(

      // ),

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
                                          builder: (context) =>
                                              TrackPrayer(
                                                subuh: subuh,
                                                syuruk: syuruk,
                                                zohor: zohor,
                                                asar: asar,
                                                maghrib: maghrib,
                                                isyak: isyak,
                                              ), // Pass the userID to the ChatPage
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
                                          builder: (context) =>
                                              const QuranPage(), // Pass the userID to the ChatPage
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
                                    imagePath: 'lib/icons/icons_Track_Prayer.png',
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
