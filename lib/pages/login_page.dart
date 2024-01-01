import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wildlifego/components/my_form_field.dart';
import 'package:wildlifego/pages/doctor/Admin_HomeScreen.dart';
import 'package:wildlifego/pages/homeScreen.dart';
import 'package:wildlifego/pages/register_page.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  //final void Function()? onTap;
  LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //key for form
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //remove space from email
  String removeSpace(final emailController) {
    var newEmail = emailController.split('');
    newEmail.removeWhere((element) => element == ' ');
    String newEmailString = newEmail.join();
    print(newEmailString is String);
    print("""the new email is '$newEmailString'""");
    return newEmailString;
  }

// Validate email format using a regular expression
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  //signup user
  void signIn() async {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    final userRole = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((value) => value.docs[0]['role']);
    print(userRole);
    try {
      await authService.signInWithEmailandPassword(
        removeSpace(emailController.text),
        passwordController.text,
      );

      if (userRole == 'Doktor') {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomeScreen(),
          ),
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          // below notch
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo

                    const SizedBox(
                      height: 20,
                    ),

                    //add image
                    Image.asset(
                      "images/icon_transparent.png",
                      height: 150,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //welcome back
                    const Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Form(
                      key: emailKey,
                      child: MyFormField(
                        controller: emailController,
                        hintText: "Emel",
                        maxLines: 1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Sila masukkan emel';
                          } else if (!isEmailValid(value)) {
                            return 'Sila masukkan emel yang sah';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //password textfield
                    Form(
                      key: passwordKey,
                      child: MyFormField(
                        controller: passwordController,
                        hintText: "Kata Laluan",
                        maxLines: 1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Sila masukkan kata laluan';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //sign in button
                    ElevatedButton(
                      onPressed: () {
                        if (emailKey.currentState!.validate() &&
                            passwordKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: const Text("Log Masuk"),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //not member? register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum mempunyai akaun?"),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            print("register button pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          }, //widget.onTap,
                          child: const Text(
                            "Daftar sekarang",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
