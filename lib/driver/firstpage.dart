import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(170, 59, 50, 231),
        actions: [
          TextButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: const Text("Driver"),
      ),
      body: const Center(
        child: Text("Loggedin"),
      ),
    );
  }
}
