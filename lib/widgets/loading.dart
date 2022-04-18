import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
          child: SpinKitThreeBounce(
        color: Color.fromARGB(170, 59, 50, 231),
        size: 30,
      )),
    );
  }
}
