// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactExpert extends StatefulWidget {
  const ContactExpert({Key? key}) : super(key: key);
  @override
  State<ContactExpert> createState() => _ContactExpertState();
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

class _ContactExpertState extends State<ContactExpert> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text("Hubungi pakar"),
        actions: [
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
                      builder: (context) => const ContactExpert(),
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
            
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'doctor').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doctors = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Senarai pakar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index].data();
                      final userID = doctor['userID'] as String?; // Handle null value
                      // final imageURL =
                      //     post['imageURL'] as String?;
                      final username = doctor['username'] as String?; // Handle null value

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
                                radius: 24,
                                backgroundColor: Colors.blue, // Set the profile image's background color
                                child: Icon(
                                  Icons.person,
                                  size: 24,
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
                                      SizedBox(height: 12),
                                      Text(
                                      '$username', // Replace with the user's name
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 12),
                                          CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.green, // Set the profile image's background color
                                          child: Icon(
                                            Icons.chat,
                                            size: 18,
                                            color: Colors.white,
                                            ),
                                          ),
                                          CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.orange, // Set the profile image's background color
                                          child: Icon(
                                            Icons.calendar_month,
                                            size: 18,
                                            color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                    ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

class ReportDetailsPage extends StatefulWidget {
  final String reportID;
  final String userID;
  final String animalType;
  final String imageURL;
  final String title;
  final String description;
  final String location;

  const ReportDetailsPage({
    Key? key,
    required this.reportID,
    required this.userID,
    required this.animalType,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.location,
  }) : super(key: key);
  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 1, // Only one item in the list
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageURL.isNotEmpty)
                SizedBox(
                  width: 450,
                  height: 450,
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Title: ${widget.title}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('Animal Type: ${widget.animalType}'),
              const SizedBox(height: 10),
              Text('By: ${widget.userID}'),
              const SizedBox(height: 10),
              Text('Details: ${widget.description}'),
              const SizedBox(height: 10),
              Text('Location: ${widget.location}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditReportPage(
                  //       reportId : widget.reportID,
                  //       originalTitle : widget.title,
                  //       originalAnimalType : widget.animalType,
                  //       originalLocation : widget.location,
                  //       originalDescription : widget.description,
                  //     ),
                  //   ),
                  // );
                },
                child: const Text('Edit Report'),
              ),
            ],
          );
        },
      ),
    );
  }
}

//VIEW ONLY

class ViewDetailsPage extends StatefulWidget {
  final String reportID;
  final String userID;
  final String animalType;
  final String imageURL;
  final String title;
  final String description;
  final String location;

  const ViewDetailsPage({
    Key? key,
    required this.reportID,
    required this.userID,
    required this.animalType,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.location,
  }) : super(key: key);
  @override
  _ViewDetailsPage createState() => _ViewDetailsPage();
}



class _ViewDetailsPage extends State<ViewDetailsPage> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 1, // Only one item in the list
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageURL.isNotEmpty)
                SizedBox(
                  width: 450,
                  height: 450,
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Title: ${widget.title}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('Animal Type: ${widget.animalType}'),
              const SizedBox(height: 10),
              Text('By: ${widget.userID}'),
              const SizedBox(height: 10),
              Text('Details: ${widget.description}'),
              const SizedBox(height: 10),
              Text('Location: ${widget.location}'),
              const SizedBox(height: 10),
              
            ],
          );
        },
      ),
    );
  }
}