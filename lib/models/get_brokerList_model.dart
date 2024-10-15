import 'dart:convert';

getBrokerListModelFromJson(String str) =>
    GetBrokerListModel.fromJson(json.decode(str));

String getBrokerListModelToJson(GetBrokerListModel data) =>
    json.encode(data.toJson());

class GetBrokerListModel {
  final int? code;
  final dynamic message;
  final List<BrokerList>? brokerList;

  GetBrokerListModel({
    this.code,
    this.message,
    this.brokerList,
  });

  factory GetBrokerListModel.fromJson(Map<String, dynamic> json) =>
      GetBrokerListModel(
        code: json["code"],
        message: json["message"],
        brokerList: List<BrokerList>.from(
            json["brokerList"].map((x) => BrokerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "brokerList": List<dynamic>.from(brokerList!.map((x) => x.toJson())),
      };
}

class BrokerList {
  final int? id;
  final String? brokerName;
  final String? logoUrl;
  final bool? isActive;

  BrokerList({
    this.id,
    this.brokerName,
    this.logoUrl,
    this.isActive,
  });

  factory BrokerList.fromJson(Map<String, dynamic> json) => BrokerList(
        id: json["id"],
        brokerName: json["brokerName"],
        logoUrl: json["logoUrl"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brokerName": brokerName,
        "logoUrl": logoUrl,
        "isActive": isActive,
      };
}
