import 'dart:convert';

StockInvestmentModel stockInvestmentFromJson(String str) => StockInvestmentModel.fromJson(json.decode(str));

String stockInvestmentToJson(StockInvestmentModel data) => json.encode(data.toJson());

class StockInvestmentModel {
  StockInvestmentModel({
    required this.code,
    required this.message,
    required this.portfolio,
    required this.investment,
    required this.gain,
    required this.stocks,
  });

  int code;
  String message;
  double portfolio;
  double investment;
  double gain;
  List<StocksData> stocks;

  factory StockInvestmentModel.fromJson(Map<String, dynamic> json) => StockInvestmentModel(
    code: json["code"],
    message: json["message"],
    portfolio: json["portfolio"].toDouble(),
    investment: json["investment"].toDouble(),
    gain: json["gain"].toDouble(),
    stocks: json["stocks"]==null?[]:List<StocksData>.from(json["stocks"].map((x) => StocksData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "portfolio": portfolio,
    "investment": investment,
    "gain": gain,
    "stocks": List<dynamic>.from(stocks.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'StockInvestmentModel{code: $code, message: $message, portfolio: $portfolio, investment: $investment, gain: $gain,stocks:$stocks}';
  }
}

class StocksData{

  String stockName;
  int balanceQty;
  double rate;
  int purchaseQty;
  double purchaseAmount;
  int saleQty;
  double saleAmount;
  double balanceAmount;
  double gainAmount;
  double perGain;
  String date;
  Null buySell;

  StocksData({
    required this.stockName,
    required this.balanceQty,
    required this.rate,
    required this.purchaseQty,
    required this.purchaseAmount,
    required this.saleQty,
    required this.saleAmount,
    required this.balanceAmount,
    required this.gainAmount,
    required this.perGain,
    required this.date,
    required this.buySell,
  });

  factory StocksData.fromJson(Map<String, dynamic> json) => StocksData(
    stockName: json["stock_name"],
    balanceQty: json["balance_Qty"],
    rate: json["rate"].toDouble(),
    purchaseQty: json["purchase_Qty"],
    purchaseAmount: json["purchase_Amount"].toDouble(),
    saleQty: json["sale_Qty"],
    saleAmount: json["sale_Amount"].toDouble(),
    balanceAmount: json["balance_Amount"].toDouble(),
    gainAmount: json["gain_Amount"].toDouble(),
    perGain: json["per_gain"].toDouble(),
    date: json["date"],
    buySell: json["buySell"],
  );

  Map<String, dynamic> toJson() =>
  {
     "stock_name": stockName,
     "balance_Qty": balanceQty,
     "rate": rate,
    "purchase_Qty": purchaseQty,
    "purchase_Amount": purchaseAmount,
    "sale_Qty": saleQty,
    "sale_Amount": saleAmount,
    "balance_Amount": balanceAmount,
    "gain_Amount": gainAmount,
    "per_gain": perGain,
    "date": date,
    "buySell": buySell,
  };

  @override
  String toString() {
    return 'Stocks{stock_name: $stockName, balance_Qty: $balanceQty, rate: $rate, purchase_Qty: $purchaseQty, purchase_Amount: $purchaseAmount ,sale_Qty:$saleQty,sale_Amount:$saleAmount, balance_Amount:$balanceAmount,gain_Amount:$gainAmount,per_gain:$perGain,date:$date,buySell:$buySell}';
  }

}