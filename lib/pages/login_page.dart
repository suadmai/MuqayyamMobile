import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wildlifego/pages/homeScreen.dart';
import 'package:wildlifego/pages/register_page.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  //final void Function()? onTap;
  LoginPage({super.key,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controllers
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  
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
        passwordController.text,
      );

      //Navigate to homescreen upon success
      // ignore: use_build_context_synchronously
    //   Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const HomeScreen(),  // Replace HomeScreen with your actual homepage
    //   ),
    // );

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
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
          
                    Form(
                      key: emailKey,
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Emel",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        obscureText: false,
                        validator:(value) {
                          if (value!.isEmpty) {
                            return 'Sila masukkan emel';
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
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: "Kata Laluan",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 1,
                        obscureText: true, //see what u typed
                        validator:(value) {
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
                          onTap: (){
                            print("register button pressed");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },//widget.onTap,
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
