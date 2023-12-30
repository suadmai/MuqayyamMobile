import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildlifego/components/my_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:wildlifego/pages/login_page.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  //final void Function()? onTap;
  const RegisterPage({super.key,});
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
  final usernameKey = GlobalKey<FormState>();
  final roleKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final ageKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormState>();
  final addressKey = GlobalKey<FormState>();
  final symptomsKey = GlobalKey<FormState>();
  final surgeryKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final passwordConfirmKey = GlobalKey<FormState>();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          // below notch
          child: Form(
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
                      MyTextField(
                        controller: emailController,
                        hintText: "Alamat emel",
                        maxLines: 1,
                        obscureText: false,
                      ),
            
                      const SizedBox(
                        height: 20,
                      ),
            
                      //staff id textfield
                      Visibility(
                        visible: isDoctor,
                        child: MyTextField(
                          controller: ageController,
                          hintText: "ID Staf",
                          maxLines: 1,
                          obscureText: false,
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
                      MyTextField(
                        controller: ageController,
                        hintText: "Umur",
                        maxLines: 1,
                        obscureText: false,
                        isVisible: !isDoctor,
                      ),
            
                      Visibility(
                        visible:
                            !isDoctor, // Only show the SizedBox when isPatient is true
                        child: const SizedBox(
                          height: 20,
                        ),
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
                        isVisible: !isDoctor,
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
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },//widget.onTap,
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
