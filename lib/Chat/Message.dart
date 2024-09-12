import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String name;
  const Message({super.key, required this.name});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('Message')
      .orderBy('time', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          primary: true,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];

            Timestamp? time = qds['time'] as Timestamp?;
            DateTime? dateTime = time?.toDate() ?? DateTime.now();

            // Lấy toàn bộ dữ liệu của tài liệu
            Map<String, dynamic> data = qds.data() as Map<String, dynamic>;

            // Kiểm tra sự tồn tại của trường imageUrl
            String? imageUrl = data['imageUrl'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: widget.name == qds['name']
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      title: Text(
                        qds['name'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kiểm tra và hiển thị ảnh nếu tồn tại imageUrl
                          if (imageUrl != null && imageUrl.isNotEmpty)
                            Image.network(imageUrl, height: 150, width: 150),

                          Text(
                            qds["message"],
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Text(" ${dateTime.hour}:${dateTime.minute} "),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
