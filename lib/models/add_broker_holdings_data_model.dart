// To parse this JSON data, do
//
//     final addbrokerholdingsModel = addbrokerholdingsModelFromJson(jsonString);

import 'dart:convert';

List<AddbrokerholdingsModel> addbrokerholdingsModelFromJson(String str) =>
    List<AddbrokerholdingsModel>.from(
        json.decode(str).map((x) => AddbrokerholdingsModel.fromJson(x)));

String addbrokerholdingsModelToJson(List<AddbrokerholdingsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddbrokerholdingsModel {
  final String? symbol;
  final int? quantity;
  final double? rate;
  final int? userId;
  final int? brokerId;
  final String? isin;

  AddbrokerholdingsModel({
    this.symbol,
    this.quantity,
    this.rate,
    this.userId,
    this.brokerId,
    this.isin,
  });

  factory AddbrokerholdingsModel.fromJson(Map<String, dynamic> json) =>
      AddbrokerholdingsModel(
        symbol: json["Symbol"],
        quantity: json["Quantity"],
        rate: json["Rate"],
        userId: json["UserId"],
        brokerId: json["BrokerId"],
        isin: json["ISIN"],
      );

  Map<String, dynamic> toJson() => {
        "Symbol": symbol,
        "Quantity": quantity,
        "Rate": rate,
        "UserId": userId,
        "BrokerId": brokerId,
        "ISIN": isin,
      };
}
