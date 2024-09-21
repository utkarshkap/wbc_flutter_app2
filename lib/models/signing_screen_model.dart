import 'dart:convert';

Authentication authenticationFromJson(String str) =>
    Authentication.fromJson(json.decode(str));

String authenticationToJson(Authentication data) => json.encode(data.toJson());

class Authentication {
  Authentication({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data? data;

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data(
      {required this.name,
      required this.mobileNo,
      required this.email,
      this.address,
      this.area,
      this.city,
      this.country,
      this.pincode,
      this.deviceId,
      this.fcmId,
      this.dob,
      required this.tnc});

  String name;
  String mobileNo;
  String email;
  String? address;
  dynamic area;
  String? city;
  String? country;
  int? pincode;
  DateTime? dob;
  String? deviceId;
  String? fcmId;
  bool tnc;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"] ?? '',
        mobileNo: json["mobileNo"] ?? '',
        email: json["email"] ?? '',
        address: json["address"] ?? '',
        area: json["area"] ?? '',
        city: json["city"] ?? '',
        country: json["country"] ?? '',
        pincode: json["pincode"] ?? '',
        deviceId: json["deviceid"] ?? '',
        fcmId: json["fcmId"] ?? '',
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        tnc: json["tnc"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobileNo": mobileNo,
        "email": email,
        "address": address,
        "area": area,
        "city": city,
        "country": country,
        "pincode": pincode,
        "deviceid": deviceId,
        "fcmId": fcmId,
        "dob": dob == null ? null : dob!.toIso8601String(),
        "tnc": tnc,
      };

  @override
  String toString() {
    return 'Data{name: $name, mobileNo: $mobileNo, email: $email, address: $address, area: $area, city: $city, country: $country, pincode: $pincode, dob: $dob, deviceId: $deviceId, fcmId: $fcmId, tnc: $tnc}';
  }
}
