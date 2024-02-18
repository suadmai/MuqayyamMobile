import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadWeb extends StatefulWidget {
  @override
  _UploadWebState createState() => _UploadWebState();
}

class _UploadWebState extends State<UploadWeb> {

  Uint8List? webImage;
  
  void pickImage() async {
    //FilePickerResult? image = await FilePicker.platform.pickFiles();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
          setState(() {
            webImage = f;
          });
    }
  }

  void uploadImage() async {
    const folderPath = 'testImages/';
    final ID = FirebaseFirestore.instance.collection('testPosts').doc().id;
    final storageRef = FirebaseStorage.instance.ref().child('$folderPath/post_$ID.jpg');
    await storageRef.putData(webImage!);
    print('Image uploaded');

    //get image url
    final imageURL = await FirebaseStorage.instance
                        .ref()
                        .child('$folderPath/post_$ID.jpg')
                        .getDownloadURL();
        
    print(imageURL);

    //save image url to firestore
    await FirebaseFirestore.instance
        .collection('testPosts')
        .doc(ID).set({
        'imageURL': imageURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image from Web'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //display selected image
            webImage != null
            //boxfit: BoxFit.cover to display image in full container
            //put it
                ? SizedBox(
                    width: 200,
                    height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                        webImage!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                  ),
                )
                : Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                ),
            const SizedBox(height: 20),
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      try {
                        final imageURL = snapshot.data!.docs[index]['imageURL'];
                        //store the image as Uint8List
                        
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: Image.network(
                            imageURL,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        );
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
    );
  }
}
