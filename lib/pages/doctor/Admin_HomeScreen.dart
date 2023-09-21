// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//other pages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:wildlifego/pages/new_quran_page.dart';

//services
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import '/services/auth_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
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

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  
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
        title: const Text("Admin Home Screen"),
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            //backgroundColor: Colors.transparent, // Set the background color to transparent
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: NewPostTextField(
                  ), // Create a separate widget for the text field
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
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
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // Updated alignment
            children: <Widget>[
              // Home
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminHomeScreen(),
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
                                          Icons.monitor_heart,
                                          size: 32,
                                        )),
                                    Text(
                                      "Pantau Pesakit",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
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
                                          Icons.view_list_sharp,
                                          size: 32,
                                        )),
                                    Text(
                                      "Papan Markah",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
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
                                          Icons.chat,
                                          size: 32,
                                        )),
                                    Text(
                                      "Perbualan",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
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
                            final username =
                                post['username'] as String?; // Handle null value
                            final title =
                                post['title'] as String?; // Handle null value
                            final description = post['description']
                                as String?; // Handle null value
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        '$description',
                                        style: TextStyle(fontSize: 14),
                                        maxLines: 10,
                                      ),
                                      SizedBox(height: 8),
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
                            //);
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

  @override
  class NewPostTextField extends StatefulWidget {
      @override
      _NewPostTextFieldState createState() => _NewPostTextFieldState();
    }

    class _NewPostTextFieldState extends State<NewPostTextField> {
      File? selectedImage;
      VideoPlayerController? _videoPlayerController;
      final TextEditingController _titleEditingController = TextEditingController();
      final TextEditingController _textEditingController = TextEditingController();

      @override
      void initState() {
        super.initState();
        _titleEditingController.addListener(_updateButtonState);
        _textEditingController.addListener(_updateButtonState);
      }

      void _updateButtonState() {
        setState(() {});
      }

      @override
      void dispose() {
        // Remove the listeners to avoid memory leaks
        _titleEditingController.removeListener(_updateButtonState);
        _textEditingController.removeListener(_updateButtonState);
        _videoPlayerController?.dispose();
        _titleEditingController.dispose();
        _textEditingController.dispose();
        super.dispose();
      }

      Future<void> _pickMedia() async {
        final pickedMedia = await ImagePicker().pickMedia(imageQuality: 80);

        if (pickedMedia != null) {

          if (pickedMedia.path.endsWith('.jpg') || pickedMedia.path.endsWith('.png')) {
            
            File imageFile = File(pickedMedia.path);

            setState(() {
              selectedImage = imageFile;
              _videoPlayerController = null; // Reset video player controller if a video was previously selected
            });
          } 
          else if (pickedMedia.path.endsWith('.mp4') || pickedMedia.path.endsWith('.mov')) {

            File videoFile = File(pickedMedia.path);
            
            VideoPlayerController videoPlayerController = VideoPlayerController.file(videoFile);
            await videoPlayerController.initialize();

            setState(() {
              selectedImage = videoFile;
              _videoPlayerController = videoPlayerController;
            });
          }
        }
      }

       Future<String> postType() async {
        if (selectedImage != null) {
          if (selectedImage!.path.endsWith('.jpg') || selectedImage!.path.endsWith('.png')) {
            return 'image';
          } else if (selectedImage!.path.endsWith('.mp4') || selectedImage!.path.endsWith('.mov')) {
            return 'video';
          }
        }
        // Default to 'text' if selectedImage is null or not recognized
        return 'text';
      }

      // TODO: Compress the image before uploading to Firebase Storage
      Future compressVideo(File selectedImage) async {

        if(selectedImage.path.endsWith('.mp4') || selectedImage.path.endsWith('.mov')){
          final compressedVideoFile = await VideoCompress.compressVideo(
            selectedImage.path,
            quality: VideoQuality.LowQuality,
          );  
          return compressedVideoFile!.file;
        }
        return selectedImage;
      }

      Future<void> postToFirebase() async {
        const folderPath = 'AllPosts/';

        final userID = FirebaseAuth.instance.currentUser!.uid;
        final usernameDocument = await FirebaseFirestore.instance.collection('users').doc(userID).get();
        final username = usernameDocument.data()!['username'].toString();
        final date = (DateTime.now()).toString();
        final postID = FirebaseFirestore.instance.collection('AllPosts').doc().id;
        final title = _titleEditingController.text;
        final description = _textEditingController.text;
        final type = await postType();

        //first upload the image to Firebase Storage
        if (selectedImage != null) {
        selectedImage = await compressVideo(selectedImage!);
        // Create a storage reference with the specified folder path
        final storageRef = FirebaseStorage.instance.ref().child('$folderPath/post_$postID.jpg');

        // Upload the selected image to the specified folder
        await storageRef.putFile(selectedImage!);
      }
        //get the image URL from Firebase Storage
        print('Getting download URL...');
        final imageURL = selectedImage != null
            ? await FirebaseStorage.instance.ref().child('$folderPath/post_$postID.jpg').getDownloadURL()
            : null;
        
        await FirebaseFirestore.instance
          .collection('AllPosts')
          .doc(postID)
          .set({
          'postID': postID,
          'userID': userID,
          'username': username,
          'title': title,
          'description': description,
          'date': date,
          'imageURL': imageURL ?? '',
          'postType': type,
        });
      }

      @override
      Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: List.generate(
            10,
            (index) => BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                //a handle to drag the bottom sheet up
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: _titleEditingController, // Use a separate controller for the title
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tajuk hantaran', // Hint for the title field
                    ),
                  ),
                ), // Add some spacing between the title field and the button
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      _titleEditingController.text.isNotEmpty &&
                              _textEditingController.text.isNotEmpty
                          ? Color(0xFF82618B)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    // Post to Firebase with title and content
                    if(_titleEditingController.text.isNotEmpty && _textEditingController.text.isNotEmpty){
                      postToFirebase();
                    }
                    
                    Navigator.of(context).pop();
                  },
                  child: Text('Hantar'),
                ),
              ],
            ),
            TextField(
              controller: _textEditingController,
              minLines: 1,
              maxLines: 10, // Adjust this to your preference
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Kongsi sesuatu...',
              ),
            ),
            Column(
              children: [
                if (selectedImage != null && _videoPlayerController == null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(selectedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close,
                        color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedImage = null; // Remove the selected image when cancel button is pressed
                          });
                        },
                      ),
                    ],
                  ),
                if (selectedImage != null && _videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                  //give it a fixed height so it doesn't take up too much space when minimized
                  //give it a rounded border
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController!.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController!),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          ),
                        onPressed: () {
                          setState(() {
                            selectedImage = null;
                            _videoPlayerController!.pause();
                            _videoPlayerController!.seekTo(Duration.zero);
                            _videoPlayerController = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(selectedImage == null && _videoPlayerController == null)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: _pickMedia,
                icon: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.grey,
                  size: 28,),
              ),
            ),
            // Display the selected image if available
          ],
        ),
        ),
      );
    }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Column(
            children: [
              //give it a fixed height so it doesn't take up too much space when minimized
              //give it a rounded border
              Align(
                alignment: Alignment.centerLeft,
                child: 
                Stack(
                  children: [
                    //give rounded border

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                        child: AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: IconButton(
                          iconSize: 28,
                          color: Colors.white,
                          icon: Icon(
                            //give icons shadow
                            _videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: () {
                            if (_videoController.value.isPlaying) {
                              _videoController.pause();
                            } else {
                              _videoController.play();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : CircularProgressIndicator(); // Show a loading indicator while initializing
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}






