import 'dart:convert';

GetFyersHoldingsModel getFyersHoldingsModelFromJson(String str) =>
    GetFyersHoldingsModel.fromJson(json.decode(str));
String getFyersHoldingsModelToJson(GetFyersHoldingsModel data) =>
    json.encode(data.toJson());

class GetFyersHoldingsModel {
  String? s;
  int? code;
  String? message;
  List<Holding>? holdings;
  Overall? overall;

  GetFyersHoldingsModel({
    this.s,
    this.code,
    this.message,
    this.holdings,
    this.overall,
  });

  factory GetFyersHoldingsModel.fromJson(Map<String, dynamic> json) =>
      GetFyersHoldingsModel(
        s: json["s"],
        code: json["code"],
        message: json["message"],
        holdings: List<Holding>.from(
            json["holdings"].map((x) => Holding.fromJson(x))),
        overall: Overall.fromJson(json["overall"]),
      );

  Map<String, dynamic> toJson() => {
        "s": s,
        "code": code,
        "message": message,
        "holdings": List<dynamic>.from(holdings!.map((x) => x.toJson())),
        "overall": overall!.toJson(),
      };
}

class Holding {
  int? quantity;
  double? costPrice;
  int? remainingQuantity;
  double? pl;
  double? ltp;
  int? id;
  String? fyToken;
  int? exchange;
  int? segment;
  String? symbol;
  double? marketVal;
  String? isin;
  int? qtyT1;
  int? remainingPledgeQuantity;
  int? collateralQuantity;
  String? holdingType;

  Holding({
    this.quantity,
    this.costPrice,
    this.remainingQuantity,
    this.pl,
    this.ltp,
    this.id,
    this.fyToken,
    this.exchange,
    this.segment,
    this.symbol,
    this.marketVal,
    this.isin,
    this.qtyT1,
    this.remainingPledgeQuantity,
    this.collateralQuantity,
    this.holdingType,
  });

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
        quantity: json["quantity"],
        costPrice: json["costPrice"].toDouble(),
        remainingQuantity: json["remainingQuantity"],
        pl: json["pl"].toDouble(),
        ltp: json["ltp"].toDouble(),
        id: json["id"],
        fyToken: json["fyToken"],
        exchange: json["exchange"],
        segment: json["segment"],
        symbol: json["symbol"],
        marketVal: json["marketVal"].toDouble(),
        isin: json["isin"],
        qtyT1: json["qty_t1"],
        remainingPledgeQuantity: json["remainingPledgeQuantity"],
        collateralQuantity: json["collateralQuantity"],
        holdingType: json["holdingType"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "costPrice": costPrice,
        "remainingQuantity": remainingQuantity,
        "pl": pl,
        "ltp": ltp,
        "id": id,
        "fyToken": fyToken,
        "exchange": exchange,
        "segment": segment,
        "symbol": symbol,
        "marketVal": marketVal,
        "isin": isin,
        "qty_t1": qtyT1,
        "remainingPledgeQuantity": remainingPledgeQuantity,
        "collateralQuantity": collateralQuantity,
        "holdingType": holdingType,
      };
}

class Overall {
  int? countTotal;
  double? pnlPerc;
  double? totalCurrentValue;
  double? totalInvestment;
  double? totalPl;

  Overall({
    this.countTotal,
    this.pnlPerc,
    this.totalCurrentValue,
    this.totalInvestment,
    this.totalPl,
  });

  factory Overall.fromJson(Map<String, dynamic> json) => Overall(
        countTotal: json["count_total"],
        pnlPerc: json["pnl_perc"].toDouble(),
        totalCurrentValue: json["total_current_value"].toDouble(),
        totalInvestment: json["total_investment"].toDouble(),
        totalPl: json["total_pl"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "count_total": countTotal,
        "pnl_perc": pnlPerc,
        "total_current_value": totalCurrentValue,
        "total_investment": totalInvestment,
        "total_pl": totalPl,
      };
}
