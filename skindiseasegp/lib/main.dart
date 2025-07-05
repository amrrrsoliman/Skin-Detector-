import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skindiseasegp/pages/history.dart';
import 'package:skindiseasegp/pages/homepage.dart';
import 'package:skindiseasegp/pages/newspage.dart';
import 'package:skindiseasegp/pages/loginpage.dart';
import 'package:skindiseasegp/pages/profile.dart';
import 'package:skindiseasegp/pages/registerpage.dart';
import 'package:skindiseasegp/pages/skindiseaseprediction.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      routes: {
        Loginpage.id: (context) => const Loginpage(), // Consistent route name
        Registerpage.id: (context) =>
            const Registerpage(), // Consistent route name
        Newspage.id: (context) => const Newspage(), // Consistent route name
        Homepage.id: (context) => const Homepage(), // Consistent route name
        SkinDiseasePrediction.id: (context) =>
            const SkinDiseasePrediction(), // Consistent route name
        Profile.id: (context) => const Profile(), // Consistent route name
        HistoryScreen.id: (context) =>
            const HistoryScreen(), // Consistent route name
      },
      debugShowCheckedModeBanner: false,
      initialRoute: Loginpage.id, // Start with the login page
    );
  }
}
