import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/components/my_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wildlifego/components/my_form_field.dart';
import 'package:wildlifego/pages/doctor/Admin_HomeScreen.dart';
import 'package:wildlifego/pages/homeScreen.dart';
import 'package:wildlifego/pages/login_page.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  //final void Function()? onTap;
  const RegisterPage({
    super.key,
  });
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
  final surgeryController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  //setting up form keys
  final formKey = GlobalKey<FormState>();

  bool isDoctor = false; // To check if user is a doctor
  bool isPatient = true; // To check if user is a patient

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
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password should be at least 6 characters."),
        ),
      );
      return;
    }
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
    final userRole = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs[0]['role'];
      } else {
        // Handle the case where there are no documents
        return null; // or any default value
      }
    });
    print(userRole);

    try {
      await authService.signUpWithEmailandPassword(
        usernameController.text,
        selectedRole,
        emailController.text,
        ageController.text,
        phoneController.text,
        addressController.text,
        symptomsController.text,
        surgeryController.text,
        passwordController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

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
                child: Form(
                  key: formKey,
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
                      MyFormField(
                        controller: usernameController,
                        hintText: "Nama pengguna",
                        maxLines: 1,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan nama pengguna";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      MyDropdownButton(
                        items: roles,
                        value: selectedRole,
                        onChanged: (newValue) {
                          setState(() {
                            print("Selected Role: $newValue");
                            selectedRole = newValue!;
                            isDoctor = newValue == 'Doktor';
                          });
                        },
                        hintText: 'Pilih Peranan',
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //email textfield
                      MyFormField(
                        controller: emailController,
                        hintText: "Alamat emel",
                        maxLines: 1,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan alamat emel";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //staff id textfield
                      Visibility(
                        visible: isDoctor,
                        child: MyFormField(
                          controller: ageController,
                          hintText: "ID Staf",
                          maxLines: 1,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Sila masukkan ID Staf";
                            }
                            return null;
                          },
                        ),
                      ),

                      Visibility(
                        visible:
                            isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),

                      //age textfield
                      MyFormField(
                        controller: ageController,
                        hintText: "Umur",
                        maxLines: 1,
                        obscureText: false,
                        isVisible: !isDoctor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan umur";
                          }
                          return null;
                        },
                      ),

                      Visibility(
                        visible:
                            !isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),

                      //phone textfield
                      MyFormField(
                        controller: phoneController,
                        hintText: "Nombor telefon",
                        maxLines: 1,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan nombor telefon";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //address textfield
                      MyFormField(
                        controller: addressController,
                        hintText: "Alamat",
                        maxLines: 1,
                        obscureText: false,
                        isVisible: !isDoctor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan alamat";
                          }
                          return null;
                        },
                      ),

                      Visibility(
                        visible:
                            !isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),

                      //symptom multi select

                      Visibility(
                        visible: !isDoctor,
                        child: MultiSelectDialogField(
                          buttonText: const Text("Pilih gejala"),
                          title: const Text("Gejala"),
                          items: _symptoms
                              .map((e) => MultiSelectItem(e, e.name))
                              .toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            setState(() {
                              // Extract the names of selected symptoms
                              List<String> selectedSymptomNames =
                                  values.map((item) => item.name).toList();
                              // Store the names in symptomsController.text
                              symptomsController.text =
                                  selectedSymptomNames.join(", ");
                            });
                          },
                        ),
                      ),

                      Visibility(
                        visible:
                            !isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),

                      // surgery multi select
                      Visibility(
                        visible: !isDoctor,
                        child: MultiSelectDialogField(
                          buttonText: const Text("Pilih pembedahan"),
                          title: const Text("Pembedahan"),
                          items: _surgeries
                              .map((e) => MultiSelectItem(e, e.name))
                              .toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            setState(() {
                              // Extract the names of selected surgeries
                              List<String> selectedSurgeryNames =
                                  values.map((item) => item.name).toList();
                              // Store the names in implantController.text
                              surgeryController.text =
                                  selectedSurgeryNames.join(", ");
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            !isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),

                      //password textfield
                      MyFormField(
                        controller: passwordController,
                        hintText: "Kata laluan",
                        maxLines: 1,
                        obscureText: false, //see what u typed
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan kata laluan";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      //password confirm textfield
                      MyFormField(
                        controller: passwordConfirmController,
                        hintText: "Sahkan kata laluan",
                        maxLines: 1,
                        obscureText: false, //see what u typed
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Sila masukkan kata laluan";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //sign in button
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            signUp();
                          }
                        },
                        child: const Text("Daftar"),
                      ),

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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }, //widget.onTap,
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
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
