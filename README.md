# studycase2

A new Flutter project.

# JGN KACAU ERROR KAT build,gradle (its is false positive error)

# HOW TO SETUP FIREBASE SAMPAI JADI
1. Download node js
2. run in bash terminal : npm install -g firebase-tools
3. npm install -g npm@9.7.1
4. firebase login
5. dart pub global activate flutterfire_cli
6. run in powershell: flutterfire configure
7. Settle setup ngan firebase(project, choice2 bla bla_)
8.  flutter pub add firebase_core
9. In main.dart : import 'package:firebase_core/firebase_core.dart';
10. import 'firebase_options.dart'; (should be auto create in lib)
11.  change void main into : Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
12. 
9. Flutter run