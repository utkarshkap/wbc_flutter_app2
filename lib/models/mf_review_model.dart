import 'dart:convert';

MfReview mfReviewFromJson(String str) => MfReview.fromJson(json.decode(str));

String mfReviewToJson(MfReview data) => json.encode(data.toJson());

class MfReview {
  MfReview({
    required this.requestUserid,
    required this.requestMobile,
    required this.requestDate,
    required this.requestType,
    required this.requestPan,
    required this.requestEmail,
  });

  int requestUserid;
  String requestMobile;
  String requestDate;
  int requestType;
  String requestPan;
  String requestEmail;

  factory MfReview.fromJson(Map<String, dynamic> json) => MfReview(
    requestUserid: json["request_userid"],
    requestMobile: json["request_mobile"],
    requestDate: json["request_date"],
    requestType: json["request_type"],
    requestPan: json["request_pan"],
    requestEmail: json["request_email"],
  );

  Map<String, dynamic> toJson() => {
    "request_userid": requestUserid,
    "request_mobile": requestMobile,
    "request_date": requestDate,
    "request_type": requestType,
    "request_pan": requestPan,
    "request_email": requestEmail,
  };

  @override
  String toString() {
    return 'MfReview{requestUserid: $requestUserid, requestMobile: $requestMobile, requestDate: $requestDate, requestType: $requestType, requestPan: $requestPan, requestEmail: $requestEmail}';
  }
}