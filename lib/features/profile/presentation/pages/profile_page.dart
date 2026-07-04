import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Developer')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SgizedBox(height: 16),
            Text('Deden Tio Zulfikri', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('NPM: 20123009', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}