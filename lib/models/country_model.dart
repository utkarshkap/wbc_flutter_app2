import 'dart:convert';

List<Country> countryFromJson(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  Country({
    required this.countryid,
    required this.countryname,
    required this.isdcode,
    required this.icon,
  });

  int countryid;
  String countryname;
  String isdcode;
  String icon;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    countryid: json["countryid"],
    countryname: json["countryname"],
    isdcode: json["isdcode"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "countryid": countryid,
    "countryname": countryname,
    "isdcode": isdcode,
    "icon": icon,
  };

  @override
  String toString() {
    return 'Country{countryid: $countryid, countryname: $countryname, isdcode: $isdcode, icon: $icon}';
  }
}