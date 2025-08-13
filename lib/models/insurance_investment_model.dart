import 'dart:convert';

InsuranceInvestment insuranceInvestmentFromJson(String str) =>
    InsuranceInvestment.fromJson(json.decode(str));

String insuranceInvestmentToJson(InsuranceInvestment? data) =>
    json.encode(data!.toJson());

class InsuranceInvestment {
  InsuranceInvestment({
    required this.code,
    required this.message,
    required this.totalInsuranceAmt,
    required this.policies,
  });

  int code;
  String message;
  num totalInsuranceAmt;
  List<Policy> policies;

  factory InsuranceInvestment.fromJson(Map<String, dynamic> json) =>
      InsuranceInvestment(
        code: json["code"],
        message: json["message"],
        totalInsuranceAmt: json["total_insurance_amt"],
        policies: json["policies"] == null
            ? []
            : List<Policy>.from(
                json["policies"].map((x) => Policy.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "total_insurance_amt": totalInsuranceAmt,
        "policies": List<dynamic>.from(policies.map((x) => x.toJson())),
      };
}

class Policy {
  Policy({
    required this.id,
    required this.name,
    required this.amount,
    required this.requestmobile,
    required this.duedate,
    required this.plan,
    required this.sumAssuredInsured,
    required this.username,
    required this.policyname,
    required this.policynumber,
    required this.grosspremium,
    required this.status,
    required this.transactiontype,
    required this.plantype,
    required this.logindate,
  });

  int id;
  String name;
  num amount;
  String requestmobile;
  String duedate;
  String plan;
  num sumAssuredInsured;
  String? username;
  String? policyname;
  String? policynumber;
  num grosspremium;
  String status;
  String transactiontype;
  String plantype;
  String logindate;

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
        requestmobile: json["requestmobile"],
        duedate: json["duedate"],
        plan: json["plan"],
        sumAssuredInsured: json["sumAssured_Insured"],
        username: json["username"],
        policyname: json["policyname"],
        policynumber: json["policynumber"],
        grosspremium: json["grosspremium"],
        status: json["status"],
        transactiontype: json["transactiontype"],
        plantype: json["plantype"],
        logindate: json["logindate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "requestmobile": requestmobile,
        "duedate": duedate,
        "plan": plan,
        "sumAssured_Insured": sumAssuredInsured,
        "username": username,
        "policyname": policyname,
        "policynumber": policynumber,
        "grosspremium": grosspremium,
        "status": status,
        "transactiontype": transactiontype,
        "plantype": plantype,
        "logindate": logindate,
      };
}
