import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/models/driver.dart';

class CallDriver extends StatefulWidget {
  final Driver driver;
  const CallDriver({Key? key, required this.driver}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
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
            SvgPicture.asset("assets/doc2.svg",height: 150,),
            const SizedBox(height: 30,),
            Text(
              "Name: ${driver.name}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
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
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(170, 59, 50, 231)),
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber(
                        driver.phoneNumber.toString());
                  },
                  child: const Text(
                    "CALL",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
