import 'dart:convert';

GetFyersHoldingsModel getFyersHoldingsFromJson(String str) => GetFyersHoldingsModel.fromJson(json.decode(str));

String getFyersHoldingsToJson(GetFyersHoldingsModel data) => json.encode(data.toJson());

class GetFyersHoldingsModel {
  String? s;
  int? code;
  String? message;
  List<Holdings>? holdings;
  Overall? overall;

  GetFyersHoldingsModel(
      {this.s, this.code, this.message, this.holdings, this.overall});

  GetFyersHoldingsModel.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    code = json['code'];
    message = json['message'];
    if (json['holdings'] != null) {
      holdings = <Holdings>[];
      json['holdings'].forEach((v) {
        holdings!.add(new Holdings.fromJson(v));
      });
    }
    overall =
    json['overall'] != null ? new Overall.fromJson(json['overall']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['s'] = this.s;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.holdings != null) {
      data['holdings'] = this.holdings!.map((v) => v.toJson()).toList();
    }
    if (this.overall != null) {
      data['overall'] = this.overall!.toJson();
    }
    return data;
  }
}

class Holdings {
  String? holdingType;
  int? quantity;
  double? costPrice;
  double? marketVal;
  int? remainingQuantity;
  double? pl;
  double? ltp;
  int? id;
  int? fyToken;
  int? exchange;
  String? symbol;

  Holdings(
      {this.holdingType,
        this.quantity,
        this.costPrice,
        this.marketVal,
        this.remainingQuantity,
        this.pl,
        this.ltp,
        this.id,
        this.fyToken,
        this.exchange,
        this.symbol});

  Holdings.fromJson(Map<String, dynamic> json) {
    holdingType = json['holdingType'];
    quantity = json['quantity'];
    costPrice = json['costPrice'];
    marketVal = json['marketVal'];
    remainingQuantity = json['remainingQuantity'];
    pl = json['pl'];
    ltp = json['ltp'];
    id = json['id'];
    fyToken = json['fyToken'];
    exchange = json['exchange'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holdingType'] = this.holdingType;
    data['quantity'] = this.quantity;
    data['costPrice'] = this.costPrice;
    data['marketVal'] = this.marketVal;
    data['remainingQuantity'] = this.remainingQuantity;
    data['pl'] = this.pl;
    data['ltp'] = this.ltp;
    data['id'] = this.id;
    data['fyToken'] = this.fyToken;
    data['exchange'] = this.exchange;
    data['symbol'] = this.symbol;
    return data;
  }
}

class Overall {
  int? countTotal;
  int? pnlPerc;
  int? totalCurrentValue;
  int? totalInvestment;
  int? totalPl;

  Overall(
      {this.countTotal,
        this.pnlPerc,
        this.totalCurrentValue,
        this.totalInvestment,
        this.totalPl});

  Overall.fromJson(Map<String, dynamic> json) {
    countTotal = json['count_total'];
    pnlPerc = json['pnl_perc'];
    totalCurrentValue = json['total_current_value'];
    totalInvestment = json['total_investment'];
    totalPl = json['total_pl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count_total'] = this.countTotal;
    data['pnl_perc'] = this.pnlPerc;
    data['total_current_value'] = this.totalCurrentValue;
    data['total_investment'] = this.totalInvestment;
    data['total_pl'] = this.totalPl;
    return data;
  }
}