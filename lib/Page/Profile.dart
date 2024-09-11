import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;


  const ProfilePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của :  $name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tên: $name' , style: TextStyle(fontSize: 30),),

          ],
        ),
      ),
    );
  }
}
