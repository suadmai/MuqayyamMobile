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
    }
  }

  Future<String> uploadImage(String id) async {
    const folderPath = 'testImages/';
    final storageRef = FirebaseStorage.instance.ref().child('$folderPath/post_$id.$extension');
    await storageRef.putData(webImage!);
    //final ID = FirebaseFirestore.instance.collection('testPosts').doc().id;
    // final userID = FirebaseAuth.instance.currentUser!.uid;
    // final usernameDocument = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    // final username = usernameDocument.data()!['username'].toString();
    // final pfpURL = await FirebaseFirestore.instance.collection('users').doc(userID).get().then((value) => value.data()!['profilePicture'].toString());
    //get image url
    final imageURL = await FirebaseStorage.instance
                        .ref()
                        .child('$folderPath/post_$id.$extension')
                        .getDownloadURL();
    return imageURL;
    // await FirebaseFirestore.instance
    //     .collection('testPosts')
    //     .doc(ID).set({
    //     'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //     'title': _title.text,
    //     'description': _description.text,
    //     'imageURL': imageURL,
    //     'type': extension,
    //     'userid' : userID,
    //     'username' : username,
    //     'pfpURL' : pfpURL,
    //});
  }

  Future <void> createPost() async{
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final usernameDocument = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    final username = usernameDocument.data()!['username'].toString();
    final pfpURL = await FirebaseFirestore.instance.collection('users').doc(userID).get().then((value) => value.data()!['profilePicture'].toString());
    final id = FirebaseFirestore.instance.collection('testPosts').doc().id;
    final imageURL;

    if(webImage!=null){
      imageURL = await uploadImage(id);
    }
    else{
      imageURL = "";
    }

    if(_title.text != "" && _description.text != ""){
      await FirebaseFirestore.instance
          .collection('testPosts')
          .doc(id).set({
          'date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'timestamp' : DateTime.now(),
          'title': _title.text,
          'description': _description.text,
          'imageURL': imageURL,
          'type': extension??"",
          'userid' : userID,
          'username' : username,
          'pfpURL' : pfpURL,
      });
      Navigator.pop(context);
    }
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
          ),
        );
      }
    }
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Buat Hantaran Baharu', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: displayMedia(),
                  onTap: pickImage,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Tajuk Hantaran',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  minLines: 1,
                  maxLines: 5,
                  controller: _description,
                  decoration: const InputDecoration(
                    labelText: 'Tulis Sesuatu',
                  ),
                ),
                const SizedBox(height: 16,),
                ElevatedButton(
                      onPressed: () {
                        createPost();
                      },
                      child: const Text('Hantar'),
                    ),
              ],
            ),
          ),
      ),
    );
  }
}
