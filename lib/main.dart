import 'package:app_chat_small/Login%20Signup/Home.dart';
import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:app_chat_small/Page/FirstPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapchot) {
        if (snapchot.hasData) {
           return const Home();
        } else {
          return const Firstpage();
        }
      }),
    );
  }

}


