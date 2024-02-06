import 'dart:convert';

MGainInvestment mGainInvestmentFromJson(String str) => MGainInvestment.fromJson(json.decode(str));

String mGainInvestmentToJson(MGainInvestment data) => json.encode(data.toJson());

class MGainInvestment {
  MGainInvestment({
    required this.code,
    required this.message,
    required this.mGainTotalInvestment,
    required this.totalIntrestReceived,
    required this.mGains,
  });

  int code;
  String message;
  num mGainTotalInvestment;
  num totalIntrestReceived;
  List<MGain> mGains;

  factory MGainInvestment.fromJson(Map<String, dynamic> json) => MGainInvestment(
        code: json["code"],
        message: json["message"],
        mGainTotalInvestment: json["mGain_total_Investment"],
        totalIntrestReceived: json["total_Intrest_received"],
        mGains: List<MGain>.from(json["mGains"].map((x) => MGain.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "mGain_total_Investment": mGainTotalInvestment,
        "total_Intrest_received": totalIntrestReceived,
        "mGains": List<dynamic>.from(mGains.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'MGainInvestment{code: $code, message: $message, mGainTotalInvestment: $mGainTotalInvestment, totalIntrestReceived: $totalIntrestReceived, mGains: $mGains}';
  }
}

class MGain {
  MGain({
    required this.mGainId,
    required this.userId,
    required this.accountid,
    required this.type,
    required this.amount,
    required this.rate,
    required this.investmentDate,
    required this.maturityDate,
    required this.isActive,
  });

  int mGainId;
  int userId;
  int accountid;
  String type;
  double amount;
  double rate;
  DateTime investmentDate;
  DateTime maturityDate;
  bool isActive;

  factory MGain.fromJson(Map<String, dynamic> json) => MGain(
        mGainId: json["mGainId"],
        userId: json["userId"],
        accountid: json["accountid"],
        type: json["type"],
        amount: json["amount"],
        rate: json["rate"],
        investmentDate: DateTime.parse(json["investmentDate"]),
        maturityDate: DateTime.parse(json["maturityDate"]),
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "mGainId": mGainId,
        "userId": userId,
        "accountid": accountid,
        "type": type,
        "amount": amount,
        "rate": rate,
        "investmentDate": investmentDate.toIso8601String(),
        "maturityDate": maturityDate.toIso8601String(),
        "isActive": isActive,
      };

  @override
  String toString() {
    return 'MGain{mGainId: $mGainId, userId: $userId, accountid: $accountid, type: $type, amount: $amount, rate: $rate, investmentDate: $investmentDate, maturityDate: $maturityDate, isActive: $isActive}';
  }
}
