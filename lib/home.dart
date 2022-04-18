import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project/general/call.dart';
import 'package:project/driver/login.dart';
import 'package:project/models/driver.dart';
import 'package:project/widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double long = 0, lat = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Loading()
              : Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        "assets/doctor.svg",
                        height: 225,
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        height: 90,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(170, 59, 50, 231)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "FIND DRIVER",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.local_shipping,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: getDriver,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        height: 90,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "ONLY FOR DRIVERS",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(170, 59, 50, 231)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Color.fromARGB(170, 59, 50, 231),
                              )
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => const LoginPage()));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  getDriver() async {
    setState(() {
      _isLoading = true;
    });
    // Location location = Location();

    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // LocationData _locationData;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }
    // _locationData = await location.getLocation();
    // // ignore: avoid_print
    // print(_locationData);
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

    Position position = await Geolocator.getCurrentPosition();
    // ignore: avoid_print
    print(position);
    Response response;
    var dio = Dio();
    response = await dio.post(
        "https://ambulance-quick-response.herokuapp.com/nearest",
        data: {"long": position.longitude, "lat": position.latitude});
    setState(() {
      _isLoading = false;
    });
    List<dynamic> drivers =
        response.data.map((driver) => Driver.fromJson(driver)).toList();
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => CallDriver(drivers: drivers)));
  }
}
