import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isLoading = false;
  XFile? image ;
  Uint8List? webImage;
  late User _user;
  late String _name = "";
  late String _role = "";
  late int _score = 0;
  late String _profilePictureUrl = ""; // Add this if you want to display the profile picture

  // For editing username
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

Future<void> _loadUserData() async {
  // Show loading indicator
  setState(() {
    _isLoading = true;
  });

  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();

    setState(() {
      _name = userDoc.data()?['username'] as String;
      _role = userDoc.data()?['role'] as String;
      _score = userDoc.data()?['score'] as int;
      _profilePictureUrl = userDoc.data()?['profilePicture'] as String;
    });
  } catch (e) {
    // Handle the error
    print('Error loading user data: $e');
  } finally {
    // Hide loading indicator
    setState(() {
      _isLoading = false;
    });
  }
}


  void _signOut() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Keluar'),
          content: const Text('Anda pasti anda mahu log keluar?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text('Log Keluar'),
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
      await authService.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>  LoginPage()), // Make sure LoginPage is a constant constructor
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _changeUsername() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Nama Pengguna'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'Nama Pengguna Baharu'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                _updateUsername(_usernameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(_user.uid);

      await userDocRef.update({'username': newUsername});

      setState(() {
        _name = newUsername;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama pengguna berjaya dikemaskini!')),
      );
    } catch (error) {
      print('Error updating username: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengemaskini nama pengguna. Sila cuba lagi.')),
      );
    }
  }

  Future<void> uploadProfilePicture() async {
  final picker = ImagePicker();
  image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    //File image = File(image.path);
    String userId = _user.uid;

    var f = await image?.readAsBytes();
          setState(() {
            webImage = f;
          });

    try {
      // Upload the file to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profile_pictures/$userId')
          .putData(webImage!);

      // When complete, fetch the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user document in Firestore with the new profile picture URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profilePicture': downloadUrl});

      // Update the local user data
      setState(() {
        _profilePictureUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar profil berjaya dikemaskini!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengemaskini gambar profil. Sila cuba lagi.')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF82618B),
        title: const Text('Akaun Saya', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF82618B), Color.fromARGB(255, 189, 126, 164)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
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
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  _name ?? '',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _role == 'Pengguna',
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: const Color(0xFF82618B),
                      child: ListTile(
                        title: Text(
                          _score?.toString() ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: const Text(
                          'Markah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Tukar Nama Pengguna',
                    style: TextStyle(
                      color: Color(0xFF82618B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Tukar nama pengguna anda',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: _changeUsername,
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Tukar Gambar Profil',
                    style: TextStyle(
                      color: Color(0xFF82618B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Tukar gambar profil anda',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: uploadProfilePicture,
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Log Keluar',
                    style: TextStyle(
                      color: Color(0xFF82618B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Log keluar dari akaun anda',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: _signOut,
                ),
                const Divider(),
                const Text('v 3.0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
