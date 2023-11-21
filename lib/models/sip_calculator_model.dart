import 'dart:convert';

SIPCalculatorModel sipCalculatorFromJson(String str) =>
    SIPCalculatorModel.fromJson(json.decode(str));

String sipCalculatorToJson(SIPCalculatorModel data) =>
    json.encode(data.toJson());

class SIPCalculatorModel {
  SIPCalculatorModel({
    required this.code,
    required this.message,
    required this.sipDetails,
    required this.maturityValue,
    required this.investedAmount,
    required this.returnValue,
  });

  final int code;
  final String message;
  final SIPDetails? sipDetails;
  final String maturityValue;
  final String investedAmount;
  final String returnValue;

  factory SIPCalculatorModel.fromJson(Map<String, dynamic> json) =>
      SIPCalculatorModel(
        code: json["code"],
        message: json["message"],
        sipDetails: json["sipDetails"] == null
            ? null
            : SIPDetails.fromJson(json["sipDetails"]),
        maturityValue: json["maturityValue"].toString(),
        investedAmount: json["investedAmount"].toString(),
        returnValue: json["returnValue"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "sipDetails": sipDetails == null ? null : sipDetails!.toJson(),
        "maturityValue": maturityValue,
        "investedAmount": investedAmount,
        "returnValue": returnValue,
      };
}

class SIPDetails {
  SIPDetails({
    required this.name,
    required this.sipAmount,
    required this.noOfYear,
    required this.expectedReturn,
  });

  final String? name;
  final int? sipAmount;
  final int? noOfYear;
  final int? expectedReturn;

  factory SIPDetails.fromJson(Map<String, dynamic> json) => SIPDetails(
        name: json["name"],
        sipAmount: json["SIPAmount"],
        noOfYear: json["NoOfYear"],
        expectedReturn: json["ExpectedReturn"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "SIPAmount": sipAmount,
        "NoOfYear": noOfYear,
        "ExpectedReturn": expectedReturn,
      };
}
