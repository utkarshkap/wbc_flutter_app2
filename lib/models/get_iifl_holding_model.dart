// To parse this JSON data, do
//
//     final getIiflHoldingModel = getIiflHoldingModelFromJson(jsonString);

import 'dart:convert';

GetIiflHoldingModel getIiflHoldingModelFromJson(String str) =>
    GetIiflHoldingModel.fromJson(json.decode(str));

String getIiflHoldingModelToJson(GetIiflHoldingModel data) =>
    json.encode(data.toJson());

class GetIiflHoldingModel {
  final Body? body;
  final Head? head;

  GetIiflHoldingModel({
    this.body,
    this.head,
  });

  factory GetIiflHoldingModel.fromJson(Map<String, dynamic> json) =>
      GetIiflHoldingModel(
        body: Body.fromJson(json["body"]),
        head: Head.fromJson(json["head"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body!.toJson(),
        "head": head!.toJson(),
      };
}

class Body {
  final int? cacheTime;
  final List<Datum>? data;
  final String? message;
  final int? status;

  Body({
    this.cacheTime,
    this.data,
    this.message,
    this.status,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        cacheTime: json["CacheTime"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
        message: json["Message"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "CacheTime": cacheTime,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "Message": message,
        "Status": status,
      };
}

class Datum {
  final int? bseCode;
  final double? currentPl;
  final double? currentPrice;
  final double? currentValue;
  final Exch? exch;
  final ExchType? exchType;
  final String? fullName;
  final int? fundedQty;
  final int? nseCode;
  final double? perChange;
  final double? previousClose;
  final int? quantity;
  final String? symbol;
  final double? yesterDayValue;
  final int? collateralQty;

  Datum({
    this.bseCode,
    this.currentPl,
    this.currentPrice,
    this.currentValue,
    this.exch,
    this.exchType,
    this.fullName,
    this.fundedQty,
    this.nseCode,
    this.perChange,
    this.previousClose,
    this.quantity,
    this.symbol,
    this.yesterDayValue,
    this.collateralQty,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        bseCode: json["BseCode"],
        currentPl: json["CurrentPL"].toDouble(),
        currentPrice: json["CurrentPrice"].toDouble(),
        currentValue: json["CurrentValue"].toDouble(),
        exch: exchValues.map[json["Exch"]],
        exchType: exchTypeValues.map[json["ExchType"]],
        fullName: json["FullName"],
        fundedQty: json["FundedQty"],
        nseCode: json["NseCode"],
        perChange: json["PerChange"].toDouble(),
        previousClose: json["PreviousClose"].toDouble(),
        quantity: json["Quantity"],
        symbol: json["Symbol"],
        yesterDayValue: json["YesterDayValue"].toDouble(),
        collateralQty: json["collateralQty"],
      );

  Map<String, dynamic> toJson() => {
        "BseCode": bseCode,
        "CurrentPL": currentPl,
        "CurrentPrice": currentPrice,
        "CurrentValue": currentValue,
        "Exch": exchValues.reverse[exch],
        "ExchType": exchTypeValues.reverse[exchType],
        "FullName": fullName,
        "FundedQty": fundedQty,
        "NseCode": nseCode,
        "PerChange": perChange,
        "PreviousClose": previousClose,
        "Quantity": quantity,
        "Symbol": symbol,
        "YesterDayValue": yesterDayValue,
        "collateralQty": collateralQty,
      };
}

enum Exch { N }

final exchValues = EnumValues({"N": Exch.N});

enum ExchType { C }

final exchTypeValues = EnumValues({"C": ExchType.C});

class Head {
  final String? responseCode;
  final String? status;
  final String? statusDescription;

  Head({
    this.responseCode,
    this.status,
    this.statusDescription,
  });

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        responseCode: json["responseCode"],
        status: json["status"],
        statusDescription: json["statusDescription"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "status": status,
        "statusDescription": statusDescription,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
