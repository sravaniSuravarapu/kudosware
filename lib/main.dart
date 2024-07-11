import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kudosware_firebase/constants.dart';
import 'package:kudosware_firebase/firebase_options.dart';
import 'package:kudosware_firebase/helpers/helper_function.dart';
import 'package:kudosware_firebase/pages/home_page.dart';
import 'package:kudosware_firebase/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
