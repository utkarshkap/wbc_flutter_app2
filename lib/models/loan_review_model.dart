// To parse this JSON data, do
//
//     final loanReviewModel = loanReviewModelFromJson(jsonString);

import 'dart:convert';

LoanReviewModel loanReviewModelFromJson(String str) =>
    LoanReviewModel.fromJson(json.decode(str));

String loanReviewModelToJson(LoanReviewModel data) =>
    json.encode(data.toJson());

class LoanReviewModel {
  LoanReviewModel({
    required this.userid,
    required this.mobile,
    required this.bankname,
    required this.loantype,
    required this.loanamount,
    required this.tenure,
    required this.emi,
    required this.rateofinterest,
  });

  final int userid;
  final String mobile;
  final String bankname;
  final int loantype;
  final int loanamount;
  final int tenure;
  final int emi;
  final double rateofinterest;

  factory LoanReviewModel.fromJson(Map<String, dynamic> json) =>
      LoanReviewModel(
        userid: json["userid"],
        mobile: json["mobile"],
        bankname: json["bankname"],
        loantype: json["loantype"],
        loanamount: json["loanamount"],
        tenure: json["tenure"],
        emi: json["emi"],
        rateofinterest: json["rateofinterest"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "mobile": mobile,
        "bankname": bankname,
        "loantype": loantype,
        "loanamount": loanamount,
        "tenure": tenure,
        "emi": emi,
        "rateofinterest": rateofinterest,
      };
}
