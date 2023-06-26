import 'dart:convert';

RetirementCalculatorModel retirementCalculatorFromJson(String str) => RetirementCalculatorModel.fromJson(json.decode(str));

String retirementCalculatorToJson(RetirementCalculatorModel data) => json.encode(data.toJson());

class RetirementCalculatorModel{
  RetirementCalculatorModel({
    required this.code,
    required this.message,
    required this.retirementDetails,
    required this.corpusAfterRetirement,
    required this.investmentRequired,
    required this.inflationAdjustedExpense,
  });

  final int code;
  final String message;
  final RetirementDetails? retirementDetails;
  final String corpusAfterRetirement;
  final String investmentRequired;
  final String inflationAdjustedExpense;

  factory RetirementCalculatorModel.fromJson(Map<String, dynamic> json) =>
      RetirementCalculatorModel(
        code: json["code"],
        message: json["message"],
        retirementDetails: json["retirement_Calculator_Details"] == null ? null : RetirementDetails.fromJson(json["retirement_Calculator_Details"]),
        corpusAfterRetirement: json["corpusAfterRetirement"].toString(),
        investmentRequired: json["investmentRequired"].toString(),
        inflationAdjustedExpense: json["inflationAdjustedExpense"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "retirement_Calculator_Details": retirementDetails == null ? null : retirementDetails!.toJson(),
    "corpusAfterRetirement": corpusAfterRetirement.toString(),
    "investmentRequired": investmentRequired.toString(),
    "inflationAdjustedExpense": inflationAdjustedExpense.toString(),
  };

}

class RetirementDetails{
  RetirementDetails({
    required this.name,
    required this.currentAge,
    required this.retirementAge,
    required this.lifeExpectancy,
    required this.monthlyExpenses,
    required this.preRetirementReturn,
    required this.postRetirementReturn,
    required this.currentInvestment,
    required this.inflationRate,
  });

  final String name;
  final int currentAge;
  final int retirementAge;
  final int lifeExpectancy;
  final int monthlyExpenses;
  final int preRetirementReturn;
  final int postRetirementReturn;
  final int currentInvestment;
  final int inflationRate;

  factory RetirementDetails.fromJson(Map<String, dynamic> json) => RetirementDetails(
    name: json["name"],
    currentAge: json["CurrentAge"],
    retirementAge: json["RetirementAge"],
    lifeExpectancy: json["LifeExpectancy"],
    monthlyExpenses: json["MonthlyExpenses"],
    preRetirementReturn: json["PreRetirementReturn"],
    postRetirementReturn: json["PostRetirementReturn"],
    currentInvestment: json["CurrentInvestment"],
    inflationRate: json["InflationRate"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "CurrentAge": currentAge,
    "RetirementAge": retirementAge,
    "LifeExpectancy": lifeExpectancy,
    "MonthlyExpenses": monthlyExpenses,
    "PreRetirementReturn": preRetirementReturn,
    "PostRetirementReturn": postRetirementReturn,
    "CurrentInvestment": currentInvestment,
    "InflationRate": inflationRate,
  };
}