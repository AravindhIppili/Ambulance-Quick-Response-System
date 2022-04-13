import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:project/call.dart';
import 'package:project/models/driver.dart';

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
              ? const Center(
                  child: SpinKitWave(
                  color: Color.fromARGB(170, 59, 50, 231),
                  size: 70.0,
                  type: SpinKitWaveType.start,
                ))
              : Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/doctor.svg",
                        height: 225,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        height: 90,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(170, 59, 50, 231)),
                          child: const Text(
                            "FIND DRIVER",
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            Location location = Location();

                            bool _serviceEnabled;
                            PermissionStatus _permissionGranted;
                            LocationData _locationData;

                            _serviceEnabled = await location.serviceEnabled();
                            if (!_serviceEnabled) {
                              _serviceEnabled = await location.requestService();
                              if (!_serviceEnabled) {
                                return;
                              }
                            }

                            _permissionGranted = await location.hasPermission();
                            if (_permissionGranted == PermissionStatus.denied) {
                              _permissionGranted =
                                  await location.requestPermission();
                              if (_permissionGranted !=
                                  PermissionStatus.granted) {
                                return;
                              }
                            }
                            _locationData = await location.getLocation();
                            // ignore: avoid_print
                            print(_locationData);
                            Response response;
                            var dio = Dio();
                            response = await dio.post(
                                "https://ambulance-quick-response.herokuapp.com/nearest",
                                data: {
                                  "long": _locationData.longitude,
                                  "lat": _locationData.latitude
                                });
                            setState(() {
                              _isLoading = false;
                            });
                            Driver driver = Driver.fromJson(response.data[0]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        CallDriver(driver: driver)));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
