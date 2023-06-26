import 'dart:convert';

InvestmentTransaction investmentTransactionFromJson(String str) => InvestmentTransaction.fromJson(json.decode(str));

String investmentTransactionToJson(InvestmentTransaction data) => json.encode(data.toJson());

class InvestmentTransaction {
  InvestmentTransaction({
    required this.code,
    required this.message,
    required this.mFStocks,
  });

  int code;
  String message;
  List<MFStockTransaction> mFStocks;

  factory InvestmentTransaction.fromJson(Map<String, dynamic> json) => InvestmentTransaction(
    code: json["code"],
    message: json["message"],
    mFStocks: json["mF_Stocks"]==null?[]:List<MFStockTransaction>.from(json["mF_Stocks"].map((x) => MFStockTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "mF_Stocks": List<dynamic>.from(mFStocks.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'InvestmentTransaction{code: $code, message: $message, mFStocks: $mFStocks}';
  }
}

class MFStockTransaction {

  String mFStockName;
  String folioNo;
  double unit;
  double nav;
  double investmentAmount;
  double gainAmount;
  double perGain;
  String transactionType;
  String date;
  double investmentUnit;
  double saleUnit;
  double saleAmount;


  MFStockTransaction({
    required this.mFStockName,
    required this.folioNo,
    required this.unit,
    required this.nav,
    required this.investmentAmount,
    required this.gainAmount,
    required this.perGain,
    required this.transactionType,
    required this.date,
    required this.investmentUnit,
    required this.saleUnit,
    required this.saleAmount,
  });

  factory MFStockTransaction.fromJson(Map<String, dynamic> json) => MFStockTransaction(
    mFStockName: json["mF_name"],
    folioNo: json["folioNo"],
    unit: json["unit"],
    nav: json["nav"].toDouble(),
    investmentAmount: json["investment_Amount"].toDouble(),
    gainAmount: json["gain_Amount"].toDouble(),
    perGain: json["per_gain"].toDouble(),
    transactionType: json["transactionType"],
    date: json["date"],
    investmentUnit: json["investment_Unit"].toDouble(),
    saleUnit: json["sale_Unit"].toDouble(),
    saleAmount: json["sale_Amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "mF_name": mFStockName,
    "folioNo": folioNo,
    "unit": unit,
    "nav": nav,
    "investment_Amount": investmentAmount,
    "gain_Amount": gainAmount,
    "per_gain": perGain,
    "transactionType": transactionType,
    "date": date,
    "investment_Unit": investmentUnit,
    "sale_Unit": saleUnit,
    "sale_Amount": saleAmount,
  };

  @override
  String toString() {
    return 'MFStock{mF_name: $mFStockName, folioNo:$folioNo, unit: $unit, nav: $nav,investment_Amount: $investmentAmount,'
        ' gainAmount: $gainAmount, perGain: $perGain,transactionType: $transactionType,date: $date,investment_Unit:$investmentUnit,sale_Amount:$saleAmount,sale_unit:$saleUnit}';
  }
}