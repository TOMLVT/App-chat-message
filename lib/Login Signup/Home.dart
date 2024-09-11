import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:app_chat_small/Service/Authentication.dart';
import 'package:app_chat_small/Widget/Button.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Congratulation \n  You have successfuley Login" ,
              textAlign: TextAlign.center,
              style: TextStyle(
              fontWeight: FontWeight.bold ,
                fontSize: 25 ,

            ),
            ),
            MyButtons(onTap: () async {
                await AuthMethod().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
            },
                text: "Log Out"),
          ],
        ),
      ),
    );
  }
}
