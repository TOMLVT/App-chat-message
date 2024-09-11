import 'package:app_chat_small/Chat/Message.dart';
import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:app_chat_small/Service/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  final String name;
  const chatPage({super.key, required this.name});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
        actions: [
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.blue,
            onPressed: () async {
              AuthMethod().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 11),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // Hiển thị danh sách tin nhắn
            child: Message(name: widget.name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Message",
                      enabled: true,
                      contentPadding: const EdgeInsets.only(left: 15, bottom: 8, top: 8),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffb3e5fc)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Message cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      messageController.text = value!;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      firebaseFirestore.collection("Message").add({
                        'message': messageController.text.trim(),
                        'time': FieldValue.serverTimestamp(), // Dùng timestamp của server
                        'name': widget.name,
                      }).then((value) {
                        messageController.clear();
                      }).catchError((error) {
                        print("Failed to send message: $error");
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.send_sharp,
                    size: 30,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
