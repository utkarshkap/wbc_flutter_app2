import 'dart:convert';

Get5PaisaHoldingModel get5PaisaHoldingFromJson(String str) => Get5PaisaHoldingModel.fromJson(json.decode(str));

String get5PaisaHoldingToJson(Get5PaisaHoldingModel data) => json.encode(data.toJson());

class Get5PaisaHoldingModel {
  Body? body;
  Head? head;

  Get5PaisaHoldingModel({this.body, this.head});

  Get5PaisaHoldingModel.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    return data;
  }
}

class Body {
  int? cacheTime;
  List? data;
  String? message;
  int? status;

  Body({this.cacheTime, this.data, this.message, this.status});

  Body.fromJson(Map<String, dynamic> json) {
    cacheTime = json['CacheTime'];
    if (json['Data'] != null) {
      data = <Null>[];
      json['Data'].forEach((v) {
        data!.add(Body.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CacheTime'] = this.cacheTime;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class Head {
  String? responseCode;
  String? status;
  String? statusDescription;

  Head({this.responseCode, this.status, this.statusDescription});

  Head.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    status = json['status'];
    statusDescription = json['statusDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['status'] = this.status;
    data['statusDescription'] = this.statusDescription;
    return data;
  }
}
