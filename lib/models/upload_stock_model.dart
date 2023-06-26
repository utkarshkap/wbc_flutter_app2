// To parse this JSON data, do
//
//     final uploadStock = uploadStockFromJson(jsonString);

import 'dart:convert';

UploadStock uploadStockFromJson(String str) => UploadStock.fromJson(json.decode(str));

String uploadStockToJson(UploadStock data) => json.encode(data.toJson());

class UploadStock {
  UploadStock({
   required this.code,
   required this.message,
   required this.reviewresponse,
  });

  final int code;
  final String message;
  final Reviewresponse reviewresponse;

  factory UploadStock.fromJson(Map<String, dynamic> json) => UploadStock(
    code: json["code"],
    message: json["message"],
    reviewresponse: Reviewresponse.fromJson(json["reviewresponse"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "reviewresponse": reviewresponse.toJson(),
  };
}

class Reviewresponse {
  Reviewresponse({
    this.requestMobile,
   required this.requestPan,
    this.refEmail,
   required this.status,
  });

  final dynamic requestMobile;
  final String requestPan;
  final dynamic refEmail;
  final String status;

  factory Reviewresponse.fromJson(Map<String, dynamic> json) => Reviewresponse(
    requestMobile: json["request_mobile"],
    requestPan: json["request_pan"],
    refEmail: json["ref_email"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "request_mobile": requestMobile,
    "request_pan": requestPan,
    "ref_email": refEmail,
    "status": status,
  };
}
