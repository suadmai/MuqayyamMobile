import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/components/my_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//Create Class for Symptom options

class Symptom {
  final int id;
  final String name;

  Symptom({
    required this.id,
    required this.name,
  });
}

class Surgery {
  final int id;
  final String name;

  Surgery({
    required this.id,
    required this.name,
  });
}

class _RegisterPageState extends State<RegisterPage> {
  //setting up text controllers
  final usernameController = TextEditingController();
  final roleController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final symptomsController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final implantController = TextEditingController();

  String selectedRole = 'Pengguna';

  final roles = ['Pengguna', 'Doktor'];

  //Symptom options
  static final List<Symptom> _symptoms = [
    Symptom(id: 1, name: "HIV"),
    Symptom(id: 2, name: "Gangguan mental"),
    Symptom(id: 3, name: "Sesak nafas"),
    Symptom(id: 4, name: "Sakit kepala"),
    Symptom(id: 5, name: "Sakit tekak"),
    Symptom(id: 6, name: "Hilang deria bau"),
  ];

  //Surgery options
  static final List<Surgery> _surgeries = [
    Surgery(id: 0, name: "Tiada"),
    Surgery(id: 1, name: "Implant Payudara"),
    Surgery(id: 2, name: "Kastrasi(Buang zakar)"),
  ];

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
    try {
      await authService.signUpWithEmailandPassword(
        usernameController.text,
        roleController.text,
        emailController.text,
        ageController.text,
        phoneController.text,
        addressController.text,
        symptomsController.text,
        passwordController.text,
        implantController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
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

                    Image.asset(
                      "images/icon_transparent.png",
                      height: 150,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //welcome back
                    const Text(
                      "Daftar Akaun",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //username textfield
                    MyTextField(
                      controller: usernameController,
                      hintText: "Nama pengguna",
                      maxLines: 1,
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

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

                    //age textfield
                    MyTextField(
                      controller: ageController,
                      hintText: "Umur",
                      maxLines: 1,
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //phone textfield
                    MyTextField(
                      controller: phoneController,
                      hintText: "Nombor telefon",
                      maxLines: 1,
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //address textfield
                    MyTextField(
                      controller: addressController,
                      hintText: "Alamat",
                      maxLines: 1,
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //symptom multi select
                    MultiSelectDialogField(
                      buttonText: const Text("Pilih gejala"),
                      title: const Text("Gejala"),
                      items: _symptoms
                          .map((e) => MultiSelectItem(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        setState(() {
                          symptomsController.text = values.toString();
                        });
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //surgery multi select
                    MultiSelectDialogField(
                      buttonText: const Text("Pilih pembedahan"),
                      title: const Text("Pembedahan"),
                      items: _surgeries
                          .map((e) => MultiSelectItem(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        setState(() {
                          implantController.text = values.toString();
                        });
                      },
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
                    MyButton(onTap: signUp, text: "Daftar"),

                    const SizedBox(
                      height: 20,
                    ),
                    //not member? register
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sudah mempunyai akaun?"),
                            const SizedBox(width: 4),
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
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
