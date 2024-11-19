// To parse this JSON data, do
//
//     final getBrokerHoldingModel = getBrokerHoldingModelFromJson(jsonString);

import 'dart:convert';

GetBrokerHoldingModel getBrokerHoldingModelFromJson(String str) =>
    GetBrokerHoldingModel.fromJson(json.decode(str));

String getBrokerHoldingModelToJson(GetBrokerHoldingModel data) =>
    json.encode(data.toJson());

class GetBrokerHoldingModel {
  final int? code;
  final dynamic message;
  final List<Datum>? data;

  GetBrokerHoldingModel({
    this.code,
    this.message,
    this.data,
  });

  factory GetBrokerHoldingModel.fromJson(Map<String, dynamic> json) =>
      GetBrokerHoldingModel(
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? id;
  final String? symbol;
  final int? rate;
  final int? quantity;
  final String? isin;
  final int? brokerId;
  final int? userId;
  final String? brokerName;

  Datum({
    this.id,
    this.symbol,
    this.rate,
    this.quantity,
    this.isin,
    this.brokerId,
    this.userId,
    this.brokerName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        symbol: json["symbol"],
        rate: json["rate"],
        quantity: json["quantity"],
        isin: json["isin"],
        brokerId: json["brokerId"],
        userId: json["userId"],
        brokerName: json["brokerName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "rate": rate,
        "quantity": quantity,
        "isin": isin,
        "brokerId": brokerId,
        "userId": userId,
        "brokerName": brokerName,
      };
}
