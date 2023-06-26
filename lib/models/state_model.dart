import 'dart:convert';

List<States> statesFromJson(String str) => List<States>.from(json.decode(str).map((x) => States.fromJson(x)));

String statesToJson(List<States> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class States {
  States({
    required this.stateid,
    required this.countryid,
    required this.statename,
  });

  int stateid;
  int countryid;
  String statename;

  factory States.fromJson(Map<String, dynamic> json) => States(
    stateid: json["stateid"],
    countryid: json["countryid"],
    statename: json["statename"],
  );

  Map<String, dynamic> toJson() => {
    "stateid": stateid,
    "countryid": countryid,
    "statename": statename,
  };

  @override
  String toString() {
    return 'States{stateid: $stateid, countryid: $countryid, statename: $statename}';
  }
}