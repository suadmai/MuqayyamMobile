//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class UploadWeb extends StatefulWidget {
  @override
  _UploadWebState createState() => _UploadWebState();
}

class _UploadWebState extends State<UploadWeb> {

  XFile? image ;
  Uint8List? webImage;
  String? extension;
  late VideoPlayerController _videoPlayerController;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  
  void pickImage() async {
     image = await ImagePicker().pickMedia(imageQuality: 75);
    if (image != null) {
      setExtension(image);
      var f = await image?.readAsBytes();
          setState(() {
            webImage = f;
          });
    }
  }

  void setExtension(var image){
    if (image != null) {
      final fileName = image.name;
      final fileExtension = fileName.split('.').last;
      setState(() {
        extension = fileExtension;
      });
      print('File extension: $extension');
    }
  }

  Future<void> uploadImage() async {
    final folderPath = 'testImages/';
    final ID = FirebaseFirestore.instance.collection('testPosts').doc().id;
    final storageRef = FirebaseStorage.instance.ref().child('$folderPath/post_$ID.$extension');
    await storageRef.putData(webImage!);
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final username = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    //display upload percentage
    
    print('Image uploaded');

    //get image url
    final imageURL = await FirebaseStorage.instance
                        .ref()
                        .child('$folderPath/post_$ID.$extension')
                        .getDownloadURL();
    print(imageURL);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image url is $imageURL and type is $extension'),
      ),
    );

    await FirebaseFirestore.instance
        .collection('testPosts')
        .doc(ID).set({
        'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'title': _title.text,
        'description': _description.text,
        'imageURL': imageURL,
        'type': extension,
        'userid' : userID,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image added to Firestore'),
      ),
    );
    print('Image added to Firestore');
  }

  Container displayMedia(){
    if (webImage != null) {
      if(extension == 'jpg' || extension == 'jpeg' || extension == 'png' || extension == 'heic'){
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.memory(
            webImage!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      } else if(extension == 'mp4' || extension == 'mov' || extension == 'hevc'){
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
        ),
          child: Center(
            child: 
            Chewie(
              controller: ChewieController(
                videoPlayerController: VideoPlayerController.asset(image!.path),
                autoPlay: true,
                autoInitialize: true,
              ),
            )
            // Chewie(
            //   controller: ChewieController(
            //     videoPlayerController: VideoPlayerController.asset(image!.path),
            //     autoPlay: true,
            //     autoInitialize: true,
            //   ),
            // )
          ),
        );
      }
    }
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }

  Container displayPost(String type, String postImage){
    if(type == 'jpg' || type == 'jpeg' || type == 'png' || type == 'heic'){
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: 
            Image.network(
              postImage,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
        ));
      } else if(type == 'mp4' || type == 'mov' || type == 'hevc'){
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
        ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
        );
      }
    return Container(
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image from Web'),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('v1.1.5'),
              //display selected image
              // webImage != null
              // //boxfit: BoxFit.cover to display image in full container
              // //put it
              //     ? SizedBox(
              //         width: 200,
              //         height: 200,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Image.memory(
              //             webImage!,
              //             width: 200,
              //             height: 200,
              //             fit: BoxFit.cover,
              //           ),
              //       ),
              //     )
              //     : Container(
              //         width: 200,
              //         height: 200,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.black),
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: const Center(
              //           child: Icon(Icons.image, size: 50, color: Colors.grey),
              //         ),
              //     ),
              displayMedia(),
              const SizedBox(height: 20),
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      uploadImage();
                    },
                    child: const Text('Upload Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //display the images from firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('testPosts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        try {
                          final imageURL = snapshot.data!.docs[index]['imageURL'];
                          final type = snapshot.data!.docs[index]['type'];
          
                          return displayPost(type, imageURL);
                        } catch (e) {
                          print('Error loading image at index $index: $e');
                          return Container(); // Placeholder or alternative content
                        }
                      },
                    );
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
