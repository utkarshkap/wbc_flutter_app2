import 'dart:convert';

StockInvestmentTransactionModel stockInvestmentTransactionFromJson(String str) => StockInvestmentTransactionModel.fromJson(json.decode(str));

String stockInvestmentTransactionToJson(StockInvestmentTransactionModel data) => json.encode(data.toJson());

class StockInvestmentTransactionModel {

  StockInvestmentTransactionModel({
    required this.code,
    required this.message,
    required this.stockTransactions,
  });

  int code;
  String message;
  List<StockTransactions> stockTransactions;

  factory StockInvestmentTransactionModel.fromJson(Map<String, dynamic> json) => StockInvestmentTransactionModel(
    code: json["code"],
    message: json["message"],
    stockTransactions: json["stockTransactions"]==null?[]:List<StockTransactions>.from(json["stockTransactions"].map((x) => StockTransactions.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "stockTransactions": List<dynamic>.from(stockTransactions.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'StockInvestmentTransactionModel{code: $code, message: $message, stockTransactions: $stockTransactions}';
  }
}

class StockTransactions {
  String stockName;
  int balanceQty;
  double rate;
  int purchaseQty;
  double purchaseAmount;
  int saleQty;
  double saleAmount;
  int balanceAmount;
  int gainAmount;
  int perGain;
  String date;
  String buySell;

  StockTransactions(
      {
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
        required this.buySell});

  factory StockTransactions.fromJson(Map<String, dynamic> json) => StockTransactions(
    stockName: json["stock_name"],
    balanceQty: json["balance_Qty"],
    rate: json["rate"].toDouble(),
    purchaseQty: json["purchase_Qty"],
    purchaseAmount: json["purchase_Amount"].toDouble(),
    saleQty: json["sale_Qty"],
    saleAmount: json["sale_Amount"].toDouble(),
    balanceAmount: json["balance_Amount"],
    gainAmount: json["gain_Amount"],
    perGain: json["per_gain"],
    date: json["date"],
    buySell: json["buySell"],
  );

  Map<String, dynamic> toJson() => {
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
    return 'StockTransactions{stock_name: $stockName, balance_Qty:$balanceQty, rate: $rate, purchase_Qty: $purchaseQty,purchase_Amount: $purchaseAmount,'
        ' sale_Qty: $saleQty, sale_Amount: $saleAmount,balance_Amount: $balanceAmount,gain_Amount: $gainAmount,per_gain:$perGain,date:$date,buySell:$buySell}';
  }

}
