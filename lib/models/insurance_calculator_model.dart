// To parse this JSON data, do
//
//     final insurancecaluculator = insurancecaluculatorFromJson(jsonString);

import 'dart:convert';

Insurancecaluculator insurancecaluculatorFromJson(String str) =>
    Insurancecaluculator.fromJson(json.decode(str));

String insurancecaluculatorToJson(Insurancecaluculator data) =>
    json.encode(data.toJson());

class Insurancecaluculator {
  Insurancecaluculator({
    required this.code,
    required this.message,
    required this.insdeatils,
    required this.requiredinsurance,
  });

  final int code;
  final String message;
  final Insdeatils? insdeatils;
  final int? requiredinsurance;

  factory Insurancecaluculator.fromJson(Map<String, dynamic> json) =>
      Insurancecaluculator(
        code: json["code"],
        message: json["message"],
        insdeatils: json["insdeatils"] == null
            ? null
            : Insdeatils.fromJson(json["insdeatils"]),
        requiredinsurance: json["requiredinsurance"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "insdeatils": insdeatils == null ? null : insdeatils!.toJson(),
        "requiredinsurance": requiredinsurance,
      };
}

class Insdeatils {
  Insdeatils({
    required this.name,
    required this.gender,
    required this.annualincome,
    required this.existinglifecover,
    required this.totalloandue,
    required this.totalsaving,
    required this.homeloandue,
    required this.insDate,
  });

  final String? name;
  final String? gender;
  final int? annualincome;
  final int? existinglifecover;
  final int? totalloandue;
  final int? totalsaving;
  final int? homeloandue;
  final DateTime? insDate;

  factory Insdeatils.fromJson(Map<String, dynamic> json) => Insdeatils(
        name: json["name"],
        gender: json["gender"],
        annualincome: json["annualincome"],
        existinglifecover: json["existinglifecover"],
        totalloandue: json["loandue"],
        totalsaving: json["totalsaving"],
        homeloandue: json["homeloandue"],
        // dob: DateTime.parse(json["dob"]),
        insDate: DateTime.parse(json["ins_date"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "annualincome": annualincome,
        "existinglifecover": existinglifecover,
        "loandue": totalloandue,
        "totalsaving": totalsaving,
        "homeloandue": homeloandue,
        // "dob": dob.toIso8601String(),
        "ins_date": insDate!.toIso8601String(),
      };
}
