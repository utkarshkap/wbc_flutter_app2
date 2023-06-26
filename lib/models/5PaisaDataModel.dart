import 'dart:convert';

Get5PaisaDataModel get5PaisaDataModelFromJson(String str) =>
    Get5PaisaDataModel.fromJson(json.decode(str));

String get5PaisaDataModelToJson(Get5PaisaDataModel data) => json.encode(data.toJson());

class Get5PaisaDataModel {
  Head? head;
  Body? body;

  Get5PaisaDataModel({this.head, this.body});

  Get5PaisaDataModel.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
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

class Head {
  String? key;

  Head({this.key});

  Head.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    return data;
  }
}

class Body {
  String? requestToken;
  String? encryKey;
  String? userId;

  Body({this.requestToken, this.encryKey, this.userId});

  Body.fromJson(Map<String, dynamic> json) {
    requestToken = json['RequestToken'];
    encryKey = json['EncryKey'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RequestToken'] = this.requestToken;
    data['EncryKey'] = this.encryKey;
    data['UserId'] = this.userId;
    return data;
  }
}
