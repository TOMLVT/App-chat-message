import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  // SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber, // New phone number parameter
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty || phoneNumber.isNotEmpty) {
        // Register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user to your Firestore database with phone number
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'phoneNumber': phoneNumber,  // Store phone number
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // LogIn User
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // Logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Send verification code to the phone number
  Future<void> sendVerificationCode({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically signs in if verification is successful
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e.message ?? 'Verification failed';
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save the verification ID to use later
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Verify the code and set new password
  Future<String> verifyCodeAndSetNewPassword({
    required String verificationCode,
    required String newPassword,
  }) async {
    String res = "Some error Occurred";
    try {
      if (_verificationId != null && verificationCode.isNotEmpty && newPassword.isNotEmpty) {
        // Create a phone credential using the verification code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: verificationCode,
        );

        // Sign in with the credential
        UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Update the user's password
        await userCredential.user!.updatePassword(newPassword);
        res = "Password updated successfully";
      } else {
        res = "Please enter all fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
