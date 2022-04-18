import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project/models/driver.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/loading.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late String email;
  late Driver? driver;
  late bool isAvailable = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getDriver();
  }

  void getDriver() async {
    email = AuthenticationService().email;
    // driver = Driver(
    //     id: 1,
    //     name: "Surya",
    //     address: "address",
    //     vanNo: "AP2143",
    //     phoneNumber: "9666545112",
    //     lat: 12.344,
    //     long: 13.231,
    //     available: true,
    //     email: email);
    Response response;
    var dio = Dio();
    response = await dio
        .get("https://ambulance-quick-response.herokuapp.com/getdriver/$email");

    driver = Driver.fromJson(response.data[0]);
    isAvailable = driver!.available;
    updateCoords();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(170, 59, 50, 231),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: const Text("Driver"),
      ),
      
      body: _isLoading
          ? const Loading()
          : Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/ambulance.png"),
                  Text(
                    "Hi ${driver!.name}",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    height: 90,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromARGB(170, 59, 50, 231)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isAvailable ? Icons.lock : Icons.lock_open,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              isAvailable
                                  ? "LOCK AMBULANCE"
                                  : "UNLOCK AMBULANCE",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: onClickLock),
                  ),
                  // const SizedBox(height: 30,),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(vertical: 15),
                  //   height: 90,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           primary: const Color.fromARGB(170, 59, 50, 231)),
                  //       child: const Text(
                  //         "UPDATE Profile",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //       onPressed: (){

                  //       }),
                  // ),
                ],
              ),
            ),
    );
  }

  void onClickLock() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isAvailable) {
        var dio = Dio();
        await dio.post(
            "https://ambulance-quick-response.herokuapp.com/updateStatus",
            data: {"email": email, "status": false});
        isAvailable = false;
      } else {
        var dio = Dio();
        await dio.post(
            "https://ambulance-quick-response.herokuapp.com/updateStatus",
            data: {"email": email, "status": true});
        updateCoords();
        isAvailable = true;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void updateCoords() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position positionMain = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      positionMain = position!;
      // ignore: avoid_print
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
    var dio = Dio();
    await dio.post(
        "https://ambulance-quick-response.herokuapp.com/updateCoords",
        data: {
          "long": positionMain.longitude,
          "lat": positionMain.latitude,
          "email": email
        });
  }
}
