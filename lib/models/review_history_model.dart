import 'dart:convert';

ReviewHistory reviewHistoryFromJson(String str) =>
    ReviewHistory.fromJson(json.decode(str));

String reviewHistoryToJson(ReviewHistory data) => json.encode(data.toJson());

class ReviewHistory {
  ReviewHistory({
    required this.code,
    required this.message,
    required this.reviewresponse,
  });

  int code;
  String message;
  List<Reviewresponse> reviewresponse;

  factory ReviewHistory.fromJson(Map<String, dynamic> json) => ReviewHistory(
        code: json["code"],
        message: json["message"],
        reviewresponse: List<Reviewresponse>.from(
            json["reviewresponse"].map((x) => Reviewresponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "reviewresponse":
            List<dynamic>.from(reviewresponse.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'ReviewHistory{code: $code, message: $message, reviewresponse: $reviewresponse}';
  }
}

class Reviewresponse {
  Reviewresponse({
    required this.requestId,
    required this.requestMobile,
    required this.requestPan,
    required this.reqEmail,
    required this.reqDate,
    required this.investmentName,
    required this.investmentType,
    required this.amount,
    required this.insuranceamount,
    required this.status,
    required this.reportPath,
  });

  int requestId;
  String requestMobile;
  String requestPan;
  String reqEmail;
  DateTime reqDate;
  String investmentName;
  String investmentType;
  double amount;
  num insuranceamount;
  String status;
  String reportPath;

  factory Reviewresponse.fromJson(Map<String, dynamic> json) => Reviewresponse(
        requestId: json["request_Id"],
        requestMobile: json["request_mobile"],
        requestPan: json["request_pan"],
        reqEmail: json["req_email"],
        reqDate: DateTime.parse(json["req_date"]),
        investmentName: json["investmentName"],
        investmentType: json["investmentType"],
        amount: json["amount"],
        insuranceamount: double.parse(json["insuranceamount"].toString()),
        status: json["status"],
        reportPath: json["reportPath"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "request_Id": requestId,
        "request_mobile": requestMobile,
        "request_pan": requestPan,
        "req_email": reqEmail,
        "req_date": reqDate.toIso8601String(),
        "investmentName": investmentName,
        "investmentType": investmentType,
        "amount": amount,
        "insuranceamount": insuranceamount,
        "status": status,
        "reportPath": reportPath,
      };

  @override
  String toString() {
    return 'Reviewresponse{requestId: $requestId, requestMobile: $requestMobile, requestPan: $requestPan, reqEmail: $reqEmail, reqDate: $reqDate, investmentName: $investmentName, investmentType: $investmentType, amount: $amount, insuranceamount: $insuranceamount, status: $status, reportPath: $reportPath}';
  }
}
