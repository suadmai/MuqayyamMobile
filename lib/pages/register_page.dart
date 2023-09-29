import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/components/my_dropdown.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

  
import '../services/auth_service.dart';
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  String selectedRole = 'Pengguna';
  final roles = ['Pengguna', 'Doktor'];

  //signup user
  void signUp() async {
    if (passwordController.text != passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kata laluan tidak sama"),
        ),
      );
      return;


    }
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      await authService.signUpWithEmailandPassword(
        usernameController.text,
        roleController.text,
        emailController.text,
        passwordController.text,
      );
    }
    catch(e){
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
          
                    const Icon(
                      Icons.app_registration,
                      size: 80,
                    ),
          
                    const SizedBox(
                      height: 20,
                    ),
          
                    //welcome back
                    Text(
                      "Daftar Akaun",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
          
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
          
                    MyTextField(
                      controller: usernameController,
                      hintText: "Nama pengguna",
                      maxLines: 1,
                      obscureText: false,
                    ),
          
                    const SizedBox(
                      height: 20
                      ),
          
                     MyDropdownButton(
                        items: roles,
                        value: selectedRole,
                        onChanged: (newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                        hintText: 'Pilih Peranan',
                      ),
          
                  const SizedBox(
                    height: 20,
                  ),
          
                    //email textfield
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
                    //password confirm textfield
                    MyTextField(
                      controller: passwordConfirmController,
                      hintText: "Sahkan kata laluan",
                      maxLines: 1,
                      obscureText: true, //see what u typed
                    ),
          
              
                    const SizedBox(
                      height: 20,
                    ),
          
                    //sign in button
                    MyButton(
                      onTap: signUp, 
                      text: "Daftar"
                      ),
          
                    const SizedBox(
                      height: 20,
          
                    ),
                    //not member? register
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sudah mempunyai akaun?"),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Log masuk sekarang",
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