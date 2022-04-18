import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallDriver extends StatefulWidget {
  final List<dynamic> drivers;
  const CallDriver({Key? key, required this.drivers}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CallDriver> createState() => _CallDriverState(drivers: drivers);
}

class _CallDriverState extends State<CallDriver> {
  List<dynamic> drivers;
  int c = 0;
  _CallDriverState({required this.drivers});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/doc2.svg",
              height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Name: ${drivers[c].name}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              "Phone: ${drivers[c].phoneNumber}",
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
                        drivers[c].phoneNumber.toString());
                    setState(() {
                      c = 1;
                    });
                  },
                  child: const Text(
                    "CALL",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
            c > 0
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    height: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(170, 59, 50, 231)),
                        onPressed: () async {
                          setState(() {
                            if (c == drivers.length - 1) {
                              c = 0;
                            } else {
                              c++;
                            }
                          });
                        },
                        child: const Text(
                          "Didn't connect?",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
