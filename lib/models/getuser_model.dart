import 'dart:convert';

GetUser getUserFromJson(String str) {
  try {
    print('Parsing JSON string: $str');
    final jsonData = json.decode(str);
    print('JSON decoded successfully: $jsonData');
    return GetUser.fromJson(jsonData);
  } catch (e, stackTrace) {
    print('Error in getUserFromJson: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

String getUserToJson(GetUser data) => json.encode(data.toJson());

class GetUser {
  GetUser({
    required this.code,
    required this.message,
    required this.data,
    required this.goldReferrals,
  });

  final int code;
  final String? message;
  final Data? data;
  final List<GoldReferral>? goldReferrals;

  factory GetUser.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing GetUser from JSON: $json');
      return GetUser(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        goldReferrals: json["goldReferrals"] == null
            ? []
            : List<GoldReferral>.from(
                json["goldReferrals"].map((x) => GoldReferral.fromJson(x))),
      );
    } catch (e, stackTrace) {
      print('Error in GetUser.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data!.toJson(),
        "goldReferrals":
            List<dynamic>.from(goldReferrals!.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'GetUser{code: $code, message: $message, data: $data, goldReferrals: $goldReferrals}';
  }
}

class Data {
  Data(
      {required this.uid,
      required this.name,
      required this.deviceid,
      required this.mobileNo,
      required this.email,
      required this.address,
      this.area,
      this.city,
      this.country,
      this.pincode,
      required this.totalcountofaddedcontact,
      required this.maxContactPermittedPerMonth,
      required this.availableContacts,
      this.dob,
      required this.tnc,
      required this.fastTrack});

  final int uid;
  final String name;
  final String deviceid;
  final String mobileNo;
  final String email;
  String? address;
  dynamic area;
  String? city;
  String? country;
  int? pincode;
  final int totalcountofaddedcontact;
  final int maxContactPermittedPerMonth;
  final int availableContacts;
  DateTime? dob;
  final bool tnc;
  final bool fastTrack;

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing Data from JSON: $json');
      return Data(
        uid: json["uid"],
        name: json["name"],
        deviceid: json["deviceid"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        address: json["address"] ?? "",
        area: json["area"] ?? "",
        city: json["city"] ?? "",
        country: json["country"] ?? "",
        pincode: json["pincode"] ?? 0,
        totalcountofaddedcontact: json["totalcountofaddedcontact"],
        maxContactPermittedPerMonth: json["maxContactPermittedPerMonth"],
        availableContacts: json["availableContacts"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        tnc: json["tnc"] ?? false,
        fastTrack: json["fasttrack"] ?? false,
      );
    } catch (e, stackTrace) {
      print('Error in Data.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "deviceid": deviceid,
        "mobileNo": mobileNo,
        "email": email,
        "address": address,
        "area": area,
        "city": city,
        "country": country,
        "pincode": pincode,
        "totalcountofaddedcontact": totalcountofaddedcontact,
        "maxContactPermittedPerMonth": maxContactPermittedPerMonth,
        "availableContacts": availableContacts,
        "dob": dob,
        "tnc": tnc,
        "fasttrack": fastTrack
      };

  @override
  String toString() {
    return 'Data{uid: $uid, name: $name, deviceid: $deviceid, mobileNo: $mobileNo, email: $email, address: $address, area: $area, city: $city, country: $country, pincode: $pincode, totalcountofaddedcontact: $totalcountofaddedcontact, maxContactPermittedPerMonth: $maxContactPermittedPerMonth, availableContacts: $availableContacts, dob: $dob, tnc: $tnc,fasttrack:$fastTrack}';
  }
}

class GoldReferral {
  GoldReferral(
      {required this.refName,
      required this.refMobile,
      required this.refDate,
      required this.userexist});

  final String refName;
  final String refMobile;
  final DateTime refDate;
  final bool userexist;
  factory GoldReferral.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing GoldReferral from JSON: $json');
      return GoldReferral(
          refName: json["ref_name"],
          refMobile: json["ref_mobile"],
          refDate: DateTime.parse(json["ref_date"]),
          userexist: json['userexist']);
    } catch (e, stackTrace) {
      print('Error in GoldReferral.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "ref_name": refName,
        "ref_mobile": refMobile,
        "ref_date": refDate.toIso8601String(),
        "userexist": userexist
      };

  @override
  String toString() {
    return 'GoldReferral{refName: $refName, refMobile: $refMobile, refDate: $refDate,userexist $userexist}';
  }
}
