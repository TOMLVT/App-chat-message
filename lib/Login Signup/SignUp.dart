import 'package:app_chat_small/Login%20Signup/Home.dart';
import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:app_chat_small/Service/Authentication.dart';
import 'package:app_chat_small/Widget/Button.dart';
import 'package:app_chat_small/Widget/Snack_bar.dart';
import 'package:app_chat_small/Widget/text_field.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  final AuthMethod _authMethod = AuthMethod();

  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      String result = await _authMethod.signupUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(), // Sửa ở đây
      );

      if (result == "success") {
        showSnackBar(context, 'Registration successful');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        showSnackBar(context, result);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("images/signup.jpeg"),
              ),
              Text("Đăng ký", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Nhập Tên...',
              ),
              TextFieldInput(
                icon: Icons.mail,
                textEditingController: emailController,
                hintText: 'Nhập Email...',
              ),
              TextFieldInput(
                icon: Icons.phone,
                textEditingController: phoneNumberController,
                hintText: 'Nhập số điện thoại...', // Sửa ở đây
              ),
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Nhập mật khẩu...',
                isPass: true,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : MyButtons(
                onTap: registerUser,
                text: "Đăng ký",
              ),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn đã có tài khoản?", style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Đăng nhập ngay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
