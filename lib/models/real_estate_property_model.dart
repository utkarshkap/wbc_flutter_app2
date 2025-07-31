// To parse this JSON data, do
//
//     final realEstatePropertyModel = realEstatePropertyModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

RealEstatePropertyModel realEstatePropertyModelFromJson(String str) =>
    RealEstatePropertyModel.fromJson(json.decode(str));

String realEstatePropertyModelToJson(RealEstatePropertyModel data) =>
    json.encode(data.toJson());

class RealEstatePropertyModel {
  int code;
  dynamic message;
  List<Realty> realty;

  RealEstatePropertyModel({
    required this.code,
    required this.message,
    required this.realty,
  });

  factory RealEstatePropertyModel.fromJson(Map<String, dynamic> json) =>
      RealEstatePropertyModel(
        code: json["code"],
        message: json["message"],
        realty:
            List<Realty>.from(json["realty"].map((x) => Realty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "realty": List<dynamic>.from(realty.map((x) => x.toJson())),
      };
}

class Realty {
  int id;
  DateTime salesDate;
  int userId;
  String userName;
  int projectId;
  String projectName;
  String plotNo;
  double totalAmount;
  bool profitSharingStatus;
  String address;
  String sqFt;
  String yard;

  Realty({
    required this.id,
    required this.salesDate,
    required this.userId,
    required this.userName,
    required this.projectId,
    required this.projectName,
    required this.plotNo,
    required this.totalAmount,
    required this.profitSharingStatus,
    required this.address,
    required this.sqFt,
    required this.yard
  });

  factory Realty.fromJson(Map<String, dynamic> json) => Realty(
        id: json["id"],
        salesDate: DateTime.parse(json["salesDate"]),
        userId: json["userId"],
        userName: json["userName"],
        projectId: json["projectId"],
        projectName: json["projectName"],
        plotNo: json["plotNo"],
        totalAmount: json["totalAmount"],
        profitSharingStatus: json["profitSharingStatus"],
        address: json['address'] ?? '' ,
        sqFt: json['sqFt'] ?? '',
        yard: json['yard'] ?? ''
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "salesDate": salesDate.toIso8601String(),
        "userId": userId,
        "userName": userName,
        "projectId": projectId,
        "projectName": projectName,
        "plotNo": plotNo,
        "totalAmount": totalAmount,
        "profitSharingStatus": profitSharingStatus,
        "address" : address,
        "sqFt" : sqFt,
        "yard" : yard
      };
}
