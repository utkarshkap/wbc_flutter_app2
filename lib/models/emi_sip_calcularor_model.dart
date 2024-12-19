import 'dart:convert';

EMISIPCalculatorModel emiSIPCalculatorFromJson(String str) =>
    EMISIPCalculatorModel.fromJson(json.decode(str));

String emiSIPCalculatorToJson(EMISIPCalculatorModel data) =>
    json.encode(data.toJson());

class EMISIPCalculatorModel {
  EMISIPCalculatorModel({
    required this.code,
    required this.message,
    required this.emiSIPDetails,
    required this.principalAmount,
    required this.interestAmount,
    required this.emiAmount,
    required this.sipAmount,
    required this.totalPayableAmount,
  });

  final int code;
  final String message;
  final EMISIPDetails? emiSIPDetails;
  final int principalAmount;
  final String interestAmount;
  final String emiAmount;
  final String sipAmount;
  final String totalPayableAmount;

  factory EMISIPCalculatorModel.fromJson(Map<String, dynamic> json) =>
      EMISIPCalculatorModel(
        code: json["code"],
        message: json["message"],
        emiSIPDetails: json["emisipDetails"] == null
            ? null
            : EMISIPDetails.fromJson(json["emisipDetails"]),
        principalAmount: json["principalAmount"],
        interestAmount: json["interestAmount"].toString(),
        emiAmount: json["emiAmount"].toString(),
        sipAmount: json["sipAmount"].toString(),
        totalPayableAmount: json["totalPayableAmount"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "emisipDetails": emiSIPDetails == null ? null : emiSIPDetails!.toJson(),
        "principalAmount": principalAmount,
        "interestAmount": interestAmount,
        "emiAmount": emiAmount,
        "sipAmount": sipAmount,
        "totalPayableAmount": totalPayableAmount,
      };
}

class EMISIPDetails {
  EMISIPDetails({
    required this.name,
    required this.loanAmount,
    required this.noOfYear,
    required this.loanInterestRate,
    required this.interestRateOnInvestment,
  });

  final String? name;
  final int? loanAmount;
  final int? noOfYear;
  final double? loanInterestRate;
  final double? interestRateOnInvestment;

  factory EMISIPDetails.fromJson(Map<String, dynamic> json) => EMISIPDetails(
        name: json["name"],
        loanAmount: json["LoanAmount"],
        noOfYear: json["NoOfYear"],
        loanInterestRate: json["LoanInterestRate"],
        interestRateOnInvestment: json["InterestRateOnInvestment"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "LoanAmount": loanAmount,
        "NoOfYear": noOfYear,
        "LoanInterestRate": loanInterestRate,
        "InterestRateOnInvestment": interestRateOnInvestment,
      };
}
