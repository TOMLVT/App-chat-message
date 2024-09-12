import 'dart:convert';
import 'package:app_chat_small/Chat/chat_page.dart';
import 'package:app_chat_small/Login%20Signup/Home.dart';
import 'package:app_chat_small/Login%20Signup/SignUp.dart';
import 'package:app_chat_small/Page/ForgotPassword.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
                Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)
        ),
      ),
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
              Text("Đăng nhập" , style: TextStyle(fontSize: 35 , fontWeight: FontWeight.bold),),
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Nhập tên...',
              ),
              TextFieldInput(
                icon: Icons.mail,
                textEditingController: emailController,
                hintText: 'Nhập email...',
              ),
              // Add the password field
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Nhập mật khẩu...',
                isPass: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                      },
                      child: Text("Quên mật khẩu ?" , style: TextStyle(color: Colors.blue, fontSize: 16 , fontWeight: FontWeight.bold),)),
                ),
              ),
              MyButtons(onTap:  loginUser, text: "Đăng nhập"),
              SizedBox(height: height / 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn chưa có tài khoản ? " ,style: TextStyle(fontSize: 16 , ),),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                      child: Text("Đăng ký ngay" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
