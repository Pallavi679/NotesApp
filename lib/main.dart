import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/pages/homepage.dart';
import 'package:noteapp/pages/login.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xff070706),
      ),
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/cover.png", height: 500),
            Text(
              "Notes Maker",
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
          ],
        )),
        splashIconSize: double.maxFinite,

        nextScreen: FirebaseAuth.instance.currentUser == null
            ? LoginPage()
            : HomePage(),
        splashTransition: SplashTransition.fadeTransition,
        // pageTransitionType: PageTransitionType.scale,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
