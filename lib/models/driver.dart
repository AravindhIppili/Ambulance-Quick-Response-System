import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    required this.id,
    required this.name,
    required this.address,
    required this.vanNo,
    required this.phoneNumber,
    required this.lat,
    required this.long,
    required this.available,
    required this.email,
  });

  int id;
  String name;
  String address;
  String vanNo;
  String phoneNumber;
  double lat;
  double long;
  bool available;
  String email;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["_id"],
        name: json["name"],
        address: json["address"],
        vanNo: json["van_no"],
        phoneNumber: json["phone_number"],
        lat: json["lat"],
        long: json["long"],
        available: json["available"],
        email: json["email"]
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "van_no": vanNo,
        "phone_number": phoneNumber,
        "lat": lat,
        "long": long,
        "available": available,
        "email": email
      };
}
