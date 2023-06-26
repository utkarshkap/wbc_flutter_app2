import 'dart:convert';

GetFyersAccessTokenModel getFyersAccessTokenFromJson(String str) => GetFyersAccessTokenModel.fromJson(json.decode(str));

String getFyersAccessTokenToJson(GetFyersAccessTokenModel data) => json.encode(data.toJson());

class GetFyersAccessTokenModel {
  int? code;
  Null? message;
  Data? data;

  GetFyersAccessTokenModel({this.code, this.message, this.data});

  GetFyersAccessTokenModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Null? s;
  int? code;
  String? message;
  String? accessToken;

  Data({this.s, this.code, this.message, this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    code = json['code'];
    message = json['message'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['s'] = this.s;
    data['code'] = this.code;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    return data;
  }
}
