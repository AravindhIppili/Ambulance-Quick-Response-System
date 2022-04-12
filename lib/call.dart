import 'package:flutter/material.dart';
import 'package:project/models/driver.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDriver extends StatefulWidget {
  final Driver driver;
  const CallDriver({Key? key, required this.driver}) : super(key: key);

  @override
  State<CallDriver> createState() => _CallDriverState(driver: driver);
}

class _CallDriverState extends State<CallDriver> {
  Driver driver;
  _CallDriverState({required this.driver});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Name: ${driver.name}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Text(
              "Phone: ${driver.phoneNumber}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              height: 80,
              child: ElevatedButton(
                  onPressed: () {
                    launch("tel://${driver.phoneNumber}");
                  },
                  child: const Text(
                    "Call",
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
