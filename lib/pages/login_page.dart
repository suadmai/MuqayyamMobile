import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String removeSpace(final emailController) {
  var newEmail = emailController.split('');
  newEmail.removeWhere((element) => element == ' ');
  String newEmailString = newEmail.join();
  print(newEmailString is String);
  print("""the new email is '$newEmailString'""");
  return newEmailString;
}

  //signup user
  void signIn() async {
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        removeSpace(emailController.text),
        //emailController.text,
        passwordController.text,
      );
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
          
                    MyTextField(
                      controller: emailController,
                      hintText: "Alamat emel",
                      maxLines: 1,
                      obscureText: false,
                    ),
          
                    const SizedBox(
                      height: 20,
                    ),
          
                    //password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: "Kata laluan",
                      maxLines: 1,
                      obscureText: true, //see what u typed
                    ),
          
                    const SizedBox(
                      height: 20,
                    ),
          
                    //sign in button
                    MyButton(
                    onTap: signIn,
                    text: "Log masuk"),
          
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
                          onTap: widget.onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: const Text(
                              "Daftar sekarang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
