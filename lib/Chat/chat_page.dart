import 'dart:io';
import 'package:app_chat_small/Chat/Message.dart';
import 'package:app_chat_small/Login%20Signup/login.dart';
import 'package:app_chat_small/Page/Profile.dart';
import 'package:app_chat_small/Service/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();


  // Phương thức _sendMessage để gửi tin nhắn:----------------------------------
  Future<void> _sendMessage({String? imageUrl}) async {
    if (messageController.text.isNotEmpty || imageUrl != null) {
      try {
        await firebaseFirestore.collection("Message").add({
          'message': messageController.text.trim(),
          'time': FieldValue.serverTimestamp(),
          'name': widget.name,
          'imageUrl': imageUrl,
        });
        messageController.clear();
      } catch (error) {
        print("Failed to send message: $error");
      }
    }
  }



  // Phương thức _pickImage để chọn và tải ảnh: --------------------------------
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('chat_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(File(image.path));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
        });

        final snapshot = await uploadTask.whenComplete(() => null);
        final imageUrl = await snapshot.ref.getDownloadURL();

        print("Image URL: $imageUrl"); // Debugging line

        // Gửi tin nhắn chứa URL của ảnh
        await _sendMessage(imageUrl: imageUrl);
      } else {
        print("No image selected.");
      }
    } catch (error) {
      print("Failed to pick and upload image: $error");
    }
  }



  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(name: widget.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: _navigateToProfile,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name),
                ],
              ),
            ],
          ),
        ),
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
              "Đăng xuất",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 11),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Message(name: widget.name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, size: 30, color: Colors.blue),
                  onPressed: _pickImage, // Chọn ảnh từ thư viện
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Nhập tin nhắn...",
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
                        return 'Tin nhắn không thể trống !';
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
                        'time': FieldValue.serverTimestamp(),
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
