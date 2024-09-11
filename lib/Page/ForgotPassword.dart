import 'package:app_chat_small/Service/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _authMethod = AuthMethod(); // Using AuthMethod for Firebase Authentication

  String _errorMessage = '';
  String? _verificationId;
  bool _isCodeSent = false;

  // Step 1: Verify email and phone number, then send the verification code
  Future<void> _sendVerificationCode() async {
    final email = _emailController.text;
    final phoneNumber = _phoneController.text;

    if (email.isEmpty || phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đủ thông tin người dùng !.';
      });
      return;
    }

    try {
      // Verify if email and phone number match an existing user in Firestore
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (userQuery.docs.isEmpty) {
        setState(() {
          _errorMessage = 'Không tìm thấy thông tin người dùng !.';
        });
        return;
      }

      // Send the verification code to the phone number
      await _authMethod.sendVerificationCode(phoneNumber: phoneNumber);
      setState(() {
        _isCodeSent = true;
        _errorMessage = 'Đã gửi mã xác nhận qua số :  $phoneNumber.';
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  // Step 2: Verify the code and allow the user to set a new password
  Future<void> _verifyCodeAndSetNewPassword() async {
    final verificationCode = _verificationCodeController.text;
    final newPassword = _newPasswordController.text;

    if (verificationCode.isEmpty || newPassword.isEmpty) {
      setState(() {
        _errorMessage = 'vui lòng nhập thông tin !';
      });
      return;
    }

    try {
      final result = await _authMethod.verifyCodeAndSetNewPassword(
        verificationCode: verificationCode,
        newPassword: newPassword,
      );
      setState(() {
        _errorMessage = result;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khôi phục mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(

              controller: _emailController,
              decoration: InputDecoration(labelText: 'Nhập Email...'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Nhập số điện thoại...'),
              keyboardType: TextInputType.phone,
            ),
            if (_isCodeSent) ...[
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(labelText: 'Nhập mã xác nhận...'),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nhập mật khẩu mới...'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyCodeAndSetNewPassword,
                child: Text('Xác nhận khôi phục'),
              ),
            ] else ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendVerificationCode,
                child: Text('Gửi mã xác nhận'),
              ),
            ],
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
