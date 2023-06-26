import 'dart:convert';

LoanInvestment loanInvestmentFromJson(String str) => LoanInvestment.fromJson(json.decode(str));

String loanInvestmentToJson(LoanInvestment? data) => json.encode(data!.toJson());

class LoanInvestment {
  LoanInvestment({
    required this.code,
    required this.message,
    required this.totalLoanAmt,
    required this.loans,
  });

  int code;
  String message;
  num totalLoanAmt;
  List<Loan> loans;

  factory LoanInvestment.fromJson(Map<String, dynamic> json) => LoanInvestment(
    code: json["code"],
    message: json["message"],
    totalLoanAmt: json["total_loan_amt"],
    loans: json["loans"] == null ? [] : List<Loan>.from(json["loans"]!.map((x) => Loan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "total_loan_amt": totalLoanAmt,
    "loans": List<dynamic>.from(loans.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'LoanInvestment{code: $code, message: $message, totalLoanAmt: $totalLoanAmt, loans: $loans}';
  }
}

class Loan {
  Loan({
    required this.name,
    required this.installmentamount,
    required this.requestmobile,
    required this.loanInvAmount,
  });

  String name;
  num installmentamount;
  String requestmobile;
  num loanInvAmount;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    name: json["name"],
    installmentamount: json["installmentamount"],
    requestmobile: json["requestmobile"],
    loanInvAmount: json["loan_inv_amount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "installmentamount": installmentamount,
    "requestmobile": requestmobile,
    "loan_inv_amount": loanInvAmount,
  };

  @override
  String toString() {
    return 'Loan{name: $name, installmentamount: $installmentamount, requestmobile: $requestmobile, loanInvAmount: $loanInvAmount}';
  }
}
