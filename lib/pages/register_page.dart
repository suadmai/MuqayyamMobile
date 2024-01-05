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

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borang Persetujuan Nusantara'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gambaran Keseluruhan:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Terima kasih kerana memilih Nusantara. Sebelum anda meneruskan untuk mencipta akaun, sila ambil masa sejenak untuk membaca dan memahami terma dan syarat berikut.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terma dan Syarat:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Maklumat Peribadi:\n'
              '   - Nusantara mengumpul dan memproses maklumat peribadi, termasuk tetapi tidak terhad kepada, nama anda, alamat emel, umur, nombor telefon, dan alamat.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Tujuan Pengumpulan:\n'
              '   - Maklumat yang dikumpul digunakan untuk tujuan mencipta dan mengekalkan akaun pengguna anda, menyediakan perkhidmatan yang dipersonalisasi, dan meningkatkan keseluruhan pengalaman pengguna.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Maklumat Kesihatan (jika berkenaan):\n'
              '   - Jika anda seorang pesakit, anda mungkin diminta untuk memberikan maklumat mengenai gejala dan pembedahan. Maklumat ini digunakan untuk menawarkan perkhidmatan berkaitan kesihatan yang dipersonalisasi.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Keselamatan:\n'
              '   - Kami mengambil serius mengenai keselamatan data anda. Nusantara menggunakan langkah-langkah piawai industri untuk melindungi maklumat peribadi anda daripada akses, pendedahan, pengubahan, dan pemusnahan yang tidak dibenarkan.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '5. Persetujuan untuk Pemprosesan:\n'
              '   - Dengan menekan "Daftar," anda bersetuju untuk pemprosesan maklumat peribadi anda seperti yang diterangkan dalam borang persetujuan ini.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '6. Terma Perkhidmatan dan Dasar Privasi:\n'
              '   - Anda digalakkan untuk membaca dan memahami Terma Perkhidmatan Kami dan Dasar Privasi Kami untuk memahami sepenuhnya hak anda dan amalan pemprosesan data kami.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '7. PDPA (Akta Perlindungan Data Peribadi):\n'
              '   - Dengan menggunakan Nusantara, anda mengakui dan bersetuju bahawa pemprosesan maklumat peribadi anda akan tertakluk kepada peruntukan Akta Perlindungan Data Peribadi (PDPA) dan dasar-dasar privasi kami.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '8. Had Umur:\n'
              '   - Aplikasi ini ditujukan untuk pengguna yang berumur 18 ke atas. Jika anda berada di bawah umur ini, harap untuk tidak menggunakan aplikasi ini.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saya telah membaca dan memahami terma dan syarat yang dinyatakan dalam Borang Persetujuan Nusantara. Dengan menekan "Daftar," saya dengan ini memberikan persetujuan untuk pemprosesan maklumat peribadi saya sebagaimana yang diterangkan.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Add any other relevant information or terms and conditions content

            // Confirmation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true); // Pass true for confirmation
                  },
                  child: Text('Agree'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false); // Pass false for rejection
                  },
                  child: Text('Disagree'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

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

  final formKey = GlobalKey<FormState>();

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

  bool isDoctor = false;
  bool isPatient = true;

  String selectedRole = 'Pengguna';

  final roles = ['Pengguna', 'Doktor'];

  static final List<Symptom> _symptoms = [
    Symptom(id: 1, name: "HIV"),
    Symptom(id: 2, name: "Gangguan mental"),
    Symptom(id: 3, name: "Sesak nafas"),
    Symptom(id: 4, name: "Sakit kepala"),
    Symptom(id: 5, name: "Sakit tekak"),
    Symptom(id: 6, name: "Hilang deria bau"),
  ];

  static final List<Surgery> _surgeries = [
    Surgery(id: 0, name: "Tiada"),
    Surgery(id: 1, name: "Implant Payudara"),
    Surgery(id: 2, name: "Kastrasi(Buang zakar)"),
  ];

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

    final authService = Provider.of<AuthService>(context, listen: false);
    final userRole = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs[0]['role'];
      } else {
        return null;
      }
    });

    final confirmed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
    );

    if (confirmed == true) {
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

        if (userRole == 'Doktor') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomeScreen(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Anda mesti bersetuju dengan terma dan syarat dahulu."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    MyFormField(
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
                    const SizedBox(
                      height: 20,
                    ),
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
                      visible: isDoctor,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
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
                      visible: !isDoctor,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
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
                      visible: !isDoctor,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
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
                            List<String> selectedSymptomNames =
                                values.map((item) => item.name).toList();
                            symptomsController.text =
                                selectedSymptomNames.join(", ");
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: !isDoctor,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
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
                            List<String> selectedSurgeryNames =
                                values.map((item) => item.name).toList();
                            surgeryController.text =
                                selectedSurgeryNames.join(", ");
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: !isDoctor,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
                    MyFormField(
                      controller: passwordController,
                      hintText: "Kata laluan",
                      maxLines: 1,
                      obscureText: false,
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
                    MyFormField(
                      controller: passwordConfirmController,
                      hintText: "Sahkan kata laluan",
                      maxLines: 1,
                      obscureText: false,
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
                              },
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
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}
