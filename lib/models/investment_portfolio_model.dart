import 'dart:convert';

InvestmentPortfolio investmentPortfolioFromJson(String str) => InvestmentPortfolio.fromJson(json.decode(str));

String investmentPortfolioToJson(InvestmentPortfolio data) => json.encode(data.toJson());

class InvestmentPortfolio {
  InvestmentPortfolio({
    required this.code,
    required this.message,
    required this.portfolio,
    required this.investment,
    required this.gain,
    required this.mFStocks,
  });

  int code;
  String message;
  double portfolio;
  double investment;
  double gain;
  List<MFStock> mFStocks;

  factory InvestmentPortfolio.fromJson(Map<String, dynamic> json) => InvestmentPortfolio(
    code: json["code"],
    message: json["message"],
    portfolio: json["portfolio"].toDouble(),
    investment: json["investment"].toDouble(),
    gain: json["gain"].toDouble(),
    mFStocks: json["mF_Stocks"]==null?[]:List<MFStock>.from(json["mF_Stocks"].map((x) => MFStock.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "portfolio": portfolio,
    "investment": investment,
    "gain": gain,
    "mF_Stocks": List<dynamic>.from(mFStocks.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'InvestmentPortfolio{code: $code, message: $message, portfolio: $portfolio, investment: $investment, gain: $gain, mFStocks: $mFStocks}';
  }
}

class MFStock {

  String mFStockName;
  String folioNo;
  double unit;
  double nav;
  double gainAmount;
  double perGain;
  double investment_Unit;
  double investment_Amount;
  double sale_Unit;
  double sale_Amount;

  MFStock({
    required this.mFStockName,
    required this.folioNo,
    required this.unit,
    required this.nav,
    required this.gainAmount,
    required this.perGain,
    required this.investment_Unit,
    required this.investment_Amount,
    required this.sale_Unit,
    required this.sale_Amount,
  });

  factory MFStock.fromJson(Map<String, dynamic> json) => MFStock(
    mFStockName: json["mF_name"],
    folioNo: json["folioNo"],
    unit: json["unit"],
    nav: json["nav"].toDouble(),
    gainAmount: json["gain_Amount"].toDouble(),
    perGain: json["per_gain"].toDouble(),
    investment_Unit: json["investment_Unit"].toDouble(),
    investment_Amount: json["investment_Amount"].toDouble(),
    sale_Unit: json["sale_Unit"].toDouble(),
    sale_Amount: json["sale_Amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "mF_name": mFStockName,
    "folioNo": folioNo,
    "unit": unit,
    "nav": nav,
    "gain_Amount": gainAmount,
    "per_gain": perGain,
    "investment_Unit": investment_Unit,
    "investment_Amount": investment_Amount,
    "sale_Unit": sale_Unit,
    "sale_Amount": sale_Amount,
  };

  @override
  String toString() {
    return 'MFStock{mFStockName: $mFStockName, unit: $unit, nav: $nav, gainAmount: $gainAmount, perGain: $perGain , folioNo:$folioNo, investment_Unit:$investment_Unit,investment_Amount:$investment_Amount,sale_Amount:$sale_Amount,sale_unit:$sale_Unit}';
  }
}