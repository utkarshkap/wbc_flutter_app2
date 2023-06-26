import 'dart:convert';

Get5PaisaHoldingsDataModel get5PaisaHoldingsDataModelFromJson(String str) =>
    Get5PaisaHoldingsDataModel.fromJson(json.decode(str));

String get5PaisaHoldingsDataModelToJson(Get5PaisaHoldingsDataModel data) => json.encode(data.toJson());

class Get5PaisaHoldingsDataModel {
  HoldingHead? head;
  HoldingBody? body;

  Get5PaisaHoldingsDataModel({this.head, this.body});

  Get5PaisaHoldingsDataModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new HoldingHead.fromJson(json['head']) : null;
    body = json['body'] != null ? new HoldingBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class HoldingHead {
  String? key;

  HoldingHead({this.key});

  HoldingHead.fromJson(Map<String, dynamic> json) {
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    return data;
  }
}

class HoldingBody {
  String? clientCode;

  HoldingBody({this.clientCode});

  HoldingBody.fromJson(Map<String, dynamic> json) {
    clientCode = json['ClientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClientCode'] = this.clientCode;
    return data;
  }
}
