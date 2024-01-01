// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//other pages
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wildlifego/pages/doctor/monitorPatient.dart';
import 'package:wildlifego/pages/leaderboards.dart';
import 'package:wildlifego/pages/contactExpert.dart';
import 'package:wildlifego/pages/new_quran_page.dart';

//services
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
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
  
  @override
  void initState() {
    super.initState();
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
        title: const Text("Nusantara"),
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
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
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
                                                  const PatientList(),
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
                            final pfpURL = post['pfpURL'] as String?;
                            final username =
                                post['username'] as String?;
                            final title =
                                post['title'] as String?;
                            final description = post['description']
                                as String?;
                            final date = post["date"] as String?;
                            final imageURL = post['imageURL'] as String?;
                            final postType = post['postType'] as String?;
                            
                            return GestureDetector(

                              onLongPress: () {
                                // show vertical menu 
                                if(post['userID'] == FirebaseAuth.instance.currentUser!.uid){
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
                                                .collection('AllPosts')
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
        final pfpURL = await FirebaseFirestore.instance.collection('users').doc(userID).get().then((value) => value.data()!['profilePicture'].toString());
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
          'pfpURL': pfpURL,
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
  bool showControls = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });

      Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_videoController.value.isPlaying) {
      setState(() {
      // Update slider value to match video position
      _sliderValue = _videoController.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  Icon displayIcon(){
    if (_videoController.value.isPlaying) {
      return Icon(
        Icons.pause,
        size: 28,
        color: Colors.white,
      );
    } else if(_videoController.value.position == _videoController.value.duration){
      return Icon(
        Icons.replay,
        size: 28,
        color: Colors.white,
      );
    }
    else {
      return Icon(
        Icons.play_arrow_rounded,
        size: 28,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showControls = !showControls;
                    });
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                          child: Align(
                          alignment: Alignment.centerLeft,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.black, // Set the background color to black
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: _videoController.value.aspectRatio,
                                  child: VideoPlayer(_videoController),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ),
                      Visibility(
                        visible: showControls,
                        child: Positioned(
                          left: 1,
                          right: 1,
                          bottom: 1,
                          child: Column(
                            children: [
                              Center(
                                child: IconButton(
                                  iconSize: 28,
                                  color: Colors.white,
                                  icon: Icon(
                                    displayIcon().icon,
                                  ),
                                  onPressed: () {
                                    if (_videoController.value.isPlaying) {
                                      _videoController.pause();
                                    } else if(_videoController.value.position == _videoController.value.duration){
                                      _videoController.seekTo(Duration.zero);
                                      _videoController.play();
                                    }
                                    else {
                                      _videoController.play();
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children:[
                                 Container(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                   child: Slider(
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.grey,
                                      min: 0.0,
                                      max: _videoController.value.duration.inSeconds.toDouble(),
                                      value: _videoController.value.position.inSeconds.toDouble(),
                                      onChanged: (double value) {
                                        setState(() {
                                        // Seek to the specified position
                                        _videoController.seekTo(Duration(seconds: value.toInt()));
                                        _sliderValue = value; // Update slider value
                                      });
                                    }
                                    ),
                                 ),
                                  IconButton(
                                    onPressed: (){
                                      //change to fullscreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => 
                                          Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: Colors.black,
                                              leading: IconButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                }, 
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),
                                            backgroundColor: Colors.black,
                                            body: Stack(
                                              children:[
                                                Center(
                                                child: AspectRatio(
                                                  aspectRatio: _videoController.value.aspectRatio,
                                                  child: VideoPlayer(_videoController),
                                                ),
                                              ),
                                              Positioned(
                                                left: 1,
                                                right: 1,
                                                bottom: 1,
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: IconButton(
                                                        iconSize: 28,
                                                        color: Colors.white,
                                                        icon: Icon(
                                                          displayIcon().icon,
                                                        ),
                                                        onPressed: () {
                                                          if (_videoController.value.isPlaying) {
                                                            _videoController.pause();
                                                          } else if(_videoController.value.position == _videoController.value.duration){
                                                            _videoController.seekTo(Duration.zero);
                                                            _videoController.play();
                                                          }
                                                          else {
                                                            _videoController.play();
                                                          }
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children:[
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.6,
                                                          child: Slider(
                                                            activeColor: Colors.white,
                                                            inactiveColor: Colors.grey,
                                                            min: 0.0,
                                                            max: _videoController.value.duration.inSeconds.toDouble(),
                                                            value: _videoController.value.position.inSeconds.toDouble(),
                                                            onChanged: (double value) {
                                                              setState(() {
                                                              // Seek to the specified position
                                                              _videoController.seekTo(Duration(seconds: value.toInt()));
                                                              _sliderValue = value; // Update slider value
                                                            });
                                                          }
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: (){
                                                            //change to fullscreen
                                                            Navigator.pop(context);
                                                          }, 
                                                          icon: Icon(
                                                            Icons.fullscreen_exit,
                                                            size: 28,
                                                            color: Colors.white,
                                                          )
                                                        ),
                                                      ]
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ]
                                            ),
                                          ),
                                        ),
                                      );
                                    }, 
                                    icon: Icon(
                                      Icons.fullscreen,
                                      size: 28,
                                      color: Colors.white,
                                    )),
                                 ]
                               ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Align(
          alignment: Alignment.centerLeft,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: //loading indicator
                  Transform.scale(
                    scale: 0.2,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      color: //use the app bar color
                      Color(0xFF82618B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ); // Show a loading indicator while initializing
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
