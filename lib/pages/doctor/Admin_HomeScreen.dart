// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wildlifego/components/videoPlayer.dart';
import 'package:wildlifego/pages/doctor/monitorPatient.dart';
import 'package:wildlifego/pages/doctor/uploadWeb.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:file_picker/file_picker.dart';

//services
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/menu_buttons.dart';
import '../profile_page.dart';
import '/services/auth_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  String? _profilePictureUrl;
  late User _user;
  String monitorIcon = 'lib/icons/icons_Monitor.png';
  String leaderboardsIcon= 'lib/icons/icons_Leaderboards.png';
  String chatIcon = 'lib/icons/icons_Contact_Expert.png';
  
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Container displayPost(String type, String postImage){
    if(type == 'jpg' || type == 'jpeg' || type == 'png' || type == 'heic'){
        return Container(
          child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                  child: Image.network(
                    postImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ));
      } else if(type == 'mp4' || type == 'mov' || type == 'hevc'){
        return Container(
          child: AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Chewie(
                    controller: ChewieController(
                      allowPlaybackSpeedChanging: false,
                      videoPlayerController: VideoPlayerController.network(postImage),
                      autoPlay: false,
                      autoInitialize: true,
                    ),
                  )
                ),
              ),
            ),
          ),
        );
      }
    return Container(
    );
  }

  Future<void> _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _profilePictureUrl = userDoc.data()?['profilePicture']
          as String?;
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
        title: const Text("Nusantara", style: TextStyle(color: Colors.white)),
        actions: [
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
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: _profilePictureUrl != null
                    ? NetworkImage(_profilePictureUrl!)
                    : null, // Display the profile picture if available
                child: _profilePictureUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null, // Show an icon if no profile picture is available
              ),
            ),
          )
        ],
      ),
      //floating action button must be center
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadWeb(),
              ),
            );
            // showModalBottomSheet(
            //   context: context,
            //   isScrollControlled: true,
            //   backgroundColor: Colors.transparent, // Set the background color to transparent
            //   barrierColor: Colors.transparent,
            //   builder: (BuildContext context) {
            //     return SingleChildScrollView(
            //       child: Container(
            //         padding: EdgeInsets.only(
            //           bottom: MediaQuery.of(context).viewInsets.bottom,
            //         ),
            //         child: NewPostTextField(
            //         ), // Create a separate widget for the text field
            //       ),
            //     );
            //   },
            // );
          },
          backgroundColor: Color(0xFF82618B),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 150,
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
                                      buttonText: 'Pantau Peserta',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PatientList(),
                                          ),
                                        );
                                      },
                                      imagePath: monitorIcon,
                                    ),
                                    SizedBox(width: 10),
                              
                                    MenuButton(
                                      buttonText: 'Papan Markah',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const LeaderboardPage(), // Pass the userID to the ChatPage
                                          ),
                                        );
                                      },
                                      imagePath: leaderboardsIcon,
                                    ),
                                    SizedBox(width: 10),
                      
                                    MenuButton(
                                      buttonText: 'Bual',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactExpert(),
                                          ),
                                        );
                                      },
                                      imagePath: chatIcon,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                          ),
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
                        .collection('testPosts')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                        builder: (context, snapshot) {
                        if (snapshot.hasData) {
                        final posts = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index].data();
                            final pfpURL = post['pfpURL'] as String?;
                            final username =
                                post['username'] as String?;
                            final title =
                                post['title'] as String?;
                            final description = post['description']
                                as String?;
                            final date = post["date"] as String?;
                            final imageURL = post['imageURL'] as String?;
                            final type = post['type'] as String?;
                            
                            return GestureDetector(

                              onLongPress: () {
                                // show vertical menu 
                                if(post['userid'] == FirebaseAuth.instance.currentUser!.uid){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Padam Hantaran'),
                                      content: Text('Adakah anda ingin memadam hantaran ini?'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text('Padam'),
                                          onPressed: () {
                                            if(post['userID'] == FirebaseAuth.instance.currentUser!.uid){
                                              FirebaseFirestore.instance
                                                .collection('testPosts')
                                                .doc(post['postID'])
                                                .delete();
                                              Navigator.of(context).pop(true);
                                              //also delete the image from Firebase Storage
                                              if (imageURL != null) {
                                                FirebaseStorage.instance.refFromURL(imageURL).delete();
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                }
                              },
                              //child: displayPost(type!, imageURL!),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                          child: pfpURL != null
                                          ? CircleAvatar(
                                              radius: 12,
                                              backgroundImage:
                                                  NetworkImage(pfpURL),
                                            )
                                          :
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '$username', // Replace with the user's name
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      //SizedBox(height: 8),
                                                      Text(
                                                        // date format dd/mm/yyyy
                                                        DateFormat("dd/MM/yyyy").format(DateTime.parse(date!)), 
                                                        style: TextStyle(
                                                            fontSize: 12),
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
                                          maxLines: 10,
                                        ),
                                        SizedBox(height: 8),
                                        displayPost(type!, imageURL!)
                                        
                                      ]),
                                ),
                              ),
                            );
                            //);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return ErrorWidget(snapshot.error!);
                      } else {
                        return const Text("Tunggu sebentar");
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
