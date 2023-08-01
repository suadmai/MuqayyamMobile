import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);
  @override
  State<Student> createState() => _StudentState();
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

class _StudentState extends State<Student> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        toolbarHeight: 100,
        title: const Text("Selamat pagi Kak Jun!"),
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
                      builder: (context) => const Student(),
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
          padding: const EdgeInsets.all(25.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 100,
                width: 500,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              ),
              Center(
                child: Padding(
                padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Jejak solat", style: TextStyle(fontSize: 11),),
                    Text("Baca al-Quran", style: TextStyle(fontSize: 11),),
                    Text("Pencapaian", style: TextStyle(fontSize: 11),),
                    Text("Hubungi pakar", style: TextStyle(fontSize: 11),),
                  ],
                )
                )
                ,
              )
            ],
          )
      //   StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      //   stream: FirebaseFirestore.instance.collection('AllReports').snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       final reports = snapshot.data!.docs;
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const Padding(
      //             padding: EdgeInsets.all(16.0),
      //             child: Text(
      //               'Latest Reports',
      //               style: TextStyle(
      //                 fontSize: 24,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             child: ListView.builder(
      //               itemCount: reports.length,
      //               itemBuilder: (context, index) {
      //                 final report = reports[index].data();
      //                 final reportID = report['reportId'] as String?;
      //                 final userID =
      //                     report['userId'] as String?; // Handle null value
      //                 final animalType =
      //                     report['animalType'] as String?; // Handle null value
      //                 final imageURL =
      //                     report['imageURL'] as String?; // Handle null value
      //                 final title =
      //                     report['title'] as String?; // Handle null value
      //                 final description =
      //                     report['description'] as String?; // Handle null value
      //                 final location =
      //                     report['location'] as String?; // Handle null value

      //                 return GestureDetector(
      //                   onTap: () {
      //                     // Navigate to details page and pass the report details
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => ViewDetailsPage(
      //                           reportID: reportID ?? '',
      //                           userID: userID ?? '',
      //                           animalType: animalType ?? '',
      //                           imageURL: imageURL ?? '',
      //                           title: title ?? '',
      //                           description: description ?? '',
      //                           location: location ?? '',
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   child: Card(
      //                     child: ListTile(
      //                       leading: imageURL != null
      //                           ? Container(
      //                               width: 100,
      //                               height: 100,
      //                               child: Image.network(
      //                                 imageURL,
      //                                 fit: BoxFit.cover,
      //                               ),
      //                             )
      //                           : const SizedBox(),
      //                       title: Text(title ?? 'No Title'),
      //                       subtitle: Text(description ?? 'No Details'),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //         ],
      //       );
      //     } else if (snapshot.hasError) {
      //       return const Text('Error retrieving data');
      //     } else {
      //       return const CircularProgressIndicator();
      //     }
      //   },
      // ),
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