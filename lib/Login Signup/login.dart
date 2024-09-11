import 'dart:convert';
import 'package:app_chat_small/Chat/chat_page.dart';
import 'package:app_chat_small/Login%20Signup/Home.dart';
import 'package:app_chat_small/Login%20Signup/SignUp.dart';
import 'package:app_chat_small/Service/Authentication.dart';
import 'package:app_chat_small/Widget/Button.dart';
import 'package:app_chat_small/Widget/Snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_chat_small/Widget/text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState(); // Changed _SignupScreenState to _LoginState
}

class _LoginState extends State<Login> { // Changed to _LoginState
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  // -------------- function processing logn user ----------------------
  bool isLoading = false;

  void despose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => chatPage(name: nameController.text),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

//---------------------------
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("images/login.jpg"),
              ),
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
              ),
              TextFieldInput(
                icon: Icons.mail,
                textEditingController: emailController,
                hintText: 'Enter your email',
              ),
              // Add the password field
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                isPass: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password ?" , style: TextStyle(color: Colors.blue, fontSize: 16 , fontWeight: FontWeight.bold),),
                ),
              ),
              MyButtons(onTap:  loginUser, text: "Log In"),
              SizedBox(height: height / 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have a account ? " ,style: TextStyle(fontSize: 16 , ),),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                      child: Text("Sign Up" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
